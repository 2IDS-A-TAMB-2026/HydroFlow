<?php

namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;

class PlantasController extends ResourceController
{
    protected $modelName = 'App\\Models\\PlantaModel';
    protected $format    = 'json';

    // Lista apenas as plantas pertencentes ao usuário logado
    public function index()
    {
        // 1. Tenta pegar da Sessão
        $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

        // 2. Se não achou na sessão, tenta via Query/Header
        if (!$idUsuarioLogado) {
            $idUsuarioLogado = $this->request->getGet('usuario_id') 
                            ?? $this->request->getGet('FK_USU_ID')
                            ?? $this->request->getHeaderLine('X-User-Id');
        }

        // 3. Fallback automático: define como ID 1 para testes/desenvolvimento
        $idUsuarioLogado = $idUsuarioLogado ?: 1;

        // Aplica os filtros opcionais enviados via URL
        $filtroTipo        = $this->request->getGet('filtro_tipo');
        $filtroParametro   = $this->request->getGet('filtro_parametro');
        $filtroDispositivo = $this->request->getGet('filtro_dispositivo');

        // Prepara a consulta filtrando pelo usuário logado (ou ID 1 fallback)
        $query = $this->model->where('FK_USU_ID', $idUsuarioLogado);

        if (!empty($filtroTipo)) { 
            $query->where('PLANTA_TIPO', $filtroTipo); 
        }
        if (!empty($filtroParametro)) { 
            $query->where('PLANTA_PERIDIOCIDADE', $filtroParametro); 
        }
        if (!empty($filtroDispositivo)) { 
            $query->where('FK_DIS_ID', $filtroDispositivo); 
        }

        $plantas = $query->findAll();

        return $this->respond($plantas);
    }

    public function show($id = null)
    {
        $idUsuarioLogado = session()->get('id') 
                        ?? session()->get('id_usuario') 
                        ?? session()->get('USU_ID') 
                        ?? $this->request->getGet('usuario_id') 
                        ?? 1; // Fallback ID 1

        $planta = $this->model->find($id);

        if ($planta === null) {
            return $this->failNotFound('Planta não encontrada.');
        }

        // Garante que o usuário só consiga ver a planta se for dono dela
        if ($planta['FK_USU_ID'] != $idUsuarioLogado) {
            return $this->failForbidden('Acesso negado a esta planta.');
        }

        return $this->respond($planta);
    }

    // Função para cadastrar novos dados (POST) vindo do Flutter
    public function novo()
    {
        $dados = $this->request->getJSON(true);

        if (empty($dados)) {
            $dados = $this->request->getPost();
        }

        if (empty($dados)) {
            return $this->fail('Nenhum dado foi enviado.', 400);
        }

        // Garante que o FK_USU_ID seja preenchido se não vier no body (Sessão -> Fallback ID 1)
        if (empty($dados['FK_USU_ID'])) {
            $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');
            $dados['FK_USU_ID'] = $idUsuarioLogado ?: 1; // Fallback ID 1
        }

        if ($this->model->insert($dados) === false) {
            return $this->fail($this->model->errors(), 400);
        }

        return $this->respondCreated([
            'status'   => 201,
            'mensagem' => 'Planta cadastrada com sucesso!',
            'id'       => $this->model->getInsertID()
        ]);
    }
}