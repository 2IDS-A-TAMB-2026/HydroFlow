// Pega o botão e o body
const btnContraste = document.getElementById('btn-contraste');
const body = document.body;

// Verifica se o usuário já tinha deixado o alto contraste ligado antes
if (localStorage.getItem('altoContraste') === 'ativado') {
    body.classList.add('alto-contraste');
}

// O que acontece quando clica no botão
btnContraste.addEventListener('click', function() {
    // Liga ou desliga a classe no body
    body.classList.toggle('alto-contraste');
    
    // Salva a preferência do usuário no navegador
    if (body.classList.contains('alto-contraste')) {
        localStorage.setItem('altoContraste', 'ativado');
    } else {
        localStorage.setItem('altoContraste', 'desativado');
    }
});