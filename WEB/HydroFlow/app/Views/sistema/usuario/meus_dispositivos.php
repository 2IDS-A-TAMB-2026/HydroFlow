<?= view("sistema/layout/dashboard/header") ?>

<div class="container mt-5">
    <div class="card shadow-sm mx-auto" style="max-width: 800px;">
        <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Dispositivos Conectados</h5>
            <a href="<?= base_url('usuario') ?>" class="btn btn-outline-light btn-sm">Voltar</a>
        </div>
        <div class="card-body">
            <p class="text-muted small">Estes são os dispositivos que acessaram a sua conta recentemente.</p>

            <ul class="list-group list-group-flush">
                <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                    <div>
                        <h6 class="mb-1">Notebook - Windows 11</h6>
                        <small class="text-muted">São Paulo, Brasil • **Sessão atual**</small>
                    </div>
                    <span class="badge bg-success rounded-pill">Online</span>
                </li>

                <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                    <div>
                        <h6 class="mb-1">iPhone 14 - Safari</h6>
                        <small class="text-muted">Rio de Janeiro, Brasil • Último acesso: Há 2 horas</small>
                    </div>
                    <button class="btn btn-outline-danger btn-sm">Desconectar</button>
                </li>
            </ul>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>