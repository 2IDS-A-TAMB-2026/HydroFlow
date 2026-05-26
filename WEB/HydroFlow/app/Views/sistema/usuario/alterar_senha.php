<?= view("sistema/layout/dashboard/header") ?>

<div class="container mt-5">
    <div class="card shadow-sm mx-auto" style="max-width: 450px;">
        <div class="card-header bg-warning text-dark fw-bold">
            <h5 class="mb-0">Alterar Minha Senha</h5>
        </div>
        <div class="card-body">

            <?php if (session()->getFlashdata('errors')): ?>
                <div class="alert alert-danger p-2 small">
                    <?php foreach (session()->getFlashdata('errors') as $error): ?>
                        <li><?= esc($error) ?></li>
                    <?php endforeach; ?>
                </div>
            <?php endif; ?>

            <form action="<?= base_url('usuario/salvar_senha') ?>" method="POST">
                
                <input type="hidden" name="USU_ID" value="<?= session()->get('USU_ID') ?? '' ?>">

                <div class="mb-3">
                    <label for="senha_atual" class="form-label small fw-bold">Senha Atual</label>
                    <input type="password" class="form-control" id="senha_atual" name="senha_atual" required>
                </div>

                <hr>

                <div class="mb-3">
                    <label for="USU_SENHA" class="form-label small fw-bold">Nova Senha</label>
                    <input type="password" class="form-control" id="USU_SENHA" name="USU_SENHA" required>
                </div>

                <div class="mb-4">
                    <label for="confirmar_senha" class="form-label small fw-bold">Confirmar Nova Senha</label>
                    <input type="password" class="form-control" id="confirmar_senha" name="confirmar_senha" required>
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <a href="<?= base_url('usuario') ?>" class="text-decoration-none text-muted small">Cancelar</a>
                    <button type="submit" class="btn btn-warning fw-bold text-dark">Atualizar Senha</button>
                </div>
            </form>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>