document.addEventListener("DOMContentLoaded", function () {
    // Procura pelo canvas do radar
    const canvas = document.getElementById('kpiRadarChart');
    if (!canvas) return;

    // Pega os dados dos atributos data-* passados pelo PHP
    const ativos   = parseFloat(canvas.dataset.ativos)   || 0;
    const alertas  = parseFloat(canvas.dataset.alertas)  || 0;
    const plantas  = parseFloat(canvas.dataset.plantas)  || 0;
    const inativos = parseFloat(canvas.dataset.inativos) || 0;

    const ctx = canvas.getContext('2d');

    new Chart(ctx, {
        type: 'radar',
        data: {
            labels: [
                'Dispositivos Ativos',
                'Alertas Não Verificados',
                'Plantas Cadastradas',
                'Dispositivos Inativos'
            ],
            datasets: [{
                label: 'Métricas do Sistema',
                data: [ativos, alertas, plantas, inativos],
                backgroundColor: 'rgba(54, 162, 235, 0.2)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 2,
                pointBackgroundColor: 'rgba(54, 162, 235, 1)',
                pointBorderColor: '#fff',
                pointHoverBackgroundColor: '#fff',
                pointHoverBorderColor: 'rgba(54, 162, 235, 1)'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                r: {
                    angleLines: {
                        display: true
                    },
                    suggestedMin: 0
                }
            },
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });
});