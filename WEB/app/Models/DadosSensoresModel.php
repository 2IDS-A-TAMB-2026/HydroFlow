<?php

namespace App\Models;

use CodeIgniter\Model;

class DadosSensoresModel extends Model
{
    protected $table = 'DADOS_SENSORES';
    protected $primaryKey = 'DDS_ID';
    protected $useAutoIncrement = true;
    protected $returnType = 'array';

    protected $allowedFields = [
        'DDS_HORA',
        'DDS_DATA',
        'DDS_TEMP',
        'DDS_UMIDADE',
        'DDS_UMIDADE_SOLO',
        'FK_SEN_ID'
    ];

    /**
     * Procura as medições trazendo os dados do Sensor
     * e filtrando pelo usuário.
     */
    public function getMedicoesPorUsuario($idUsuario)
    {
        return $this->select(
                'DADOS_SENSORES.*, 
                 SENSOR.SEN_NOME as nome_sensor'
            )
            ->join(
                'SENSOR',
                'SENSOR.SEN_ID = DADOS_SENSORES.FK_SEN_ID'
            )
            ->join(
                'DISPOSITIVO',
                'DISPOSITIVO.DIS_ID = SENSOR.FK_DIS_ID'
            )
            ->where(
                'DISPOSITIVO.FK_USU_ID',
                $idUsuario
            )
            ->orderBy(
                'DDS_DATA DESC',
                'DDS_HORA DESC'
            )
            ->findAll();
    }
}