<div class="container mt-4">
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-info text-white">
            <h4 class="mb-0">Detalhes do Canteiro: <?= esc($planta['PLANTA_NOME']) ?></h4>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Tipo/Categoria:</strong> <?= esc($planta['PLANTA_TIPO']) ?></p>
                    <p><strong>Cultura Praticada:</strong> <?= esc($planta['PLANTA_CULTURA'] ?? 'Nenhum detalhe adicional') ?></p>
                </div>
                <div class="col-md-6">
                    <p><strong>Volume de Irrigação Esperado:</strong> <?= esc($planta['PLANTA_QTD_AGUA'] ?? '0') ?> ml</p>
                    <p><strong>Intervalo de Rega:</strong> A cada <?= esc($planta['PLANTA_PERIDIOCIDADE']) ?> dia(s)</p>
                </div>
            </div>
            <hr>
            <div class="row bg-light p-3 rounded">
                <div class="col-md-6">
                    <small class="text-muted d-block">ID do Usuário Dono</small>
                    <strong>#<?= esc($planta['FK_USU_ID']) ?></strong>
                </div>
                <div class="col-md-6">
                    <small class="text-muted d-block">Hardware IoT Vinculado</small>
                    <span class="badge bg-secondary p-2">Dispositivo #<?= esc($planta['FK_DIS_ID']) ?></span>
                </div>
            </div>
        </div>
        <div class="card-footer d-flex justify-content-end">
            <a href="<?= base_url('plantas') ?>" class="btn btn-outline-secondary btn-sm me-2">Voltar para a Lista</a>
            <a href="<?= base_url('plantas/editar/' . $planta['PLANTA_ID']) ?>" class="btn btn-warning btn-sm">Editar Planta</a>
        </div>
    </div>
</div>