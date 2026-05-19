<?php

namespace App\Controllers;

use App\Models\PlantaModel; // Importa a model certa
use CodeIgniter\Controller;

class PlantaController extends BaseController
{
    protected $plantaModel;

    public function __construct()
    {
        // Instancia a model de planta
        $this->plantaModel = new PlantaModel();
    }

    // Listar todas as plantas :o
    public function index()
    {
        $data = [
            'titulo'  => 'Minhas Plantas',
            'plantas' => $this->plantaModel->findAll()
        ];

        return view('plantas/lista', $data);
    }

    // Página de Cadastro de Planta
    public function novo()
    {
        return view('plantas/cadastro');
    }

    // Salvar Planta (Insert ou Update)
    public function salvar()
    {
        $postData = $this->request->getPost();

        // No CodeIgniter, o save() olha se existe o PLANTA_ID no post.
        // Se existir, ele faz Update. Se não, faz Insert.
        if ($this->plantaModel->save($postData)) {
            return redirect()->to('/plantas')->with('success', 'Planta salva com sucesso!');
        } else {
            return redirect()->back()
                             ->withInput()
                             ->with('errors', $this->plantaModel->errors());
        }
    }

    // Formulário de Edição da Planta
    public function editar($id)
    {
        $planta = $this->plantaModel->find($id);

        if (!$planta) {
            throw \CodeIgniter\Exceptions\PageNotFoundException::forPageNotFound("Planta $id não encontrada.");
        }

        return view('plantas/editar', ['planta' => $planta]);
    }

    // Excluindo a planta
    public function excluir($id)
    {
        if ($this->plantaModel->delete($id)) {
            return redirect()->to('/plantas')->with('success', 'Planta removida!');
        }
        
        return redirect()->to('/plantas')->with('error', 'Erro ao remover planta.');
    }
}