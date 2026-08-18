<?php

namespace App\Controllers;

use App\Models\UsuarioModel;
use CodeIgniter\Controller;

class UsuarioController extends BaseController
{
    protected $usuarioModel;

    public function __construct()
    {
        $this->usuarioModel = new UsuarioModel();
    }

    // Listar todos os usuários
    public function index()
    {
        $data = [
            'titulo'   => 'Lista de Usuários',
            'usuarios' => $this->usuarioModel->findAll()
        ];

        return view('usuario/lista', $data);
    }

    // Página de Cadastro
    public function novo()
    {
        return view('usuarios/cadastro');
    }

    // Salvar Dados do Formulário
    public function salvar()
{
    $postData = $this->request->getPost();

    if ($this->usuarioModel->save($postData)) {
        // Redireciona o novo usuário direto para a tela de login com uma mensagem!
        return redirect()->to('/login')->with('sucesso', 'Cadastro realizado com sucesso! Faça seu login.');
    } else {
        return redirect()->back()
                         ->withInput()
                         ->with('errors', $this->usuarioModel->errors());
    }
}

    // Formulário de Edição
    public function editar($id)
    {
        $usuario = $this->usuarioModel->find($id);

        if (!$usuario) {
            throw \CodeIgniter\Exceptions\PageNotFoundException::forPageNotFound("Usuário $id não existe.");
        }

        return view('usuarios/perfil', ['usuario' => $usuario]);
    }

    // Excluindo o mano
    public function excluir($id)
    {
        if ($this->usuarioModel->delete($id)) {
            return redirect()->to('/usuarios')->with('sucesso', 'Usuário removido!');
        }
        
        return redirect()->to('/usuarios')->with('error', 'Erro ao remover usuário.');
    }
}