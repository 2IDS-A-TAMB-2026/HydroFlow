<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\AdmModel;

class AdmAuthController extends BaseController
{
    public function autenticar()
    {
        $model = new AdmModel();

        // Busca o administrador pelo e-mail postado
        $admin = $model->where('ADM_EMAIL', $this->request->getPost('email'))->first();

        if ($admin) {
            // Verifica se a senha bate
            if ($this->request->getPost('senha') == $admin['ADM_SENHA']) {
                
                // Verifica se o administrador está ATIVO no sistema
                if ($admin['ADM_STATUS'] === 'ATIVO') {
                    
                    // ⚠️ TRAVA DE SEGURANÇA: Limpa qualquer sessão de usuário comum anterior
                    // para evitar que as credenciais se misturem no filtro
                    session()->remove(['id', 'usuario_tipo', 'logado']);
                    
                    // Define a sessão específica para o administrador
                    session()->set([
                        'ADM_ID'     => $admin['ADM_ID'],
                        'ADM_NOME'   => $admin['ADM_NOME'],
                        'logado_adm' => true, // Identificador exclusivo lido pelo AuthFilter
                        'logado'     => false  // Força o login comum a ser falso
                    ]);

                    // Redireciona para o painel do administrador
                    return redirect()->to('/admin/dashboard');
                    
                } else {
                    session()->setFlashdata('erro', 'Esta conta de administrador está desativada.');
                    return redirect()->to('/admin/login');
                }
            }
        }

        session()->setFlashdata('erro', 'E-mail ou senha de administrador inválidos.');
        return redirect()->to('/admin/login');
    }

    public function logout()
    {
        // Destrói totalmente a sessão atual para garantir segurança máxima
        session()->destroy();

        return redirect()->to('/admin/login');
    }
}