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
        'USU_UF', 'USU_CEP', 'USU_RUA'
    ];

    // Mantido apenas o gatilho para definir o status inicial como ATIVO
    protected $beforeInsert = ['setInitialStatus'];

    /**
     * Garante que todo novo usuário comece como 'ATIVO' por padrão
     */
    protected function setInitialStatus(array $data)
    {
        if (!isset($data['data']['USU_STATUS'])) {
            $data['data']['USU_STATUS'] = 'ATIVO';
        }
        return $data;
    }
}