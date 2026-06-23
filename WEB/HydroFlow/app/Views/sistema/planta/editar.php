<?= view("sistema/layout/dashboard/usuario/header") ?>

<main class="main-content">

    <div class="widget form-widget full-width-form">

        <div class="form-header-flex">
            <h3 class="form-title">
                <i class="fa-solid fa-leaf" style="color:#f39c12;"></i> Editar Planta
            </h3>

            <a href="<?= base_url('planta') ?>" style="text-decoration:none;">
                <button class="btn-voltar" type="button">
                    <i class="fa-solid fa-list"></i> Ver Cadastradas
                </button>
            </a>
        </div>

        <hr class="divider">

        <form action="<?= base_url('planta/atualizar/' . $planta['PLANTA_ID']) ?>" method="post" id="formEditar">
            <?= csrf_field() ?>

            <h4 class="section-title">Informações da Espécie</h4>

            <div class="form-row">

                <div class="form-group" style="flex:2;">
                    <label for="PLANTA_NOME">Nome da Planta</label>
                    <input type="text"
                           id="PLANTA_NOME"
                           name="PLANTA_NOME"
                           class="form-control"
                           value="<?= esc($planta['PLANTA_NOME']) ?>"
                           required>
                </div>

                <div class="form-group" style="flex:1;">
                    <label for="PLANTA_TIPO">Tipo da Planta</label>
                    <input type="text"
                           id="PLANTA_TIPO"
                           name="PLANTA_TIPO"
                           class="form-control"
                           value="<?= esc($planta['PLANTA_TIPO']) ?>"
                           required>
                </div>

                <div class="form-group" style="flex:1.5;">
                    <label for="PLANTA_CULTURA">Cultura</label>
                    <input type="text"
                           id="PLANTA_CULTURA"
                           name="PLANTA_CULTURA"
                           class="form-control"
                           value="<?= esc($planta['PLANTA_CULTURA'] ?? '') ?>">
                </div>

            </div>

            <h4 class="section-title" style="margin-top:15px;">
                Parâmetros de Irrigação e Vínculos
            </h4>

            <div class="form-row">

                <div class="form-group">
                    <label for="PLANTA_QTD_AGUA">Quantidade de Água (ml)</label>
                    <input type="number"
                           id="PLANTA_QTD_AGUA"
                           name="PLANTA_QTD_AGUA"
                           class="form-control"
                           value="<?= esc($planta['PLANTA_QTD_AGUA'] ?? '') ?>">
                </div>

                <div class="form-group">
                    <label for="PLANTA_PERIDIOCIDADE">Periodicidade (dias)</label>
                    <input type="number"
                           id="PLANTA_PERIDIOCIDADE"
                           name="PLANTA_PERIDIOCIDADE"
                           class="form-control"
                           value="<?= esc($planta['PLANTA_PERIDIOCIDADE']) ?>"
                           required>
                </div>

                <div class="form-group" style="flex: 2;">
                    <label for="FK_DIS_ID">Dispositivo Responsável</label>
                    <select name="FK_DIS_ID" id="FK_DIS_ID" class="form-control" required>
                        <option value="">Selecione um Dispositivo...</option>
                        <?php if (!empty($dispositivos) && is_array($dispositivos)): ?>
                            <?php foreach ($dispositivos as $disp): ?>
                                <option value="<?= $disp['DIS_ID'] ?>" <?= (isset($planta['FK_DIS_ID']) && $planta['FK_DIS_ID'] == $disp['DIS_ID']) ? 'selected' : '' ?>>
                                    <?= esc($disp['DIS_NOME']) ?>
                                </option>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </select>
                </div>

                </div>

            <hr class="divider">

            <div class="form-actions">
                <a href="<?= base_url('planta') ?>">
                    <button type="button" class="btn-cancelar">
                        Cancelar
                    </button>
                </a>

                <button type="submit" class="btn-submit">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar Alterações
                </button>
            </div>

        </form>
    </div>

</main>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
document.addEventListener("DOMContentLoaded", function () {

    const form = document.getElementById("formEditar");

    form.addEventListener("submit", function (e) {
        e.preventDefault();

        Swal.fire({
            title: 'Salvar alterações?',
            text: "Os dados da planta serão atualizados.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#1e3c72',
            cancelButtonColor: '#6e7881',
            confirmButtonText: 'Sim, salvar!',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {

                Swal.fire({
                    title: 'Atualizando...',
                    allowOutsideClick: false,
                    didOpen: () => Swal.showLoading()
                });

                form.submit();
            }
        });
    });

});
</script>