<?php

namespace App\Models;

use CodeIgniter\Model;

class DadosSensoresModel extends Model
{
    protected $table            = 'DADOS_SENSORES';
    protected $primaryKey       = 'DDS_ID';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    
    // Adicionado 'DDS_TEMP' aos campos permitidos
    protected $allowedFields    = ['DDS_HORA', 'DDS_DATA', 'DDS_TEMP', 'DDS_UMIDADE', 'FK_SEN_ID'];

    /**
     * Procura as medições trazendo os dados do Sensor e incluindo a temperatura
     */
    public function getMedicoesComSensor()
    {
        return $this->select('DADOS_SENSORES.*, SENSOR.SEN_NOME as nome_sensor') // Ajusta 'SEN_NOME' se o campo na tabela SENSOR for diferente
                    ->join('SENSOR', 'SENSOR.SEN_ID = DADOS_SENSORES.FK_SEN_ID')
                    ->orderBy('DDS_DATA DESC', 'DDS_HORA DESC') // Mais recentes primeiro
                    ->findAll();
    }
}