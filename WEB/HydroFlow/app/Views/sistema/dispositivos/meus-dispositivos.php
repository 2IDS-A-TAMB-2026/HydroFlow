<?php if (session()->getFlashdata('sucesso')): ?>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            Swal.fire({
                title: 'Sucesso!',
                text: '<?= session()->getFlashdata('sucesso') ?>',
                icon: 'success',
                confirmButtonColor: '#00a65a',
                timer: 3000
            });
        });
    </script>
<?php endif; ?>

<?php if (session()->getFlashdata('erro')): ?>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            Swal.fire({
                title: 'Erro!',
                text: '<?= session()->getFlashdata('erro') ?>',
                icon: 'error',
                confirmButtonColor: '#d33'
            });
        });
    </script>
<?php endif; ?>

<?= view('sistema/layout/dashboard/usuario/header') ?>

<!-- CHART.JS -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- LEAFLET.JS (OPENSTREETMAP) - CSS E JS -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<style>
    .unified-card {
        background: #ffffff;
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        padding: 20px;
        margin-bottom: 20px;
        border: 1px solid #eef2f5;
    }
    .filter-section {
        padding-bottom: 20px;
        margin-bottom: 20px;    
        border-bottom: 1px solid #f1f3f5;
    }
    .data-table tbody tr {
        background-color: #ffffff !important;
        transition: background-color 0.2s ease;
    }
    .data-table tbody tr:hover {
        background-color: #f8f9fa !important;
    }
    .dashboard-row {
        display: flex;
        gap: 20px;
        margin-bottom: 20px;
        flex-wrap: wrap;
    }
    .dashboard-col {
        flex: 1;
        min-width: 300px;
        max-height: 320px;
        display: flex;
        flex-direction: column;
        align-items: center;
    }
    .status-badge {
        padding: 5px 10px;
        border-radius: 20px;
        font-size: 0.85rem;
        font-weight: bold;
        display: inline-block;
    }
    .badge-green { background-color: #d1fae5; color: #065f46; }
    .badge-red { background-color: #fee2e2; color: #991b1b; }
    
    .btn-view-details:hover {
        transform: scale(1.15);
        color: #2a5298 !important;
    }

    /* ESTILOS BASE DO MODAL SWEETALERT */
    .custom-swal-modal {
        padding: 0 !important;
        border-radius: 12px !important;
        overflow: hidden !important;
        background-color: #ffffff !important;
        color: #1e293b !important;
        border: 1px solid #cbd5e1 !important;
    }
    .custom-swal-modal .swal2-html-container {
        margin: 0 !important;
        padding: 0 !important;
    }
    .custom-swal-modal .swal2-actions {
        margin: 0 0 20px 0 !important;
    }
    .custom-swal-confirm-btn {
        background: #1e3c72 !important;
        color: #ffffff !important;
        font-family: 'Segoe UI', Arial, sans-serif !important;
        font-size: 0.85rem !important;
        font-weight: 600 !important;
        padding: 10px 28px !important;
        border-radius: 8px !important;
        border: none !important;
        box-shadow: 0 4px 6px -1px rgba(30, 60, 114, 0.2) !important;
        transition: all 0.2s ease-in-out !important;
    }
    .custom-swal-confirm-btn:hover {
        background: #2a5298 !important;
        transform: translateY(-1px) !important;
        box-shadow: 0 6px 10px -1px rgba(42, 82, 152, 0.3) !important;
    }

    /* COMPONENTES INTERNOS DO MODAL */
    .swal-modal-header {
        background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
        width: 100%;
        padding: 18px 24px;
        text-align: left;
        display: flex;
        align-items: center;
        justify-content: space-between;
        box-sizing: border-box;
    }
    .swal-card-bg {
        background-color: #ffffff;
        border: 1px solid #e2e8f0;
        color: #1e293b;
    }
    .swal-card-bg-sub {
        background-color: #f8fafc;
        border: 1px solid #e2e8f0;
        color: #0f172a;
    }

    /* CONTAINER DO MAPA OPENSTREETMAP */
    #osm-map {
        width: 100%;
        height: 140px;
        border-radius: 8px;
        border: 1px solid #cbd5e1;
        z-index: 10;
    }

    /* BADGES DE STATUS ADAPTÁVEIS */
    .swal-badge-online {
        background-color: #0284c7;
        color: #ffffff !important;
        padding: 4px 10px;
        border-radius: 20px;
        font-weight: 700;
        font-size: 0.7rem;
        display: inline-block;
        white-space: nowrap;
    }
    .swal-badge-offline {
        background-color: #64748b;
        color: #ffffff !important;
        padding: 4px 10px;
        border-radius: 20px;
        font-weight: 700;
        font-size: 0.7rem;
        display: inline-block;
        white-space: nowrap;
    }
    .swal-badge-ativo {
        background-color: #10b981;
        color: #ffffff !important;
        padding: 4px 12px;
        border-radius: 20px;
        font-weight: 700;
        font-size: 0.75rem;
        display: inline-block;
        white-space: nowrap;
    }
    .swal-badge-inativo {
        background-color: #ef4444;
        color: #ffffff !important;
        padding: 4px 12px;
        border-radius: 20px;
        font-weight: 700;
        font-size: 0.75rem;
        display: inline-block;
        white-space: nowrap;
    }

    /* ==========================================================================
       SUPORTE TOTAL AO SISTEMA DE ALTO CONTRASTE DO HYDROFLOW
       ========================================================================== */
    body.alto-contraste .custom-swal-modal,
    body.alto-contraste .swal2-popup {
        background-color: #000000 !important;
        color: #ffffff !important;
        border: 2px solid #ffffff !important;
    }
    
    body.alto-contraste .swal-modal-header {
        background: #000000 !important;
        border-bottom: 2px solid #ffff00 !important;
    }

    body.alto-contraste .swal-card-bg,
    body.alto-contraste .swal-card-bg-sub {
        background-color: #000000 !important;
        background: #000000 !important;
        border: 2px solid #ffffff !important;
        color: #ffffff !important;
    }

    body.alto-contraste #osm-map {
        border: 2px solid #ffffff !important;
        filter: contrast(120%);
    }

    body.alto-contraste .custom-swal-modal h3,
    body.alto-contraste .custom-swal-modal h4,
    body.alto-contraste .custom-swal-modal strong,
    body.alto-contraste .custom-swal-modal span,
    body.alto-contraste .custom-swal-modal small,
    body.alto-contraste .custom-swal-modal i {
        color: #ffffff !important;
    }

    body.alto-contraste .custom-swal-confirm-btn {
        background-color: #ffffff !important;
        color: #000000 !important;
        border: 2px solid #ffffff !important;
        font-weight: bold !important;
    }
    body.alto-contraste .custom-swal-confirm-btn:hover {
        background-color: #000000 !important;
        color: #ffffff !important;
    }

    body.alto-contraste .swal-badge-online {
        background-color: #000000 !important;
        color: #ffff00 !important;
        border: 2px solid #ffff00 !important;
    }
    body.alto-contraste .swal-badge-ativo {
        background-color: #000000 !important;
        color: #555ff55 !important;
        border: 2px solid #55ff55 !important;
    }
    body.alto-contraste .swal-badge-inativo {
        background-color: #000000 !important;
        color: #ff5555 !important;
        border: 2px solid #ff5555 !important;
    }
</style>

<main style="padding: 20px; font-family: Arial, sans-serif;">
    <div class="page-header" style="margin-bottom: 25px;">
        <div>
            <h2 style="color: #1e3c72; margin: 0; font-weight: 600;">Meus Dispositivos (IoT)</h2>
            <p style="color: #666; margin: 5px 0 0 0;">Monitore em tempo real a telemetria e o nível de armazenamento dos seus tanques integrados.</p>
        </div>
    </div>

    <?php if (!empty($dispositivos)): ?>
    <div class="unified-card">
        <h3 style="margin-top: 0; margin-bottom: 20px; font-size: 1.1rem; font-weight: bold; color: #333;">
            <i class="fa-solid fa-chart-pie" style="color: #1e3c72;"></i> Meus Indicadores
        </h3>
        <div class="dashboard-row">
            <div class="dashboard-col" style="border-right: 1px solid #f1f3f5; padding-right: 10px;">
                <span style="font-size: 0.9rem; font-weight: bold; color: #666; margin-bottom: 10px;">Status dos Meus Equipamentos</span>
                <div style="width: 100%; max-width: 230px; height: 230px;">
                    <canvas id="chartStatus"></canvas>
                </div>
            </div>
            
            <div class="dashboard-col" style="flex: 2;">
                <span style="font-size: 0.9rem; font-weight: bold; color: #666; margin-bottom: 15px;">Volume Atual dos Meus Tanques (%)</span>
                <div style="width: 100%; height: 220px; position: relative;">
                    <canvas id="chartTanques"></canvas>
                </div>
            </div>
        </div>
    </div>
    <?php endif; ?>

    <div class="unified-card">
        <!-- BARRA DE FILTROS AVANÇADA -->
        <div class="filter-section">
            <h3 class="form-title" style="margin-top: 0; margin-bottom: 15px; font-size: 1.1rem; font-weight: bold; color: #333;">
                <i class="fa-solid fa-filter" style="color: #6c757d;"></i> Filtrar Meus Dispositivos
            </h3>
            <form class="filter-bar" method="get" action="<?= base_url('meus-dispositivos') ?>" style="display: flex; gap: 15px; flex-wrap: wrap; align-items: flex-end;">
                
                <div class="form-group" style="flex: 2; min-width: 220px; display: flex; flex-direction: column; gap: 5px;">
                    <label style="font-size: 0.85rem; font-weight: bold; color: #555;">Buscar por Texto</label>
                    <div style="position: relative; width: 100%;">
                        <input type="text" class="form-control" name="busca" placeholder="Ex: Sensor da Horta..." value="<?= esc($busca ?? '') ?>" style="width: 100%; padding: 10px 40px 10px 12px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px; font-size: 0.9rem;">
                        <i class="fa-solid fa-magnifying-glass" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #888;"></i>
                    </div>
                </div>

                <div class="form-group" style="flex: 1; min-width: 150px; display: flex; flex-direction: column; gap: 5px;">
                    <label style="font-size: 0.85rem; font-weight: bold; color: #555;">Status do Equipamento</label>
                    <select name="status" style="width: 100%; padding: 0 12px; border: 1px solid #ccc; border-radius: 6px; height: 42px; background: #fff; font-size: 0.9rem; cursor: pointer;">
                        <option value="">Todos os Status</option>
                        <option value="ativo" <?= ($status_sel ?? '') === 'ativo' ? 'selected' : '' ?>>🟢 Ativo</option>
                        <option value="inativo" <?= ($status_sel ?? '') === 'inativo' ? 'selected' : '' ?>>🔴 Inativo</option>
                    </select>
                </div>

                <div class="form-group" style="flex: 1; min-width: 180px; display: flex; flex-direction: column; gap: 5px;">
                    <label style="font-size: 0.85rem; font-weight: bold; color: #555;">Volume do Tanque</label>
                    <select name="nivel" style="width: 100%; padding: 0 12px; border: 1px solid #ccc; border-radius: 6px; height: 42px; background: #fff; font-size: 0.9rem; cursor: pointer;">
                        <option value="">Todos os Volumes</option>
                        <option value="critico" <?= ($nivel_sel ?? '') === 'critico' ? 'selected' : '' ?>>⚠️ Crítico (Abaixo de 30%)</option>
                        <option value="alerta" <?= ($nivel_sel ?? '') === 'alerta' ? 'selected' : '' ?>>🟠 Alerta (30% a 50%)</option>
                        <option value="ideal" <?= ($nivel_sel ?? '') === 'ideal' ? 'selected' : '' ?>>🔵 Ideal (Acima de 50%)</option>
                    </select>
                </div>

                <div class="form-group" style="flex: 0 0 auto; display: flex; gap: 8px;">
                    <button type="submit" class="btn-submit" style="height: 42px; padding: 0 20px; background-color: #1e3c72; color: #fff; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; display: flex; align-items: center; gap: 8px; font-size: 0.9rem;">
                        <i class="fa-solid fa-filter"></i> Filtrar
                    </button>
                    
                    <?php if (!empty($busca) || !empty($status_sel) || !empty($nivel_sel)): ?>
                        <a href="<?= base_url('meus-dispositivos') ?>" style="display: flex; align-items: center; justify-content: center; height: 42px; width: 42px; border: 1px solid #ccc; border-radius: 6px; background: #f5f5f5; color: #333; text-decoration: none;" title="Limpar Todos os Filtros">
                            <i class="fa-solid fa-xmark"></i>
                        </a>
                    <?php endif; ?>
                </div>
            </form>
        </div>

        <!-- TABELA DE DISPOSITIVOS -->
        <div class="table-responsive">
            <table class="data-table" style="width: 100%; border-collapse: collapse; text-align: left;">
                <thead>
                    <tr style="border-bottom: 2px solid #eef2f5;">
                        <th style="padding: 12px 8px;">ID</th>
                        <th style="padding: 12px 8px;">Nome do Dispositivo</th>
                        <th style="padding: 12px 8px;">Descrição / Identificação</th>
                        <th style="padding: 12px 8px;">Nível Ocupado</th>
                        <th style="padding: 12px 8px;">Status do Sistema</th>
                        <th style="padding: 12px 8px; text-align: center;">Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($dispositivos) && is_array($dispositivos)): ?>
                        <?php foreach ($dispositivos as $disp): ?>
                            <?php 
                                $litros = number_format(($disp['DIS_NIVEL_TANQUE'] * 0.147), 1, ',', '.'); 
                                $idFormatado = str_pad($disp['DIS_ID'], 3, '0', STR_PAD_LEFT);
                            ?>
                            <tr style="border-bottom: 1px solid #f1f3f5; vertical-align: middle;">
                                <td style="padding: 12px 8px;">#<?= $idFormatado ?></td>
                                <td style="padding: 12px 8px;"><strong><?= esc($disp['DIS_NOME']) ?></strong></td>
                                <td style="padding: 12px 8px; color: #555;">
                                    <?= esc($disp['DIS_DESCRICAO'] ?: 'Sem descrição cadastrada pelo administrador.') ?>
                                </td>
                                <td style="padding: 12px 8px;">
                                    <strong><?= esc($disp['DIS_NIVEL_TANQUE']) ?>%</strong> 
                                    <small style="color: #666; margin-left: 4px;">(<?= $litros ?>L)</small>
                                </td>
                                <td style="padding: 12px 8px;">
                                    <?php if (strtoupper($disp['DIS_STATUS']) === 'ATIVO'): ?>
                                        <span class="status-badge badge-green">Ativo</span>
                                    <?php else: ?>
                                        <span class="status-badge badge-red">Inativo</span>
                                    <?php endif; ?>
                                </td>
                                <td style="padding: 12px 8px; text-align: center;">
                                    <button type="button" class="btn-view-details" 
                                            data-id="<?= $idFormatado ?>"
                                            data-nome="<?= esc($disp['DIS_NOME']) ?>"
                                            data-descricao="<?= esc($disp['DIS_DESCRICAO'] ?: 'Nenhuma descrição detalhada informada.') ?>"
                                            data-nivel="<?= esc($disp['DIS_NIVEL_TANQUE']) ?>"
                                            data-litros="<?= $litros ?>"
                                            data-status="<?= strtoupper($disp['DIS_STATUS']) ?>"
                                            data-endereco="<?= esc($disp['DIS_ENDERECO'] ?: 'Não Informado') ?>"
                                            data-cep="<?= esc($disp['DIS_CEP'] ?: 'N/A') ?>"
                                            data-rua="<?= esc($disp['DIS_RUA'] ?: 'Não cadastrada') ?>"
                                            data-num="<?= esc($disp['DIS_NUM'] ?: 'S/N') ?>"
                                            data-cidade="<?= esc($disp['DIS_CIDADE'] ?: 'Não informada') ?>"
                                            data-uf="<?= esc($disp['DIS_UF'] ?: '-') ?>"
                                            data-lat="<?= esc($disp['DIS_LATITUDE'] ?: '-23.5505') ?>"
                                            data-lng="<?= esc($disp['DIS_LONGITUDE'] ?: '-46.6333') ?>"
                                            
                                            data-sensor-nome="<?= esc($disp['sensor_nome'] ?? '') ?>"
                                            data-sensor-tipo="<?= esc($disp['sensor_tipo'] ?? '') ?>"
                                            data-sensor-status="<?= esc($disp['sensor_status'] ?? '') ?>"

                                            style="background: none; border: none; color: #1e3c72; cursor: pointer; font-size: 1.1rem; padding: 5px; transition: transform 0.2s;"
                                            title="Ver Detalhes">
                                        <i class="fa-solid fa-eye"></i>
                                    </button>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="6" style="text-align: center; color: #999; padding: 40px 20px;">
                                <div style="margin-bottom: 10px;">
                                    <i class="fa-solid fa-folder-open" style="font-size: 1.5rem; color: #adb5bd;"></i>
                                </div>
                                Nenhum dispositivo correspondente aos filtros foi encontrado.
                            </td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</main>

<script>
document.addEventListener('DOMContentLoaded', function() {
    <?php if (!empty($dispositivos)): ?>
    
    const centroIconePlugin = {
        id: 'centroIcone',
        afterDraw: function(chart) {
            if (chart.config.options.plugins.centroIcone) {
                const ctx = chart.ctx;
                const options = chart.config.options.plugins.centroIcone;
                
                if (options.exibir) {
                    ctx.save();
                    const xCentro = (chart.chartArea.left + chart.chartArea.right) / 2;
                    const yCentro = (chart.chartArea.top + chart.chartArea.bottom) / 2;
                    
                    ctx.textAlign = 'center';
                    ctx.textBaseline = 'middle';
                    ctx.font = `900 ${options.tamanho || '24px'} "${options.fonte || 'Font Awesome 6 Free'}"`;
                    ctx.fillStyle = options.cor || '#1e3c72';
                    ctx.fillText(options.icone, xCentro, yCentro);
                    ctx.restore();
                }
            }
        }
    };

    const ctxStatus = document.getElementById('chartStatus').getContext('2d');
    new Chart(ctxStatus, {
        type: 'doughnut',
        plugins: [centroIconePlugin],
        data: {
            labels: <?= json_encode($grafico_status['labels']) ?>,
            datasets: [{
                data: <?= json_encode($grafico_status['valores']) ?>,
                backgroundColor: ['#10b981', '#ef4444', '#f59e0b'], 
                borderWidth: 0, 
                spacing: 4,     
                borderRadius: 6 
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '75%', 
            plugins: {
                centroIcone: {
                    exibir: true,
                    icone: '\uf2db',
                    tamanho: '28px', 
                    cor: '#475569', 
                    fonte: 'Font Awesome 6 Free'
                },
                legend: { 
                    position: 'bottom', 
                    labels: { 
                        boxWidth: 10,
                        boxHeight: 10,
                        usePointStyle: true, 
                        pointStyle: 'circle',
                        padding: 20,
                        font: { size: 11, weight: '600', family: 'Arial' },
                        color: '#555'
                    } 
                },
                tooltip: {
                    backgroundColor: '#1e3c72',
                    padding: 10,
                    cornerRadius: 6,
                    displayColors: false
                }
            }
        }
    });

    const ctxTanques = document.getElementById('chartTanques').getContext('2d');
    const dadosOriginais = <?= json_encode($grafico_tanques) ?>;

    let listaTanques = [];
    if (dadosOriginais && dadosOriginais.labels) {
        for (let i = 0; i < dadosOriginais.labels.length; i++) {
            listaTanques.push({
                nome: dadosOriginais.labels[i],
                nivel: parseFloat(dadosOriginais.valores[i])
            });
        }
    }

    listaTanques.sort((a, b) => a.nivel - b.nivel);

    const labelsOrdenadas = listaTanques.map(item => item.nome);
    const valoresOrdenados = listaTanques.map(item => item.nivel);

    new Chart(ctxTanques, {
        type: 'bar',
        data: {
            labels: labelsOrdenadas,
            datasets: [{
                label: 'Nível Atual',
                data: valoresOrdenados,
                borderWidth: 1.5,
                borderRadius: 6,
                borderSkipped: 'start',
                backgroundColor: function(context) {
                    const value = context.dataset.data[context.dataIndex];
                    if (value < 30) return 'rgba(211, 47, 47, 0.85)';
                    if (value <= 50) return 'rgba(245, 124, 0, 0.85)';
                    return 'rgba(30, 136, 229, 0.85)';
                },
                borderColor: function(context) {
                    const value = context.dataset.data[context.dataIndex];
                    if (value < 30) return '#d32f2f';
                    if (value <= 50) return '#f57c00';
                    return '#1e88e5';
                },
                hoverBackgroundColor: function(context) {
                    const value = context.dataset.data[context.dataIndex];
                    if (value < 30) return '#b71c1c';
                    if (value <= 50) return '#e65100';
                    return '#1565c0';
                }
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return ` Nível: ${context.parsed.y}%`;
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    max: 100,
                    grid: { color: '#f1f3f5' },
                    ticks: {
                        callback: function(value) { return value + '%'; },
                        font: { size: 11, family: 'Arial' }
                    }
                },
                x: {
                    grid: { display: false },
                    ticks: {
                        maxRotation: 25,
                        minRotation: 15,
                        font: { size: 10, weight: '600' },
                        color: '#444'
                    }
                }
            }
        }
    });
    <?php endif; ?>

    // MODAL INTEGRADO AO OPENSTREETMAP + ALTO CONTRASTE
    const botoesDetalhes = document.querySelectorAll('.btn-view-details');
    botoesDetalhes.forEach(botao => {
        botao.addEventListener('click', function() {
            const id = this.getAttribute('data-id');
            const nome = this.getAttribute('data-nome');
            const descricao = this.getAttribute('data-descricao');
            const nivel = this.getAttribute('data-nivel');
            const litros = this.getAttribute('data-litros');
            const status = this.getAttribute('data-status');
            
            const enderecoIdentificador = this.getAttribute('data-endereco');
            const cep = this.getAttribute('data-cep');
            const rua = this.getAttribute('data-rua');
            const num = this.getAttribute('data-num');
            const cidade = this.getAttribute('data-cidade');
            const uf = this.getAttribute('data-uf');
            
            // CONVERTE AS COORDENADAS OU USA SÃO PAULO COMO PADRÃO CASO VENHAM ZERADAS
            let lat = parseFloat(this.getAttribute('data-lat'));
            let lng = parseFloat(this.getAttribute('data-lng'));
            if (isNaN(lat) || lat === 0) lat = -23.5505;
            if (isNaN(lng) || lng === 0) lng = -46.6333;

            const sensorNome = this.getAttribute('data-sensor-nome');
            const sensorTipo = this.getAttribute('data-sensor-tipo');
            const sensorStatus = this.getAttribute('data-sensor-status') ? this.getAttribute('data-sensor-status').toUpperCase() : '';

            const statusBadge = status === 'ATIVO' 
                ? '<span class="swal-badge-ativo">● ATIVO</span>'
                : '<span class="swal-badge-inativo">● INATIVO</span>';

            let htmlSensorBox = '';
            if (sensorNome) {
                const badgeSensor = sensorStatus === 'ATIVO'
                    ? '<span class="swal-badge-online">ONLINE</span>'
                    : '<span class="swal-badge-offline">OFFLINE</span>';
                
                htmlSensorBox = `
                    <div class="swal-card-bg" style="border-radius: 8px; padding: 12px; margin-top: 12px; display: flex; align-items: center; justify-content: space-between; gap: 12px;">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <div style="background: #1e3c72; width: 34px; height: 34px; border-radius: 8px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                <i class="fa-solid fa-satellite-dish" style="color: #ffffff; font-size: 0.9rem;"></i>
                            </div>
                            <div style="text-align: left;">
                                <small style="display: block; font-weight: 700; text-transform: uppercase; font-size: 0.6rem;">Sensor Conectado</small>
                                <strong style="font-size: 0.9rem; display: block; line-height: 1.2; margin-top: 1px;">${sensorNome}</strong> 
                                <span style="font-size: 0.75rem;">(${sensorTipo})</span>
                            </div>
                        </div>
                        <div>${badgeSensor}</div>
                    </div>
                `;
            } else {
                htmlSensorBox = `
                    <div class="swal-card-bg" style="border-style: dashed; border-radius: 8px; padding: 12px; margin-top: 12px; text-align: center; font-size: 0.8rem;">
                        <i class="fa-solid fa-link-slash" style="margin-right: 6px;"></i> <span>Sem sensor vinculado</span>
                    </div>
                `;
            }

            Swal.fire({
                html: `
                    <!-- HEADER FULL-WIDTH -->
                    <div class="swal-modal-header">
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <div style="background: rgba(255,255,255,0.2); width: 38px; height: 38px; border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                                <i class="fa-solid fa-microchip" style="color: #ffffff; font-size: 1.1rem;"></i>
                            </div>
                            <div>
                                <h3 style="margin: 0; font-size: 1.15rem; color: #ffffff; font-weight: 700; letter-spacing: -0.3px;">Painel de Telemetria</h3>
                                <span style="font-size: 0.75rem; color: #e2e8f0; font-weight: 600;">Equipamento ID #${id}</span>
                            </div>
                        </div>
                    </div>

                    <!-- CONTEÚDO ADAPTÁVEL -->
                    <div style="padding: 20px 24px; text-align: left; font-family: 'Segoe UI', Arial, sans-serif;">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                            
                            <!-- COLUNA ESQUERDA -->
                            <div style="display: flex; flex-direction: column; gap: 12px;">
                                
                                <div class="swal-card-bg-sub" style="border-radius: 10px; padding: 14px;">
                                    <div style="margin-bottom: 8px;">
                                        <small style="display: block; font-weight: 700; text-transform: uppercase; font-size: 0.6rem;">Nome Identificador</small>
                                        <strong style="font-size: 1.05rem; font-weight: 700; display: block; margin-top: 2px;">${nome}</strong>
                                    </div>
                                    <div>
                                        <small style="display: block; font-weight: 700; text-transform: uppercase; font-size: 0.6rem;">Descrição Operacional</small>
                                        <span style="font-size: 0.82rem; line-height: 1.4; display: block; margin-top: 2px;">${descricao}</span>
                                    </div>
                                    ${htmlSensorBox}
                                </div>

                                <div class="swal-card-bg" style="border-radius: 10px; padding: 14px;">
                                    <h4 style="margin: 0 0 10px 0; border-bottom: 1px solid #cbd5e1; padding-bottom: 6px; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; display: flex; align-items: center; gap: 6px;">
                                        <i class="fa-solid fa-gauge-high"></i> Telemetria
                                    </h4>
                                    <div style="display: flex; justify-content: space-between; align-items: center;">
                                        <div>
                                            <small style="display: block; font-size: 0.7rem; font-weight: 600;">Volume de Armazenamento</small>
                                            <div style="display: flex; align-items: baseline; gap: 4px; margin-top: 2px;">
                                                <strong style="font-size: 1.3rem; font-weight: 800;">${nivel}%</strong>
                                                <span style="font-size: 0.8rem; font-weight: 600;">(${litros}L)</span>
                                            </div>
                                        </div>
                                        <div>
                                            <small style="display: block; font-size: 0.7rem; font-weight: 600; margin-bottom: 3px;">Status do Sistema</small>
                                            ${statusBadge}
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <!-- COLUNA DIREITA (COM MAPA OPENSTREETMAP) -->
                            <div style="display: flex; flex-direction: column; gap: 12px;">
                                
                                <div class="swal-card-bg" style="border-radius: 10px; padding: 14px; height: 100%; display: flex; flex-direction: column; justify-content: space-between;">
                                    <div>
                                        <h4 style="margin: 0 0 10px 0; border-bottom: 1px solid #cbd5e1; padding-bottom: 6px; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; display: flex; align-items: center; gap: 6px;">
                                            <i class="fa-solid fa-map-location-dot"></i> Local de Instalação
                                        </h4>
                                        
                                        <div style="margin-bottom: 8px;">
                                            <small style="display: block; font-size: 0.65rem; font-weight: 600;">Ponto de Referência</small>
                                            <span style="font-weight: 600; font-size: 0.8rem; display: block; margin-top: 1px;">${enderecoIdentificador}</span>
                                        </div>

                                        <div style="margin-bottom: 10px; line-height: 1.3;">
                                            <small style="display: block; font-size: 0.65rem; font-weight: 600;">Endereço Físico</small>
                                            <span style="font-weight: 700; font-size: 0.8rem; display: block; margin-top: 1px;">${rua}, Nº ${num}</span>
                                            <span style="font-size: 0.75rem; display: block;">${cidade} - ${uf} (CEP: ${cep})</span>
                                        </div>
                                    </div>

                                    <!-- MAPINHA INTERATIVO LEAFLET / OPENSTREETMAP -->
                                    <div>
                                        <small style="display: block; font-size: 0.65rem; font-weight: 600; margin-bottom: 4px;">Localização via GPS (${lat}, ${lng})</small>
                                        <div id="osm-map"></div>
                                    </div>
                                </div>

                            </div>

                        </div>
                    </div>
                `,
                showConfirmButton: true,
                confirmButtonText: '<i class="fa-solid fa-xmark" style="margin-right: 6px;"></i> Fechar Painel',
                customClass: {
                    popup: 'custom-swal-modal',
                    confirmButton: 'custom-swal-confirm-btn'
                },
                width: '680px',
                didOpen: () => {
                    // RENDERIZA O MAPA QUANDO O MODAL TERMINAR DE ABRIR
                    setTimeout(() => {
                        const map = L.map('osm-map').setView([lat, lng], 14);

                        // CAMADA DE MAPA GRATUITA DO OPENSTREETMAP
                        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                            maxZoom: 19,
                            attribution: '© OpenStreetMap'
                        }).addTo(map);

                        // MARCADOR NO LOCAL DO DISPOSITIVO
                        L.marker([lat, lng]).addTo(map)
                            .bindPopup(`<b>${nome}</b><br>ID #${id}`)
                            .openPopup();
                    }, 200);
                }
            });
        });
    });
});
</script>