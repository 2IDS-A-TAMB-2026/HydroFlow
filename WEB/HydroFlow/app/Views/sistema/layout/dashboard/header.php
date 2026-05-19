<!DOCTYPE html>
<!--002855-->
<!--0056b3-->
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <link rel="stylesheet" href="css/style_dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="logo">
                <i class="fa-solid fa-droplet"></i> <span class="logos">HYDRO</span>FLOW
            </div>
            <div class="search-bar">
                <input type="text" placeholder="Procurar opção do menu...">
                <i class="fa-solid fa-magnifying-glass"></i>
            </div>
            <ul class="nav-menu">
                <li class="active"><a href="#"><i class="fa-solid fa-house"></i> Painel</a></li>
                <li><a href="agendamento.html"><i class="fa-solid fa-calendar-days"></i> Agendamentos</a></li>
                <li><a href="plantas.html"><i class="fa-solid fa-tree"></i> Plantas</a></li>
                <li><a href="historico.html"><i class="fas fa-history"></i> Histórico</a></li>
                <li><a href="cadastro_planta.html"><i class="fa-solid fa-seedling"></i> Cadastro de Plantas</a></li>
                <li><a href="cadastro_equipamento.html"><i class="fa-solid fa-cart-shopping"></i>Cadastro de Equipamento</a></li>
            </ul>
        </aside>

        <main class="main-content">
            <header class="top-nav">
                <div class="nav-left">
                    <button class="menu-btn"><i class="fa-solid fa-bars"></i></button>
                    <h2>Painel</h2>
                </div>
                <div class="nav-right">
                    <span></span>
                    <i class="fa-solid fa-user"></i>
                    <i class="fa-solid fa-bell"></i>
                </div>
            </header>
