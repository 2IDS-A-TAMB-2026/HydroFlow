// Espera que toda a página HTML seja carregada antes de rodar o código
    document.addEventListener("DOMContentLoaded", function() {
        
        // 1. Encontrar os elementos na tela usando os IDs que criamos
        const botaoExportar = document.getElementById("btn-exportar");
        const areaParaExportar = document.getElementById("tabela-historico");

        // 2. Adicionar uma ação (evento) para quando o botão for clicado
        botaoExportar.addEventListener("click", function() {
            
            // Variável opcional para mostrar que está carregando (muda o texto do botão)
            const textoOriginal = botaoExportar.innerHTML;
            botaoExportar.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Gerando PDF...';

            // 3. Configurações de como o PDF vai ficar
            const opcoesPDF = {
                margin:       10, // Margem das bordas (em mm)
                filename:     'historico_irrigacao.pdf', // Nome do arquivo que será baixado
                image:        { type: 'jpeg', quality: 0.98 }, // Qualidade da "foto" que ele tira do HTML
                html2canvas:  { scale: 2 }, // Aumenta a escala para o PDF não ficar embaçado (resolução)
                jsPDF:        { unit: 'mm', format: 'a4', orientation: 'landscape' } // Formato A4, 'landscape' = paisagem (deitado)
            };

            // 4. Comando da biblioteca que pega a área, aplica as opções e salva o PDF
            html2pdf()
                .set(opcoesPDF) // Aplica as configurações
                .from(areaParaExportar) // Diz qual parte do HTML copiar
                .save() // Faz o download do arquivo
                .then(function() {
                    // Quando terminar de baixar, volta o botão ao normal
                    botaoExportar.innerHTML = textoOriginal;
                });
        });
    });