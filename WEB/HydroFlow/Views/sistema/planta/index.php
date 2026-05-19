<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Minhas Plantas/Culturas</h2>
        <a href="<?= base_url('plantas/novo') ?>" class="btn btn-success">+ Nova Planta</a>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Nome</th>
                            <th>Tipo</th>
                            <th>Cultura</th>
                            <th>Qtd. Água</th>
                            <th>Periodicidade (Dias)</th>
                            <th>Ações</th>
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
                                    <td><?= esc($planta['PLANTA_QTD_AGUA'] ?? '0') ?> ml</td>
                                    <td>A cada <?= esc($planta['PLANTA_PERIDIOCIDADE']) ?> dia(s)</td>
                                    <td>
                                        <a href="<?= base_url('plantas/detalhes/' . $planta['PLANTA_ID']) ?>" class="btn btn-sm btn-info text-white">Ver</a>
                                        <a href="<?= base_url('plantas/editar/' . $planta['PLANTA_ID']) ?>" class="btn btn-sm btn-warning">Editar</a>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <tr>
                                <td colspan="7" class="text-center text-muted">Nenhuma planta cadastrada até o momento.</td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>