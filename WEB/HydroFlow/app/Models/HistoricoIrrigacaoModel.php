<?php

namespace App\Models;

use CodeIgniter\Model;

class HistoricoIrrigacaoModel extends Model
{
    protected $table            = 'HISTORICO_IRRIGACAO';
    protected $primaryKey       = 'IRR_ID';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    
    protected $allowedFields    = [
        'IRR_DATA', 
        'IRR_HORA', 
        'IRR_DURACAO', 
        'IRR_VOLUME', 
        'IRR_ACIONAMENTO', 
        'IRR_STATUS', 
        'FK_USU_ID', 
        'FK_PLANTA_ID', 
        'FK_DIS_ID'
    ];

    // --- REGRAS DE VALIDAÇÃO (Centralizadas no Model para segurança do IoT) ---
    protected $validationRules = [
        'IRR_DATA'        => 'required|valid_date[Y-m-d]',
        'IRR_HORA'        => 'required',
        'IRR_DURACAO'     => 'required|integer|greater_than_equal_to[0]',
        'IRR_VOLUME'      => 'permit_empty|decimal',
        'IRR_ACIONAMENTO' => 'required|in_list[Automático,Manual]',
        'IRR_STATUS'      => 'required|in_list[Concluído,Falha,Interrompido]',
        'FK_USU_ID'       => 'required|integer',
        'FK_PLANTA_ID'    => 'required|integer',
        'FK_DIS_ID'       => 'required|integer'
    ];

    // --- MENSAGENS DE ERRO PERSONALIZADAS ---
    protected $validationMessages = [
        'IRR_DURACAO' => [
            'required' => 'A duração da irrigação deve ser informada.',
            'integer'  => 'A duração deve ser um valor inteiro em minutos.'
        ],
        'IRR_ACIONAMENTO' => [
            'in_list' => 'O tipo de acionamento deve ser "Automático" ou "Manual".'
        ],
        'IRR_STATUS' => [
            'in_list' => 'O status deve ser "Concluído", "Falha" ou "Interrompido".'
        ],
        'FK_PLANTA_ID' => [
            'required' => 'O registro deve estar associado a uma planta/setor.'
        ],
        'FK_DIS_ID' => [
            'required' => 'O registro deve identificar qual dispositivo executou a ação.'
        ]
    ];

    /**
     * Busca o histórico de irrigações aplicando os JOINs necessários de forma limpa.
     * Filtra pelo usuário logado e injeta os dados da Planta e do Dispositivo.
     */
    public function getHistoricoCompleto($idUsuarioLogado, $filtros = [])
    {
        $query = $this->select('HISTORICO_IRRIGACAO.*, PLANTA.PLANTA_NOME as nome_planta, PLANTA.PLANTA_CULTURA as cultura, DISPOSITIVO.DIS_NOME as nome_dispositivo')
                      ->join('PLANTA', 'PLANTA.PLANTA_ID = HISTORICO_IRRIGACAO.FK_PLANTA_ID')
                      ->join('DISPOSITIVO', 'DISPOSITIVO.DIS_ID = HISTORICO_IRRIGACAO.FK_DIS_ID')
                      ->where('HISTORICO_IRRIGACAO.FK_USU_ID', $idUsuarioLogado);

        // Aplicação dos filtros dinâmicos caso venham do Controller
        if (!empty($filtros['data_inicial'])) {
            $query->where('HISTORICO_IRRIGACAO.IRR_DATA >=', $filtros['data_inicial']);
        }
        if (!empty($filtros['data_final'])) {
            $query->where('HISTORICO_IRRIGACAO.IRR_DATA <=', $filtros['data_final']);
        }
        if (!empty($filtros['setor_filtro']) && $filtros['setor_filtro'] !== 'todos') {
            $query->where('HISTORICO_IRRIGACAO.FK_PLANTA_ID', $filtros['setor_filtro']);
        }
        if (!empty($filtros['status_filtro']) && $filtros['status_filtro'] !== 'todos') {
            $query->where('HISTORICO_IRRIGACAO.IRR_STATUS', $filtros['status_filtro']);
        }

        // Ordena sempre trazendo os eventos mais recentes no topo do painel
        return $query->orderBy('IRR_DATA DESC', 'IRR_HORA DESC')
                     ->findAll();
    }
}