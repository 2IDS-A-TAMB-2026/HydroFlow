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
        // 1. Pega o ID do usuário que está logado direto da Session
        $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

        if (!$idUsuarioLogado) {
            return redirect()->to(base_url('login'))->with('erro', 'Por favor, faça login para acessar suas plantas.');
        }

        // 2. Instancia o model de dispositivos para alimentar o select da View
        $dispositivoModel = new DispositivoModel();
        $dispositivos = $dispositivoModel->where('FK_USU_ID', $idUsuarioLogado)->findAll();

        // 3. Captura os dados enviados pelo formulário de filtro via GET
        $filtroTipo        = $this->request->getGet('filtro_tipo');
        $filtroParametro   = $this->request->getGet('filtro_parametro');
        $filtroDispositivo = $this->request->getGet('filtro_dispositivo');

        // 4. Inicia a construção da Query filtrando sempre pelo usuário logado
        $query = $this->plantaModel->where('FK_USU_ID', $idUsuarioLogado);

        // Se escolheu um Tipo específico
        if (!empty($filtroTipo)) {
            $query->where('PLANTA_TIPO', $filtroTipo);
        }

        // Se escolheu uma Periodicidade de irrigação específica
        if (!empty($filtroParametro)) {
            $query->where('PLANTA_PERIDIOCIDADE', $filtroParametro);
        }

        // Se escolheu um Dispositivo responsável específico
        if (!empty($filtroDispositivo)) {
            $query->where('FK_DIS_ID', $filtroDispositivo);
        }

        // Busca os resultados finais com os filtros ativos aplicados
        $plantas = $query->findAll();

        $data = [
            'titulo'             => 'Minhas Plantas',
            'plantas'            => $plantas,
            'dispositivos'       => $dispositivos, // Passa a lista para o select da view
            'filtroTipo'         => $filtroTipo,        // Mantém o valor selecionado após o submit
            'filtroParametro'    => $filtroParametro,   // Mantém o valor selecionado após o submit
            'filtroDispositivo'  => $filtroDispositivo  // Mantém o valor selecionado após o submit
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
    public function editar($id)
    {
        $planta = $this->plantaModel->find($id);

        if (!$planta) {
            throw \CodeIgniter\Exceptions\PageNotFoundException::forPageNotFound("Planta $id não encontrada.");
        }

        return view('sistema/planta/editar', ['planta' => $planta]);
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