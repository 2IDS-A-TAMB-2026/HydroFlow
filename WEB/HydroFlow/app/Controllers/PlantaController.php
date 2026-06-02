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
    // 1. Pega o ID do usuário que está logado direto da Session do sistema
    // (Ajuste o termo 'id' ou 'USU_ID' para o nome exato que você usou na hora de salvar o login)
    $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

    // 2. Se por acaso a sessão expirou ou o cara não está logado, manda pro login
    if (!$idUsuarioLogado) {
        return redirect()->to(base_url('login'))->with('error', 'Por favor, faça login para acessar suas plantas.');
    }

    $data = [
        'titulo'  => 'Minhas Plantas',
        // 3. O filtro "where" mágico: procura na coluna FK_USU_ID apenas o ID de quem está logado
        'plantas' => $this->plantaModel->where('FK_USU_ID', $idUsuarioLogado)->findAll()
    ];

    return view('sistema/planta/index', $data);
}
    // Página de Cadastro de Planta
    public function novo()
{
    // 1. Pega o ID do usuário logado direto da Session do sistema
    // (Caso sua session use outra chave, mude o texto de dentro do get)
    $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

    // 2. Se a sessão tiver caído ou o usuário não estiver logado, barra ele e manda pro login
    if (!$idUsuarioLogado) {
        return redirect()->to(base_url('login'))->with('error', 'Sessão expirada. Faça login novamente.');
    }

    // 3. Instancia apenas o model de Dispositivos (não precisa mais do de Usuários)
    $dispositivoModel = new \App\Models\DispositivoModel();

    // 4. Busca apenas os dispositivos vinculados ao ID do usuário logado
    // (Ajuste 'FK_USU_ID' para o nome exato da coluna da tabela de dispositivos se for diferente)
    $data['dispositivos'] = $dispositivoModel->where('FK_USU_ID', $idUsuarioLogado)->findAll();

    // 5. Passa os dispositivos filtrados para a sua view de cadastro
    return view('sistema/planta/cadastro', $data);
}
    // Salvar Planta (Insert ou Update)
    public function salvar()
{
    // 1. Pega o ID do usuário logado direto da Session
    $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

    if (!$idUsuarioLogado) {
        return redirect()->to(base_url('login'))->with('error', 'Sessão expirada. Faça login novamente.');
    }

    // 2. Pega os dados que vieram do formulário HTML
    $dadosPlanta = [
        'PLANTA_NOME'          => $this->request->getPost('PLANTA_NOME'),
        'PLANTA_TIPO'          => $this->request->getPost('PLANTA_TIPO'),
        'PLANTA_CULTURA'       => $this->request->getPost('PLANTA_CULTURA'),
        'PLANTA_QTD_AGUA'      => $this->request->getPost('PLANTA_QTD_AGUA'),
        'PLANTA_PERIDIOCIDADE' => $this->request->getPost('PLANTA_PERIDIOCIDADE'),
        'FK_DIS_ID'            => $this->request->getPost('FK_DIS_ID'),
        
        // 3. A MÁGICA: O ID do usuário vai aqui, direto da sessão, sem passar pela tela!
        'FK_USU_ID'            => $idUsuarioLogado 
    ];

    // 4. Salva no banco de dados usando o Model
    if ($this->plantaModel->save($dadosPlanta)) {
        return redirect()->to(base_url('planta'))->with('success', 'Planta cadastrada com sucesso!');
    }

    return redirect()->back()->with('error', 'Erro ao salvar a planta. Tente novamente.')->withInput();
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
   // Excluindo a planta
public function excluir($id)
{
    if ($this->plantaModel->delete($id)) {
        // Ajustado de '/plantas' para 'planta'
        return redirect()->to(base_url('planta'))->with('success', 'Planta removida!');
    }
    
    // Ajustado de '/plantas' para 'planta'
    return redirect()->to(base_url('planta'))->with('error', 'Erro ao remover planta.');
}
}