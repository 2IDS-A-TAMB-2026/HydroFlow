<?php

namespace App\Controllers;

use App\Models\SensorModel;
use App\Models\DispositivoModel;
use CodeIgniter\Controller;

class SensorController extends BaseController
{
    private $sensorModel;
    private $dispositivoModel;

    public function __construct()
    {
        $this->sensorModel = new SensorModel();
        $this->dispositivoModel = new DispositivoModel();
    }

    /**
     * Lista todos os sensores e seus respectivos dispositivos
     */
    public function index()
    {
        // Usando o método join que você criou na Model
        $data = [
            'titulo'   => 'Gerenciar Sensores',
            'sensores' => $this->sensorModel->getSensoresComDispositivo()
        ];

        return view('sensores/index', $data);
    }

    /**
     * Exibe o formulário de cadastro de sensor
     */
    public function novo()
    {
        // Precisamos listar os dispositivos para o usuário escolher onde instalar o sensor
        $data = [
            'titulo'       => 'Cadastrar Novo Sensor',
            'dispositivos' => $this->dispositivoModel->findAll()
        ];

        return view('sensores/form', $data);
    }

    /**
     * Processa a criação ou atualização do sensor
     */
    public function salvar()
    {
        $id = $this->request->getPost('SEN_ID');
        
        $dados = [
            'SEN_NOME'   => $this->request->getPost('SEN_NOME'),
            'SEN_TIPO'   => $this->request->getPost('SEN_TIPO'),
            'SEN_STATUS' => $this->request->getPost('SEN_STATUS') ?? 'ATIVO',
            'FK_DIS_ID'  => $this->request->getPost('FK_DIS_ID'),
        ];

        // Se houver ID, estamos editando, caso contrário, inserindo
        if ($id) {
            $dados['SEN_ID'] = $id;
        }

        if ($this->sensorModel->save($dados)) {
            return redirect()->to('/sensores')->with('success', 'Sensor configurado com sucesso!');
        } else {
            // Retorna para o formulário com os erros de validação da Model
            return redirect()->back()->withInput()->with('errors', $this->sensorModel->errors());
        }
    }

    /**
     * Exibe o formulário de edição
     */
    public function editar($id)
    {
        $sensor = $this->sensorModel->find($id);

        if (!$sensor) {
            throw \CodeIgniter\Exceptions\PageNotFoundException::forPageNotFound("Sensor não encontrado.");
        }

        $data = [
            'titulo'       => 'Editar Sensor',
            'sensor'       => $sensor,
            'dispositivos' => $this->dispositivoModel->findAll()
        ];

        return view('sensores/form', $data);
    }

    /**
     * Remove um sensor do sistema
     */
    public function excluir($id)
    {
        if ($this->sensorModel->delete($id)) {
            return redirect()->to('/sensores')->with('success', 'Sensor removido.');
        }

        return redirect()->to('/sensores')->with('error', 'Não foi possível excluir o sensor.');
    }
}