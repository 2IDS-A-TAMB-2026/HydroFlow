document.querySelector("#form")

form.addEventListener("submit", function(e){
    let email = document.getElementById("email").value;
    let senha = document.getElementById("password").value;

    e.preventDefault();

    let isValid = true;

    let inputs = form.querySelectorAll("input");

     inputs.forEach(function(input) {
        // Pega o elemento <span> que está exatamente abaixo do input atual no HTML
        let spanErro = input.nextElementSibling; 
        
        // Verifica se está vazio
        if (input.value.trim() === "") {
            input.classList.add("erro-borda"); // Pinta a borda de vermelho
            if (spanErro) {
                spanErro.innerText = "Preencha este campo para poder enviar";
            }
            isValid = false; // Bloqueia o envio
        } else {
            input.classList.remove("erro-borda"); // Remove a borda vermelha se estiver preenchido
            if (spanErro) {
                spanErro.innerText = ""; // Limpa a mensagem
            }
        }
    });
})