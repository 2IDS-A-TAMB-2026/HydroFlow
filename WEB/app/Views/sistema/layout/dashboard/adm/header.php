<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>

    <link rel="stylesheet" href="<?= base_url('assets/css/style_dashboard.css') ?>">

    <link 
        rel="stylesheet" 
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    >

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="<?= base_url('assets/js/imprime.js') ?>"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>

    <link href="https://cdn.jsdelivr.net/npm/tom-select@2.3.1/dist/css/tom-select.bootstrap5.min.css" rel="stylesheet">
    <script src="https://unpkg.com/imask"></script>
    <script src="https://cdn.jsdelivr.net/npm/tom-select@2.3.1/dist/js/tom-select.complete.min.js"></script>
</head>

<body>

    <div class="dashboard-container">

        <aside class="sidebar" aria-label="Menu lateral">

            <div class="logo" aria-label="Logo HydroFlow">
                <i class="fa-solid fa-droplet" aria-hidden="true"></i>
                <span class="logos">HYDRO</span>FLOW
            </div>

            <div class="search-bar">
                <label for="busca-menu" class="sr-only">
                    Procurar opção do menu
                </label>
                <input 
                    type="text"
                    id="busca-menu"
                    placeholder="Procurar opção do menu..."
                    aria-label="Procurar opção do menu"
                >
                <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i>
            </div>

            <div class="sidebar-user-card">
                <div class="sidebar-user-avatar">
                    <i class="fa-solid fa-user-check"></i>
                </div>
                <div class="sidebar-user-info">
                    <span class="sidebar-user-name">
                        <?= esc(session()->get('ADM_NOME') ?? session()->get('nome') ?? session()->get('USU_NOME') ?? 'Administrador') ?>
                    </span>
                    <span class="sidebar-user-role">
                        <i class="fa-solid fa-circle" style="color: #2ecc71; font-size: 6px; vertical-align: middle;"></i> Online
                    </span>
                </div>
            </div>
            <ul class="nav-menu">

                <div class="menu-section-title">Painel Geral</div>
                <li>
                    <a href="<?= base_url('admin/dashboard') ?>" aria-label="Ir para painel">
                        <i class="fa-solid fa-house" aria-hidden="true"></i>
                        Painel
                    </a>
                </li>

                <div class="menu-section-title">Gerenciamento</div>
                <li>
                    <a href="<?= base_url('admin/usuarios') ?>" aria-label="Ir para gerenciamento de usuários">
                        <i class="fa-solid fa-users-gear" aria-hidden="true"></i>
                        Usuários
                    </a>
                </li>

                <li>
                    <a href="<?= base_url('admin/dispositivos') ?>" aria-label="Ir para malha de dispositivos">
                        <i class="fa-solid fa-microchip" aria-hidden="true"></i>
                        Malha de Dispositivos
                    </a>
                </li>

                <li>
                    <a href="<?= base_url('admin/sensores') ?>" aria-label="Ir para malha de sensores">
                        <i class="fa-solid fa-circle-nodes" aria-hidden="true"></i>
                        Malha de Sensores
                    </a>
                </li>

                <li>
                    <a href="<?= base_url('admin/perfil') ?>" aria-label="Ir para configurações do perfil">
                        <i class="fa-solid fa-user-gear" aria-hidden="true"></i>
                        Perfil
                    </a>
                </li>

                <div class="menu-section-title">Sessão</div>
                <li>
                    <?php if (session()->get('logado_adm')): ?>
                        <a href="<?= base_url('/logout_adm') ?>" aria-label="Sair do sistema como admin" class="logout-btn">
                    <?php else: ?>
                        <a href="<?= base_url('/logout') ?>" aria-label="Sair do sistema" class="logout-btn">
                    <?php endif; ?>
                        <i class="fa-solid fa-right-from-bracket" aria-hidden="true"></i>
                        Logout
                    </a>
                </li>

            </ul>

        </aside>

        <main class="main-content">

            <header class="top-nav">

                <div class="nav-left">
                    <button 
                        class="menu-btn"
                        aria-label="Abrir menu lateral"
                    >
                        <i class="fa-solid fa-bars" aria-hidden="true"></i>
                    </button>
                    <h2>Painel</h2>
                </div>
                
                <div class="acessibilidade-group">
                    <button
                        id="btn-contraste"
                        class="btn-acessibilidade"
                        aria-label="Ativar ou desativar alto contraste"
                        title="Contraste"
                    >
                        ◐
                    </button>

                    <button
                        id="btnIncreaseFont"
                        class="btn-acessibilidade"
                        aria-label="Aumentar tamanho da fonte"
                        title="Aumentar fonte"
                    >
                        +
                    </button>

                    <button
                        id="btnDecreaseFont"
                        class="btn-acessibilidade"
                        aria-label="Diminuir tamanho da fonte"
                        title="Diminuir fonte"
                    >
                        -
                    </button>
                </div>

            </header>

    <script>
    document.addEventListener('DOMContentLoaded', function () {
        const logoutBtn = document.querySelector('.logout-btn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', function (e) {
                e.preventDefault();
                const url = this.href;

                Swal.fire({
                    title: 'Deseja sair?',
                    text: 'Sua sessão será encerrada.',
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#0056b3',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Sim, sair',
                    cancelButtonText: 'Cancelar'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = url;
                    }
                });
            });
        }
    });
    </script>
    <script src="<?= base_url('assets/js/acessibilidade.js') ?>"></script>
    <script src="<?= base_url('assets/js/alto_contraste.js') ?>"></script>