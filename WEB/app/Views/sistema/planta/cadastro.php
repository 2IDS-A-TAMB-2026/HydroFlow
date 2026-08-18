<?= view("sistema/layout/dashboard/usuario/header") ?>

<main class="main-content">
    

    <div class="widget form-widget full-width-form">
        <div class="form-header-flex">
            <h3 class="form-title">
                <i class="fa-solid fa-leaf" style="color: #00a65a;"></i> Nova Planta
            </h3>
            <a href="<?= base_url('planta') ?>" style="text-decoration: none;">
                <button class="btn-voltar" type="button"><i class="fa-solid fa-list"></i> Ver Cadastradas</button>
            </a>
        </div>
        <hr class="divider">
        
        <form action="<?= base_url('planta/salvar') ?>" method="post" id="formPlanta">
            <?= csrf_field() ?>
            
            <h4 class="section-title">Informações da Espécie</h4>
            
            <div class="form-row">
                <div class="form-group" style="flex: 2;">
                    <label for="PLANTA_NOME">Nome da Planta</label>
                    <input type="text" id="PLANTA_NOME" name="PLANTA_NOME" class="form-control" placeholder="Ex: Tomate Carmem, Alface Crespa..." required>
                </div>
                
                <div class="form-group" style="flex: 1;">
                    <label for="PLANTA_TIPO">Tipo da Planta</label>
                    <select id="PLANTA_TIPO" name="PLANTA_TIPO" class="form-control" required>
                        <option value="">Selecione...</option>
                        <option value="Hortaliça">Hortaliça</option>
                        <option value="Frutífera">Frutífera</option>
                        <option value="Legume">Legume</option>
                        <option value="Grão / Cereal">Grão / Cereal</option>
                        <option value="Ornamental">Ornamental</option>
                    </select>
                </div>
                
                <div class="form-group" style="flex: 1.5;">
                    <label for="PLANTA_CULTURA">Cultura</label>
                    <input type="text" id="PLANTA_CULTURA" name="PLANTA_CULTURA" class="form-control" placeholder="Ex: Solanáceas, Hortifruti..." required>
                </div>
            </div>

            <h4 class="section-title" style="margin-top: 15px;">Parâmetros de Irrigação e Vínculos</h4>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="PLANTA_QTD_AGUA">Quantidade de Água Necessária (L)</label>
                    <div style="display: flex; gap: 10px;">
                        <input type="number" id="PLANTA_QTD_AGUA" name="PLANTA_QTD_AGUA" class="form-control" step="0.1" placeholder="Ex: 500" required>
                        <select class="form-control" style="width: 120px;" disabled>
                            <option selected>L</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="FK_DIS_ID">Dispositivo Responsável</label>
                    <select id="FK_DIS_ID" name="FK_DIS_ID" class="form-control" required>
                        <option value="">Selecione o Dispositivo...</option>
                        <?php if (!empty($dispositivos) && is_array($dispositivos)): ?>
                            <?php foreach ($dispositivos as $dispositivo): ?>
                                <option value="<?= $dispositivo['DIS_ID'] ?>">
                                    <?= esc($dispositivo['DIS_NOME'] ?? 'Dispositivo ' . $dispositivo['DIS_ID']) ?>
                                </option>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </select>
                </div>
                <div class="form-group">
                    <label for="PLANTA_PERIDIOCIDADE">Periodicidade entre irrigações (tempo em dias)</label>
                    <div style="display: flex; gap: 10px;">
                        <input type="number" id="PLANTA_PERIDIOCIDADE" name="PLANTA_PERIDIOCIDADE" class="form-control" min="1" placeholder="Ex: 2" required>
                        <select class="form-control" style="width: 120px;" disabled>
                            <option selected>Dias</option>
                        </select>
                    </div>
                </div>
            </div>

            <hr class="divider">

            <div class="form-actions">
                <button type="reset" class="btn-cancelar">Limpar</button>
                <button type="submit" class="btn-submit" style="width: auto; padding: 12px 30px; margin-top: 0;">
                    <i class="fa-solid fa-seedling"></i> Salvar Planta
                </button>
            </div>
        </form>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("formPlanta");

    if (form) {
        form.addEventListener("submit", function (e) {
            e.preventDefault();

            Swal.fire({
                title: 'Confirmar Cadastro?',
                text: "Deseja salvar esta nova planta no sistema?",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#1e3c72',
                cancelButtonColor: '#6e7881',
                confirmButtonText: 'Sim, salvar!',
                cancelButtonText: 'Revisar',
                reverseButtons: true
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Enviando dados...',
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });
                    form.submit();
                }
            });
        });
    }
});
</script>