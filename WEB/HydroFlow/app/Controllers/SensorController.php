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

        return view('sistema/sensor/index', $data);
    }

    /**
     * Exibe o formulário de cadastro de sensor (Layout sequencial/duplo)
     */
    public function novo()
    {
        // Listando os dispositivos para o usuário escolher onde instalar o sensor
        $data = [
            'titulo'       => 'Cadastrar Novo Sensor',
            'dispositivos' => $this->dispositivoModel->findAll()
        ];

        return view('sistema/sensor/cadastro', $data);
    }

    /**
     * Processa a criação individual ou atualização do sensor (Método original)
     */
    /**
     * Processa a criação individual ou atualização do sensor
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

        if ($id) {
            $dados['SEN_ID'] = $id;
        }

        if ($this->sensorModel->save($dados)) {
            // CORREÇÃO: Redireciona para a rota correta com o prefixo admin
            return redirect()->to('admin/sensores')->with('sucesso', 'Sensor atualizado com sucesso!');
        } else {
            return redirect()->back()->withInput()->with('errors', $this->sensorModel->errors());
        }
    }

    public function salvarDuplo()
    {
        $nomeSolo  = $this->request->getPost('NOME_SOLO');
        $nomeAr    = $this->request->getPost('NOME_AR');
        $fkDisId   = $this->request->getPost('FK_DIS_ID');
        $status    = $this->request->getPost('SEN_STATUS') ?? 'ATIVO';

        $dadosSolo = [
            'SEN_NOME'   => $nomeSolo,
            'SEN_TIPO'   => 'Umidade do Solo',
            'FK_DIS_ID'  => $fkDisId,
            'SEN_STATUS' => $status
        ];

        $dadosAr = [
            'SEN_NOME'   => $nomeAr,
            'SEN_TIPO'   => 'Umidade do Ar/Temp',
            'FK_DIS_ID'  => $fkDisId,
            'SEN_STATUS' => $status
        ];

        $db = \Config\Database::connect();
        $db->transStart();

        $this->sensorModel->insert($dadosSolo);
        $this->sensorModel->insert($dadosAr);

        $db->transComplete();

        if ($db->transStatus() === FALSE || !empty($this->sensorModel->errors())) {
            $errosValidacao = $this->sensorModel->errors() ?: ['Não foi possível cadastrar os sensores.'];
            return redirect()->back()->withInput()->with('errors', $errosValidacao);
        }

        // CORREÇÃO: Redireciona para a rota correta com o prefixo admin
        return redirect()->to('admin/sensores')->with('sucesso', 'Sensores configurados juntos com sucesso!');
    }

    public function excluir($id)
    {
        if ($this->sensorModel->delete($id)) {
            return redirect()->to('admin/sensores')->with('sucesso', 'Sensor removido.');
        }

        return redirect()->to('admin/sensores')->with('erro', 'Não foi possível excluir o sensor.');
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

        return view('sistema/sensor/cadastro', $data);
    }
}