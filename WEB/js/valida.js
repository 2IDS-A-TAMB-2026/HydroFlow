let form = document.querySelector("#form");

form.addEventListener("submit", function(e){

    let nome = document.getElementById("nome").value;
    let cpf = document.getElementById("cpf").value;
    let email = document.getElementById("email").value;
    let cep = document.getElementById("cep").value;
    let rua = document.getElementById("rua").value;
    let bairro = document.getElementById("bairro").value;
    let numero = document.getElementById("numero").value;
    let cidade = document.getElementById("cidade").value;
    let uf = document.getElementById("uf").value;
    let senha = document.getElementById("senha").value;
    let confirmarSenha = document.getElementById("confirmar-senha").value;

    // Impede o formulário de enviar imediatamente
    e.preventDefault(); 

    let isValid = true;
    
    // Pega todos os inputs
    let inputs = form.querySelectorAll("input");

    // 1. vê se tem algum vazio nesse bglh
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

    // 2. VERIFICA SE AS SENHAS BATEM
    
    // Só faz essa checagem se as senhas não estiverem vazias
    if (senha !== "" && confirmarSenha !== "" && senha !== confirmarSenha) {
        confirmarSenha.classList.add("erro-borda");
        confirmarSenha.nextElementSibling.innerText = "Ambas as senhas devem ser iguais!";
        isValid = false;
    }

    // 3. SE TUDO ESTIVER CERTO, ENVIA!
    if (isValid) {
        alert("Show! Cadastro validado com sucesso.");
        
        let cpfLimpo = mascaraCpf.unmaskedValue; 
        let cepLimpo = mascaraCep.unmaskedValue;
        
        console.log(nome);
        console.log(cpfLimpo);
        console.log(email);
        console.log(cepLimpo);
        console.log(rua);
        console.log(numero);
        console.log(bairro);
        console.log(cidade);
        console.log(uf);
    }
});

// máscara pros bglh do cpf e pro CEP

const inputCpf = document.getElementById('cpf');
const inputCep = document.getElementById('cep');

// Cria as máscaras
const mascaraCpf = IMask(inputCpf, { mask: '000.000.000-00' });
const mascaraCep = IMask(inputCep, { mask: '00000-000' });