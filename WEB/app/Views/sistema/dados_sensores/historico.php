<?= view("sistema/layout/dashboard/usuario/header") ?>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.6.0/jspdf.plugin.autotable.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<main class="main-content">
    <header class="top-nav">
        <div class="nav-left">
            <button class="menu-btn"><i class="fa-solid fa-bars"></i></button>
            <h2><?= esc($titulo) ?></h2>
        </div>
    </header>

    <div class="widget form-widget full-width-form ignore-pdf" style="margin-bottom: 20px;">
        <h3 class="form-title" style="margin-bottom: 15px; font-size: 1.1rem;">
            <i class="fa-solid fa-filter" style="color: #6c757d;"></i> Filtros de Busca
        </h3>
        
        <form class="filter-bar" method="get" action="<?= base_url('dados_sensores') ?>">
            <div class="form-group">
                <label>Data Inicial</label>
                <input type="date" class="form-control" name="data_inicial" value="<?= esc($filtro_valores['data_inicial'] ?? '') ?>">
            </div>

            <div class="form-group">
                <label>Data Final</label>
                <input type="date" class="form-control" name="data_final" value="<?= esc($filtro_valores['data_final'] ?? '') ?>">
            </div>

            <div class="form-group">
                <label>Temperatura Acima de (°C)</label>
                <input type="number" class="form-control" name="temp_min" placeholder="Ex: 25" min="0" max="100" value="<?= esc($filtro_valores['temp_min'] ?? '') ?>">
            </div>

            <div class="form-group">
                <label>Umidade Abaixo de (%)</label>
                <input type="number" class="form-control" name="umidade_max" placeholder="Ex: 40" min="0" max="100" value="<?= esc($filtro_valores['umidade_max'] ?? '') ?>">
            </div>

            <div class="form-group">
                <label>Classificação da Umidade</label>
                <?php $statusAtual = $filtro_valores['status_filtro'] ?? 'todos'; ?>
                <select class="form-control" name="status_filtro">
                    <option value="todos" <?= $statusAtual === 'todos' ? 'selected' : '' ?>>Todos</option>
                    <option value="otimo" <?= $statusAtual === 'otimo' ? 'selected' : '' ?>>Ótimo (>70%)</option>
                    <option value="bom" <?= $statusAtual === 'bom' ? 'selected' : '' ?>>Bom (40% - 70%)</option>
                    <option value="ruim" <?= $statusAtual === 'ruim' ? 'selected' : '' ?>>Ruim (<40%)</option>
                </select>
            </div>

            <div class="form-group" style="display: flex; align-items: flex-end;">
                <button type="submit" class="btn-submit" style="width: 100%; margin: 0; padding: 12px; background-color: #00a65a; border: none; color: white; cursor: pointer; font-weight: bold; border-radius: 4px;">
                    <i class="fa-solid fa-magnifying-glass"></i> Filtrar
                </button>
            </div>
        </form>
    </div>

    <div class="widget form-widget full-width-form ignore-pdf" style="margin-bottom: 20px; background: #fff; border-radius: 8px; padding: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
        <h3 class="form-title" style="margin-bottom: 15px; font-size: 1.1rem; color: #1e3c72;">
            <i class="fa-solid fa-chart-area"></i> Comportamento do Ambiente (Médias Diárias)
        </h3>
        <div style="width: 100%; max-height: 280px; height: 280px;">
            <canvas id="chartMedicoesAmbiente"></canvas>
        </div>
    </div>

    <div id="area-impressao" class="widget form-widget full-width-form">
        <div class="form-header-flex" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px;">
            <h3 class="form-title" style="margin: 0;">
                <i class="fa-solid fa-clipboard-list" style="color: #1e3c72;"></i> Registros dos Sensores (ESP32)
            </h3>
            <div class="actions-wrapper" style="display: flex; gap: 10px;">
                <button id="btn-exportar-excel" class="ignore-pdf" style="margin: 0; padding: 8px 15px; background-color: #1f7246; border: none; color: white; cursor: pointer; font-weight: bold; border-radius: 4px;">
                    <i class="fa-solid fa-file-excel"></i> Exportar Excel (.xlsx)
                </button>
                <button id="btn-exportar-pdf" class="btn-cancelar ignore-pdf" style="margin: 0;"><i class="fa-solid fa-download"></i> Exportar PDF</button>
            </div>
        </div>
        <hr class="divider">
        
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Data e Hora</th>
                        <th>Sensor / Área</th>
                        <th>Temperatura</th>
                        <th>Umidade Coletada</th>
                        <th style="text-align: center;" class="actions-cell">Status / Saúde</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($medicoes) && is_array($medicoes)): ?>
                        <?php foreach ($medicoes as $medicao): ?>
                            <tr>
                                <td>
                                    <strong>
                                        <?= date('d/m/Y', strtotime($medicao['DDS_DATA'])) ?> - <?= date('H:i', strtotime($medicao['DDS_HORA'])) ?>
                                    </strong>
                                </td>
                                <td><?= esc($medicao['nome_sensor'] ?? 'Sensor #' . $medicao['FK_SEN_ID']) ?></td>
                                <td><?= esc($medicao['DDS_TEMP'] ?? '0') ?> °C</td>
                                <td><?= esc($medicao['DDS_UMIDADE'] ?? '0') ?> %</td>
                                
                                <td style="text-align: center;" class="actions-cell">
                                    <?php 
                                    $umidade = (float)($medicao['DDS_UMIDADE'] ?? 0);
                                    
                                    if ($umidade < 40.00): ?>
                                        <span class="status-badge badge-red" style="background-color: #f8d7da; color: #721c24; padding: 6px 12px; border-radius: 4px; font-weight: bold; display: inline-block; min-width: 70px;">Ruim</span>
                                    <?php elseif ($umidade <= 70.00): ?>
                                        <span class="status-badge badge-yellow" style="background-color: #fff3cd; color: #856404; padding: 6px 12px; border-radius: 4px; font-weight: bold; display: inline-block; min-width: 70px;">Bom</span>
                                    <?php else: ?>
                                        <span class="status-badge badge-green" style="background-color: #d4edda; color: #155724; padding: 6px 12px; border-radius: 4px; font-weight: bold; display: inline-block; min-width: 70px;">Ótimo</span>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="5" class="text-center text-muted" style="padding: 20px; text-align: center;">Nenhuma medição encontrada para os seus dispositivos.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</main>

<script>
document.addEventListener("DOMContentLoaded", function() {
    
    // ==========================================
    // 1. PROCESSAMENTO E RENDERIZAÇÃO DO GRÁFICO
    // ==========================================
    const dadosBrutos = <?= json_encode($dados_grafico ?? ['labels' => [], 'temperaturas' => [], 'umidades' => []]) ?>;
    const ctx = document.getElementById('chartMedicoesAmbiente');
    
    if (ctx) {
        const ctx2d = ctx.getContext('2d');
        
        const gradienteUmid = ctx2d.createLinearGradient(0, 0, 0, 240);
        gradienteUmid.addColorStop(0, 'rgba(2, 132, 199, 0.25)');
        gradienteUmid.addColorStop(1, 'rgba(2, 132, 199, 0.00)');

        const gradienteTemp = ctx2d.createLinearGradient(0, 0, 0, 240);
        gradienteTemp.addColorStop(0, 'rgba(255, 107, 107, 0.15)');
        gradienteTemp.addColorStop(1, 'rgba(255, 107, 107, 0.00)');
        
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: dadosBrutos.labels.length ? dadosBrutos.labels : ['Sem dados'],
                datasets: [
                    {
                        label: 'Temperatura (°C)',
                        data: dadosBrutos.temperaturas.length ? dadosBrutos.temperaturas : [0],
                        borderColor: '#ff6b6b',
                        backgroundColor: gradienteTemp,
                        borderWidth: 3,
                        pointBackgroundColor: '#ff6b6b',
                        pointBorderColor: '#ffffff',
                        pointBorderWidth: 2,
                        pointRadius: 4, // CORRIGIDO: Era 0, agora pontos isolados são visíveis!
                        pointHoverRadius: 6,
                        fill: true,
                        yAxisID: 'yTemp',
                        tension: 0.35
                    },
                    {
                        label: 'Umidade (%)',
                        data: dadosBrutos.umidades.length ? dadosBrutos.umidades : [0],
                        borderColor: '#0284c7',
                        backgroundColor: gradienteUmid,
                        borderWidth: 3,
                        pointBackgroundColor: '#0284c7',
                        pointBorderColor: '#ffffff',
                        pointBorderWidth: 2,
                        pointRadius: 4, // CORRIGIDO: Era 0, agora pontos isolados são visíveis!
                        pointHoverRadius: 6,
                        fill: true,
                        yAxisID: 'yUmid',
                        tension: 0.35
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                        labels: {
                            usePointStyle: true,
                            pointStyle: 'circle',
                            padding: 20,
                            font: { size: 12, family: 'Inter, sans-serif', weight: '500' }
                        }
                    },
                    tooltip: {
                        backgroundColor: '#1e293b',
                        titleFont: { size: 13, weight: '600' },
                        bodyFont: { size: 12 },
                        padding: 12,
                        cornerRadius: 6,
                        displayColors: true
                    }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: {
                            font: { size: 11, family: 'Inter, sans-serif' },
                            color: '#64748b'
                        }
                    },
                    yTemp: {
                        type: 'linear',
                        position: 'left',
                        beginAtZero: false,
                        grid: { color: 'rgba(226, 232, 240, 0.6)' },
                        ticks: {
                            color: '#ff6b6b',
                            font: { weight: '600' },
                            callback: function(val) { return val + ' °C'; }
                        }
                    },
                    yUmid: {
                        type: 'linear',
                        position: 'right',
                        min: 0,
                        max: 100,
                        grid: { drawOnChartArea: false },
                        ticks: {
                            color: '#0284c7',
                            font: { weight: '600' },
                            callback: function(val) { return val + ' %'; }
                        }
                    }
                }
            }
        });
    }

    // ==========================================
    // 2. EXPORTAÇÃO PARA PDF (jsPDF + AutoTable)
    // ==========================================
    const btnExportarPdf = document.getElementById("btn-exportar-pdf");
    const areaParaExportar = document.getElementById("area-impressao");

    if (btnExportarPdf && areaParaExportar) {
        btnExportarPdf.addEventListener("click", function(e) {
            e.preventDefault();
            
            const textoOriginal = btnExportarPdf.innerHTML;
            btnExportarPdf.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Gerando PDF...';

            try {
                const { jsPDF } = window.jspdf;
                const doc = new jsPDF({ orientation: 'landscape', unit: 'mm', format: 'a4' });

                const tabelaOriginal = areaParaExportar.querySelector(".data-table");
                if (!tabelaOriginal) {
                    alert("Erro: Tabela de dados não encontrada.");
                    btnExportarPdf.innerHTML = textoOriginal;
                    return;
                }

                const cloneTabela = tabelaOriginal.cloneNode(true);

                doc.autoTable({
                    html: cloneTabela,
                    startY: 32, 
                    theme: 'striped',
                    headStyles: { 
                        fillColor: [30, 60, 114],
                        textColor: [255, 255, 255], 
                        fontStyle: 'bold',
                        fontSize: 10,
                        halign: 'left',
                        valign: 'middle',
                        cellPadding: 4
                    },
                    bodyStyles: { 
                        textColor: [60, 66, 82], 
                        fontSize: 9,
                        valign: 'middle',
                        cellPadding: 4
                    },
                    alternateRowStyles: {
                        fillColor: [248, 249, 250] 
                    },
                    tableLineColor: [222, 226, 230], 
                    tableLineWidth: 0.2,
                    margin: { top: 32, right: 15, bottom: 20, left: 15 },
                    
                    didDrawPage: function(data) {
                        doc.setFillColor(30, 60, 114);
                        doc.rect(15, 10, 267, 14, 'F');
                        
                        doc.setTextColor(255, 255, 255);
                        doc.setFont("helvetica", "bold");
                        doc.setFontSize(12);
                        doc.text("SISTEMA DE IRRIGAÇÃO - REGISTROS DOS SENSORES (ESP32)", 20, 18.5);

                        doc.setFont("helvetica", "normal");
                        doc.setFontSize(9);
                        const dataHoje = new Date().toLocaleDateString('pt-BR');
                        doc.text("Gerado em: " + dataHoje, 242, 18.5);

                        doc.setDrawColor(222, 226, 230);
                        doc.setLineWidth(0.3);
                        doc.line(15, 195, 282, 195); 

                        doc.setTextColor(108, 117, 125);
                        doc.setFontSize(9);
                        doc.text("Relatório de Monitoramento de Sensores Automático", 15, 201);
                        
                        doc.text("Página " + data.pageNumber, 265, 201);
                    }
                });

                doc.save('registros_sensores.pdf');
            } catch (error) {
                console.error("Erro ao gerar PDF:", error);
                alert("Ocorreu um erro ao exportar o PDF.");
            } finally {
                btnExportarPdf.innerHTML = textoOriginal;
            }
        });
    }

    // ==========================================
    // 3. EXPORTAÇÃO PARA EXCEL (SheetJS)
    // ==========================================
    const btnExportarExcel = document.getElementById("btn-exportar-excel");

    if (btnExportarExcel) {
        btnExportarExcel.addEventListener("click", function(e) {
            e.preventDefault();

            const tabela = document.querySelector(".data-table");
            if (!tabela) return;

            const planilha = XLSX.utils.table_to_sheet(tabela);

            const largurasColunas = [
                { wch: 22 }, // Data e Hora
                { wch: 25 }, // Sensor / Área
                { wch: 15 }, // Temperatura
                { wch: 18 }, // Umidade Coletada
                { wch: 15 }  // Status / Saúde
            ];
            planilha['!cols'] = largurasColunas; // CORRIGIDO: Estava 'planirha' com 'r'

            const pastaTrabalho = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(pastaTrabalho, planilha, "Dados do ESP32");

            XLSX.writeFile(pastaTrabalho, "registros_sensores.xlsx");
        });
    }
});
</script>