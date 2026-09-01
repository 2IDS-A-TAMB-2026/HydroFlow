<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\HistoricoIrrigacaoModel;

class HistoricoController extends BaseController
{
    protected $historicoModel;

    public function __construct()
    {
        $this->historicoModel = new HistoricoIrrigacaoModel();
    }

    public function index()
{
    $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

    if (!$idUsuarioLogado) {
        return redirect()->to(base_url('login'))->with('error', 'Por favor, faça login.');
    }

    // Pega os filtros da URL
    $dataInicial  = $this->request->getGet('data_inicial');
    $dataFinal    = $this->request->getGet('data_final');
    $setorFiltro  = $this->request->getGet('setor_filtro') ?? 'todos';
    $statusFiltro = $this->request->getGet('status_filtro') ?? 'todos';

    // Query base trazendo os dados da Planta vinculada
    $query = $this->historicoModel->select('HISTORICO_IRRIGACAO.*, PLANTA.PLANTA_NOME as nome_planta, PLANTA.PLANTA_CULTURA as cultura')
        ->join('PLANTA', 'PLANTA.PLANTA_ID = HISTORICO_IRRIGACAO.FK_PLANTA_ID')
        ->where('HISTORICO_IRRIGACAO.FK_USU_ID', $idUsuarioLogado);

    // Filtros dinâmicos
    if (!empty($dataInicial)) {
        $query->where('HISTORICO_IRRIGACAO.IRR_DATA >=', $dataInicial);
    }
    if (!empty($dataFinal)) {
        $query->where('HISTORICO_IRRIGACAO.IRR_DATA <=', $dataFinal);
    }
    if ($setorFiltro !== 'todos') {
        $query->where('HISTORICO_IRRIGACAO.FK_PLANTA_ID', $setorFiltro);
    }
    if ($statusFiltro !== 'todos') {
        $query->where('HISTORICO_IRRIGACAO.IRR_STATUS', $statusFiltro);
    }

    // Registros para a tabela (Ordenados do mais recente para o mais antigo)
    $irrigacoes = $query->orderBy('IRR_DATA DESC', 'IRR_HORA DESC')->findAll();
    $data['irrigacoes'] = $irrigacoes;
    $data['titulo']     = "Histórico de Ativações (Irrigador)";
    
    $data['filtro_valores'] = [
        'data_inicial'  => $dataInicial,
        'data_final'    => $dataFinal,
        'setor_filtro'  => $setorFiltro,
        'status_filtro' => $statusFiltro
    ];

    // --- NOVA LÓGICA: GERAR DADOS DO GRÁFICO ---
    $subtotaisGrafico = [];
    foreach ($irrigacoes as $item) {
        // Ignora registros com falha se quiser computar apenas água consumida de fato
        if ($item['IRR_STATUS'] === 'Falha') {
            continue;
        }
        
        $dataFormatada = date('d/m', strtotime($item['IRR_DATA']));
        $volume = (float)($item['IRR_VOLUME'] ?? 0);
        
        if (!isset($subtotaisGrafico[$dataFormatada])) {
            $subtotaisGrafico[$dataFormatada] = 0;
        }
        $subtotaisGrafico[$dataFormatada] += $volume;
    }
    
    // Inverte a ordem para que o gráfico mostre da data mais antiga para a mais recente (cronológico)
    $subtotaisGrafico = array_reverse($subtotaisGrafico);

    $data['dados_grafico'] = [
        'labels' => array_keys($subtotaisGrafico),
        'valores' => array_values($subtotaisGrafico)
    ];

    return view('sistema/Historico/historico', $data);
}
}