<?php

namespace App\Models;

use CodeIgniter\Model;

class AdmModel extends Model
{
    protected $table            = 'ADM';
    protected $primaryKey       = 'ID_ADM';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';

    protected $allowedFields = [
        'NOME_ADM',
        'STATUS_ADM',
        'EMAIL_ADM',
        'SENHA_ADM'
    ];

    // --- REGRAS DE VALIDAÇÃO ---
    protected $validationRules = [
        'NOME_ADM'   => 'required|min_length[3]',
        'EMAIL_ADM'  => 'required|valid_email|is_unique[ADM.EMAIL_ADM,ID_ADM,{ID_ADM}]',
        'SENHA_ADM'  => 'required|min_length[8]',
        // Validação específica para garantir que só aceite os valores do ENUM
        'STATUS_ADM' => 'required|in_list[ATIVO,INATIVO]' 
    ];

    protected $beforeInsert = ['hashPassword', 'setDefaultStatus'];
    protected $beforeUpdate = ['hashPassword'];

    protected function hashPassword(array $data)
    {
        if (isset($data['data']['SENHA_ADM'])) {
            $data['data']['SENHA_ADM'] = password_hash($data['data']['SENHA_ADM'], PASSWORD_DEFAULT);
        }
        return $data;
    }

    protected function setDefaultStatus(array $data)
    {
        // Se não for enviado status, define como o valor padrão do ENUM
        if (!isset($data['data']['STATUS_ADM'])) {
            $data['data']['STATUS_ADM'] = 'ATIVO';
        }
        return $data;
    }
}

?>