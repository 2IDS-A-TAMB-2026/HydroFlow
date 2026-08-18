<?= view("sistema/layout/dashboard/usuario/header") ?>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<?php if (session()->getFlashdata('sucesso')): ?>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            Swal.fire({ title: 'Sucesso!', text: '<?= session()->getFlashdata('sucesso') ?>', icon: 'success', confirmButtonColor: '#00a65a', timer: 3000 });
        });
    </script>
<?php endif; ?>

<main class="main-content">
    <div class="widget form-widget full-width-form">
        <div class="form-header-flex">
            <h3 class="form-title">
                <i class="fa-solid fa-list" style="color: #1e3c72;"></i> Plantas Cadastradas
            </h3>
            <a href="<?= base_url('planta/novo') ?>" style="text-decoration: none;">
                <button class="btn-submit" style="margin: 0; padding: 10px 20px;">
                    <i class="fa-solid fa-plus"></i> Nova Planta
                </button>
            </a>
        </div>
        <hr class="divider">

        <div style="display: flex; flex-wrap: wrap; gap: 20px; margin-bottom: 25px;">
            <div style="flex: 1; min-width: 300px; background: #fff; border: 1px solid #e9ecef; border-radius: 8px; padding: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); display: flex; flex-direction: column; align-items: center;">
                <h4 style="margin: 0 0 15px 0; color: #1e3c72; font-size: 15px; font-weight: 600; align-self: flex-start;">
                    <i class="fa-solid fa-pie-chart"></i> Variedade de Cultivo
                </h4>
                <div style="width: 100%; max-width: 240px; max-height: 240px;">
                    <canvas id="chartTipos"></canvas>
                </div>
            </div>

            <div style="flex: 1; min-width: 300px; background: #fff; border: 1px solid #e9ecef; border-radius: 8px; padding: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); display: flex; flex-direction: column; align-items: center;">
                <h4 style="margin: 0 0 15px 0; color: #1e3c72; font-size: 15px; font-weight: 600; align-self: flex-start;">
                    <i class="fa-solid fa-droplet"></i> Top Consumo de Água (L por rega)
                </h4>
                <div style="width: 100%; max-width: 100%; max-height: 240px;">
                    <canvas id="chartConsumo"></canvas>
                </div>
            </div>
        </div>

        <div style="background: #f8f9fa; border: 1px solid #e9ecef; border-radius: 8px; padding: 20px; margin-bottom: 25px;">
            <h5 style="margin-top: 0; margin-bottom: 15px; color: #495057; font-weight: 600; display: inline-flex; align-items: center; gap: 8px;">
                <i class="fa-solid fa-filter" style="color: #6c757d;"></i> Filtros de Busca Avançada
            </h5>
            <form method="GET" action="<?= base_url('planta') ?>" style="display: flex; flex-wrap: wrap; gap: 15px; align-items: flex-end;">
                <div style="flex: 1; min-width: 200px;">
                    <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #495057;">Buscar por Tipo</label>
                    <select name="filtro_tipo" class="form-control" style="width: 100%; height: 40px; border-radius: 6px; border: 1px solid #ced4da; padding: 0 10px;">
                        <option value="">Todos os Tipos</option>
                        <option value="Ornamental" <?= (($filtroTipo ?? '') == 'Ornamental') ? 'selected' : '' ?>>Ornamental</option>
                        <option value="Frutífera" <?= (($filtroTipo ?? '') == 'Frutífera') ? 'selected' : '' ?>>Frutífera</option>
                        <option value="Medicinal" <?= (($filtroTipo ?? '') == 'Medicinal') ? 'selected' : '' ?>>Medicinal</option>
                        <option value="Hortaliça" <?= (($filtroTipo ?? '') == 'Hortaliça') ? 'selected' : '' ?>>Hortaliça</option>
                    </select>
                </div>

                <div style="flex: 1; min-width: 200px;">
                    <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #495057;">Parâmetro (Irrigação)</label>
                    <select name="filtro_parametro" class="form-control" style="width: 100%; height: 40px; border-radius: 6px; border: 1px solid #ced4da; padding: 0 10px;">
                        <option value="">Todas as Periodicidades</option>
                        <option value="1" <?= (($filtroParametro ?? '') == '1') ? 'selected' : '' ?>>Regar todo dia</option>
                        <option value="2" <?= (($filtroParametro ?? '') == '2') ? 'selected' : '' ?>>A cada 2 dias</option>
                        <option value="3" <?= (($filtroParametro ?? '') == '3') ? 'selected' : '' ?>>A cada 3 dias</option>
                        <option value="5" <?= (($filtroParametro ?? '') == '5') ? 'selected' : '' ?>>A cada 5 dias</option>
                        <option value="7" <?= (($filtroParametro ?? '') == '7') ? 'selected' : '' ?>>A cada 7 dias (Semanal)</option>
                    </select>
                </div>

                <div style="flex: 1; min-width: 200px;">
                    <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #495057;">Dispositivo Responsável</label>
                    <select name="filtro_dispositivo" class="form-control" style="width: 100%; height: 40px; border-radius: 6px; border: 1px solid #ced4da; padding: 0 10px;">
                        <option value="">Todos os Dispositivos</option>
                        <?php if (!empty($dispositivos) && is_array($dispositivos)): ?>
                            <?php foreach ($dispositivos as $disp): ?>
                                <option value="<?= $disp['DIS_ID'] ?>" <?= (($filtroDispositivo ?? '') == $disp['DIS_ID']) ? 'selected' : '' ?>><?= esc($disp['DIS_NOME']) ?></option>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </select>
                </div>

                <div style="display: flex; gap: 10px;">
                    <?php if (!empty($filtroTipo) || !empty($filtroParametro) || !empty($filtroDispositivo)): ?>
                        <a href="<?= base_url('planta') ?>" class="btn-cancelar" style="margin: 0; padding: 10px 15px; height: 40px; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; background: #6c757d; color: white; border-radius: 6px;">Limpar</a>
                    <?php endif; ?>
                    <button type="submit" class="btn-submit" style="margin: 0; padding: 0 25px; height: 40px; background: #00a65a; color: white; border: none; border-radius: 6px; font-weight: 600; cursor: pointer;">Filtrar</button>
                </div>
            </form>
        </div>

        <div class="table-toolbar" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px; margin-bottom: 15px;">
            <div class="search-table" style="flex: 1; min-width: 250px;">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="input-busca-local" class="form-control" placeholder="Buscar por nome ou cultura nesta página...">
            </div>
            <div style="display: flex; gap: 10px;">
                <button id="btn-exportar-excel" style="margin: 0; padding: 8px 15px; background-color: #1f7246; border: none; color: white; cursor: pointer; font-weight: bold; border-radius: 4px; display: flex; align-items: center; gap: 6px;">
                    <i class="fa-solid fa-file-excel"></i> Exportar Excel
                </button>
                <button id="btn-exportar" class="btn-cancelar" style="margin: 0;">
                    <i class="fa-solid fa-download"></i> Exportar PDF
                </button>
            </div>
        </div>
        
        <div id="tabela-historico" class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nome da Planta</th>
                        <th>Tipo</th>
                        <th>Cultura</th>
                        <th>Parâmetros de Irrigação</th>
                        <th>Dispositivo responsável</th>
                        <th class="actions-cell" style="text-align: center;">Ações</th>
                    </tr>
                </thead>
                <tbody id="corpo-tabela-plantas">
                    <?php if (!empty($plantas) && is_array($plantas)): ?>
                        <?php foreach ($plantas as $planta): ?>
                            <tr>
                                <td><?= $planta['PLANTA_ID'] ?></td>
                                <td><strong><?= esc($planta['PLANTA_NOME']) ?></strong></td>
                                <td><?= esc($planta['PLANTA_TIPO']) ?></td>
                                <td><?= esc($planta['PLANTA_CULTURA'] ?? 'Não informada') ?></td>
                                <td><?= esc($planta['PLANTA_QTD_AGUA'] ?? '0') ?> L (a cada <?= esc($planta['PLANTA_PERIDIOCIDADE']) ?> dia(s))</td>
                                <td><?= esc($planta['DISPOSITIVO_RESPONSAVEL'] ?? 'Irrigation 1000') ?></td>
                                <td class="actions-cell" style="text-align: center;">
                                    <a href="<?= base_url('planta/editar/' . $planta['PLANTA_ID']) ?>" class="btn-icon btn-edit" title="Editar" style="display: inline-flex; align-items: center; justify-content: center; text-decoration: none;">
                                        <i class="fa-solid fa-pen"></i>
                                    </a>
                                    <button class="btn-icon btn-delete" onclick="confirmarExclusao('<?= $planta['PLANTA_ID'] ?>', '<?= esc($planta['PLANTA_NOME']) ?>')" title="Excluir">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 40px 20px; color: #6c757d;">
                                <div style="margin-bottom: 12px;"><i class="fa-solid fa-folder-open" style="font-size: 36px; color: #adb5bd;"></i></div>
                                <span style="font-size: 14px; font-weight: 400;">Nenhuma planta corresponde aos filtros aplicados.</span>
                            </td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</main>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.6.0/jspdf.plugin.autotable.min.js"></script>

<script>
document.addEventListener("DOMContentLoaded", function() {
    // ==========================================
    // 1. INICIALIZAÇÃO DOS GRÁFICOS (CHART.JS)
    // ==========================================
    const dadosTiposPHP = <?= json_encode($dadosTipos ?? []) ?>;
    const labelsTipos = dadosTiposPHP.map(item => item.tipo);
    const valoresTipos = dadosTiposPHP.map(item => item.total);

    if (document.getElementById('chartTipos')) {
        new Chart(document.getElementById('chartTipos'), {
            type: 'doughnut',
            data: {
                labels: labelsTipos.length ? labelsTipos : ['Nenhuma'],
                datasets: [{
                    data: valoresTipos.length ? valoresTipos : [1],
                    backgroundColor: ['#1e3c72', '#2a5298', '#4a74b4', '#7097d1', '#a2c2e8'],
                    borderWidth: 1
                }]
            },
            options: { responsive: true, plugins: { legend: { position: 'bottom' } } }
        });
    }

    const dadosConsumoPHP = <?= json_encode($dadosConsumo ?? []) ?>;
    const labelsConsumo = dadosConsumoPHP.map(item => item.nome);
    const valoresConsumo = dadosConsumoPHP.map(item => parseInt(item.qtd_agua));

    if (document.getElementById('chartConsumo')) {
        new Chart(document.getElementById('chartConsumo'), {
            type: 'bar',
            data: {
                labels: labelsConsumo.length ? labelsConsumo : ['Sem dados'],
                datasets: [{
                    label: 'Volume de Água (L)',
                    data: valoresConsumo.length ? valoresConsumo : [0],
                    backgroundColor: '#2a5298',
                    borderRadius: 4
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                plugins: { legend: { display: false } },
                scales: { x: { beginAtZero: true } }
            }
        });
    }

    // ==========================================
    // 2. EXPORTAÇÃO PARA PDF (CORREÇÃO DE CONTRASTE NO TOPO)
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

                const cloneTabela = tabelaOriginal.cloneNode(true);
                cloneTabela.querySelectorAll('.actions-cell').forEach(el => el.remove());

                doc.autoTable({
                    html: cloneTabela,
                    startY: 32, // Ajustado levemente para dar mais respiro abaixo do topo
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
                        // ---- 1. CABEÇALHO CORRIGIDO ----
                        // Desenha a Faixa Azul do Topo
                        doc.setFillColor(30, 60, 114);
                        doc.rect(15, 10, 267, 14, 'F');
                        
                        // O SEGREDO: Força a cor do texto para BRANCO Puro [255, 255, 255] antes de escrever o título
                        doc.setTextColor(255, 255, 255);
                        doc.setFont("helvetica", "bold");
                        doc.setFontSize(12);
                        doc.text("SISTEMA DE IRRIGAÇÃO - RELATÓRIO DE PLANTAS CADASTRADAS", 20, 18.5);

                        // Mantém em BRANCO para a data de emissão no canto direito também
                        doc.setFont("helvetica", "normal");
                        doc.setFontSize(9);
                        const dataHoje = new Date().toLocaleDateString('pt-BR');
                        doc.text("Gerado em: " + dataHoje, 242, 18.5);

                        // ---- 2. RODAPÉ ----
                        doc.setDrawColor(222, 226, 230);
                        doc.setLineWidth(0.3);
                        doc.line(15, 195, 282, 195); 

                        // Reseta a cor para cinza escuro para os textos do rodapé fora da barra
                        doc.textColor = [108, 117, 125];
                        doc.setFontSize(8);
                        doc.text("Relatório Administrativo - Uso Interno", 15, 201);
                        
                        const textoPagina = "Página " + data.pageNumber;
                        doc.text(textoPagina, 270, 201);
                    },
                    didParseCell: function(data) {
                        if (data.cell.element) {
                            data.cell.text = [data.cell.element.innerText.trim()];
                        }
                    }
                });

                doc.save('plantas_cadastradas.pdf');
                botaoExportar.innerHTML = textoOriginal;

            } catch (erro) {
                console.error("Erro no jsPDF AutoTable:", erro);
                alert("Falha ao estilizar o PDF.");
                botaoExportar.innerHTML = textoOriginal;
            }
        });
    }

    // ==========================================
    // 3. EXPORTAÇÃO PARA EXCEL (SHEETJS)
    // ==========================================
    const btnExportarExcel = document.getElementById("btn-exportar-excel");
    if (btnExportarExcel) {
        btnExportarExcel.addEventListener("click", function(e) {
            e.preventDefault();

            const tabelaOriginal = document.querySelector(".data-table");
            if (!tabelaOriginal) return;

            const tabelaClone = tabelaOriginal.cloneNode(true);
            tabelaClone.querySelectorAll('.actions-cell').forEach(el => el.remove());

            const planilha = XLSX.utils.table_to_sheet(tabelaClone);

            const largurasColunas = [
                { wch: 8 },  
                { wch: 25 }, 
                { wch: 16 }, 
                { wch: 20 }, 
                { wch: 35 }, 
                { wch: 25 }  
            ];
            planilha['!cols'] = largurasColunas;

            const pastaTrabalho = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(pastaTrabalho, planilha, "Plantas");

            XLSX.writeFile(pastaTrabalho, "plantas_cadastradas.xlsx");
        });
    }
});

// Filtro de pesquisa de tabela local
document.getElementById('input-busca-local')?.addEventListener('keyup', function() {
    const busca = this.value.toLowerCase();
    const linhas = document.querySelectorAll('#corpo-tabela-plantas tr');
    linhas.forEach(linha => {
        const texto = linha.textContent ? linha.textContent.toLowerCase() : linha.innerText.toLowerCase();
        linha.style.display = texto.includes(busca) ? '' : 'none';
    });
});

// Confirmação de exclusão SweetAlert2
function confirmarExclusao(idPlanta, nomePlanta) {
    Swal.fire({
        title: 'Tem certeza?',
        text: `Você está prestes a remover a planta "${nomePlanta}". Esta ação não pode ser desfeita!`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33', 
        cancelButtonColor: '#3085d6',
        confirmButtonText: '<i class="fa-solid fa-trash"></i> Sim, deletar!',
        cancelButtonText: 'Cancelar',
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = `<?= base_url('planta/excluir') ?>/${idPlanta}`;
        }
    });
}
</script>
</html>