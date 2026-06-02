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
     * 1. LISTAGEM DE MEDIÇÕES (Interface Web filtrada por Usuário)
     * Rota: GET /historico
     */
    /**
     * 1. LISTAGEM DE MEDIÇÕES COM FILTROS ATIVOS
     * Rota: GET /historico
     */
    public function index()
    {
        // 1. Pega o ID do usuário logado direto da Session
        $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

        if (!$idUsuarioLogado) {
            return redirect()->to(base_url('login'))->with('error', 'Por favor, faça login para acessar seu histórico.');
        }

        // 2. Captura os valores dos filtros vindos da URL (via GET)
        $dataInicial = $this->request->getGet('data_inicial');
        $dataFinal   = $this->request->getGet('data_final');
        $tempMin     = $this->request->getGet('temp_min');
        $umidadeMax  = $this->request->getGet('umidade_max');

        // 3. Inicia a construção da Query com os JOINs base de segurança
        $query = $this->dadosSensoresModel->select('DADOS_SENSORES.*, SENSOR.SEN_NOME as nome_sensor')
            ->join('SENSOR', 'SENSOR.SEN_ID = DADOS_SENSORES.FK_SEN_ID')
            ->join('DISPOSITIVO', 'DISPOSITIVO.DIS_ID = SENSOR.FK_DIS_ID')
            ->where('DISPOSITIVO.FK_USU_ID', $idUsuarioLogado);

        // 4. Aplica os filtros dinamicamente apenas se o usuário preencheu os campos
        if (!empty($dataInicial)) {
            $query->where('DADOS_SENSORES.DDS_DATA >=', $dataInicial);
        }
        
        if (!empty($dataFinal)) {
            $query->where('DADOS_SENSORES.DDS_DATA <=', $dataFinal);
        }

        if ($tempMin !== null && $tempMin !== '') {
            $query->where('DADOS_SENSORES.DDS_TEMP >=', $tempMin);
        }

        if ($umidadeMax !== null && $umidadeMax !== '') {
            $query->where('DADOS_SENSORES.DDS_UMIDADE <=', $umidadeMax);
        }

        // 5. Executa a busca ordenando pelos mais recentes
        $medicoesFiltradas = $query->orderBy('DDS_DATA DESC', 'DDS_HORA DESC')->findAll();

        // 6. Devolve os valores selecionados para a View manter os campos preenchidos no ecrã
        $data['medicoes']      = $medicoesFiltradas;
        $data['titulo']        = "Histórico de Medições (Temperatura e Umidade)";
        $data['filtro_valores'] = [
            'data_inicial' => $dataInicial ?? date('Y-m-01'),
            'data_final'   => $dataFinal ?? date('Y-m-d'),
            'temp_min'     => $tempMin,
            'umidade_max'  => $umidadeMax
        ];

        return view('sistema/planta/historico', $data);
    }
    /**
     * 2. RECEBER DADOS DA ESP32 (Endpoint de API)
     * Rota: POST /api/medicoes/receber
     */
    public function receber()
    {
        // Pega o JSON enviado pela ESP32
        $json = $this->request->getJSON(true);

        if (empty($json)) {
            $json = $this->request->getPost();
        }

        // Validação: Verifica se os dados necessários da ESP32 estão presentes
        if (empty($json['fk_sen_id']) || !isset($json['dds_umidade']) || !isset($json['dds_temp'])) {
            return $this->response->setJSON([
                'status'  => 'error',
                'message' => 'Dados incompletos (fk_sen_id, dds_umidade ou dds_temp ausentes).'
            ])->setStatusCode(400);
        }

        // Prepara os dados incluindo o campo DDS_TEMP
        $novaMedicao = [
            'DDS_HORA'    => date('H:i:s'),
            'DDS_DATA'    => date('Y-m-d'),
            'DDS_TEMP'    => $json['dds_temp'],
            'DDS_UMIDADE' => $json['dds_umidade'],
            'FK_SEN_ID'   => $json['fk_sen_id']
        ];

        // Salva no banco de dados
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