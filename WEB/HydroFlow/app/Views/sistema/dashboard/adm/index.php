<?= view('layout/dashboard/header') ?>

<!DOCTYPE html>
<!--002855-->
<!--0056b3-->
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard ADM</title>

    <!-- CSS -->
    <link rel="stylesheet" href="<?= base_url('assets/c/stysle_dashboard.css') ?>">

    <!-- Font Awesome -->
    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>

    <div class="dashboard-container">

        <!-- Sidebar -->
        <aside class="sidebar">

            <div class="logo">
                <i class="fa-solid fa-droplet"></i>
                <span class="logos">HYDRO</span>FLOW
            </div>

            <div class="search-bar">
                <input type="text" placeholder="Procurar opção do menu...">
                <i class="fa-solid fa-magnifying-glass"></i>
            </div>

            <ul class="nav-menu">

                <li class="active">
                    <a href="<?= base_url('dashboard-admin') ?>">
                        <i class="fa-solid fa-house"></i> Painel
                    </a>
                </li>

                <li>
                    <a href="<?= base_url('agendamentos') ?>">
                        <i class="fa-solid fa-calendar-days"></i> Agendamentos
                    </a>
                </li>

                <li>
                    <a href="<?= base_url('usuarios') ?>"
                        style="background-color: rgba(255,255,255,0.1);">

                        <i class="fa-solid fa-users"></i>
                        Gestão de Usuários
                    </a>
                </li>

                <li>
                    <a href="<?= base_url('perfil') ?>">
                        <i class="fa-solid fa-user-gear"></i>
                        Meu Perfil
                    </a>
                </li>

            </ul>

        </aside>

        <!-- Conteúdo -->
        <main class="main-content">

            <!-- Topo -->
            <header class="top-nav">

                <div class="nav-left">

                    <button class="menu-btn">
                        <i class="fa-solid fa-bars"></i>
                    </button>

                    <h2>Painel Administrativo</h2>

                </div>

                <div class="nav-right">

                    <span>
                        <?= session()->get('nome') ?? 'Administrador' ?>
                    </span>

                    <i class="fa-solid fa-user"></i>
                    <i class="fa-solid fa-bell"></i>

                </div>

            </header>

            <!-- Cards -->
            <section class="kpi-cards">

                <div class="card card-cyan">

                    <div class="card-content">
                        <h3><?= $ativos ?? 66 ?></h3>
                        <p>Dispositivos Ativos</p>
                    </div>

                    <i class="fa-solid fa-hard-drive card-icon"></i>

                    <div class="card-footer"></div>

                </div>

                <div class="card card-orange">

                    <div class="card-content">
                        <h3><?= $alertas ?? 68 ?></h3>
                        <p>Alertas não verificados</p>
                    </div>

                    <i class="fa-solid fa-triangle-exclamation card-icon"></i>

                    <div class="card-footer"></div>

                </div>

                <div class="card card-green">

                    <div class="card-content">
                        <h3><?= $plantas ?? 30 ?></h3>
                        <p>Plantas Cadastradas</p>
                    </div>

                    <i class="fa-solid fa-seedling card-icon"></i>

                    <div class="card-footer"></div>

                </div>

                <div class="card card-red">

                    <div class="card-content">
                        <h3><?= $inativos ?? 30 ?></h3>
                        <p>Dispositivos Inativos</p>
                    </div>

                    <i class="fa-solid fa-bug card-icon"></i>

                    <div class="card-footer"></div>

                </div>

            </section>

            <!-- Área Inferior -->
            <section class="bottom-grid">

                <!-- Tabela -->
                <div class="widget table-widget">

                    <h3>Status</h3>

                    <table>

                        <thead>
                            <tr>
                                <th>Planta</th>
                                <th>Dispositivo</th>
                                <th>Status</th>
                            </tr>
                        </thead>

                        <tbody>

                            <?php if (!empty($status)): ?>

                                <?php foreach ($status as $item): ?>

                                    <tr>

                                        <td><?= esc($item['planta']) ?></td>

                                        <td><?= esc($item['dispositivo']) ?></td>

                                        <td>

                                            <?php if ($item['status'] == 'IRRIGADO'): ?>

                                                <span class="badge badge-green">
                                                    IRRIGADO
                                                </span>

                                            <?php else: ?>

                                                <span class="badge badge-red">
                                                    FALHA
                                                </span>

                                            <?php endif; ?>

                                        </td>

                                    </tr>

                                <?php endforeach; ?>

                            <?php else: ?>

                                <tr>
                                    <td>Samambaia</td>
                                    <td>Irriga 1000</td>
                                    <td>
                                        <span class="badge badge-green">
                                            IRRIGADO
                                        </span>
                                    </td>
                                </tr>

                                <tr>
                                    <td>Tomateira</td>
                                    <td>Irrigador Lest</td>
                                    <td>
                                        <span class="badge badge-green">
                                            IRRIGADO
                                        </span>
                                    </td>
                                </tr>

                                <tr>
                                    <td>Cliente Modelo 2</td>
                                    <td>2,00</td>
                                    <td>
                                        <span class="badge badge-red">
                                            FALHA
                                        </span>
                                    </td>
                                </tr>

                            <?php endif; ?>

                        </tbody>

                    </table>

                </div>

                <!-- Gráfico -->
                <div class="widget chart-widget">

                    <h3 class="chart-title">
                        Monitoramento Geral
                    </h3>

                    <div class="chart-container">
                        <canvas id="vendasChart"></canvas>
                    </div>

                </div>

            </section>

        </main>

    </div>

    <!-- JS -->
    <script src="<?= base_url('assts/ejs/dashboard.js') ?>"></script>

</body>

</html>