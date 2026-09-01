<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\DadosSensoresModel;

class dados_SensoresController extends BaseController
{
    protected $dadosSensoresModel;

    public function __construct()
    {
        $this->dadosSensoresModel = new DadosSensoresModel();
    }

    /**
     * 1. LISTAGEM DE MEDIÇÕES COM FILTROS ATIVOS
     * Rota: GET /dados_sensores
     */

public function index()
{
    // 1. Pega o ID do usuário logado direto da Session
    $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

    if (!$idUsuarioLogado) {
        return redirect()->to(base_url('login'))->with('error', 'Por favor, faça login para acessar seu histórico.');
    }

    // 2. Captura os valores dos filtros vindos da URL (via GET)
    $dataInicial  = $this->request->getGet('data_inicial');
    $dataFinal    = $this->request->getGet('data_final');
    $tempMin      = $this->request->getGet('temp_min');
    $umidadeMax   = $this->request->getGet('umidade_max');
    $statusFiltro = $this->request->getGet('status_filtro') ?? 'todos';

    // Conexão nativa com o banco
    $db = \Config\Database::connect();

    // 3. Busca os Sensores que pertencem a este usuário logado
    $sensoresDoUsuario = $db->table('SENSOR s')
        ->select('s.SEN_ID')
        ->join('DISPOSITIVO d', 'd.DIS_ID = s.FK_DIS_ID')
        ->where('d.FK_USU_ID', $idUsuarioLogado)
        ->get()
        ->getResultArray();

    $idsSensores = array_column($sensoresDoUsuario, 'SEN_ID');

    // Se o usuário não tiver sensores vinculados, define [0] para a query rodar limpa sem quebrar
    if (empty($idsSensores)) {
        $idsSensores = [0];
    }

    // 4. Construtor nativo para a listagem filtrada por usuário
    $builder = $db->table('DADOS_SENSORES ds')
        ->select('ds.*, s.SEN_NOME as nome_sensor')
        ->join('SENSOR s', 's.SEN_ID = ds.FK_SEN_ID')
        ->whereIn('ds.FK_SEN_ID', $idsSensores);

    // 5. Aplica filtros APENAS se o usuário preencher no formulário
    if (!empty($dataInicial)) {
        $builder->where('ds.DDS_DATA >=', $dataInicial);
    }

    if (!empty($dataFinal)) {
        $builder->where('ds.DDS_DATA <=', $dataFinal);
    }

    if ($tempMin !== null && $tempMin !== '') {
        $builder->where('ds.DDS_TEMP >=', (float)$tempMin);
    }

    // 6. Filtro de Classificação da Umidade
    $statusFiltroLimpio = trim(strtolower($statusFiltro));
    if ($statusFiltroLimpio !== 'todos' && !empty($statusFiltroLimpio)) {
        if ($statusFiltroLimpio === 'otimo') {
            $builder->where('ds.DDS_UMIDADE >', 70.00);
        } elseif ($statusFiltroLimpio === 'bom') {
            $builder->where('ds.DDS_UMIDADE >=', 40.00);
            $builder->where('ds.DDS_UMIDADE <=', 70.00);
        } elseif ($statusFiltroLimpio === 'ruim') {
            $builder->where('ds.DDS_UMIDADE <', 40.00);
        }
    } else {
        if ($umidadeMax !== null && $umidadeMax !== '') {
            $builder->where('ds.DDS_UMIDADE <=', (float)$umidadeMax);
        }
    }

    // 7. Executa a busca ordenando para a tabela
    $medicoesFiltradas = $builder->orderBy('ds.DDS_DATA DESC', 'ds.DDS_HORA DESC')
                                 ->get()
                                 ->getResultArray();

    $data['medicoes'] = $medicoesFiltradas;
    $data['titulo']   = "Histórico de Medições (Temperatura e Umidade)";
    
    // Mão única: Mantém o formulário limpo quando não houver busca de datas
    $data['filtro_valores'] = [
        'data_inicial'  => $dataInicial ?? '',
        'data_final'    => $dataFinal ?? '',
        'temp_min'      => $tempMin,
        'umidade_max'   => $umidadeMax,
        'status_filtro' => $statusFiltro
    ];

    // --- AGRUPAMENTO EM MÉDIA DIÁRIA PARA O GRÁFICO ---
    $agrupadoPorDia = [];
    foreach ($medicoesFiltradas as $med) {
        $dia = date('d/m', strtotime($med['DDS_DATA']));
        if (!isset($agrupadoPorDia[$dia])) {
            $agrupadoPorDia[$dia] = ['temp_soma' => 0, 'umid_soma' => 0, 'qtd' => 0];
        }
        $agrupadoPorDia[$dia]['temp_soma'] += (float)($med['DDS_TEMP'] ?? 0);
        $agrupadoPorDia[$dia]['umid_soma'] += (float)($med['DDS_UMIDADE'] ?? 0);
        $agrupadoPorDia[$dia]['qtd']++;
    }

    $agrupadoPorDia = array_reverse($agrupadoPorDia, true);

    $labels = [];
    $temperaturas = [];
    $umidades = [];

    foreach ($agrupadoPorDia as $dia => $valores) {
        $labels[]       = $dia;
        $temperaturas[] = round($valores['temp_soma'] / $valores['qtd'], 1);
        $umidades[]     = round($valores['umid_soma'] / $valores['qtd'], 1);
    }

    $data['dados_grafico'] = [
        'labels'       => $labels,
        'temperaturas' => $temperaturas,
        'umidades'     => $umidades
    ];

    return view('sistema/dados_sensores/historico', $data);
}
    /**
     * 2. RECEBER DADOS DA ESP32 (Endpoint de API)
     * Rota: POST /api/medicoes/receber
     */
    public function receber()
    {
        $json = $this->request->getJSON(true);

        if (empty($json)) {
            $json = $this->request->getPost();
        }

        if (empty($json['fk_sen_id']) || !isset($json['dds_umidade']) || !isset($json['dds_temp'])) {
            return $this->response->setJSON([
                'status'  => 'error',
                'message' => 'Dados incompletos (fk_sen_id, dds_umidade ou dds_temp ausentes).'
            ])->setStatusCode(400);
        }

        $novaMedicao = [
            'DDS_HORA'    => date('H:i:s'),
            'DDS_DATA'    => date('Y-m-d'),
            'DDS_TEMP'    => $json['dds_temp'],
            'DDS_UMIDADE' => $json['dds_umidade'],
            'DDS_UMIDADE_SOLO' => $json['dds_umidade_solo'],
            'FK_SEN_ID'   => $json['fk_sen_id']
        ];

        if ($this->dadosSensoresModel->insert($novaMedicao)) {
            return $this->response->setJSON([
                'status'  => 'success',
                'message' => 'Medição de temperatura e humidade gravada!'
            ])->setStatusCode(201);
        } else {
            return $this->response->setJSON([
                'status'  => 'error',
                'message' => 'Erro ao salvar no banco de dados.',
                'errors'  => $this->dadosSensoresModel->errors()
            ])->setStatusCode(500);
        }
    }
}