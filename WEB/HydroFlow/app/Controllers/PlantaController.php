<?php

namespace App\Controllers;

use App\Models\PlantaModel;
use App\Models\DispositivoModel; // Importa o model de dispositivos para o filtro dinâmico
use CodeIgniter\Controller;

class PlantaController extends BaseController
{
    protected $plantaModel;

    public function __construct()
    {
        $this->plantaModel = new PlantaModel();
    }

    // Listar todas as plantas com filtros aplicados
    public function index()
{
    $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

    if (!$idUsuarioLogado) {
        return redirect()->to(base_url('login'))->with('erro', 'Por favor, faça login para acessar suas plantas.');
    }

    $dispositivoModel = new DispositivoModel();
    $dispositivos = $dispositivoModel->where('FK_USU_ID', $idUsuarioLogado)->findAll();

    $filtroTipo        = $this->request->getGet('filtro_tipo');
    $filtroParametro   = $this->request->getGet('filtro_parametro');
    $filtroDispositivo = $this->request->getGet('filtro_dispositivo');

    $query = $this->plantaModel->where('FK_USU_ID', $idUsuarioLogado);

    if (!empty($filtroTipo)) { $query->where('PLANTA_TIPO', $filtroTipo); }
    if (!empty($filtroParametro)) { $query->where('PLANTA_PERIDIOCIDADE', $filtroParametro); }
    if (!empty($filtroDispositivo)) { $query->where('FK_DIS_ID', $filtroDispositivo); }

    $plantas = $query->findAll();

    // --- CAPTURA DE DADOS PARA OS GRÁFICOS ---
    $dadosTipos   = $this->plantaModel->getQtdPorTipo($idUsuarioLogado);
    $dadosConsumo = $this->plantaModel->getConsumoAguaPorPlanta($idUsuarioLogado, 5);

    $data = [
        'titulo'            => 'Minhas Plantas',
        'plantas'           => $plantas,
        'dispositivos'      => $dispositivos,
        'filtroTipo'        => $filtroTipo,
        'filtroParametro'   => $filtroParametro,
        'filtroDispositivo' => $filtroDispositivo,
        // Envia para a View os dados prontos para o JS de gráficos
        'dadosTipos'        => $dadosTipos,
        'dadosConsumo'      => $dadosConsumo
    ];

    return view('sistema/planta/index', $data);
}

    // Página de Cadastro de Planta
    public function novo()
    {
        $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

        if (!$idUsuarioLogado) {
            return redirect()->to(base_url('login'))->with('erro', 'Sessão expirada. Faça login novamente.');
        }

        $dispositivoModel = new \App\Models\DispositivoModel();
        $data['dispositivos'] = $dispositivoModel->where('FK_USU_ID', $idUsuarioLogado)->findAll();

        return view('sistema/planta/cadastro', $data);
    }

    // Salvar Planta (Insert ou Update)
    public function salvar()
    {
        $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

        if (!$idUsuarioLogado) {
            return redirect()->to(base_url('login'))->with('erro', 'Sessão expirada. Faça login novamente.');
        }

        $dadosPlanta = [
            'PLANTA_NOME'          => $this->request->getPost('PLANTA_NOME'),
            'PLANTA_TIPO'          => $this->request->getPost('PLANTA_TIPO'),
            'PLANTA_CULTURA'       => $this->request->getPost('PLANTA_CULTURA'),
            'PLANTA_QTD_AGUA'      => $this->request->getPost('PLANTA_QTD_AGUA'),
            'PLANTA_PERIDIOCIDADE' => $this->request->getPost('PLANTA_PERIDIOCIDADE'),
            'FK_DIS_ID'            => $this->request->getPost('FK_DIS_ID'),
            'FK_USU_ID'            => $idUsuarioLogado 
        ];

        if ($this->plantaModel->save($dadosPlanta)) {
            return redirect()->to(base_url('planta'))->with('sucesso', 'Planta cadastrada com sucesso!');
        }

        return redirect()->back()->with('erro', 'Erro ao salvar a planta. Tente novamente.')->withInput();
    }

    // Formulário de Edição da Planta
    // Formulário de Edição da Planta
    public function editar($id)
    {
        // 1. Recupera o ID do usuário logado na sessão
        $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

        if (!$idUsuarioLogado) {
            return redirect()->to(base_url('login'))->with('erro', 'Sessão expirada. Faça login novamente.');
        }

        // 2. Busca a planta
        $planta = $this->plantaModel->find($id);

        if (!$planta) {
            throw \CodeIgniter\Exceptions\PageNotFoundException::forPageNotFound("Planta $id não encontrada.");
        }

        // Security check: Garante que o usuário só edita a planta que é dele
        if ($planta['FK_USU_ID'] != $idUsuarioLogado) {
            return redirect()->to(base_url('planta'))->with('erro', 'Você não tem permissão para editar esta planta.');
        }

        // 3. Busca APENAS os dispositivos que pertencem ao usuário logado
        $dispositivoModel = new \App\Models\DispositivoModel();
        $dispositivos = $dispositivoModel->where('FK_USU_ID', $idUsuarioLogado)->findAll();

        // 4. Retorna a view com todos os dados necessários
        return view('sistema/planta/editar', [
            'planta'       => $planta,
            'dispositivos' => $dispositivos
        ]);
    }

    // Processar a atualização da planta
    public function atualizar($id)
    {
        $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

        if (!$idUsuarioLogado) {
            return redirect()->to(base_url('login'))->with('erro', 'Sessão expirada. Faça login novamente.');
        }

        // Verifica se a planta realmente existe
        $planta = $this->plantaModel->find($id);
        if (!$planta || $planta['FK_USU_ID'] != $idUsuarioLogado) {
            return redirect()->to(base_url('planta'))->with('erro', 'Planta não encontrada ou acesso negado.');
        }

        // Monta os dados mesclando o que veio do formulário com o ID da sessão de forma automática
        $dadosAtualizados = [
            'PLANTA_NOME'          => $this->request->getPost('PLANTA_NOME'),
            'PLANTA_TIPO'          => $this->request->getPost('PLANTA_TIPO'),
            'PLANTA_CULTURA'       => $this->request->getPost('PLANTA_CULTURA'),
            'PLANTA_QTD_AGUA'      => $this->request->getPost('PLANTA_QTD_AGUA'),
            'PLANTA_PERIDIOCIDADE' => $this->request->getPost('PLANTA_PERIDIOCIDADE'),
            'FK_DIS_ID'            => $this->request->getPost('FK_DIS_ID'), // Nome corrigido de acordo com o Model
            'FK_USU_ID'            => $idUsuarioLogado // Injetado automaticamente via sessão
        ];

        if ($this->plantaModel->update($id, $dadosAtualizados)) {
            return redirect()->to(base_url('planta'))->with('sucesso', 'Planta atualizada com sucesso!');
        }

        return redirect()->back()->with('erro', 'Erro ao atualizar a planta. Tente novamente.')->withInput();
    }

    // Excluindo a planta
    public function excluir($id)
    {
        if ($this->plantaModel->delete($id)) {
            return redirect()->to(base_url('planta'))->with('sucesso', 'Planta removida!');
        }
        
        return redirect()->to(base_url('planta'))->with('erro', 'Erro ao remover planta.');
    }
}