<?php

namespace App\Controllers;

use App\Controllers\BaseController;
// Supondo que você tenha um Model para o Adm e outro para os Usuários que ele gerencia
use App\Models\AdmModel; 
use App\Models\UsuarioModel; 

class Adm extends BaseController
{
    protected $admModel;
    protected $usuarioModel;

    public function __construct()
    {
        // Inicializa os models necessários
        $this->admModel = new AdmModel();
        $this->usuarioModel = new UsuarioModel();
    }

    /**
     * Corresponde ao método gerenciarUsuarios() do seu diagrama UML.
     * Esse método vai listar os usuários do sistema para o administrador.
     */
    public function gerenciarUsuarios()
    {
        // 1. Busca todos os usuários do banco de dados através do Model de usuários
        $dados['usuarios'] = $this->usuarioModel->findAll();

        // 2. Passa o título da página ou outras infos necessárias
        $dados['titulo'] = "Gerenciamento de Usuários";

        // 3. Renderiza as views (banco de dados + visual)
        // Substitua pelos nomes reais das suas views
        echo view('templates/header', $dados);
        echo view('adm/gerenciar_usuarios', $dados);
        echo view('templates/footer');
    }
}