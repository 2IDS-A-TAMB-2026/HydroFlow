<main class="main-content" style="flex: 1; padding: 30px; background-color: #f4f6f9; overflow-y: auto; font-family: Arial, sans-serif;">
    
    <!-- HEADER -->
    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
        <div>
            <h2 style="color: #1e3c72; font-size: 1.8rem; font-weight: 600; margin: 0;">
                <i class="fa-solid fa-lock-open"></i> Painel do Administrador
            </h2>
            <p style="color: #666; margin-top: 5px; margin-bottom: 0;">
                Olá, <b><?= session()->get('ADM_NOME') ?? 'Administrador' ?></b>. Selecione uma opção para gerenciar o sistema global.
            </p>
        </div>
        <a href="<?= base_url('logout') ?>" id="btn-logout" style="background-color: #dc3545; color: white; padding: 10px 20px; text-decoration: none; border-radius: 8px; font-weight: bold; display: flex; align-items: center; gap: 8px; box-shadow: 0 4px 10px rgba(220, 53, 69, 0.2); transition: all 0.3s;">
            <i class="fa-solid fa-right-from-bracket"></i> Sair do Sistema
        </a>
    </div>

    <!-- CARDS KPI -->
    <div class="kpi-cards" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 30px;">
        
        <div class="card card-cyan">
            <div class="card-content">
                <h3><?= esc($dispositivosAtivos ?? $total_ativos ?? 0) ?></h3>
                <p>Dispositivos Ativos</p>
            </div>
            <div class="card-icon">
                <i class="fa-solid fa-server"></i>
            </div>
        </div>

        <div class="card card-orange">
            <div class="card-content">
                <h3><?= esc($totalFalhas ?? $total_falhas ?? 0) ?></h3>
                <p>Alertas (Falhas)</p>
            </div>
            <div class="card-icon">
                <i class="fa-solid fa-triangle-exclamation"></i>
            </div>
        </div>

        <div class="card card-green">
            <div class="card-content">
                <h3><?= esc($totalUsuarios ?? $total_usuarios ?? 0) ?></h3>
                <p>Usuários na Base</p>
            </div>
            <div class="card-icon">
                <i class="fa-solid fa-users"></i>
            </div>
        </div>

        <div class="card card-red">
            <div class="card-content">
                <h3><?= esc($dispositivosInativos ?? $total_inativos ?? 0) ?></h3>
                <p>Dispositivos Inativos</p>
            </div>
            <div class="card-icon">
                <i class="fa-solid fa-bug"></i>
            </div>
        </div>

    </div>

    <!-- SEÇÃO DO GRÁFICO RADAR -->
    <div class="grafRadar" style="">
        <h3 style0="color: #333; font-size: 1.2rem; margin-top: 0; margin-bottom: 20px; font-weight: 600;">
            <i class="fa-solid fa-chart-pie" style="color: #007bff; margin-right: 8px;"></i> Visão Geral dos Indicadores do Sistema (KPIs)
        </h3>
        <div style="position: relative; height: 350px; width: 100%; max-width: 700px; margin: 0 auto;">
            <canvas id="graficoGlobalAdmin"></canvas>
        </div>
    </div>

    <!-- CARDS DE AÇÃO (SERVIÇOS/GESTÃO) -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; margin-bottom: 30px;">
        
        <div class ="ctUsu"style="">
            <div>
                <div style="background-color: rgba(0, 123, 255, 0.1); color: #007bff; width: 50px; height: 50px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 15px;">
                    <i class="fa-solid fa-users-gear"></i>
                </div>
                <h3 style="color: #333; font-size: 1.2rem; margin: 0 0 10px 0; font-weight: 600;">Controle de Usuários</h3>
                <p style="color: #666; font-size: 0.9rem; line-height: 1.5; margin-bottom: 20px;">Gerencie permissões de operadores, visualize dados de acesso e remova ou suspenda contas da base.</p>
            </div>
            <a href="<?= base_url('admin/usuarios') ?>" style="display: block; text-align: center; background: #007bff; color: white; padding: 12px; text-decoration: none; border-radius: 8px; font-weight: 600; font-size: 0.95rem; box-shadow: 0 4px 10px rgba(0,123,255,0.15);">
                Gerenciar Acessos
            </a>
        </div>

        <div class="ctSen" style="">
            <div>
                <div style="background-color: rgba(40, 167, 69, 0.1); color: #28a745; width: 50px; height: 50px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 15px;">
                    <i class="fa-solid fa-microchip"></i>
                </div>
                <h3 style="color: #333; font-size: 1.2rem; margin: 0 0 10px 0; font-weight: 600;">Malha de Sensores</h3>
                <p style="color: #666; font-size: 0.9rem; line-height: 1.5; margin-bottom: 20px;">Integre novos dispositivos físicos de leitura de umidade e fluxo de água ao ecossistema HydroFlow.</p>
            </div>
            <a href="<?= base_url('admin/dispositivos/') ?>" style="display: block; text-align: center; background: #28a745; color: white; padding: 12px; text-decoration: none; border-radius: 8px; font-weight: 600; font-size: 0.95rem; box-shadow: 0 4px 10px rgba(40,167,69,0.15);">
                Novo Sensor
            </a>
        </div>


    </div>

    
    <!-- CENTRAL DE MONITORAMENTO DOS DISPOSITIVOS -->
    <div class="cmd"style="">

        <div style="display: flex; justify-content: space-between;
                    align-items: center; flex-wrap: wrap; gap: 12px;
                    margin-bottom: 20px;">

            <div>
                <h3 style="color: #333; font-size: 1.2rem;
                        margin: 0 0 6px; font-weight: 600;">
                    <i class="fa-solid fa-tower-broadcast"
                    style="color: #17a2b8; margin-right: 8px;"></i>
                    Central de Monitoramento
                </h3>

                <p style="color: #777; font-size: 0.9rem; margin: 0;">
                    Acompanhe a situação dos dispositivos cadastrados.
                </p>
            </div>

            <a href="<?= base_url('admin/dispositivos/') ?>"
            style="background: #007bff; color: white; padding: 10px 16px;
                    border-radius: 7px; text-decoration: none;
                    font-weight: 600; font-size: 0.9rem;">
                <i class="fa-solid fa-microchip"></i>
                Gerenciar dispositivos
            </a>
        </div>

        <div style="overflow-x: auto;">
            <table style="width: 100%; border-collapse: collapse;
                        text-align: left; font-size: 0.9rem;">

                <thead>
                    <tr style="border-bottom: 2px solid #eee; color: #666;">
                        <th style="padding: 14px 10px;">ID</th>
                        <th style="padding: 14px 10px;">Dispositivo</th>
                        <th style="padding: 14px 10px;">Responsável</th>
                        <th style="padding: 14px 10px;">Estado</th>
                        <th style="padding: 14px 10px;">Última comunicação</th>
                    </tr>
                </thead>

                <tbody>
                    <?php if (!empty($dispositivos_monitoramento)): ?>

                        <?php foreach ($dispositivos_monitoramento as $disp): ?>
                            <?php
                                $status = strtoupper(trim($disp['DIS_STATUS'] ?? ''));
                                $ativo = ($status === 'ATIVO');
                            ?>

                            <tr style="border-bottom: 1px solid #eee; color: #444;">

                                <td style="padding: 15px 10px;">
                                    #<?= esc($disp['DIS_ID']) ?>
                                </td>

                                <td style="padding: 15px 10px;">
                                    <div style="display: flex; align-items: center; gap: 10px;">
                                        <div style="width: 36px; height: 36px;
                                                    border-radius: 8px;
                                                    background: #eaf2ff; color: #007bff;
                                                    display: flex; align-items: center;
                                                    justify-content: center;">
                                            <i class="fa-solid fa-microchip"></i>
                                        </div>

                                        <strong>
                                            <?= esc($disp['DIS_NOME'] ?? 'Sem nome') ?>
                                        </strong>
                                    </div>
                                </td>

                                <td style="padding: 15px 10px;">
                                    <?= esc($disp['nome_usuario'] ?? 'Não identificado') ?>
                                </td>

                                <td style="padding: 15px 10px;">
                                    <?php if ($ativo): ?>
                                        <span class="spanAtivoo">
                                            <i class="fa-solid fa-circle-check"></i>
                                            Ativo
                                        </span>
                                    <?php else: ?>
                                        <span class="spanInativoo" style="">
                                            <i class="fa-solid fa-circle-xmark"></i>
                                            Inativo
                                        </span>
                                    <?php endif; ?>
                                </td>
                                <td style="padding: 15px 10px;">
                                    <?php if (!empty($disp['ultima_data']) && !empty($disp['ultima_hora'])): ?>
                                        <?= esc(date('d/m/Y', strtotime($disp['ultima_data']))) ?>
                                        <?= esc($disp['ultima_hora']) ?>
                                    <?php else: ?>
                                        <span style="color: #999;">Nenhuma medição</span>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>

                    <?php else: ?>
                        <tr>
                            <td colspan="6"
                                style="padding: 30px; text-align: center; color: #999;">
                                <i class="fa-solid fa-server"
                                style="font-size: 1.5rem; display: block;
                                        margin-bottom: 10px;"></i>
                                Nenhum dispositivo cadastrado.
                            </td>
                        </tr>
                    <?php endif; ?>
                </tbody>

            </table>
        </div>
    </div>


</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        
        // Renderização Dinâmica do Gráfico RADAR
            const ctx = document.getElementById('graficoGlobalAdmin').getContext('2d');

            const graficoRadar = new Chart(ctx, {
                type: 'radar',

                data: {
                    labels: [
                        'Dispositivos Ativos',
                        'Alertas (Falhas)',
                        'Usuários na Base',
                        'Dispositivos Inativos'
                    ],

                    datasets: [{
                        label: 'Métricas do Sistema',

                        data: [
                            <?= (int)($dispositivosAtivos ?? $total_ativos ?? 0) ?>,
                            <?= (int)($totalFalhas ?? $total_falhas ?? 0) ?>,
                            <?= (int)($totalUsuarios ?? $total_usuarios ?? 0) ?>,
                            <?= (int)($dispositivosInativos ?? $total_inativos ?? 0) ?>
                        ],

                        backgroundColor: 'rgba(0, 123, 255, 0.25)',
                        borderColor: '#007bff',
                        borderWidth: 2,
                        pointBackgroundColor: '#007bff',
                        pointBorderColor: '#fff',
                        pointHoverBackgroundColor: '#fff',
                        pointHoverBorderColor: '#007bff',
                        pointRadius: 5
                    }]
                },

                options: {
                    responsive: true,
                    maintainAspectRatio: false,

                    plugins: {
                        legend: {
                            display: false
                        }
                    },

                    scales: {
                        r: {
                            angleLines: {
                                color: document.body.classList.contains('alto-contraste')
                                    ? 'rgba(169, 192, 214, 0.4)'
                                    : 'rgba(0, 0, 0, 0.1)'
                            },

                            grid: {
                                color: document.body.classList.contains('alto-contraste')
                                    ? 'rgba(169, 192, 214, 0.25)'
                                    : 'rgba(0, 0, 0, 0.08)'
                            },

                            suggestedMin: 0,
                            suggestedMax: 35,

                            ticks: {
                                stepSize: 10,
                                backdropColor: 'transparent',

                                color: document.body.classList.contains('alto-contraste')
                                    ? '#F2F6FA'
                                    : '#666',

                                font: {
                                    size: 11
                                }
                            },

                            pointLabels: {
                                font: {
                                    size: 12,
                                    weight: 'bold'
                                },

                                color: document.body.classList.contains('alto-contraste')
                                    ? '#FFFFFF'
                                    : '#333'
                            }
                        }
                    }
                }
            });


            // Atualização das cores ao alternar o alto contraste
            const btnContraste = document.getElementById('btn-contraste');

            if (btnContraste) {
                btnContraste.addEventListener('click', function () {

                    // Verifica o estado atualizado do alto contraste
                    const escuro = document.body.classList.contains('alto-contraste');

                    const escala = graficoRadar.options.scales.r;

                    // Textos ao redor do gráfico
                    escala.pointLabels.color = escuro
                        ? '#FFFFFF'
                        : '#333';

                    // Números da escala
                    escala.ticks.color = escuro
                        ? '#F2F6FA'
                        : '#666';

                    // Linhas da grade
                    escala.grid.color = escuro
                        ? 'rgba(169, 192, 214, 0.25)'
                        : 'rgba(0, 0, 0, 0.08)';

                    // Linhas que partem do centro
                    escala.angleLines.color = escuro
                        ? 'rgba(169, 192, 214, 0.4)'
                        : 'rgba(0, 0, 0, 0.1)';

                    // Aplica as alterações no gráfico
                    graficoRadar.update();
                });
            }

        // Interceptador de Logout Amigável (SweetAlert2)
        const btnLogout = document.getElementById('btn-logout');
        if (btnLogout) {
            btnLogout.addEventListener('click', function(e) {
                e.preventDefault();
                const url = this.getAttribute('href');

                Swal.fire({
                    title: 'Deseja encerrar a sessão?',
                    text: "As credenciais e o painel de auditoria do administrador master serão bloqueados.",
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#dc3545',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Sair Agora',
                    cancelButtonText: 'Ficar',
                    reverseButtons: true
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = url;
                    }
                });
            });
        }
    });
</script>