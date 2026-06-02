<?= view("sistema/layout/dashboard/header") ?>

<main class="main-content">
    <header class="top-nav">
        <div class="nav-left">
            <button class="menu-btn"><i class="fa-solid fa-bars"></i></button>
            <h2>Listagem de Culturas e Plantas</h2>
        </div>
        <div class="nav-right">
            <span>Manual Sistema Gestão Online</span>
            <i class="fa-solid fa-user"></i>
            <i class="fa-solid fa-bell"></i>
        </div>
    </header>

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

        <div class="table-toolbar">
            <div class="search-table">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" class="form-control" placeholder="Buscar por nome ou cultura...">
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
                <tbody>
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
                            <td colspan="7" class="text-center text-muted" style="padding: 20px; text-align: center;">Nenhuma planta cadastrada até o momento.</td>
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
    // Atualizado para receber ID e Nome da planta para futura integração com a rota de exclusão real
function confirmarExclusao(idPlanta, nomePlanta) {
    Swal.fire({
        title: 'Excluir Planta?',
        text: `Tem certeza que deseja remover "${nomePlanta}" (ID: ${idPlanta})? Esta ação não pode ser desfeita.`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33', 
        cancelButtonColor: '#6e7881',
        confirmButtonText: 'Sim, excluir!',
        cancelButtonText: 'Cancelar',
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed) {
            // Feedback visual de carregamento rápido
            Swal.fire({
                title: 'Removendo...',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            // ATIVAÇÃO REAL: Redireciona para a rota correta do CodeIgniter
            window.location.href = `<?= base_url('planta/excluir') ?>/${idPlanta}`;
        }
    });
}

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