<?= $this->extend('sistema/layout/main') ?>

<?= $this->section('conteudo') ?>
<div class="container mt-4">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2><i class="fas fa-database me-2"></i><?= esc($titulo ?? 'Histórico de Leituras dos Sensores') ?></h2>
            <p class="text-muted mb-0">Dados de telemetria coletados em tempo real pelo sistema HydroFlow.</p>
        </div>
        <a href="<?= base_url('sensores') ?>" class="btn btn-secondary">
            <i class="fas fa-arrow-left me-1"></i> Voltar para Sensores
        </a>
    </div>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped mb-0 align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>Cód. Registro (DDS_ID)</th>
                            <th>Sensor Origem</th>
                            <th>Data da Coleta</th>
                            <th>Hora da Coleta</th>
                            <th>Umidade Registrada</th>
                            <th>Temperatura Registrada</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if (!empty($ativacoes)): foreach ($ativacoes as $item): ?>
                            <?php $dado = (array) $item; ?>
                        <tr>
                            <td>#<?= $dado['DDS_ID'] ?></td>
                            <td>
                                <strong><?= esc($dado['SEN_NOME'] ?? 'Sensor ID: ' . $dado['FK_SEN_ID']) ?></strong>
                            </td>
                            <td>
                                <?= isset($dado['DDS_DATA']) ? date('d/m/Y', strtotime($dado['DDS_DATA'])) : '-' ?>
                            </td>
                            <td>
                                <?= esc($dado['DDS_HORA'] ?? '-') ?>
                            </td>
                            <td>
                                <span class="fw-bold text-primary">
                                    <?= esc($dado['DDS_UMIDADE']) ?>%
                                </span>
                            </td>
                            <td>
                                <span class="fw-bold text-danger">
                                    <?= esc($dado['DDS_TEMP']) ?>°C
                                </span>
                            </td>
                        </tr>
                        <?php endforeach; else: ?>
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">
                                <i class="fas fa-calendar-times me-1"></i> Nenhum dado de telemetria foi registrado recentemente nesta tabela.
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