// --- 1. SEU SCRIPT DE ALTO CONTRASTE (Inalterado) ---
const btnContraste = document.getElementById('btn-contraste');
const body = document.body;

if (localStorage.getItem('altoContraste') === 'ativado') {
    body.classList.add('alto-contraste');
}

btnContraste.addEventListener('click', function() {
    body.classList.toggle('alto-contraste');
    
    if (body.classList.contains('alto-contraste')) {
        localStorage.setItem('altoContraste', 'ativado');
    } else {
        localStorage.setItem('altoContraste', 'desativado');
    }
});
// ------ 2. Menu e fonte
document.addEventListener('DOMContentLoaded', () => {
    const toggleBtn = document.getElementById('btnAccessibilityToggle');
    const menu = document.getElementById('accessibilityMenu');
    const btnIncreaseFont = document.getElementById('btnIncreaseFont');
    const btnDecreaseFont = document.getElementById('btnDecreaseFont');

    // 1. Alternar exibição do menu
    if (toggleBtn && menu) {
        toggleBtn.addEventListener('click', () => {
            menu.classList.toggle('hidden');
        });
    }

    // 2. Controle de Fonte Seguro (Altera o font-size do <html>)
    let currentFontSize = parseFloat(localStorage.getItem('userFontSize')) || 16;
    document.documentElement.style.fontSize = `${currentFontSize}px`;

    if (btnIncreaseFont) {
        btnIncreaseFont.addEventListener('click', () => {
            if (currentFontSize < 20) { // Limite máximo para não quebrar a tela
                currentFontSize += 1;
                document.documentElement.style.fontSize = `${currentFontSize}px`;
                localStorage.setItem('userFontSize', currentFontSize);
            }
        });
    }

    if (btnDecreaseFont) {
        btnDecreaseFont.addEventListener('click', () => {
            if (currentFontSize > 13) { // Limite mínimo
                currentFontSize -= 1;
                document.documentElement.style.fontSize = `${currentFontSize}px`;
                localStorage.setItem('userFontSize', currentFontSize);
            }
        });
    }
});
