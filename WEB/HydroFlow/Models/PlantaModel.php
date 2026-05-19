<?php

namespace App\Models;

use CodeIgniter\Model;

class PlantaModel extends Model
{
    // Nome da tabela no banco de dados
    protected $table = 'PLANTA';

    // A chave primária definida no seu SQL
    protected $primaryKey = 'PLANTA_ID';

    // Você PRECISA listar todos aqui para conseguir inserir dados.
    protected $allowedFields = [
        'PLANTA_NOME',
        'PLANTA_TIPO',
        'PLANTA_QTD_AGUA',
        'PLANTA_PERIDIOCIDADE',
        'PLANTA_CULTURA',
        'FK_USU_ID',
        'FK_DIS_ID'
    ];

    // Configurações adicionais úteis
    protected $useAutoIncrement = true;

    
    protected $validationRules = [
        'PLANTA_NOME'          => 'required|min_length[3]|max_length[255]',
        'PLANTA_TIPO'          => 'required|max_length[20]',
        'PLANTA_PERIDIOCIDADE' => 'required|integer',
        'FK_USU_ID'            => 'required|integer',
        'FK_DIS_ID'            => 'required|integer',
    ];
}