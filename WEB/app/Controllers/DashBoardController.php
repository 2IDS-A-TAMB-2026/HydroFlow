<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\DispositivoModel;
use App\Models\DadosSensoresModel;
use CodeIgniter\Model;

class DashboardController extends BaseController
{
    public function index()
    {
        $idUsuarioLogado = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

        if (!$idUsuarioLogado) {
            return redirect()->to(base_url('login'));
        }

        // 1. Instanciar os Models necessários
        $dispositivoModel = new DispositivoModel();
        $dadosModel   = new DadosSensoresModel();
        $db = \Config\Database::connect();

        // 2. Contagens para os cards de KPI (Filtrados por Usuário)
        $data['total_ativos']   = $dispositivoModel->where('FK_USU_ID', $idUsuarioLogado)->where('DIS_STATUS', 'ATIVO')->countAllResults();
        $data['total_inativos'] = $dispositivoModel->where('FK_USU_ID', $idUsuarioLogado)->where('DIS_STATUS', 'INATIVO')->countAllResults();
        
        // Contagem de Plantas Cadastradas
        $data['total_plantas']  = $db->table('PLANTA')->where('FK_USU_ID', $idUsuarioLogado)->countAllResults();
        
        // Contagem de Alertas / Falhas registradas no histórico
        $data['total_alertas']  = $dadosModel->where('FK_SEN_ID', $idUsuarioLogado)->where('DDS_STATUS', '0')->countAllResults();


        // 4. PREPARAÇÃO DOS DADOS DO GRÁFICO (Radar Multi-Métricas)
        $labelsGrafico = [
            'Dispositivos Ativos', 
            'Dispositivos Inativos', 
            'Alertas (Falhas)', 
            'Plantas Cadastradas', 
        ];

        $valoresGrafico = [
            (float) $data['total_ativos'],
            (float) $data['total_inativos'],
            (float) $data['total_alertas'],
            (float) $data['total_plantas'],
        ];

        $data['grafico_labels']  = $labelsGrafico;
        $data['grafico_valores'] = $valoresGrafico;
        $data['titulo']          = "Painel de Controle - HydroFlow";

        return view('sistema/dashboard/usuario/index', $data);
    }
}