<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\DadosSensoresModel;

class Medicoes extends BaseController
{
    protected $dadosSensoresModel;

    public function __construct()
    {
        $this->dadosSensoresModel = new DadosSensoresModel();
    }

    /**
     * 1. LISTAGEM DE MEDIÇÕES (Interface Web)
     * Rota: GET /medicoes
     */
    public function index()
    {
        $data['medicoes'] = $this->dadosSensoresModel->getMedicoesComSensor();
        $data['titulo']   = "Histórico de Medições (Temperatura e Humidade)";

        echo view('templates/header', $data);
        echo view('medicoes/listar', $data); // Lembra-te de adicionar a coluna de Temperatura na tua View HTML!
        echo view('templates/footer');
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

        // Validação: Agora verifica se fk_sen_id, dds_umidade E dds_temp estão presentes
        if (empty($json['fk_sen_id']) || !isset($json['dds_umidade']) || !isset($json['dds_temp'])) {
            return $this->response->setJSON([
                'status'  => 'error',
                'message' => 'Dados incompletos (fk_sen_id, dds_umidade ou dds_temp ausentes).'
            ])->setStatusCode(400);
        }

        // Prepara os dados incluindo o novo campo DDS_TEMP
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