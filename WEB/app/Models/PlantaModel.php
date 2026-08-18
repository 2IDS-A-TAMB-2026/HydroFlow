<?php

namespace App\Models;

use CodeIgniter\Model;

class PlantaModel extends Model
{
    protected $table = 'PLANTA';
    protected $primaryKey = 'PLANTA_ID';
    protected $allowedFields = [
        'PLANTA_NOME', 'PLANTA_TIPO', 'PLANTA_QTD_AGUA',
        'PLANTA_PERIDIOCIDADE', 'PLANTA_CULTURA', 'FK_USU_ID', 'FK_DIS_ID'
    ];
    protected $useAutoIncrement = true;

    protected $validationRules = [
        'PLANTA_NOME'          => 'required|min_length[3]|max_length[255]',
        'PLANTA_TIPO'          => 'required|max_length[20]',
        'PLANTA_PERIDIOCIDADE' => 'required|integer',
        'FK_USU_ID'            => 'required|integer',
        'FK_DIS_ID'            => 'required|integer',
    ];

    // --- MÉTODOS PARA OS GRÁFICOS ---

    // Quantidade de plantas agrupadas por tipo
    public function getQtdPorTipo($idUsuario)
    {
        return $this->select('PLANTA_TIPO as tipo, COUNT(*) as total')
                    ->where('FK_USU_ID', $idUsuario)
                    ->groupBy('PLANTA_TIPO')
                    ->findAll();
    }

    // Top plantas que mais consomem água (ml)
    public function getConsumoAguaPorPlanta($idUsuario, $limite = 5)
    {
        return $this->select('PLANTA_NOME as nome, PLANTA_QTD_AGUA as qtd_agua')
                    ->where('FK_USU_ID', $idUsuario)
                    ->orderBy('PLANTA_QTD_AGUA', 'DESC')
                    ->limit($limite)
                    ->findAll();
    }
}