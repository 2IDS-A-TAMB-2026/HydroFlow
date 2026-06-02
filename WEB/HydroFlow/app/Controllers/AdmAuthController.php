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
            // 1. Verifica se a senha bate
            // 2. Verifica se o administrador está ATIVO no sistema
            if ($this->request->getPost('senha') == $admin['ADM_SENHA']) {
                
                if ($admin['ADM_STATUS'] === 'ATIVO') {
                    
                    // Define a sessão específica para o administrador
                    session()->set([
                        'ADM_ID'     => $admin['ADM_ID'],
                        'ADM_NOME'   => $admin['ADM_NOME'],
                        'logado_adm' => true // Identificador exclusivo para rotas protegidas de ADM
                    ]);

                    // Redireciona para o painel do administrador (mude para a sua rota de admin)
                    return redirect()->to('/admin/dashboard');
                    
                } else {
                    // Caso o administrador esteja INATIVO no banco
                    session()->setFlashdata('erro', 'Esta conta de administrador está desativada.');
                    return redirect()->to('/admin/login');
                }
            }
        }

        // Mensagem de erro padrão para e-mail ou senhas incorretas
        session()->setFlashdata('erro', 'E-mail ou senha de administrador inválidos.');
        return redirect()->to('/admin/login');
    }

    public function logout()
    {
        // Destrói apenas os dados da sessão do administrador para não deslogar um usuário comum caso estejam no mesmo navegador testing
        session()->remove(['ADM_ID', 'ADM_NOME', 'logado_adm']);

        return redirect()->to('/admin/login');
    }
}