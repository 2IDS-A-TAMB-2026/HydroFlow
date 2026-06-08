<?= view("sistema/layout/dashboard/usuario/header") ?>

    <section class="kpi-cards">
        <div class="card card-cyan">
            <div class="card-content">
                <h3><?= $total_ativos ?></h3>
                <p>Dispositivos Ativos</p>
            </div>
            <i class="fa-solid fa-hard-drive card-icon"></i>
            <div class="card-footer"></div>
        </div>
        <div class="card card-orange">
            <div class="card-content">
                <h3><?= $total_alertas ?></h3>
                <p>Alertas (Falhas)</p>
            </div>
            <i class="fa-solid fa-triangle-exclamation card-icon"></i>
            <div class="card-footer"></div>
        </div>
        <div class="card card-green">
            <div class="card-content">
                <h3><?= $total_plantas ?></h3>
                <p>Plantas Cadastradas</p>
            </div>
            <i class="fa-solid fa-seedling card-icon"></i>
            <div class="card-footer"></div>
        </div>
        <div class="card card-red">
            <div class="card-content">
                <h3><?= $total_inativos ?></h3>
                <p>Dispositivos Inativos</p>
            </div>
            <i class="fa-solid fa-bug card-icon"></i>
            <div class="card-footer"></div>
        </div>
    </section>

    <section class="bottom-grid" style="display: grid; grid-template-columns: 1fr 2fr; gap: 20px; align-items: start;">
        
        <div class="widget table-widget" style="background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
            <h3>Últimos Status de Irrigação</h3>
            <table>
                <thead>
                    <tr>
                        <th>Planta</th>
                        <th>Dispositivo</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if(!empty($ultimas_irrigacoes) && is_array($ultimas_irrigacoes)): ?>
                        <?php foreach($ultimas_irrigacoes as $irr): ?>
                            <tr>
                                <td><strong><?= esc($irr['nome_planta']) ?></strong></td>
                                <td><?= esc($irr['nome_dispositivo']) ?></td>
                                <td>
                                    <?php 
                                        $badgeClass = 'badge-green';
                                        $textoBadge = 'IRRIGADO';
                                        if ($irr['IRR_STATUS'] === 'Falha') { $badgeClass = 'badge-red'; $textoBadge = 'FALHA'; }
                                        if ($irr['IRR_STATUS'] === 'Interrompido') { $badgeClass = 'badge-yellow'; $textoBadge = 'ALERTA'; }
                                    ?>
                                    <span class="status-badge <?= $badgeClass ?>"><?= $textoBadge ?></span>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="3" style="text-align: center; color: #888;">Nenhuma rega executada recentemente.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>

        <div class="widget chart-widget" style="background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); height: 100%;">
            <h3 class="chart-title"><i class="fa-solid fa-chart-line" style="color: #00a65a;"></i> Consumo de Água Recente (Litros)</h3>
            <div class="chart-container" style="position: relative; height: 380px; width: 100%;">
                <canvas id="vendasChart"></canvas>
            </div>
        </div>
    </section>
</main>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    //  O PHP renderiza as arrays do banco em formato JSON válido para o JavaScript ler
    const labelsDoBanco = <?= json_encode($grafico_labels) ?>;
    const valoresDoBanco = <?= json_encode($grafico_valores) ?>;

    document.addEventListener("DOMContentLoaded", function() {
        const ctx = document.getElementById('vendasChart').getContext('2d');
        
        new Chart(ctx, {
            type: 'line', // Transforma em um gráfico de linha contínuo elegante
            data: {
                labels: labelsDoBanco, // Injetado via PHP
                datasets: [{
                    label: 'Volume de Água Gasto (L)',
                    data: valoresDoBanco, // Injetado via PHP
                    backgroundColor: 'rgba(0, 166, 90, 0.1)',
                    borderColor: '#00a65a', // Verde padrão do seu sistema
                    borderWidth: 3,
                    tension: 0.3, // Deixa a linha suave e curvada
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false, // Permite que o gráfico preencha a altura da div do CSS
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    });
</script>
</body>
</html>