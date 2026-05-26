<!DOCTYPE html>
<!--002855-->
<!--0056b3-->
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>

    <link rel="stylesheet" href="<?= base_url('assets/css/style_dashboard.css') ?>">

    <!-- Ícones -->
    <link 
        rel="stylesheet" 
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    >

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

            <ul class="nav-menu">

                <li class="active">
                    <a href="#" aria-label="Ir para painel">
                        <i class="fa-solid fa-house" aria-hidden="true"></i>
                        Painel
                    </a>
                </li>

                <li>
                    <a href="agendamento.html" aria-label="Ir para agendamentos">
                        <i class="fa-solid fa-calendar-days" aria-hidden="true"></i>
                        Agendamentos
                    </a>
                </li>

                <li>
                    <a href="plantas.html" aria-label="Ir para plantas">
                        <i class="fa-solid fa-tree" aria-hidden="true"></i>
                        Plantas
                    </a>
                </li>

                <li>
                    <a href="historico.html" aria-label="Ir para histórico">
                        <i class="fas fa-history" aria-hidden="true"></i>
                        Histórico
                    </a>
                </li>

                <li>
                    <a href="cadastro_planta.html" aria-label="Ir para cadastro de plantas">
                        <i class="fa-solid fa-seedling" aria-hidden="true"></i>
                        Cadastro de Plantas
                    </a>
                </li>

                <li>
                    <a href="cadastro_equipamento.html" aria-label="Ir para cadastro de equipamento">
                        <i class="fa-solid fa-cart-shopping" aria-hidden="true"></i>
                        Cadastro de Equipamento
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

                <div class="nav-right">

                    <span></span>

                    <i 
                        class="fa-solid fa-user"
                        aria-label="Perfil do usuário"
                        role="img"
                    ></i>

                    <i 
                        class="fa-solid fa-bell"
                        aria-label="Notificações"
                        role="img"
                    ></i>

                </div>

            </header>