<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\DispositivoModel;
use App\Models\HistoricoIrrigacaoModel;
use CodeIgniter\Model;

class DashboardController extends BaseController
{
    public function index()
    {
        $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

        if (!$idUsuarioLogado) {
            return redirect()->to(base_url('login'));
        }

        // 1. Instanciar os Models necessários
        $dispositivoModel = new DispositivoModel();
        $historicoModel   = new HistoricoIrrigacaoModel();
        $db = \Config\Database::connect();

        // 2. Contagens para os cards de KPI (Filtrados por Usuário)
        $data['total_ativos']   = $dispositivoModel->where('FK_USU_ID', $idUsuarioLogado)->where('DIS_STATUS', 'ATIVO')->countAllResults();
        $data['total_inativos'] = $dispositivoModel->where('FK_USU_ID', $idUsuarioLogado)->where('DIS_STATUS', 'INATIVO')->countAllResults();
        
        // Contagem de Plantas Cadastradas
        $data['total_plantas']  = $db->table('PLANTA')->where('FK_USU_ID', $idUsuarioLogado)->countAllResults();
        
        // Contagem de Alertas / Falhas registradas no histórico
        $data['total_alertas']  = $historicoModel->where('FK_USU_ID', $idUsuarioLogado)->where('IRR_STATUS', 'Falha')->countAllResults();

        // 3. Dados para a tabela de Status Recentes (Últimas 5 Irrigações)
        $data['ultimas_irrigacoes'] = $historicoModel
            ->select('HISTORICO_IRRIGACAO.*, PLANTA.PLANTA_NOME as nome_planta, DISPOSITIVO.DIS_NOME as nome_dispositivo')
            ->join('PLANTA', 'PLANTA.PLANTA_ID = HISTORICO_IRRIGACAO.FK_PLANTA_ID')
            ->join('DISPOSITIVO', 'DISPOSITIVO.DIS_ID = HISTORICO_IRRIGACAO.FK_DIS_ID')
            ->where('HISTORICO_IRRIGACAO.FK_USU_ID', $idUsuarioLogado)
            ->orderBy('IRR_DATA DESC', 'IRR_HORA DESC')
            ->limit(8)
            ->findAll();

        // 4. PREPARAÇÃO DOS DADOS DO GRÁFICO (Volume Consumido por Dia nos últimos 7 dias)
        // Agrupa o volume de água gasto por data
        $graficoQuery = $historicoModel
            ->select("IRR_DATA, SUM(IRR_VOLUME) as volume_total")
            ->where('FK_USU_ID', $idUsuarioLogado)
            ->where('IRR_STATUS', 'Concluído')
            ->groupBy('IRR_DATA')
            ->orderBy('IRR_DATA ASC')
            ->limit(7)
            ->findAll();

        $labelsGrafico = [];
        $valoresGrafico = [];

        foreach ($graficoQuery as $registro) {
            // Formata a data para padrão brasileiro (Ex: 14/04) para ficar bonito no gráfico
            $labelsGrafico[]  = date('d/m', strtotime($registro['IRR_DATA']));
            $valoresGrafico[] = (float) $registro['volume_total'];
        }

        // Se o banco estiver vazio, coloca valores padrão para o gráfico não sumir da tela
        if (empty($labelsGrafico)) {
            $labelsGrafico  = ['Sem dados'];
            $valoresGrafico = [0];
        }

        $data['grafico_labels']  = $labelsGrafico;
        $data['grafico_valores'] = $valoresGrafico;
        $data['titulo']          = "Painel de Controle - HydroFlow";

        return view('sistema/dashboard/usuario/index', $data);
    }
}