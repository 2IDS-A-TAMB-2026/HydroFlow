<?= view("sistema/layout/dashboard/usuario/header") ?>

<div class="container mt-5">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <h3 class="mb-0"><?= $titulo ?></h3>
            <a href="<?= base_url('usuario/novo') ?>" class="btn btn-light btn-sm fw-bold">+ Novo Usuário</a>
        </div>
        <div class="card-body">

            <?php if (session()->getFlashdata('success')): ?>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <?= session()->getFlashdata('success') ?>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <?php endif; ?>

            <?php if (session()->getFlashdata('error')): ?>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <?= session()->getFlashdata('error') ?>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <?php endif; ?>

            <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Nome</th>
                            <th>E-mail</th>
                            <th>Cidade/UF</th>
                            <th>Status</th>
                            <th class="text-center">Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if (!empty($usuarios) && is_array($usuarios)): ?>
                            <?php foreach ($usuarios as $user): ?>
                                <tr>
                                    <td><?= $user['USU_ID'] ?></td>
                                    <td><?= esc($user['USU_NOME']) ?></td>
                                    <td><?= esc($user['USU_EMAIL']) ?></td>
                                    <td><?= esc($user['USU_CIDADE']) ?>/<?= esc($user['USU_UF']) ?></td>
                                    <td>
                                        <span class="badge <?= $user['USU_STATUS'] === 'ATIVO' ? 'bg-success' : 'bg-danger' ?>">
                                            <?= $user['USU_STATUS'] ?>
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <a href="<?= base_url('usuario/editar/' . $user['USU_ID']) ?>" class="btn btn-warning btn-sm me-1">Editar</a>
                                        
                                        <a href="<?= base_url('usuario/excluir/' . $user['USU_ID']) ?>" 
                                           class="btn btn-danger btn-sm" 
                                           onclick="return confirm('Tem certeza que deseja excluir o usuário <?= esc($user['USU_NOME']) ?>?');">
                                            Excluir
                                        </a>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">Nenhum usuário cadastrado.</td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>