<?php

namespace App\Controllers\Api;

use App\Controllers\BaseController;
use App\Models\DispositivoModel;
use App\Models\HistoricoIrrigacaoModel;
use CodeIgniter\API\ResponseTrait;

class DashboardController extends BaseController
{
    use ResponseTrait;

    /**
     * GET /api/dashboard
     * Retorna os dados do Dashboard consolidados para o usuário logado
     */
    public function index()
    {
        // 1. Validação do Usuário Autenticado
        $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

        if (!$idUsuarioLogado) {
            return $this->failUnauthorized('Acesso restrito. Faça login para continuar.');
        }

        // 2. Instanciação dos Models e conexão com o DB
        $dispositivoModel = new DispositivoModel();
        $historicoModel   = new HistoricoIrrigacaoModel();
        $db               = \Config\Database::connect();

        // 3. Contagens de KPIs
        $totalAtivos   = $dispositivoModel->where('FK_USU_ID', $idUsuarioLogado)->where('DIS_STATUS', 'ATIVO')->countAllResults();
        $totalInativos = $dispositivoModel->where('FK_USU_ID', $idUsuarioLogado)->where('DIS_STATUS', 'INATIVO')->countAllResults();
        $totalPlantas  = $db->table('PLANTA')->where('FK_USU_ID', $idUsuarioLogado)->countAllResults();
        $totalAlertas  = $historicoModel->where('FK_USU_ID', $idUsuarioLogado)->where('IRR_STATUS', 'Falha')->countAllResults();

        // 4. Últimas Irrigações
        $ultimasIrrigacoes = $historicoModel
            ->select('HISTORICO_IRRIGACAO.*, PLANTA.PLANTA_NOME as nome_planta, DISPOSITIVO.DIS_NOME as nome_dispositivo')
            ->join('PLANTA', 'PLANTA.PLANTA_ID = HISTORICO_IRRIGACAO.FK_PLANTA_ID')
            ->join('DISPOSITIVO', 'DISPOSITIVO.DIS_ID = HISTORICO_IRRIGACAO.FK_DIS_ID')
            ->where('HISTORICO_IRRIGACAO.FK_USU_ID', $idUsuarioLogado)
            ->orderBy('IRR_DATA DESC', 'IRR_HORA DESC')
            ->limit(8)
            ->findAll();

        // 5. Cálculo do Consumo Total em Litros (Otimizado via SUM no banco)
        $consumoTotal = $historicoModel
            ->where('FK_USU_ID', $idUsuarioLogado)
            ->where('IRR_STATUS', 'Concluído')
            ->selectSum('IRR_VOLUME', 'total')
            ->first();

        $volumeLitros = (float) ($consumoTotal['total'] ?? 0);

        // 6. Montagem da Estrutura de Retorno para o Mobile
        $data = [
            'kpis' => [
                'total_ativos'   => (int) $totalAtivos,
                'total_inativos' => (int) $totalInativos,
                'total_plantas'  => (int) $totalPlantas,
                'total_alertas'  => (int) $totalAlertas,
                'consumo_total_litros' => $volumeLitros
            ],
            'grafico' => [
                'labels' => [
                    'Dispositivos Ativos', 
                    'Dispositivos Inativos', 
                    'Alertas (Falhas)', 
                    'Plantas Cadastradas', 
                    'Consumo Total (L)'
                ],
                'valores' => [
                    (float) $totalAtivos,
                    (float) $totalInativos,
                    (float) $totalAlertas,
                    (float) $totalPlantas,
                    $volumeLitros
                ]
            ],
            'ultimas_irrigacoes' => $ultimasIrrigacoes
        ];

        return $this->respond([
            'status' => true,
            'data'   => $data,
        ]);
    }
}