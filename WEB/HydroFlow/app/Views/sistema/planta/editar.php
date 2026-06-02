<?= view("sistema/layout/dashboard/header") ?>
<script src="<?= base_url('assets/css/') ?>"></script>
<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-warning text-dark">
                    <h4 class="mb-0">Editar Planta: <?= esc($planta['PLANTA_NOME']) ?></h4>
                </div>
                <div class="card-body">
                    <form action="<?= base_url('plantas/atualizar/' . $planta['PLANTA_ID']) ?>" method="post" id="formEditar">
                        <?= csrf_field() ?>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="PLANTA_NOME" class="form-label">Nome da Planta</label>
                                <input type="text" class="form-control" id="PLANTA_NOME" name="PLANTA_NOME" value="<?= esc($planta['PLANTA_NOME']) ?>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="PLANTA_TIPO" class="form-label">Tipo de Solo/Planta</label>
                                <input type="text" class="form-control" id="PLANTA_TIPO" name="PLANTA_TIPO" value="<?= esc($planta['PLANTA_TIPO']) ?>" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="PLANTA_CULTURA" class="form-label">Cultura</label>
                                <input type="text" class="form-control" id="PLANTA_CULTURA" name="PLANTA_CULTURA" value="<?= esc($planta['PLANTA_CULTURA'] ?? '') ?>">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="PLANTA_QTD_AGUA" class="form-label">Qtd. Água (ml)</label>
                                <input type="number" class="form-control" id="PLANTA_QTD_AGUA" name="PLANTA_QTD_AGUA" value="<?= esc($planta['PLANTA_QTD_AGUA'] ?? '') ?>">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="PLANTA_PERIDIOCIDADE" class="form-label">Periodicidade (Dias)</label>
                                <input type="number" class="form-control" id="PLANTA_PERIDIOCIDADE" name="PLANTA_PERIDIOCIDADE" value="<?= esc($planta['PLANTA_PERIDIOCIDADE']) ?>" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="FK_USU_ID" class="form-label">ID do Usuário Responsável</label>
                                <input type="number" class="form-control" id="FK_USU_ID" name="FK_USU_ID" value="<?= esc($planta['FK_USU_ID']) ?>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="FK_DIS_ID" class="form-label">ID do Dispositivo Vinculado</label>
                                <input type="number" class="form-control" id="FK_DIS_ID" name="FK_DIS_ID" value="<?= esc($planta['FK_DIS_ID']) ?>" required>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-3">
                            <a href="<?= base_url('plantas') ?>" class="btn btn-secondary">Voltar</a>
                            <button type="submit" class="btn btn-warning">Salvar Alterações</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("formEditar");

    form.addEventListener("submit", function (e) {
        e.preventDefault(); // Impede o envio imediato

        Swal.fire({
            title: 'Salvar Alterações?',
            text: "Os dados antigos serão substituídos pelas novas informações.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ffc107', 
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Sim, atualizar!',
            cancelButtonText: 'Cancelar',
            reverseButtons: true 
        }).then((result) => {
            if (result.isConfirmed) {
                
                Swal.fire({
                    title: 'Atualizando...',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });
                
                
                form.submit();
            }
        });
    });
});
</script>