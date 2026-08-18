document.addEventListener("DOMContentLoaded", function() {
    const ctx = document.getElementById('vendasChart').getContext('2d');
    
    const vendasChart = new Chart(ctx, {
        type: 'bar',
        data: {
            // Datas exatas da imagem
            labels: ['31/08/2018', '03/09/2018'],
            datasets: [{
                label: 'Vendas',
                // Valores da imagem
                data: [2.00, 66.00],
                // Cor do gráfico (Azul claro da imagem)
                backgroundColor: 'rgba(179, 223, 255, 0.9)', 
                borderColor: 'rgba(100, 180, 255, 1)',
                borderWidth: 1,
                barPercentage: 0.4 // Deixa a barra mais fina, similar ao print
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false // Esconde a legenda para ficar igual à foto
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    max: 70, // Limite superior para parecer com a imagem
                    title: {
                        display: true,
                        text: 'R$ Total Geral'
                    }
                },
                x: {
                    title: {
                        display: true,
                        text: 'Data'
                    }
                }
            }
        }
    });
});