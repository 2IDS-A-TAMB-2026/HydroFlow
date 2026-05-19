<?php

namespace App\Models;

use CodeIgniter\Model;

class DispositivoModel extends Model
{
    protected $table            = 'DISPOSITIVO';
    protected $primaryKey       = 'DIS_ID';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';

    protected $allowedFields = [
        'DIS_NOME',
        'DIS_DESCRICAO',
        'DIS_STATUS',
        'DIS_NIVEL_TANQUE',
        'DIS_ENDERECO',
        'DIS_CEP',
        'DIS_RUA',
        'DIS_NUM',
        'DIS_CIDADE',
        'DIS_UF',
        'DIS_LATITUDE',
        'DIS_LONGITUDE',
        'FK_USU_ID' // Chave Estrangeira
    ];

    // --- REGRAS DE VALIDAÇÃO ---
    protected $validationRules = [
        'DIS_NOME'         => 'required|min_length[3]',
        'DIS_STATUS'       => 'required|in_list[ATIVO,INATIVO]',
        'DIS_NIVEL_TANQUE' => 'required|decimal',
        'DIS_LATITUDE'     => 'required|max_length[20]',
        'DIS_LONGITUDE'    => 'required|max_length[20]',
        'FK_USU_ID'        => 'required|is_not_unique[USUARIO.USU_ID]' // Garante que o usuário existe
    ];

    /**
     * BÔNUS: Método para buscar o dispositivo e os dados do usuário dono
     */
    public function getDispositivoComDono($id = null)
    {
        $builder = $this->builder();
        $builder->select('DISPOSITIVO.*, USUARIO.USU_NOME as dono_nome, USUARIO.USU_EMAIL as dono_email');
        $builder->join('USUARIO', 'USUARIO.USU_ID = DISPOSITIVO.FK_USU_ID');
        
        if ($id !== null) {
            return $builder->where('DIS_ID', $id)->get()->getRowArray();
        }

        return $builder->get()->getResultArray();
    }
}