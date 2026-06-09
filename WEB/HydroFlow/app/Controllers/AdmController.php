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
     */
    public function gerenciarUsuarios($id = null)
    {
        $usuarioModel = new UsuarioModel();

        $buscaNome  = $this->request->getGet('busca_nome');
        $buscaUf    = $this->request->getGet('busca_uf');

        $query = $usuarioModel;

        if (!empty($buscaNome)) {
            $query = $query->groupStart()
                           ->like('USU_NOME', $buscaNome)
                           ->orLike('USU_EMAIL', $buscaNome)
                           ->groupEnd();
        }

        if (!empty($buscaUf)) {
            $query = $query->where('USU_UF', $buscaUf);
        }

        $dados['usuarios'] = $query->findAll();

        $dados['ufs_disponiveis'] = $usuarioModel->select('USU_UF')
                                                 ->groupBy('USU_UF')
                                                 ->orderBy('USU_UF', 'ASC')
                                                 ->findAll();

        $dados['busca_nome']  = $buscaNome;
        $dados['busca_uf']    = $buscaUf;
        $dados['usuario']     = null;

        return view('sistema/layout/dashboard/adm/header', $dados)
             . view('sistema/adm/usuarios', $dados);
    }

    public function editarUsuario($id = null)
    {
        if ($id === null) {
            return redirect()->to(base_url('admin/usuarios'))->with('erro', 'ID do usuário não fornecido.');
        }

        $usuarioModel = new UsuarioModel();
        $usuario = $usuarioModel->find($id);

        if (!$usuario) {
            return redirect()->to(base_url('admin/usuarios'))->with('erro', 'Usuário não encontrado.');
        }

        $data = [
            'usuario_selecionado' => $usuario
        ];

        return view('sistema/adm/gerenciar_usuario', $data);
    }

    public function atualizarUsuario($id)
    {
        $usuarioModel = new \App\Models\UsuarioModel();

        $usuario = $usuarioModel->find($id);
        if (!$usuario) {
            return redirect()->to(base_url('admin/usuarios'))->with('erro', 'Usuário não encontrado.');
        }

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

        $senhaDigitada = $this->request->getPost('SENHA_USUARIO');
        if (!empty($senhaDigitada)) {
            $dadosAtualizados['USU_SENHA'] = $senhaDigitada; 
        }

        if ($usuarioModel->update($id, $dadosAtualizados)) {
            return redirect()->to(base_url('admin/usuarios'))->with('sucesso', 'Usuário updated successfully!');
        } else {
            return redirect()->back()->withInput()->with('erro', 'Não foi possível atualizar o usuário.');
        }
    }

    public function excluirUsuario($id)
    {
        $usuarioModel = new \App\Models\UsuarioModel();

        $usuario = $usuarioModel->find($id);
        if (!$usuario) {
            return redirect()->to(base_url('admin/usuarios'))->with('error', 'Usuário não encontrado.');
        }

        if ($usuarioModel->delete($id)) {
            return redirect()->to(base_url('admin/usuarios'))->with('success', 'Usuário removido do sistema permanentemente.');
        } else {
            return redirect()->to(base_url('admin/usuarios'))->with('error', 'Erro ao tentar excluir o usuário.');
        }
    }

    // =========================================================
    // ATUALIZADO: Captura máxima de dados da Sessão e Banco
    // =========================================================
    public function editarPerfil()
    {
        if (!session()->get('logado_adm')) {
            return redirect()->to(base_url('admin/login'));
        }

        // Pega o ID do admin guardado na sessão
        $id_adm = session()->get('id') ?? session()->get('ADM_ID') ?? session()->get('id_adm') ?? session()->get('id_usuario');

        // Captura o nome e e-mail que já estão salvos na sessão atual
        $nome_sessao  = session()->get('nome') ?? session()->get('NOME_ADM') ?? session()->get('USU_NOME') ?? session()->get('user_name');
        $email_sessao = session()->get('email') ?? session()->get('EMAIL_ADM') ?? session()->get('USU_EMAIL') ?? session()->get('user_email');

        $dados['adm'] = null;

        // Se achar um ID, tenta buscar as informações direto do banco
        if ($id_adm) {
            $dados['adm'] = $this->admModel->where('ADM_ID', $id_adm)->first();
        }

        // Se o banco não achar nada, monta o array de segurança baseado na sessão do usuário
        if (!$dados['adm']) {
            $dados['adm'] = [
                'NOME_ADM'  => $nome_sessao,
                'EMAIL_ADM' => $email_sessao
            ];
        }

        $dados['titulo'] = "Configurações do Perfil - HydroFlow";

        $html  = view('sistema/layout/dashboard/adm/header', $dados);
        $html .= view('sistema/adm/editar_perfil', $dados); 

        return $html;
    }

    // =========================================================
    // SALVAR: Processa a atualização dos dados do administrador
    // =========================================================
    public function salvarPerfil()
    {
        if (!session()->get('logado_adm')) {
            return redirect()->to(base_url('admin/login'));
        }

        $id_adm = session()->get('id') ?? session()->get('ADM_ID') ?? session()->get('id_adm');

        if (!$id_adm) {
            return redirect()->back()->with('erro', 'Erro ao identificar a sessão do administrador.');
        }

        $regras = [
            'NOME_ADM'  => 'required|min_length[3]',
            'EMAIL_ADM' => 'required|valid_email'
        ];

        if (!$this->validate($regras)) {
            return redirect()->back()->withInput()->with('erros_validacao', $this->validator->getErrors());
        }

        $dadosAtualizados = [
            'ADM_NOME'  => $this->request->getPost('NOME_ADM'), 
            'ADM_EMAIL' => $this->request->getPost('EMAIL_ADM')  
        ];

        $novaSenha = $this->request->getPost('SENHA_ADM');
        if (!empty($novaSenha)) {
            $dadosAtualizados['ADM_SENHA'] = $novaSenha; 
        }

        if ($this->admModel->where('ADM_ID', $id_adm)->set($dadosAtualizados)->update()) {
            
            session()->set([
                'nome'  => $dadosAtualizados['ADM_NOME'],
                'email' => $dadosAtualizados['ADM_EMAIL']
            ]);

            return redirect()->to(base_url('admin'))->with('sucesso', 'Seu perfil foi atualizado com sucesso!');
        } else {
            return redirect()->back()->withInput()->with('erro', 'Não foi possível atualizar o perfil.');
        }
    }
}