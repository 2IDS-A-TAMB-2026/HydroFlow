<?php

namespace App\Models;

use CodeIgniter\Model;

class UsuarioModel extends Model
{
    protected $table            = 'USUARIO';
    protected $primaryKey       = 'USU_ID';
    protected $useAutoIncrement = true;
    
    protected $allowedFields = [
        'USU_BAIRRO', 'USU_NUM', 'USU_NOME', 'USU_STATUS', 
        'USU_CPF', 'USU_EMAIL', 'USU_SENHA', 'USU_CIDADE', 
        'USU_UF', 'USU_CEP'
    ];

    // --- CALLBACKS (Gatilhos Automáticos) ---
    protected $beforeInsert = ['hashPassword', 'setInitialStatus'];
    protected $beforeUpdate = ['hashPassword'];

    /**
     * Criptografa a senha antes de salvar no banco
     */
    protected function hashPassword(array $data)
    {
        if (!isset($data['data']['USU_SENHA'])) {
            return $data;
        }

        $data['data']['USU_SENHA'] = password_hash($data['data']['USU_SENHA'], PASSWORD_DEFAULT);
        return $data;
    }

    /**
     * Garante que todo novo usuário comece como 'ATIVO'
     */
    protected function setInitialStatus(array $data)
    {
        if (!isset($data['data']['USU_STATUS'])) {
            $data['data']['USU_STATUS'] = 'ATIVO';
        }
        return $data;
    }
}
