
<main class="main-content" style="flex: 1; padding: 30px; background-color: #f4f6f9; overflow-y: auto; font-family: Arial, sans-serif;">
    
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

    <div class="kpi-cards">
        
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

    <div style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-bottom: 30px;">
        <h3 style="color: #333; font-size: 1.2rem; margin-top: 0; margin-bottom: 20px; font-weight: 600;">
            <i class="fa-solid fa-chart-line" style="color: #007bff; margin-right: 8px;"></i> Volume Consumido de Água (Últimos 7 dias)
        </h3>
        <div style="height: 300px; width: 100%;">
            <canvas id="graficoGlobalAdmin"></canvas>
        </div>
    </div>

    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; margin-bottom: 30px;">
        
        <div style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); display: flex; flex-direction: column; justify-content: space-between;">
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

        <div style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); display: flex; flex-direction: column; justify-content: space-between;">
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

        <div style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); display: flex; flex-direction: column; justify-content: space-between;">
            <div>
                <div style="background-color: rgba(108, 117, 125, 0.1); color: #6c757d; width: 50px; height: 50px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 15px;">
                    <i class="fa-solid fa-id-card-clip"></i>
                </div>
                <h3 style="color: #333; font-size: 1.2rem; margin: 0 0 10px 0; font-weight: 600;">Configurações do Perfil</h3>
                <p style="color: #666; font-size: 0.9rem; line-height: 1.5; margin-bottom: 20px;">Modifique suas credenciais de segurança do administrador master, troque e-mails e chaves de criptografia.</p>
            </div>
            <a href="<?= base_url('admin/usuarios/editar-perfil') ?>" style="display: block; text-align: center; background: #6c757d; color: white; padding: 12px; text-decoration: none; border-radius: 8px; font-weight: 600; font-size: 0.95rem; box-shadow: 0 4px 10px rgba(108,117,125,0.15);">
                Editar Dados
            </a>
        </div>

    </div>

    <div style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
        <h3 style="color: #333; font-size: 1.2rem; margin-top: 0; margin-bottom: 20px; font-weight: 600;">
            <i class="fa-solid fa-clock-rotate-left" style="color: #17a2b8; margin-right: 8px;"></i> Últimas Irrigações do Sistema (Auditoria Global)
        </h3>
        <div style="overflow-x: auto;">
            <table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 0.9rem;">
                <thead>
                    <tr style="border-bottom: 2px solid #eee; color: #666; font-weight: bold;">
                        <th style="padding: 12px 8px;">Data/Hora</th>
                        <th style="padding: 12px 8px;">Usuário</th>
                        <th style="padding: 12px 8px;">Planta</th>
                        <th style="padding: 12px 8px;">Dispositivo</th>
                        <th style="padding: 12px 8px;">Volume (L)</th>
                        <th style="padding: 12px 8px;">Status</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if(!empty($ultimas_irrigacoes)): ?>
                        <?php foreach($ultimas_irrigacoes as $irrigacao): ?>
                            <tr style="border-bottom: 1px solid #eee; color: #444;">
                                <td style="padding: 12px 8px;"><?= date('d/m/Y', strtotime($irrigacao['IRR_DATA'])) ?> - <?= $irrigacao['IRR_HORA'] ?></td>
                                <td style="padding: 12px 8px;"><b><?= esc($irrigacao['nome_usuario']) ?></b></td>
                                <td style="padding: 12px 8px;"><?= esc($irrigacao['nome_planta']) ?></td>
                                <td style="padding: 12px 8px;"><code style="background: #f1f1f1; padding: 3px 6px; border-radius: 4px;"><?= esc($irrigacao['nome_dispositivo']) ?></code></td>
                                <td style="padding: 12px 8px;"><?= number_format($irrigacao['IRR_VOLUME'], 2, ',', '.') ?> L</td>
                                <td style="padding: 12px 8px;">
                                    <?php if($irrigacao['IRR_STATUS'] == 'Concluído'): ?>
                                        <span style="background: #d4edda; color: #155724; padding: 4px 8px; border-radius: 20px; font-size: 0.8rem; font-weight: bold;">Concluído</span>
                                    <?php else: ?>
                                        <span style="background: #f8d7da; color: #721c24; padding: 4px 8px; border-radius: 20px; font-size: 0.8rem; font-weight: bold;">Falha</span>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="6" style="padding: 20px; text-align: center; color: #999;">Nenhuma irrigação registrada na malha global até o momento.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>

</main>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        
        // 1. Renderização Dinâmica do Gráfico de Telemetria
        const ctx = document.getElementById('graficoGlobalAdmin').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: <?= json_encode($grafico_labels) ?>,
                datasets: [{
                    label: 'Volume de Água (Litros)',
                    data: <?= json_encode($grafico_valores) ?>,
                    backgroundColor: 'rgba(0, 180, 219, 0.1)',
                    borderColor: '#0083b0',
                    borderWidth: 3,
                    pointBackgroundColor: '#00b4db',
                    pointBorderColor: '#fff',
                    pointRadius: 5,
                    tension: 0.3,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.05)' } },
                    x: { grid: { display: false } }
                }
            }
        });

        // 2. Interceptador de Logout Amigável (SweetAlert2)
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
