<?php

namespace App\Models;

use CodeIgniter\Model;

class DadosSensoresModel extends Model
{
    protected $table      = 'DADOS_SENSORES';
    protected $primaryKey = 'DDS_ID';

    protected $useAutoIncrement = true;

    // Campos que o CodeIgniter tem permissão para manipular
    protected $allowedFields = [
        'DDS_HORA',
        'DDS_DATA',
        'DDS_UMIDADE',
        'DDS_TEMP',
        'FK_SEN_ID'
    ];

    protected $returnType = 'array';

    /**
     * Regras de validação para garantir a integridade dos dados
     * DECIMAL(4,2) permite valores como 99.99
     */
    protected $validationRules = [
        'DDS_UMIDADE' => 'required|decimal',
        'DDS_TEMP' => 'required|decimal',
        'FK_SEN_ID'   => 'required|integer'
    ];

    /**
     * Método útil para buscar as últimas leituras de um sensor específico
     */
    public function getUltimasLeituras(int $sensorId, int $limite = 10)
    {
        return $this->where('FK_SEN_ID', $sensorId)
                    ->orderBy('DDS_ID', 'DESC') // Pega os mais recentes primeiro
                    ->findAll($limite);
    }
}