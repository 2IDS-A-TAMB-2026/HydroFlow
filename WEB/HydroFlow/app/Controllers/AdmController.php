<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\AdmModel; 
use App\Models\UsuarioModel; 
use App\Models\DispositivoModel;
use App\Models\HistoricoIrrigacaoModel;

class AdmController extends BaseController
{
    protected $admModel;
    protected $usuarioModel;
    protected $dispositivoModel;
    protected $historicoModel;

    public function __construct()
    {
        // Inicializa todos os models necessários
        $this->admModel         = new AdmModel();
        $this->usuarioModel     = new UsuarioModel();
        $this->dispositivoModel = new DispositivoModel();
        $this->historicoModel   = new HistoricoIrrigacaoModel();
    }

    /**
     * Dashboard Geral do Administrador
     * Mostra os KPIs e gráficos globais do sistema HydroFlow
     */
    public function index()
    {
        $db = \Config\Database::connect();

        // 1. KPIs Globais
        $dados['total_ativos']   = $this->dispositivoModel->where('DIS_STATUS', 'ATIVO')->countAllResults();
        $dados['total_inativos'] = $this->dispositivoModel->where('DIS_STATUS', 'INATIVO')->countAllResults();
        $dados['total_plantas']  = $db->table('PLANTA')->countAllResults();
        $dados['total_alertas']  = $this->historicoModel->where('IRR_STATUS', 'Falha')->countAllResults();
        $dados['total_usuarios'] = $this->usuarioModel->countAllResults();

        // 2. Últimas 8 irrigações gerais do sistema
        $dados['ultimas_irrigacoes'] = $this->historicoModel
            ->select('HISTORICO_IRRIGACAO.*, PLANTA.PLANTA_NOME as nome_planta, DISPOSITIVO.DIS_NOME as nome_dispositivo, USUARIO.USU_NOME as nome_usuario')
            ->join('PLANTA', 'PLANTA.PLANTA_ID = HISTORICO_IRRIGACAO.FK_PLANTA_ID')
            ->join('DISPOSITIVO', 'DISPOSITIVO.DIS_ID = HISTORICO_IRRIGACAO.FK_DIS_ID')
            ->join('USUARIO', 'USUARIO.USU_ID = HISTORICO_IRRIGACAO.FK_USU_ID')
            ->orderBy('IRR_DATA DESC', 'IRR_HORA DESC')
            ->limit(8)
            ->findAll();

        // 3. Dados do Gráfico Global
        $graficoQuery = $this->historicoModel
            ->select("IRR_DATA, SUM(IRR_VOLUME) as volume_total")
            ->where('IRR_STATUS', 'Concluído')
            ->groupBy('IRR_DATA')
            ->orderBy('IRR_DATA ASC')
            ->limit(7)
            ->findAll();

        $labelsGrafico = [];
        $valoresGrafico = [];

        foreach ($graficoQuery as $registro) {
            $labelsGrafico[]  = date('d/m', strtotime($registro['IRR_DATA']));
            $valoresGrafico[] = (float) $registro['volume_total'];
        }

        if (empty($labelsGrafico)) {
            $labelsGrafico  = ['Sem dados'];
            $valoresGrafico = [0];
        }

        $dados['grafico_labels']  = $labelsGrafico;
        $dados['grafico_valores'] = $valoresGrafico;
        $dados['titulo']          = "Painel de Controle Admin - HydroFlow";

        return view('sistema/layout/dashboard/adm/header', $dados)
             . view('sistema/adm/index', $dados);
    }

    /**
     * Gerenciamento de Usuários (Tabela de Listagem / Filtros e Formulário de Edição)
     * Rota: admin/usuarios ou admin/usuarios/ID
     */
    public function gerenciarUsuarios($id = null)
    {
        $usuarioModel = new UsuarioModel();

        // ========================================================
        // MODO B: LISTAGEM GERAL COM FILTROS ATIVOS
        // ========================================================
        $buscaNome  = $this->request->getGet('busca_nome');
        $buscaUf    = $this->request->getGet('busca_uf');

        $query = $usuarioModel;

        // Filtro de Busca por Texto (Busca tanto no Nome quanto no E-mail ao mesmo tempo)
        if (!empty($buscaNome)) {
            $query = $query->groupStart()
                           ->like('USU_NOME', $buscaNome)
                           ->orLike('USU_EMAIL', $buscaNome)
                           ->groupEnd();
        }

        // Filtro de Busca pela UF (Estado)
        if (!empty($buscaUf)) {
            $query = $query->where('USU_UF', $buscaUf);
        }

        // Executa a query com os filtros acumulados
        $dados['usuarios'] = $query->findAll();

        // Carrega as UFs dinamicamente do banco para popular o <select>
        $dados['ufs_disponiveis'] = $usuarioModel->select('USU_UF')
                                                 ->groupBy('USU_UF')
                                                 ->orderBy('USU_UF', 'ASC')
                                                 ->findAll();

        // Retorna as variáveis de busca para manter os campos preenchidos na View
        $dados['busca_nome']  = $buscaNome;
        $dados['busca_uf']    = $buscaUf;
        $dados['usuario']     = null; // Garante que o modo Edição não seja disparado

        return view('sistema/layout/dashboard/adm/header', $dados)
             . view('sistema/adm/usuarios', $dados);
    }

    public function editarUsuario($id = null)
    {
        // 1. Verifica se o ID foi passado na URL, se não, redireciona de volta
        if ($id === null) {
            return redirect()->to(base_url('admin/usuarios'))->with('erro', 'ID do usuário não fornecido.');
        }

        $usuarioModel = new UsuarioModel();

        // 2. Busca o usuário no banco de dados pelo ID
        // O find() busca pela chave primária definida no seu Model
        $usuario = $usuarioModel->find($id);

        // 3. Se não encontrar o usuário, manda de volta com mensagem de erro
        if (!$usuario) {
            return redirect()->to(base_url('admin/usuarios'))->with('erro', 'Usuário não encontrado.');
        }

        // 4. Prepara os dados para mandar para a View
        // Reparou na variável $usuario_selecionado? É ela que o topo da sua View está esperando!
        $data = [
            'usuario_selecionado' => $usuario
        ];

        // 5. Retorna a view de gerenciamento passando os dados
        return view('sistema/adm/gerenciar_usuario', $data);
    }


    public function atualizarUsuario($id)
{
    $usuarioModel = new \App\Models\UsuarioModel();

    // 1. Verifica se o usuário realmente existe no banco
    $usuario = $usuarioModel->find($id);
    if (!$usuario) {
        return redirect()->to(base_url('admin/usuarios'))->with('erro', 'Usuário não encontrado.');
    }

    // 2. Coleta os dados convertendo para as colunas REAIS do seu banco de dados (USU_...)
    $dadosAtualizados = [
        'USU_NOME'   => $this->request->getPost('NOME_USUARIO'),
        'USU_EMAIL'  => $this->request->getPost('EMAIL_USUARIO'),
        'USU_CPF'    => $this->request->getPost('CPF_USUARIO'),
        'USU_STATUS' => $this->request->getPost('STATUS_USUARIO'),
        'USU_CEP'    => $this->request->getPost('CEP_USUARIO'),
        'USU_RUA'    => $this->request->getPost('RUA_USUARIO'),
        'USU_BAIRRO' => $this->request->getPost('BAIRRO_USUARIO'),
        'USU_NUM'    => $this->request->getPost('NUMERO_USUARIO'),
        'USU_CIDADE' => $this->request->getPost('CIDADE_USUARIO'),
        'USU_UF'     => $this->request->getPost('UF_USUARIO'),
    ];

    // Trata a senha: só atualiza se o administrador digitou alguma coisa no campo
    $senhaDigitada = $this->request->getPost('SENHA_USUARIO');
    if (!empty($senhaDigitada)) {
        // Se no seu sistema usar hash (o ideal), mude para: password_hash($senhaDigitada, PASSWORD_DEFAULT)
        $dadosAtualizados['USU_SENHA'] = $senhaDigitada; 
    }

    // 3. Executa a atualização
    if ($usuarioModel->update($id, $dadosAtualizados)) {
        // Redireciona de volta para a listagem com mensagem de sucesso
        return redirect()->to(base_url('admin/usuarios'))->with('sucesso', 'Usuário atualizado com sucesso!');
    } else {
        return redirect()->back()->withInput()->with('erro', 'Não foi possível atualizar o usuário.');
    }
}
    public function excluirUsuario($id)
    {
    $usuarioModel = new \App\Models\UsuarioModel();

    // 1. Verifica se o usuário existe
    $usuario = $usuarioModel->find($id);
    if (!$usuario) {
        return redirect()->to(base_url('admin/usuarios'))->with('error', 'Usuário não encontrado.');
    }

    // 2. Executa a exclusão definitiva
    if ($usuarioModel->delete($id)) {
        return redirect()->to(base_url('admin/usuarios'))->with('success', 'Usuário removido do sistema permanentemente.');
    } else {
        return redirect()->to(base_url('admin/usuarios'))->with('error', 'Erro ao tentar excluir o usuário.');
    }
    }

    // =========================================================
    // MÉTODO DEFINITIVO: Caminho corrigido com base nas Views
    // =========================================================
    public function editarPerfil()
    {
        // Certifica de que o usuário está logado como admin
        if (!session()->get('logado_adm')) {
            return redirect()->to(base_url('admin/login'));
        }

        // Define o título da página
        $dados['titulo'] = "Configurações do Perfil - HydroFlow";

        // Carrega o cabeçalho e a sua view correta: sistema/adm/editar_perfil
        $html  = view('sistema/layout/dashboard/adm/header', $dados);
        $html .= view('sistema/adm/editar_perfil', $dados); 

        return $html;
    }
}