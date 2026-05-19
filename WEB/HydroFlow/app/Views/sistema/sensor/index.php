<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>🔌 Gerenciamento de Sensores</h2>
        <a href="<?= base_url('sensores/novo') ?>" class="btn btn-primary">+ Novo Sensor</a>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Nome do Sensor</th>
                            <th>Tipo/Grandeza</th>
                            <th>Dispositivo Vinculado</th>
                            <th>Status</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if (!empty($sensores) && is_array($sensores)): ?>
                            <?php foreach ($sensores as $sensor): ?>
                                <tr>
                                    <td><?= $sensor['SEN_ID'] ?></td>
                                    <td><strong><?= esc($sensor['SEN_NOME']) ?></strong></td>
                                    <td>
                                        <span class="badge bg-secondary p-2"><?= esc($sensor['SEN_TIPO']) ?></span>
                                    </td>
                                    <td>
                                        <?= esc($sensor['DIS_NOME'] ?? 'Dispositivo #' . $sensor['FK_DIS_ID']) ?>
                                    </td>
                                    <td>
                                        <?php if (($sensor['SEN_STATUS'] ?? 'ATIVO') === 'ATIVO'): ?>
                                            <span class="badge bg-success">ATIVO</span>
                                        <?php else: ?>
                                            <span class="badge bg-danger">INATIVO</span>
                                        <?php endif; ?>
                                    </td>
                                    <td>
                                        <a href="<?= base_url('sensores/editar/' . $sensor['SEN_ID']) ?>" class="btn btn-sm btn-warning">Editar</a>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <tr>
                                <td colspan="6" class="text-center text-muted">Nenhum sensor cadastrado até o momento.</td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>