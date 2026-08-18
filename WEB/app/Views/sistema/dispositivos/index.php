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

<?= view('sistema/layout/dashboard/adm/header') ?>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
    /* Estilo para a seção de dashboards */
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
</style>

<main style="padding: 20px; font-family: Arial, sans-serif;">
    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
        <div>
            <h2 style="color: #1e3c72; margin: 0; font-weight: 600;">Módulo de Dispositivos (IoT)</h2>
            <p style="color: #666; margin: 5px 0 0 0;">Gerencie a telemetria, localização e propriedade dos dispositivos integrados.</p>
        </div>
        
        <a href="<?= base_url('admin/dispositivos/novo') ?>" class="btn-add-user" style="text-decoration: none; display: inline-flex; align-items: center; gap: 8px;">
            <i class="fa-solid fa-plus"></i> Novo Cadastro
        </a>
    </div>

    <?php if (!empty($dispositivos)): ?>
    <div class="unified-card">
        <h3 style="margin-top: 0; margin-bottom: 20px; font-size: 1.1rem; font-weight: bold; color: #333;">
            <i class="fa-solid fa-chart-pie" style="color: #1e3c72;"></i> Indicadores em Tempo Real
        </h3>
        <div class="dashboard-row">
            <div class="dashboard-col" style="border-right: 1px solid #f1f3f5; padding-right: 10px;">
                <span style="font-size: 0.9rem; font-weight: bold; color: #666; margin-bottom: 10px;">Status Geral dos Equipamentos</span>
                <div style="width: 100%; max-width: 230px; height: 230px;">
                    <canvas id="chartStatus"></canvas>
                </div>
            </div>
            
            <div class="dashboard-col" style="flex: 2;">
                <span style="font-size: 0.9rem; font-weight: bold; color: #666; margin-bottom: 15px;">Nível Atual dos Tanques (%)</span>
                <div style="width: 100%; height: 220px; position: relative;">
                    <canvas id="chartTanques"></canvas>
                </div>
            </div>
        </div>
    </div>
    <?php endif; ?>

    <div class="unified-card">
        <div class="filter-section">
            <h3 class="form-title" style="margin-top: 0; margin-bottom: 15px; font-size: 1.1rem; font-weight: bold; color: #333;">
                <i class="fa-solid fa-filter" style="color: #6c757d;"></i> Filtros de Busca
            </h3>
            <form class="filter-bar" method="get" action="<?= base_url('admin/dispositivos') ?>" style="display: flex; gap: 15px; flex-wrap: wrap; align-items: flex-end;">
                
                <div class="form-group" style="flex: 3; min-width: 250px; display: flex; flex-direction: column; gap: 5px;">
                    <label style="font-size: 0.9rem; font-weight: bold; color: #444;">Buscar por Nome / Descrição</label>
                    <div style="position: relative; width: 100%;">
                        <input type="text" class="form-control" name="busca" placeholder="Ex: Sensor Alpha..." value="<?= esc($filtro_valores['busca'] ?? '') ?>" style="width: 100%; padding: 10px 40px 10px 12px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px;">
                        <i class="fa-solid fa-magnifying-glass" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #888;"></i>
                    </div>
                </div>

                <div class="form-group" style="flex: 2; min-width: 200px; display: flex; flex-direction: column; gap: 5px;">
                    <label style="font-size: 0.9rem; font-weight: bold; color: #444;">Dono / Proprietário</label>
                    <select class="form-control" name="dono_id" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px; background-color: #fff;">
                        <option value="todos" <?= (isset($filtro_valores['dono_id']) && $filtro_valores['dono_id'] == 'todos') ? 'selected' : '' ?>>Todos os Proprietários</option>
                        <?php if (!empty($usuarios_disponiveis)): ?>
                            <?php foreach ($usuarios_disponiveis as $usu): ?>
                                <option value="<?= $usu['USU_ID'] ?>" <?= (isset($filtro_valores['dono_id']) && $filtro_valores['dono_id'] == $usu['USU_ID']) ? 'selected' : '' ?>>
                                    <?= esc($usu['USU_NOME']) ?>
                                </option>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </select>
                </div>

                <div class="form-group" style="flex: 1; min-width: 150px; display: flex; flex-direction: column; gap: 5px;">
                    <label style="font-size: 0.9rem; font-weight: bold; color: #444;">Status</label>
                    <select class="form-control" name="status_filtro" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px; background-color: #fff;">
                        <option value="todos" <?= (isset($filtro_valores['status_filtro']) && $filtro_valores['status_filtro'] == 'todos') ? 'selected' : '' ?>>Todos os Status</option>
                        <option value="ativo" <?= (isset($filtro_valores['status_filtro']) && $filtro_valores['status_filtro'] == 'ativo') ? 'selected' : '' ?>>Ativo</option>
                        <option value="alerta" <?= (isset($filtro_valores['status_filtro']) && $filtro_valores['status_filtro'] == 'alerta') ? 'selected' : '' ?>>Alerta</option>
                        <option value="inativo" <?= (isset($filtro_valores['status_filtro']) && $filtro_valores['status_filtro'] == 'inativo') ? 'selected' : '' ?>>Inativo</option>
                    </select>
                </div>

                <div class="form-group" style="flex: 0 0 auto; display: flex; gap: 8px;">
                    <button type="submit" class="btn-submit" style="height: 42px; padding: 0 20px; background-color: #00a65a; color: #fff; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; display: flex; align-items: center; gap: 8px;">
                        Filtrar
                    </button>
                    
                    <?php if (!empty($filtro_valores['busca']) || (isset($filtro_valores['dono_id']) && $filtro_valores['dono_id'] !== 'todos') || (isset($filtro_valores['status_filtro']) && $filtro_valores['status_filtro'] !== 'todos')): ?>
                        <a href="<?= base_url('admin/dispositivos') ?>" style="display: flex; align-items: center; justify-content: center; height: 42px; width: 42px; border: 1px solid #ccc; border-radius: 6px; background: #f5f5f5; color: #333; text-decoration: none;" title="Limpar Filtros">
                            <i class="fa-solid fa-xmark"></i>
                        </a>
                    <?php endif; ?>
                </div>
            </form>
        </div>

        <div class="table-responsive">
            <table class="data-table" style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nome do Dispositivo</th>
                        <th>Localização / Tanque</th>
                        <th>Última Telemetria</th>
                        <th>Status</th>
                        <th style="text-align: center;">Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($dispositivos) && is_array($dispositivos)): ?>
                        <?php foreach ($dispositivos as $disp): ?>
                            <tr>
                                <td>#<?= str_pad($disp['DIS_ID'], 3, '0', STR_PAD_LEFT) ?></td>
                                <td><strong><?= esc($disp['DIS_NOME']) ?></strong></td>
                                <td>
                                    <?= esc($disp['DIS_DESCRICAO'] ?: 'Sem descrição informada') ?>
                                    <br>
                                    <small style="color: #888;">
                                        <i class="fa-solid fa-user"></i> Dono: <?= esc($disp['dono_nome'] ?? 'Não vinculado') ?>
                                    </small>
                                </td>
                                <td>
                                    <?= esc($disp['DIS_NIVEL_TANQUE']) ?>% (<?= number_format(($disp['DIS_NIVEL_TANQUE'] * 0.147), 1, ',', '.') ?>L)
                                </td>
                                <td>
                                    <?php if (strtoupper($disp['DIS_STATUS']) === 'ATIVO'): ?>
                                        <span class="status-badge badge-green">Ativo</span>
                                    <?php else: ?>
                                        <span class="status-badge badge-red">Inativo</span>
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <div class="actions-cell">
                                        <a href="<?= base_url('admin/dispositivos/novo/' . $disp['DIS_ID']) ?>" class="btn-icon btn-edit" title="Editar" style="text-decoration: none;">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>
                                        
                                        <a href="#" 
                                           class="btn-icon btn-delete btn-deletar-custom" 
                                           title="Excluir" 
                                           style="text-decoration: none;"
                                           data-url="<?= base_url('admin/dispositivos/excluir/' . $disp['DIS_ID']) ?>" 
                                           data-nome="<?= esc($disp['DIS_NOME']) ?>">
                                            <i class="fa-solid fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="6" style="text-align: center; color: #999; padding: 40px 20px;">
                                <div style="margin-bottom: 10px;">
                                    <i class="fa-solid fa-folder-open" style="font-size: 1.5rem; color: #adb5bd;"></i>
                                </div>
                                Nenhum dispositivo encontrado.
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
    // ---------------- LÓGICA DOS GRÁFICOS ----------------
    <?php if (!empty($dispositivos)): ?>
    
    // 1. Criamos o plugin que vai desenhar o ícone no centro do gráfico
const centroIconePlugin = {
    id: 'centroIcone',
    afterDraw: function(chart) {
        if (chart.config.options.plugins.centroIcone) {
            const ctx = chart.ctx;
            const options = chart.config.options.plugins.centroIcone;
            
            // Ativa o plugin apenas se configurado
            if (options.exibir) {
                ctx.save();
                
                // Encontra o centro exato da rosca
                const xCentro = (chart.chartArea.left + chart.chartArea.right) / 2;
                const yCentro = (chart.chartArea.top + chart.chartArea.bottom) / 2;
                
                ctx.textAlign = 'center';
                ctx.textBaseline = 'middle';
                
                // Configura o estilo do ícone (Tamanho e Fonte)
                // Procure por esta linha dentro do "afterDraw" do seu plugin e mude para:
                ctx.font = `900 ${options.tamanho || '24px'} "${options.fonte || 'Font Awesome 6 Free'}"`;
                ctx.fillStyle = options.cor || '#1e3c72'; // Cor do ícone
                
                // Desenha o caractere/ícone bem no meio
                ctx.fillText(options.icone, xCentro, yCentro);
                
                ctx.restore();
            }
        }
    }
};

// 2. Inicialização do Gráfico de Status com o Plugin Ativado
const ctxStatus = document.getElementById('chartStatus').getContext('2d');

new Chart(ctxStatus, {
    type: 'doughnut',
    plugins: [centroIconePlugin], // <--- Registra o plugin aqui dentro!
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
            // CONFIGURAÇÃO PERSONALIZADA DO SEU ÍCONE
        centroIcone: {
            exibir: true,
            icone: '\uf2db',             // Código do microchip/hardware
            tamanho: '28px', 
            cor: '#475569', 
            fonte: 'Font Awesome 6 Free' // Mantém a família que você descobriu
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
                titleFont: { size: 13 },
                bodyFont: { size: 12 },
                padding: 10,
                cornerRadius: 6,
                displayColors: false
            }
        }
    }
});

    // Configuração do Gráfico de Nível dos Tanques (Barras)
    // Configuração do Gráfico de Nível dos Tanques (Barras Dinâmicas e Ordenadas)
const ctxTanques = document.getElementById('chartTanques').getContext('2d');

// 1. Pegamos os dados originais vindos do PHP
const dadosOriginais = <?= json_encode($grafico_tanques) ?>;

// 2. Juntamos as labels e valores em um array de objetos para conseguir ordenar
let listaTanques = [];
if (dadosOriginais && dadosOriginais.labels) {
    for (let i = 0; i < dadosOriginais.labels.length; i++) {
        listaTanques.push({
            nome: dadosOriginais.labels[i],
            nivel: parseFloat(dadosOriginais.valores[i])
        });
    }
}

// 3. Ordena a lista em ordem CRESCENTE (menor nível para o maior)
listaTanques.sort((a, b) => a.nivel - b.nivel);

// 4. Separa novamente em arrays para o Chart.js usar
const labelsOrdenadas = listaTanques.map(item => item.nome);
const valoresOrdenados = listaTanques.map(item => item.nivel);

// 5. Renderiza o gráfico com as regras visuais personalizadas
new Chart(ctxTanques, {
    type: 'bar',
    data: {
        labels: labelsOrdenadas,
        datasets: [{
            label: 'Nível Atual',
            data: valoresOrdenados,
            borderWidth: 1.5,
            borderRadius: 6, // Deixa o topo das barras arredondado e moderno
            borderSkipped: 'start',
            
            // FUNÇÃO DE COR CONDICIONAL (Roda para cada barra individualmente)
            backgroundColor: function(context) {
                const value = context.dataset.data[context.dataIndex];
                if (value < 30) {
                    return 'rgba(211, 47, 47, 0.85)';  // Vermelho Crítico (< 30%)
                } else if (value <= 50) {
                    return 'rgba(245, 124, 0, 0.85)';  // Laranja/Amarelo Atenção (30% a 50%)
                } else {
                    return 'rgba(30, 136, 229, 0.85)';  // Azul Seguro (> 50%)
                }
            },
            borderColor: function(context) {
                const value = context.dataset.data[context.dataIndex];
                if (value < 30) {
                    return '#d32f2f';
                } else if (value <= 50) {
                    return '#f57c00';
                } else {
                    return '#1e88e5';
                }
            },
            // Efeito visual ao passar o mouse por cima
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
            legend: { display: false }, // Remove aquela legenda redundante do topo
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
                grid: {
                    color: '#f1f3f5' // Linhas horizontais bem sutis de fundo
                },
                ticks: {
                    callback: function(value) { return value + '%'; },
                    font: { size: 11, family: 'Arial' }
                }
            },
            x: {
                grid: { display: false }, // Remove as linhas verticais para limpar o visual
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

    // ---------------- LÓGICA DE EXCLUSÃO (SWAL) ----------------
    const botoesExcluir = document.querySelectorAll('.btn-deletar-custom');
    botoesExcluir.forEach(botao => {
        botao.addEventListener('click', function(e) {
            e.preventDefault();
            const urlExclusao = this.getAttribute('data-url');
            const nomeDispositivo = this.getAttribute('data-nome');

            Swal.fire({
                title: 'Tem certeza?',
                text: `Você está prestes a remover o dispositivo "${nomeDispositivo}". Esta ação não pode ser desfeita!`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: '<i class="fa-solid fa-trash"></i> Sim, deletar!',
                cancelButtonText: 'Cancelar',
                background: '#fff',
                borderRadius: '8px'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = urlExclusao;
                }
            });
        });
    });
});
</script>