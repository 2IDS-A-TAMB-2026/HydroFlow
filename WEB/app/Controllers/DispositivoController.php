<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\DispositivoModel;
use App\Models\UsuarioModel;

class DispositivoController extends BaseController
{
    protected $dispositivoModel;
    protected $usuarioModel;

    public function __construct()
    {
        // Inicializa os models necessários para o funcionamento do módulo
        $this->dispositivoModel = new DispositivoModel();
        $this->usuarioModel     = new UsuarioModel();
    }

    /**
     * Listagem Geral de Dispositivos com Filtro de Busca
     * Rota: admin/dispositivos ou dispositivos
     */
    public function index()
{
    // 1. Instancia o UsuarioModel para listar os proprietários no select do filtro
    $usuarioModel = new \App\Models\UsuarioModel();
    $dados['usuarios_disponiveis'] = $usuarioModel->select('USU_ID, USU_NOME')->orderBy('USU_NOME', 'ASC')->findAll();

    // 2. Captura os valores que vieram da URL (Filtros + Busca por Texto)
    $filtroValores = [
        'busca'         => $this->request->getGet('busca'),
        'dono_id'       => $this->request->getGet('dono_id') ?? 'todos',
        'status_filtro' => $this->request->getGet('status_filtro') ?? 'todos',
    ];

    $query = $this->dispositivoModel;

    // 3. Aplica a Busca por Texto
    if (!empty($filtroValores['busca'])) {
        $query = $query->groupStart()
                       ->like('DIS_NOME', $filtroValores['busca'])
                       ->orLike('DIS_DESCRICAO', $filtroValores['busca'])
                       ->groupEnd();
    }

    // 4. Aplica o filtro de Dono
    if ($filtroValores['dono_id'] !== 'todos') {
        $query = $query->where('FK_USU_ID', $filtroValores['dono_id']);
    }

    // 5. Aplica o filtro de Status
    if ($filtroValores['status_filtro'] !== 'todos') {
        $query = $query->where('DIS_STATUS', $filtroValores['status_filtro']);
    }

    // 6. Executa a busca trazendo os dados da tabela
    $dados['dispositivos']   = $query->getDispositivoComDono()->findAll();
    $dados['filtro_valores'] = $filtroValores;

    // ================= DATA DOS GRÁFICOS =================
    // Gráfico 1: Status (Ativos vs Inativos) - Respeitando o filtro de dono se houver
    $contagemStatus = $this->dispositivoModel->getContagemStatus($filtroValores['dono_id']);

    $statusLabels = [];
    $statusValores = [];
    foreach ($contagemStatus as $cs) {
        $statusLabels[] = strtoupper($cs['DIS_STATUS']);
        $statusValores[] = (int)$cs['total'];
    }
    $dados['grafico_status'] = [
        'labels'  => $statusLabels,
        'valores' => $statusValores
    ];

    // Gráfico 2: Nível dos Tanques (Pega os dispositivos atuais filtrados)
    $tanqueLabels = [];
    $tanqueValores = [];
    // Limitando a 10 no gráfico para não quebrar o layout se tiver muitos dados
    $dispositivosGrafico = array_slice($dados['dispositivos'], 0, 10); 
    foreach ($dispositivosGrafico as $disp) {
        $tanqueLabels[] = $disp['DIS_NOME'];
        $tanqueValores[] = (float)$disp['DIS_NIVEL_TANQUE'];
    }
    $dados['grafico_tanques'] = [
        'labels'  => $tanqueLabels,
        'valores' => $tanqueValores
    ];
    // =====================================================

    // 7. Renderiza as views coladas
    return view('sistema/dispositivos/index', $dados);
}
    /**
     * Rota Unificada para renderizar o formulário (Novo ou Editar)
     * Rota: dispositivos/novo ou dispositivos/editar/ID
     */
    public function cadastrarDispositivo($id = null)
    {
        // Puxa todos os usuários para popular o <select> de proprietários na View
        $dados['usuarios_disponiveis'] = $this->usuarioModel
                                              ->select('USU_ID, USU_NOME')
                                              ->orderBy('USU_NOME', 'ASC')
                                              ->findAll();

        $dados['dispositivo'] = null;

        // Se vier ID na URL, carrega os dados do banco para entrar no Modo Edição
        if ($id !== null) {
            $dispositivo = $this->dispositivoModel->find($id);

            if (!$dispositivo) {
                return redirect()->to(base_url('dispositivos'))->with('errors', ['Dispositivo não encontrado.']);
            }
            $dados['dispositivo'] = $dispositivo;
        }

        // Renderiza a tela de cadastro/edição de dispositivo
        return view('sistema/dispositivos/novo_dispositivo', $dados); 
    }

    /**
     * AÇÃO: Salva um novo dispositivo ou Atualiza um existente
     * Rota: dispositivos/salvar (POST)
     */
    public function salvar()
    {
        $dadosPost = $this->request->getPost();

        // Remove tokens CSRF para não interferirem na verificação de alterações de dados
        unset($dadosPost['csrf_test_name']);

        // Se o ID do dispositivo estiver presente, mapeia para atualizar
        if (!empty($dadosPost['DIS_ID'])) {
            $id = $dadosPost['DIS_ID'];

            // Busca o registro atual do banco para comparar mudanças
            $registroAtual = $this->dispositivoModel->find($id);

            if ($registroAtual) {
                // Compara se houve de fato alguma alteração nos inputs enviados
                $alterado = false;
                foreach ($dadosPost as $key => $value) {
                    if (array_key_exists($key, $registroAtual) && (string)$registroAtual[$key] !== (string)$value) {
                        $alterado = true;
                    }
                }

                // Se tentou salvar sem alterar absolutamente nada, evita o erro do CodeIgniter "There is no data to update"
                if (!$alterado) {
                    return redirect()->to(base_url('admin/dispositivos'))->with('sucesso', 'Dispositivo atualizado (sem alterações).');
                }
            }
        }

        // Executa o salvamento (Insert ou Update automático baseado na presença da PK chave primária)
        if ($this->dispositivoModel->save($dadosPost)) {
            $mensagem = !empty($dadosPost['DIS_ID']) ? 'Dispositivo atualizado com sucesso!' : 'Dispositivo cadastrado com sucesso!';
            return redirect()->to(base_url('admin/dispositivos'))->with('sucesso', $mensagem);
        } else {
            return redirect()->back()->withInput()->with('errors', $this->dispositivoModel->errors());
        }
    }

    /**
     * AÇÃO: Exclusão definitiva de dispositivo
     * Rota: dispositivos/excluir/ID
     */
    public function excluir($id)
    {
        // Remove o dispositivo permanente do banco através do ID informado
        if ($this->dispositivoModel->delete($id)) {
            return redirect()->to(base_url('admin/dispositivos'))->with('sucesso', 'Dispositivo removido do sistema com sucesso.');
        } else {
            return redirect()->to(base_url('admin/dispositivos'))->with('erro', 'Erro ao tentar excluir o dispositivo.');
        }
    }

    /**
     * Área do Usuário: Listagem dos Dispositivos Vinculados à Sessão do Cliente
     * Rota: /meus-dispositivos
     */
    public function meusDispositivos()
    {
        // 1. TRAVA DE SEGURANÇA SEGUNDO SUAS REGRAS: Verifica se o usuário está logado
        if (!session()->get('logado') && !session()->get('id')) {
            return redirect()->to(base_url('login'))->with('erro', 'Acesso restrito. Por favor, faça login.');
        }

        // 2. Captura o ID do usuário guardado na sessão atual dele (com os seus fallbacks)
        $usuarioId = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

        // 3. Captura TODOS os filtros de busca vindos da URL (GET)
        $busca  = $this->request->getGet('busca');
        $status = $this->request->getGet('status');
        $nivel  = $this->request->getGet('nivel');

        // 4. Query com JOIN na tabela SENSOR e aliases para os campos não colidirem
        $query = $this->dispositivoModel
                      ->select('DISPOSITIVO.*, SENSOR.SEN_NOME as sensor_nome, SENSOR.SEN_TIPO as sensor_tipo, SENSOR.SEN_STATUS as sensor_status')
                      ->join('SENSOR', 'SENSOR.FK_DIS_ID = DISPOSITIVO.DIS_ID', 'left') // Left join garante exibições sem sensor
                      ->where('DISPOSITIVO.FK_USU_ID', $usuarioId);

        // FILTRO 1: Busca por texto (Nome ou Descrição)
        if (!empty($busca)) {
            $query = $query->groupStart()
                           ->like('DISPOSITIVO.DIS_NOME', $busca)
                           ->orLike('DISPOSITIVO.DIS_DESCRICAO', $busca)
                           ->groupEnd();
        }

        // FILTRO 2: Busca por Status (Ativo / Inativo)
        if (!empty($status)) {
            $query = $query->where('DISPOSITIVO.DIS_STATUS', strtoupper($status));
        }

        // FILTRO 3: Busca Inteligente por Faixas de Nível do Tanque
        if (!empty($nivel)) {
            if ($nivel === 'critico') {
                $query = $query->where('DISPOSITIVO.DIS_NIVEL_TANQUE <', 30);
            } elseif ($nivel === 'alerta') {
                $query = $query->where('DISPOSITIVO.DIS_NIVEL_TANQUE >=', 30)->where('DISPOSITIVO.DIS_NIVEL_TANQUE <=', 50);
            } elseif ($nivel === 'ideal') {
                $query = $query->where('DISPOSITIVO.DIS_NIVEL_TANQUE >', 50);
            }
        }

        // 5. Executa a busca trazendo os dispositivos filtrados do dono
        $dados['dispositivos'] = $query->findAll();
        
        // Devolvemos os estados dos filtros para manter os selects selecionados na tela
        $dados['busca']        = $busca;
        $dados['status_sel']   = $status;
        $dados['nivel_sel']    = $nivel;
        $dados['titulo']       = "Meus Dispositivos - HydroFlow";

        // ================= GRÁFICOS DO USUÁRIO =================
        // Gráfico 1: Status dos dispositivos DELE (Ativos vs Inativos)
        $contagemStatus = $this->dispositivoModel->getContagemStatus($usuarioId);
        
        $statusLabels = [];
        $statusValores = [];
        foreach ($contagemStatus as $cs) {
            $statusLabels[] = strtoupper($cs['DIS_STATUS']);
            $statusValores[] = (int)$cs['total'];
        }
        $dados['grafico_status'] = [
            'labels'  => $statusLabels,
            'valores' => $statusValores
        ];

        // Gráfico 2: Nível dos Tanques (Baseado nos itens que restaram após o filtro)
        $tanqueLabels = [];
        $tanqueValores = [];
        $dispositivosGrafico = array_slice($dados['dispositivos'], 0, 10); 
        foreach ($dispositivosGrafico as $disp) {
            $tanqueLabels[] = $disp['DIS_NOME'];
            $tanqueValores[] = (float)$disp['DIS_NIVEL_TANQUE'];
        }
        $dados['grafico_tanques'] = [
            'labels'  => $tanqueLabels,
            'valores' => $tanqueValores
        ];
        // =====================================================

        // 6. Renderiza a View do painel do cliente
        return view('sistema/dispositivos/meus-dispositivos', $dados);
    }
}