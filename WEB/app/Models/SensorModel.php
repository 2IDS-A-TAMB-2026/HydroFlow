<?php

namespace App\Models;

use CodeIgniter\Model;

class SensorModel extends Model
{
    protected $table            = 'SENSOR';
    protected $primaryKey       = 'SEN_ID';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';

    // FK_DIS_ID tem que estar aqui para você conseguir cadastrar!
    protected $allowedFields = [
        'SEN_NOME',
        'SEN_STATUS',
        'SEN_TIPO',
        'FK_DIS_ID'
    ];

    // Regras de validação para não quebrar o ENUM nem a FK
    protected $validationRules = [
        'SEN_NOME'   => 'required|max_length[50]',
        'SEN_STATUS' => 'permit_empty|in_list[ATIVO,INATIVO]',
        'SEN_TIPO'   => 'required|max_length[30]',
        'FK_DIS_ID'  => 'required|is_not_unique[DISPOSITIVO.DIS_ID]'
    ];

    /**
     * Bônus: Listagem completa trazendo o nome do dispositivo
     */
    public function getSensoresComDispositivo()
    {
        return $this->select('SENSOR.*, DISPOSITIVO.DIS_NOME')
                    ->join('DISPOSITIVO', 'DISPOSITIVO.DIS_ID = SENSOR.FK_DIS_ID')
                    ->findAll();
    }
}