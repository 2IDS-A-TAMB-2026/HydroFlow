<?php
    namespace App\Controllers;

    use App\Controllers\BaseController;
    use App\Models\UsuarioModel;

    class AuthController extends BaseController{
        public function autenticar(){
            $model = new UsuarioModel();

            $usuario = $model
                ->where('USU_EMAIL', $this->request->getPost('email'))->first();
    
            if($usuario){
                if($this->request->getPost('senha') == $usuario['USU_SENHA']){
                    session()->set([
                        'USU_ID' => $usuario['USU_ID'],
                        'USU_NOME' => $usuario['USU_NOME'],
                        'logado' => true
                    ]);

                    return redirect()->to('/dashboard');
                }
            }
            session()->setFlashdata('erro','Usuário ou senha inválidos');

            return redirect()->to('/login');
        }

        public function logout(){
            session()->destroy();

            return redirect()->to('/login');
        }
    }
?>