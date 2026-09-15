document.addEventListener("DOMContentLoaded", function () {

    const botaoAumentar = document.getElementById("btnIncreaseFont");
    const botaoDiminuir = document.getElementById("btnDecreaseFont");

    let tamanhoFonte = 100;

    const limiteMaximo = 150;
    const limiteMinimo = 80;

    function aplicarTamanhoFonte() {
        document.documentElement.style.fontSize = tamanhoFonte + "%";
    }

    if (botaoAumentar) {
        botaoAumentar.addEventListener("click", function () {

            if (tamanhoFonte < limiteMaximo) {
                tamanhoFonte += 10;
                aplicarTamanhoFonte();
            }

        });
    }

    if (botaoDiminuir) {
        botaoDiminuir.addEventListener("click", function () {

            if (tamanhoFonte > limiteMinimo) {
                tamanhoFonte -= 10;
                aplicarTamanhoFonte();
            }

        });
    }

});