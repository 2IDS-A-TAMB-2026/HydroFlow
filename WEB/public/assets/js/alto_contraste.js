document.addEventListener('DOMContentLoaded', function () {
    const btnContraste = document.getElementById('btn-contraste');
    const body = document.body;

    if (!btnContraste) return; // Evita erro caso o botão não exista na tela

    // Restaura preferência salva
    if (localStorage.getItem('altoContraste') === 'ativado') {
        body.classList.add('alto-contraste');
    }

    // Toggle do contraste
    btnContraste.addEventListener('click', function () {
        body.classList.toggle('alto-contraste');

        if (body.classList.contains('alto-contraste')) {
            localStorage.setItem('altoContraste', 'ativado');
        } else {
            localStorage.setItem('altoContraste', 'desativado');
        }
    });
});