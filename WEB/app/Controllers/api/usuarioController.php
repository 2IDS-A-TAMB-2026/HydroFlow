<?php
namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;

class UsuarioController extends ResourceController{
    protected $modelName = 'App\\Models\\UsuarioModel';
    protected $format = "json";

    public function index(){
            $usuarios = array_map(
                fn ($usuario) => $this->removerSenha($usuario),
                $this->model->findAll()
            );

            return $this->respond($usuarios);
        }

        public function show($id = null){
            $usuario = $this->model->find($id);

            if ($usuario === null){
                return $this->failNotFound("Usuario nao encontrado");
            }

            return $this->respond($this->removerSenha($usuario));
        }

        private function removerSenha(array $usuario): array{
            unset($usuario['USU_SENHA']);

            return $usuario;
        }
    // NOVA FUNÇÃO DE LOGIN
    public function login(){
        // Pega os dados enviados no body (JSON ou Form-Data)
        $dados = $this->request->getJSON(true) ?? $this->request->getPost();

        $login = $dados['USU_EMAIL'] ?? $dados['email'] ?? null;
        $senha = $dados['USU_SENHA'] ?? $dados['senha'] ?? null;

        // Valida se enviou tudo
        if (empty($login) || empty($senha)) {
            return $this->failValidationError("Login e senha são obrigatórios.");
        }

        // Busca o usuário pelo e-mail/login
        // Ajuste 'USU_EMAIL' para a coluna correta da sua tabela se for diferente (ex: USU_LOGIN)
        $usuario = $this->model->where('USU_EMAIL', $login)
                              ->orWhere('USU_EMAIL', $login)
                              ->first();

        if (!$usuario) {
            return $this->failNotFound("Usuário não encontrado.");
        }

        // Verifica a senha (assumindo que está salva com password_hash no banco)
        // Se a sua senha no banco estiver em texto puro, troque por: if ($senha !== $usuario['USU_SENHA'])
        if (!password_verify($senha, $usuario['USU_SENHA'])) {
            return $this->failUnauthorized("Senha incorreta.");
        }

        // Se deu tudo certo, remove a senha do retorno e envia os dados
        $usuarioLimpo = $this->removerSenha($usuario);

        return $this->respond([
            'status' => 200,
            'message' => 'Login realizado com sucesso!',
            'usuario' => $usuarioLimpo
        ]);
    }
}

?>