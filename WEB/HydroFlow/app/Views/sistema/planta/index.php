<?= view("sistema/layout/dashboard/usuario/header") ?>

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

        <?php if (session()->getFlashdata('sucesso')): ?>
            <div style="background: #d4edda; color: #155724; border: 1px solid #c3e6cb; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; font-weight: 500;">
                <i class="fa-solid fa-circle-check"></i> <?= session()->getFlashdata('sucesso') ?>
            </div>
        <?php endif; ?>

        <?php if (session()->getFlashdata('erro')): ?>
            <div style="background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; font-weight: 500;">
                <i class="fa-solid fa-circle-xmark"></i> <?= session()->getFlashdata('erro') ?>
            </div>
        <?php endif; ?>

        <div style="background: #f8f9fa; border: 1px solid #e9ecef; border-radius: 8px; padding: 20px; margin-bottom: 25px;">
            <h5 style="margin-top: 0; margin-bottom: 15px; color: #495057; font-weight: 600; display: inline-flex; align-items: center; gap: 8px;">
                <i class="fa-solid fa-filter" style="color: #6c757d;"></i> Filtros de Busca Avançada
            </h5>
            
            <form method="GET" action="<?= base_url('planta') ?>" style="display: flex; flex-wrap: wrap; gap: 15px; align-items: flex-end;">
                
                <div style="flex: 1; min-width: 200px;">
                    <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #495057;">Buscar por Tipo</label>
                    <select name="filtro_tipo" class="form-control" style="width: 100%; height: 40px; border-radius: 6px; border: 1px solid #ced4da; padding: 0 10px;">
                        <option value="">Todos os Tipos</option>
                        <option value="Ornamental" <?= ($filtroTipo == 'Ornamental') ? 'selected' : '' ?>>Ornamental</option>
                        <option value="Frutífera" <?= ($filtroTipo == 'Frutífera') ? 'selected' : '' ?>>Frutífera</option>
                        <option value="Medicinal" <?= ($filtroTipo == 'Medicinal') ? 'selected' : '' ?>>Medicinal</option>
                        <option value="Hortaliça" <?= ($filtroTipo == 'Hortaliça') ? 'selected' : '' ?>>Hortaliça</option>
                    </select>
                </div>

                <div style="flex: 1; min-width: 200px;">
                    <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #495057;">Parâmetro (Irrigação)</label>
                    <select name="filtro_parametro" class="form-control" style="width: 100%; height: 40px; border-radius: 6px; border: 1px solid #ced4da; padding: 0 10px;">
                        <option value="">Todas as Periodicidades</option>
                        <option value="1" <?= ($filtroParametro == '1') ? 'selected' : '' ?>>Regar todo dia</option>
                        <option value="2" <?= ($filtroParametro == '2') ? 'selected' : '' ?>>A cada 2 dias</option>
                        <option value="3" <?= ($filtroParametro == '3') ? 'selected' : '' ?>>A cada 3 dias</option>
                        <option value="5" <?= ($filtroParametro == '5') ? 'selected' : '' ?>>A cada 5 dias</option>
                        <option value="7" <?= ($filtroParametro == '7') ? 'selected' : '' ?>>A cada 7 dias (Semanal)</option>
                    </select>
                </div>

                <div style="flex: 1; min-width: 200px;">
                    <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #495057;">Dispositivo Responsável</label>
                    <select name="filtro_dispositivo" class="form-control" style="width: 100%; height: 40px; border-radius: 6px; border: 1px solid #ced4da; padding: 0 10px;">
                        <option value="">Todos os Dispositivos</option>
                        <?php if (!empty($dispositivos) && is_array($dispositivos)): ?>
                            <?php foreach ($dispositivos as $disp): ?>
                                <option value="<?= $disp['DIS_ID'] ?>" <?= ($filtroDispositivo == $disp['DIS_ID']) ? 'selected' : '' ?>>
                                    <?= esc($disp['DIS_NOME']) ?>
                                </option>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </select>
                </div>

                <div style="display: flex; gap: 10px;">
                    <?php if (!empty($filtroTipo) || !empty($filtroParametro) || !empty($filtroDispositivo)): ?>
                        <a href="<?= base_url('planta') ?>" class="btn-cancelar" style="margin: 0; padding: 10px 15px; height: 40px; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; background: #6c757d; color: white; border-radius: 6px;">
                            Limpar
                        </a>
                    <?php endif; ?>
                    <button type="submit" class="btn-submit" style="margin: 0; padding: 0 25px; height: 40px; background: #00a65a; color: white; border: none; border-radius: 6px; font-weight: 600; cursor: pointer;">
                        Filtrar
                    </button>
                </div>

            </form>
        </div>

        <div class="table-toolbar">
            <div class="search-table">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="input-busca-local" class="form-control" placeholder="Buscar por nome ou cultura nesta página...">
            </div>
            <button id="btn-exportar" class="btn-cancelar" style="margin: 0;">
                <i class="fa-solid fa-download"></i> Exportar PDF
            </button>
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
                        <th style="text-align: center;">Ações</th>
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
                                <td><?= esc($planta['PLANTA_QTD_AGUA'] ?? '0') ?> ml (a cada <?= esc($planta['PLANTA_PERIDIOCIDADE']) ?> dia(s))</td>
                                <td><?= esc($planta['DISPOSITIVO_RESPONSAVEL'] ?? 'Irrigation 1000') ?></td>
                                
                                <td class="actions-cell">
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
                                <div style="margin-bottom: 12px;">
                                    <i class="fa-solid fa-folder-open" style="font-size: 36px; color: #adb5bd;"></i>
                                </div>
                                <span style="font-size: 14px; font-weight: 400;">Nenhuma planta corresponde aos filtros aplicados.</span>
                            </td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

<script>
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
        background: '#fff',
        borderRadius: '8px',
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire({
                title: 'Removendo...',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            window.location.href = `<?= base_url('planta/excluir') ?>/${idPlanta}`;
        }
    });
}

document.getElementById('input-busca-local')?.addEventListener('keyup', function() {
    const busca = this.value.toLowerCase();
    const linhas = document.querySelectorAll('#corpo-tabela-plantas tr');
    
    linhas.forEach(linha => {
        const texto = line.textContent.toLowerCase();
        linha.style.display = texto.includes(busca) ? '' : 'none';
    });
});

document.addEventListener("DOMContentLoaded", function() {
    const botaoExportar = document.getElementById("btn-exportar");
    const areaParaExportar = document.getElementById("tabela-historico");

    if(botaoExportar && areaParaExportar) {
        botaoExportar.addEventListener("click", function() {
            const textoOriginal = botaoExportar.innerHTML;
            botaoExportar.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Gerando...';

            const opcoesPDF = {
                margin: 10,
                filename: 'historico_plantas.pdf',
                image: { type: 'jpeg', quality: 0.98 },
                html2canvas: { scale: 2 },
                jsPDF: { unit: 'mm', format: 'a4', orientation: 'landscape' }
            };

            html2pdf()
                .set(opcoesPDF)
                .from(areaParaExportar)
                .save()
                .then(function() {
                    botaoExportar.innerHTML = textoOriginal;
                    Swal.fire({
                        toast: true,
                        position: 'top-end',
                        icon: 'success',
                        title: 'PDF gerado com sucesso!',
                        showConfirmButton: false,
                        timer: 3000,
                        timerProgressBar: true
                    });
                });
        });
    }
});
</script>