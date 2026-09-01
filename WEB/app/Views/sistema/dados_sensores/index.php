<?= view('sistema/layout/dashboard/usuario/header') ?>

<?= $this->section('conteudo') ?>
<div class="container mt-4">
    
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
                                    <a href="<?= base_url('sensores/excluir/' . $sensor['SEN_ID']) ?>" 
                                       class="btn btn-danger btn-excluir" 
                                       data-nome="<?= esc($sensor['SEN_NOME']) ?>" 
                                       title="Excluir">
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

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
document.addEventListener("DOMContentLoaded", function() {
    
    const flashSuccess = "<?= session()->getFlashdata('success') ?>";
    const flashError = "<?= session()->getFlashdata('error') ?>";

    if (flashSuccess) {
        Swal.fire({
            icon: 'success',
            title: 'Sucesso!',
            text: flashSuccess,
            timer: 3000,
            showConfirmButton: false
        });
    }

    if (flashError) {
        Swal.fire({
            icon: 'error',
            title: 'Erro!',
            text: flashError,
            confirmButtonColor: '#dc3545'
        });
    }

    
    const botoesExcluir = document.querySelectorAll('.btn-excluir');
    
    botoesExcluir.forEach(botao => {
        botao.addEventListener('click', function(e) {
            e.preventDefault(); 
            
            const url = this.getAttribute('href');
            const nomeSensor = this.getAttribute('data-nome');

            Swal.fire({
                title: 'Tem certeza?',
                html: `Você está prestes a excluir o sensor: <b>${nomeSensor}</b>.<br>Isso pode afetar o histórico de leituras!`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sim, excluir!',
                cancelButtonText: 'Cancelar',
                reverseButtons: true
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = url; 
                }
            });
        });
    });
});
</script>

<?= $this->endSection() ?>