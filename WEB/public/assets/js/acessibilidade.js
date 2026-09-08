// Aguarda a página carregar
document.addEventListener("DOMContentLoaded", function() {
    
    // Seleciona os botões pelos IDs
    const botaoAumentar = document.getElementById("aumentar-fonte");
    const botaoDiminuir = document.getElementById("diminuir-fonte");
    
    let tamanhoAtual = 100; // Começa em 100%
    const limiteMaximo = 150; // Não deixa aumentar mais que 150%
    const limiteMinimo = 80;  // Não deixa diminuir menos que 80%

    // Função para Aumentar
    botaoAumentar.addEventListener("click", function() {
        if (tamanhoAtual < limiteMaximo) {
            tamanhoAtual += 10; // Aumenta de 10% em 10%
            document.documentElement.style.fontSize = tamanhoAtual + "%";
        }
    });

    // Função para Diminuir
    botaoDiminuir.addEventListener("click", function() {
        if (tamanhoAtual > limiteMinimo) {
            tamanhoAtual -= 10; // Diminui de 10% em 10%
            document.documentElement.style.fontSize = tamanhoAtual + "%";
        }
    });
});