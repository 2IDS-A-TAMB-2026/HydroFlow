<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\DadosSensoresModel;

class Medicoes extends BaseController
{
    /**
     * Propriedade protegida para armazenar a instância do Model
     */
    protected $dadosSensoresModel;

    /**
     * Construtor da classe para inicializar o Model globalmente no Controller
     */
    public function __construct()
    {
        $this->dadosSensoresModel = new DadosSensoresModel();
    }

    /**
     * 1. LISTAGEM DE MEDIÇÕES (Para a interface Web/Dashboard)
     * Rota sugerida: GET /medicoes
     */
    public function index()
    {
        // Puxa as medições do banco fazendo o JOIN com a tabela de Sensores
        $data['medicoes'] = $this->dadosSensoresModel->getMedicoesComSensor();
        $data['titulo']   = "Histórico de Medições dos Sensores";

        // Renderiza a interface enviando o array de dados para a View
        echo view('templates/header', $data);
        echo view('medicoes/listar', $data);
        echo view('templates/footer');
    }

    /**
     * 2. RECONHECIMENTO DE DADOS DA ESP32 (Endpoint de API)
     * Rota sugerida: POST /api/medicoes/receber
     */
    public function receber()
    {
        // Tenta capturar o JSON bruto enviado no corpo da requisição da ESP32
        $json = $this->request->getJSON(true);

        // Caso a ESP32 envie como formulário tradicional x-www-form-urlencoded
        if (empty($json)) {
            $json = $this->request->getPost();
        }

        // Validação básica: confere se as chaves necessárias existem na requisição
        if (empty($json['fk_sen_id']) || !isset($json['dds_umidade'])) {
            return $this->response->setJSON([
                'status'  => 'error',
                'message' => 'Dados incompletos (fk_sen_id ou dds_umidade ausentes).'
            ])->setStatusCode(400); // Bad Request
        }

        // Prepara a estrutura do array baseada nas colunas da tabela DADOS_SENSORES
        // Pega automaticamente a data e hora do servidor no momento do insert
        $novaMedicao = [
            'DDS_HORA'    => date('H:i:s'),
            'DDS_DATA'    => date('Y-m-d'),
            'DDS_UMIDADE' => $json['dds_umidade'],
            'FK_SEN_ID'   => $json['fk_sen_id']
        ];

        // Tenta salvar os dados tratados no Banco através do Model
        if ($this->dadosSensoresModel->insert($novaMedicao)) {
            // Retorna resposta de sucesso para a ESP32
            return $this->response->setJSON([
                'status'  => 'success',
                'message' => 'Medição gravada com sucesso!'
            ])->setStatusCode(201); // Created
        } else {
            // Caso ocorra falha na inserção (erros de validação, tipo de dados, etc.)
            return $this->response->setJSON([
                'status'  => 'error',
                'message' => 'Erro ao salvar no banco de dados.',
                'errors'  => $this->dadosSensoresModel->errors()
            ])->setStatusCode(500); // Internal Server Error
        }
    }
}