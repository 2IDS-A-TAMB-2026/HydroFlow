<?= view("sistema/layout/dashboard/usuario/header") ?>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>

<div class="widget form-widget full-width-form" style="margin-bottom: 20px;">
    <h3 class="form-title" style="margin-bottom: 15px; font-size: 1.1rem;">
        <i class="fa-solid fa-filter" style="color: #6c757d;"></i> Filtros de Busca
    </h3>
    <form class="filter-bar" method="get" action="<?= base_url('historico') ?>">
        <div class="form-group">
            <label>Data Inicial</label>
            <input type="date" class="form-control" name="data_inicial" value="<?= esc($filtro_valores['data_inicial'] ?? '') ?>">
        </div>
        <div class="form-group">
            <label>Data Final</label>
            <input type="date" class="form-control" name="data_final" value="<?= esc($filtro_valores['data_final'] ?? '') ?>">
        </div>
        <div class="form-group">
            <label>Setor / Área</label>
            <?php $setor = $filtro_valores['setor_filtro'] ?? 'todos'; ?>
            <select class="form-control" name="setor_filtro">
                <option value="todos" <?= $setor == 'todos' ? 'selected' : '' ?>>Todos os Setores</option>
                <?php if (!empty($lista_plantas) && is_array($lista_plantas)): ?>
                    <?php foreach ($lista_plantas as $planta): ?>
                        <option value="<?= $planta['PLANTA_ID'] ?>" <?= $setor == $planta['PLANTA_ID'] ? 'selected' : '' ?>>
                            <?= esc($planta['PLANTA_NOME']) ?> (<?= esc($planta['PLANTA_CULTURA'] ?? 'Geral') ?>)
                        </option>
                    <?php endforeach; ?>
                <?php endif; ?>
            </select>
        </div>
        <div class="form-group">
            <label>Status</label>
            <?php $status = $filtro_valores['status_filtro'] ?? 'todos'; ?>
            <select class="form-control" name="status_filtro">
                <option value="todos" <?= $status == 'todos' ? 'selected' : '' ?>>Todos</option>
                <option value="Concluído" <?= $status == 'Concluído' ? 'selected' : '' ?>>Concluído</option>
                <option value="Falha" <?= $status == 'Falha' ? 'selected' : '' ?>>Falha</option>
                <option value="Interrompido" <?= $status == 'Interrompido' ? 'selected' : '' ?>>Interrompido</option>
            </select>
        </div>
        <div class="form-group" style="display: flex; align-items: flex-end;">
            <button type="submit" class="btn-submit" style="width: 100%; margin: 0; padding: 12px;">
                <i class="fa-solid fa-magnifying-glass"></i> Filtrar
            </button>
        </div>
    </form>
</div>

<div class="widget form-widget full-width-form" style="margin-bottom: 20px; background: #fff; border-radius: 8px; padding: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
    <h3 class="form-title" style="margin-bottom: 15px; font-size: 1.1rem; color: #1e3c72;">
        <i class="fa-solid fa-chart-line"></i> Consumo de Água no Período (Litros)
    </h3>
    <div style="width: 100%; max-height: 280px;">
        <canvas id="chartHistoricoConsumo"></canvas>
    </div>
</div>

<div class="widget form-widget full-width-form">
    <div class="form-header-flex" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px;">
        <h3 class="form-title" style="margin: 0;">
            <i class="fa-solid fa-clipboard-list" style="color: #1e3c72;"></i> Registros de Irrigação
        </h3>
        <div class="actions-wrapper" style="display: flex; gap: 10px;">
            <button id="btn-exportar-excel" style="margin: 0; padding: 8px 15px; background-color: #1f7246; border: none; color: white; cursor: pointer; font-weight: bold; border-radius: 4px; display: flex; align-items: center; gap: 6px;">
                <i class="fa-solid fa-file-excel"></i> Exportar Excel
            </button>
            <button id="btn-exportar" class="btn-cancelar" style="margin: 0;">
                <i class="fa-solid fa-download"></i> Exportar PDF
            </button>
        </div>
    </div>
    <hr class="divider">
    
    <div class="table-responsive" id="tabela-historico">
        <table class="data-table">
            <thead>
                <tr>
                    <th>Data e Hora</th>
                    <th>Setor / Cultura</th>
                    <th>Duração</th>
                    <th>Volume Estimado</th>
                    <th>Acionamento</th>
                    <th style="text-align: center;">Status</th>
                </tr>
            </thead>
            <tbody>
                <?php if (!empty($irrigacoes) && is_array($irrigacoes)): ?>
                    <?php foreach ($irrigacoes as $item): ?>
                        <tr>
                            <td>
                                <strong>
                                    <?= date('d/m/Y', strtotime($item['IRR_DATA'])) ?> - <?= date('H:i', strtotime($item['IRR_HORA'])) ?>
                                </strong>
                            </td>
                            <td><?= esc($item['nome_planta']) ?> (<?= esc($item['cultura'] ?? 'Geral') ?>)</td>
                            <td><?= esc($item['IRR_DURACAO']) ?> min</td>
                            <td><?= esc($item['IRR_VOLUME'] ?? '0.00') ?> Litros</td>
                            <td>
                                <?php if ($item['IRR_ACIONAMENTO'] === 'Automático'): ?>
                                    <i class="fa-solid fa-robot" title="Automático"></i> Automático
                                <?php else: ?>
                                    <i class="fa-solid fa-hand-pointer" title="Manual"></i> Manual
                                <?php endif; ?>
                            </td>
                            <td style="text-align: center;">
                                <?php 
                                    $badge = 'badge-green';
                                    if ($item['IRR_STATUS'] === 'Falha') $badge = 'badge-red';
                                    if ($item['IRR_STATUS'] === 'Interrompido') $badge = 'badge-yellow';
                                ?>
                                <span class="status-badge <?= $badge ?>"><?= esc($item['IRR_STATUS']) ?></span>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                <?php else: ?>
                    <tr>
                        <td colspan="6" style="text-align: center; color: #888; padding: 30px;">
                            <i class="fa-regular fa-folder-open" style="font-size: 24px; display: block; margin-bottom: 10px;"></i>
                            Nenhum registro de irrigação encontrado para os filtros selecionados.
                        </td>
                    </tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>
</main>
</div>
</body>

<script>
document.addEventListener("DOMContentLoaded", function() {
    // ==========================================
    // RENDERIZAÇÃO ORIGINAL DO GRÁFICO (Inalterado)
    // ==========================================
    const dadosGrafico = <?= json_encode($dados_grafico ?? ['labels' => [], 'valores' => []]) ?>;
    
    new Chart(document.getElementById('chartHistoricoConsumo'), {
        type: 'line',
        data: {
            labels: dadosGrafico.labels.length ? dadosGrafico.labels : ['Sem dados'],
            datasets: [{
                label: 'Consumo diário (Litros)',
                data: dadosGrafico.valores.length ? dadosGrafico.valores : [0],
                borderColor: '#1e3c72',
                backgroundColor: 'rgba(30, 60, 114, 0.1)',
                borderWidth: 3,
                fill: true,
                tension: 0.3, 
                pointBackgroundColor: '#00a65a',
                pointBorderColor: '#fff',
                pointRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) { return value + ' L'; }
                    }
                }
            }
        }
    });

    // ==========================================
    // BASE ATUALIZADA: EXPORTAÇÃO PARA PDF (jsPDF + AutoTable)
    // ==========================================
    const botaoExportar = document.getElementById("btn-exportar");
    const areaParaExportar = document.getElementById("tabela-historico");

    if (botaoExportar && areaParaExportar) {
        botaoExportar.addEventListener("click", function(e) {
            e.preventDefault();
            
            const textoOriginal = botaoExportar.innerHTML;
            botaoExportar.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Gerando PDF...';

            try {
                const { jsPDF } = window.jspdf;
                const doc = new jsPDF({ orientation: 'landscape', unit: 'mm', format: 'a4' });

                const tabelaOriginal = areaParaExportar.querySelector(".data-table");
                if (!tabelaOriginal) {
                    alert("Erro: Tabela de dados não encontrada.");
                    botaoExportar.innerHTML = textoOriginal;
                    return;
                }

                // Cria o clone limpo para alimentar a API
                const cloneTabela = tabelaOriginal.cloneNode(true);
                cloneTabela.querySelectorAll('.actions-cell').forEach(el => el.remove());

                doc.autoTable({
                    html: cloneTabela,
                    startY: 32, // Espaço ideal abaixo do cabeçalho
                    theme: 'striped',
                    headStyles: { 
                        fillColor: [30, 60, 114], // Azul #1e3c72
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
                        // ---- 1. CABEÇALHO PADRONIZADO ----
                        // Desenha a Faixa Azul do Topo (#1e3c72)
                        doc.setFillColor(30, 60, 114);
                        doc.rect(15, 10, 267, 14, 'F');
                        
                        // Força texto branco para o título do relatório
                        doc.setTextColor(255, 255, 255);
                        doc.setFont("helvetica", "bold");
                        doc.setFontSize(12);
                        doc.text("SISTEMA DE IRRIGAÇÃO - HISTÓRICO DE IRRIGAÇÃO", 20, 18.5);

                        // Data de emissão no lado direito da faixa azul
                        doc.setFont("helvetica", "normal");
                        doc.setFontSize(9);
                        const dataHoje = new Date().toLocaleDateString('pt-BR');
                        doc.text("Gerado em: " + dataHoje, 242, 18.5);

                        // ---- 2. RODAPÉ ----
                        doc.setDrawColor(222, 226, 230);
                        doc.setLineWidth(0.3);
                        doc.line(15, 195, 282, 195); 

                        // Texto de rodapé com contraste escuro
                        doc.setTextColor(108, 117, 125);
                        doc.setFontSize(8);
                        doc.text("Relatório Administrativo - Uso Interno", 15, 201);
                        
                        const textoPagina = "Página " + data.pageNumber;
                        doc.text(textoPagina, 270, 201);
                    },
                    didParseCell: function(data) {
                        // Limpa espaços extras capturados das células HTML
                        if (data.cell.element) {
                            data.cell.text = [data.cell.element.innerText.trim()];
                        }
                    }
                });

                // Baixa o arquivo final correto
                doc.save('historico_irrigacao.pdf');
                botaoExportar.innerHTML = textoOriginal;

            } catch (erro) {
                console.error("Erro no jsPDF AutoTable:", erro);
                alert("Falha ao estilizar o PDF.");
                botaoExportar.innerHTML = textoOriginal;
            }
        });
    }

    // ==========================================
    // NOVA ROTINA: EXPORTAR PARA EXCEL (SheetJS)
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
                { wch: 30 }, // Setor / Cultura
                { wch: 12 }, // Duração
                { wch: 18 }, // Volume Estimado
                { wch: 16 }, // Acionamento
                { wch: 14 }  // Status
            ];
            planilha['!cols'] = largurasColunas;

            const pastaTrabalho = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(pastaTrabalho, planilha, "Histórico");

            XLSX.writeFile(pastaTrabalho, "historico_irrigacao.xlsx");
        });
    }
});
</script>
</html>