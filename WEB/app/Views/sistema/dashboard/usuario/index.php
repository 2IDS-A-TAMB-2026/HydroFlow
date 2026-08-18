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


    <section class="bottom-grid">
        
        <div class="widget table-widget">
            <h3>Últimos Status de Irrigação</h3>
            <table class="modern-table">
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
                                        
                                        if ($irr['IRR_STATUS'] === 'Falha') { 
                                            $badgeClass = 'badge-red'; 
                                            $textoBadge = 'FALHA'; 
                                        }
                                        if ($irr['IRR_STATUS'] === 'Interrompido' || $irr['IRR_STATUS'] === 'Alerta') { 
                                            $badgeClass = 'badge-yellow'; 
                                            $textoBadge = 'ALERTA'; 
                                        }
                                    ?>
                                    <span class="<?= $badgeClass ?>"><?= $textoBadge ?></span>
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
            <h3 class="chart-title"><i class="fa-solid fa-circle-nodes" style="color: #00a65a;"></i> Visão Geral do Ecossistema</h3>
            <div class="chart-container" style="position: relative; height: 380px; width: 100%;">
                <canvas id="vendasChart"></canvas>
            </div>
        </div>
    </section>
</main>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    const labelsDoBanco = <?= json_encode($grafico_labels) ?>;
    const valoresDoBanco = <?= json_encode($grafico_valores) ?>;

    function normalizarParaEscala(valores) {
        const ativos = valores[0];
        const inativos = valores[1];
        const alertas = valores[2];
        const plantas = valores[3];
        const consumo = valores[4];

        const maxAtivos = 5;    
        const maxInativos = 5;  
        const maxAlertas = 10;  
        const maxPlantas = 10;  
        const maxConsumo = 500; 

        return [
            Math.min((ativos / maxAtivos) * 10, 10),
            Math.min((inativos / maxInativos) * 10, 10),
            Math.min((alertas / maxAlertas) * 10, 10),
            Math.min((plantas / maxPlantas) * 10, 10),
            Math.min((consumo / maxConsumo) * 10, 10)
        ];
    }

    const v = normalizarParaEscala(valoresDoBanco);

    const coresFatias = [
        { border: 'rgba(0, 188, 212, 1)',   bg: 'rgba(0, 188, 212, 0.4)' }, 
        { border: 'rgba(233, 30, 99, 1)',   bg: 'rgba(233, 30, 99, 0.4)' }, 
        { border: 'rgba(255, 152, 0, 1)',   bg: 'rgba(255, 152, 0, 0.4)' }, 
        { border: 'rgba(76, 175, 80, 1)',   bg: 'rgba(76, 175, 80, 0.4)' }, 
        { border: 'rgba(33, 150, 243, 1)',  bg: 'rgba(33, 150, 243, 0.4)' } 
    ];

    const pluginFatiasColoridas = {
        id: 'pluginFatiasColoridas',
        beforeDraw(chart) {
            const { ctx, scales: { r } } = chart;
            const centroX = r.xCenter;
            const centroY = r.yCenter;
            const metaData = chart.getDatasetMeta(0).data;

            if (!metaData || metaData.length === 0) return;

            metaData.forEach((ponto, i) => {
                const proximoIndice = (i + 1) % metaData.length;
                const proximoPonto = metaData[proximoIndice];

                ctx.save();
                ctx.beginPath();
                
                ctx.moveTo(centroX, centroY);
                ctx.lineTo(ponto.x, ponto.y);
                ctx.lineTo(proximoPonto.x, proximoPonto.y);
                ctx.closePath();

                ctx.fillStyle = coresFatias[i].bg;
                ctx.fill();

                ctx.strokeStyle = coresFatias[i].border;
                ctx.lineWidth = 3;
                ctx.beginPath();
                ctx.moveTo(ponto.x, ponto.y);
                ctx.lineTo(proximoPonto.x, proximoPonto.y);
                ctx.stroke();

                ctx.restore();
            });
        }
    };

    document.addEventListener("DOMContentLoaded", function() {
        const ctx = document.getElementById('vendasChart').getContext('2d');
        
        new Chart(ctx, {
            type: 'radar',
            data: {
                labels: labelsDoBanco, 
                datasets: [{
                    label: 'Métricas do Sistema',
                    data: v, 
                    borderColor: 'transparent', 
                    backgroundColor: 'transparent', 
                    pointBackgroundColor: coresFatias.map(c => c.border), 
                    pointBorderColor: '#fff',
                    pointRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    r: {
                        suggestMin: 0,
                        suggestMax: 10,
                        ticks: {
                            display: false,
                            backdropColor: 'transparent'
                        },
                        angleLines: { display: true }
                    }
                },
                plugins: {
                    legend: { display: false }, 
                    tooltip: {
                        enabled: true,
                        position: 'average',
                        backgroundColor: 'rgba(20, 20, 20, 0.95)',
                        titleColor: '#fff',
                        bodyColor: '#fff',
                        z: 9999,
                        callbacks: {
                            label: function(context) {
                                const indice = context.dataIndex;
                                const valorReal = valoresDoBanco[indice];
                                const label = labelsDoBanco[indice];
                                
                                if (label === 'Consumo Total (L)') {
                                    return `${label}: ${valorReal.toFixed(1)} L`;
                                } else {
                                    return `${label}: ${valorReal}`;
                                }
                            }
                        }
                    }
                }
            },
            plugins: [pluginFatiasColoridas]
        });
    });
</script>
</body>
</html>