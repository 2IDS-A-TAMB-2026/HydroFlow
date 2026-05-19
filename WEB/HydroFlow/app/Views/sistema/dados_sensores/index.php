<?= $this->extend('sistema/layout/main') ?>

<?= $this->section('conteudo') ?>
<div class="container mt-4">
    
    <?php if (session()->getFlashdata('success')) : ?>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i><?= session()->getFlashdata('success') ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <?php endif; ?>

    <?php if (session()->getFlashdata('error')) : ?>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i><?= session()->getFlashdata('error') ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <?php endif; ?>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="fas fa-microchip me-2"></i><?= esc($titulo) ?></h2>
        <div class="d-flex gap-2">
            <a href="<?= base_url('sensores/leituras') ?>" class="btn btn-outline-secondary">
                <i class="fas fa-history me-1"></i> Histórico de Leituras
            </a>
            <a href="<?= base_url('sensores/novo') ?>" class="btn btn-primary">
                <i class="fas fa-plus me-1"></i> Cadastrar Sensor
            </a>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped mb-0 align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Nome do Sensor</th>
                            <th>Tipo de Medição</th>
                            <th>Dispositivo Conectado</th>
                            <th>Status</th>
                            <th class="text-center">Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if (!empty($sensores)): foreach ($sensores as $item): ?>
                            <?php $sensor = (array) $item; ?>
                        <tr>
                            <td><?= $sensor['SEN_ID'] ?></td>
                            <td><strong><?= esc($sensor['SEN_NOME']) ?></strong></td>
                            <td><span class="badge bg-secondary"><?= esc($sensor['SEN_TIPO']) ?></span></td>
                            <td><?= esc($sensor['DIS_NOME'] ?? "ID: " . $sensor['FK_DIS_ID']) ?></td>
                            <td>
                                <span class="badge bg-<?= $sensor['SEN_STATUS'] === 'ATIVO' ? 'success' : 'danger' ?>">
                                    <?= esc($sensor['SEN_STATUS']) ?>
                                </span>
                            </td>
                            <td class="text-center">
                                <div class="btn-group btn-group-sm">
                                    <a href="<?= base_url('sensores/editar/' . $sensor['SEN_ID']) ?>" class="btn btn-warning" title="Editar">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="<?= base_url('sensores/excluir/' . $sensor['SEN_ID']) ?>" class="btn btn-danger" 
                                       onclick="return confirm('Tem certeza que deseja remover este sensor?')" title="Excluir">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <?php endforeach; else: ?>
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">
                                <i class="fas fa-info-circle me-1"></i> Nenhum sensor localizado no sistema.
                            </td>
                        </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<?= $this->endSection() ?>