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
        // Regras de validação incluindo o e-mail e CPF únicos
        // Ajuste 'nome_da_tabela' para o nome correto da sua tabela no banco (ex: usuarios)
        $regras = [
            'USU_CPF'   => 'required|is_unique[USUARIO.USU_CPF]',
            'USU_EMAIL' => 'required|valid_email|is_unique[USUARIO.USU_EMAIL]',
            'USU_NOME'  => 'required',
            'USU_SENHA' => 'required'
        ];

        // Mensagens personalizadas que vão aparecer no SweetAlert2
        $mensagens = [
            'USU_CPF' => [
                'required'  => 'O campo CPF é obrigatório.',
                'is_unique' => 'Este CPF já está cadastrado no sistema!'
            ],
            'USU_EMAIL' => [
                'required'    => 'O campo E-mail é obrigatório.',
                'valid_email' => 'Informe um e-mail válido.',
                'is_unique'   => 'Este E-mail já está cadastrado no sistema!'
            ]
        ];

        // Valida antes de enviar para a Model
        if (!$this->validate($regras, $mensagens)) {
            return redirect()->back()
                             ->withInput()
                             ->with('errors', $this->validator->getErrors());
        }

        $postData = $this->request->getPost();

        // Criptografa a senha antes de salvar por segurança
        if (isset($postData['USU_SENHA'])) {
            $postData['USU_SENHA'] = password_hash($postData['USU_SENHA'], PASSWORD_DEFAULT);
        }

        if ($this->usuarioModel->save($postData)) {
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