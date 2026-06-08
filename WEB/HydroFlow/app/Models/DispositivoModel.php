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
    // 1. Definimos o select trazendo o apelido 'dono_nome' que você já usava
    $this->select('DISPOSITIVO.*, USUARIO.USU_NOME as dono_nome, USUARIO.USU_EMAIL as dono_email');
    $this->join('USUARIO', 'USUARIO.USU_ID = DISPOSITIVO.FK_USU_ID', 'left'); // left join evita sumir dispositivos sem dono
    
    // 2. Se passar o ID, busca um só (para a tela de edição)
    if ($id !== null) {
        return $this->where('DIS_ID', $id)->first();
    }

    // 3. ATENÇÃO: Retornamos apenas o $this (sem fechar com find/findAll). 
    // Isso permite que o Controller coloque os filtros de busca antes de dar o findAll().
    return $this;
}

}