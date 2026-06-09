<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\DadosSensoresModel;

class Dados_SensoresController extends BaseController
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

    // Instancia a conexão nativa com o banco de dados
    $db = \Config\Database::connect();

    // 3. Busca os Sensores que pertencem a este usuário logado
    $sensoresDoUsuario = $db->table('SENSOR s')
        ->select('s.SEN_ID')
        ->join('DISPOSITIVO d', 'd.DIS_ID = s.FK_DIS_ID')
        ->where('d.FK_USU_ID', $idUsuarioLogado)
        ->get()
        ->getResultArray();

    $idsSensores = array_column($sensoresDoUsuario, 'SEN_ID');

    // Se o usuário não tiver sensores, retorna vazio de primeira
    if (empty($idsSensores)) {
        $data['medicoes']       = [];
        $data['titulo']         = "Histórico de Medições (Temperatura e Umidade)";
        $data['filtro_valores'] = [
            'data_inicial'  => $dataInicial ?? date('Y-m-01'),
            'data_final'    => $dataFinal ?? date('Y-m-d'),
            'temp_min'      => $tempMin,
            'umidade_max'   => $umidadeMax,
            'status_filtro' => $statusFiltro
        ];
        return view('sistema/dados_sensores/historico', $data);
    }

    // 4. 👉 A SOLUÇÃO: Usar o construtor nativo ($db->table) para o select não ser corrompido pelo Model
    $builder = $db->table('DADOS_SENSORES ds')
        ->select('ds.*, s.SEN_NOME as nome_sensor')
        ->join('SENSOR s', 's.SEN_ID = ds.FK_SEN_ID')
        ->whereIn('ds.FK_SEN_ID', $idsSensores);

    // 5. Só aplica o filtro de data se o usuário realmente mexeu no calendário (ignorando as travas automáticas de 2026)
    if (!empty($dataInicial) && $dataInicial !== date('Y-m-01') && $dataInicial !== '2026-06-01') {
        $builder->where('ds.DDS_DATA >=', $dataInicial);
    }
    
    if (!empty($dataFinal) && $dataFinal !== date('Y-m-d') && $dataFinal !== '2026-06-09') {
        $builder->where('ds.DDS_DATA <=', $dataFinal);
    }

    // Filtro de Temperatura Mínima
    if ($tempMin !== null && $tempMin !== '') {
        $builder->where('ds.DDS_TEMP >=', (float)$tempMin);
    }

    // 6. FILTRO DE CLASSIFICAÇÃO DA UMIDADE (Rodando direto na tabela nativa)
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
        // Se estiver em 'Todos', aceita o corte manual do input de teto se preenchido
        if ($umidadeMax !== null && $umidadeMax !== '') {
            $builder->where('ds.DDS_UMIDADE <=', (float)$umidadeMax);
        }
    }

    // 7. Executa a query pura ordenando e convertendo para Array igual ao Model fazia
    $medicoesFiltradas = $builder->orderBy('ds.DDS_DATA DESC', 'ds.DDS_HORA DESC')
                                 ->get()
                                 ->getResultArray();

    // 8. Envia tudo mastigado para a View
    $data['medicoes']       = $medicoesFiltradas;
    $data['titulo']         = "Histórico de Medições (Temperatura e Umidade)";
    $data['filtro_valores'] = [
        'data_inicial'  => $dataInicial ?? date('Y-m-01'),
        'data_final'    => $dataFinal ?? date('Y-m-d'),
        'temp_min'      => $tempMin,
        'umidade_max'   => $umidadeMax,
        'status_filtro' => $statusFiltro
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