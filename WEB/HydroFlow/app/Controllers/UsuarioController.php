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

    // Listar todos os usuários :o
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

    // Salvar (entra em novo ou em edição ?)
    public function salvar()
    {
        // Pegando os bglh do psot
        $postData = $this->request->getPost();

        // Tenta salvar (o save() escolhe entre o Insert ou Update baseado no ID)
        if ($this->usuarioModel->save($postData)) {
            return redirect()->to('/usuarios')->with('success', 'Usuário salvo com sucesso!');
        } else {
            // Se a validação da Model falhar, volta para o formulário com os erros
            return redirect()->back()
                             ->withInput()
                             ->with('errors', $this->usuarioModel->errors());
        }
    }

    // Formulário de Edição com base nos dados que já tinha do mano
    public function editar($id)
    {
        $usuario = $this->usuarioModel->find($id);

        if (!$usuario) {
            throw \CodeIgniter\Exceptions\PageNotFoundException::forPageNotFound("Usuário $id não existe.");
        }

        return view('usuarios/perfil', ['usuario' => $usuario]);
    }

    // Excluindo o mano :o
    public function excluir($id)
    {
        if ($this->usuarioModel->delete($id)) {
            return redirect()->to('/usuarios')->with('success', 'Usuário removido!');
        }
        
        return redirect()->to('/usuarios')->with('error', 'Erro ao remover usuário.');
    }
}