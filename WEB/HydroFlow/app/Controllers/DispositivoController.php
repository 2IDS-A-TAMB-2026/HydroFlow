<?php
namespace App\Controllers;

use App\Models\DispositivoModel;
use CodeIgniter\Controller;

class DispositivoController extends BaseController
{
    private $dispositivoModel;

    public function __construct()
    {
        // Instancia a model para usar em todos os métodos
        $this->dispositivoModel = new DispositivoModel();
    }

    public function index()
    {
        $dados['dispositivos'] = $this->dispositivoModel->getDispositivoComDono();
        
        return view('dispositivos/lista', $dados);
    }

    public function novo()
    {
        return view('dispositivos/formulario');
    }

    // 3. AÇÃO: Recebe os dados do formulário e salva
    public function salvar()
    {
        $dadosPost = $this->request->getPost();

        // O save() do CodeIgniter já usa as validationRules que você definiu na Model
        if ($this->dispositivoModel->save($dadosPost)) {
            return redirect()->to('/dispositivos')->with('success', 'Dispositivo salvo com sucesso!');
        } else {
            // Se falhar (validação), volta para o formulário com os erros
            return redirect()->back()->withInput()->with('errors', $this->dispositivoModel->errors());
        }
    }

    // 4. AÇÃO: Deletar dispositivo
    public function excluir($id)
    {
        $this->dispositivoModel->delete($id);
        return redirect()->to('/dispositivos');
    }
}