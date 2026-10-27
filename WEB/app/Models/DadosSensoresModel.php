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
        'DDS_STATUS',
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

    
    /**
     * Busca a última medição registrada de cada dispositivo.
     */
    public function getUltimaMedicaoPorDispositivo()
    {
        $db = \Config\Database::connect();

        $subquery = $db->table('DADOS_SENSORES ds2')
            ->select('MAX(ds2.DDS_ID)', false)
            ->join('SENSOR s2', 's2.SEN_ID = ds2.FK_SEN_ID')
            ->where('s2.FK_DIS_ID = D.DIS_ID', null, false);

        return $db->table('DISPOSITIVO D')
            ->select('
                D.DIS_ID,
                D.DIS_NOME,
                D.DIS_STATUS,
                U.USU_NOME AS nome_usuario,
                DS.DDS_DATA AS ultima_data,
                DS.DDS_HORA AS ultima_hora
            ')
            ->join('USUARIO U', 'U.USU_ID = D.FK_USU_ID', 'left')
            ->join(
                'SENSOR S',
                'S.FK_DIS_ID = D.DIS_ID',
                'left'
            )
            ->join(
                'DADOS_SENSORES DS',
                'DS.FK_SEN_ID = S.SEN_ID
                AND DS.DDS_ID = (' . $subquery->getCompiledSelect() . ')',
                'left',
                false
            )
            ->groupBy([
                'D.DIS_ID',
                'D.DIS_NOME',
                'D.DIS_STATUS',
                'U.USU_NOME',
                'DS.DDS_DATA',
                'DS.DDS_HORA'
            ])
            ->orderBy('D.DIS_NOME', 'ASC')
            ->get()
            ->getResultArray();
    }

}