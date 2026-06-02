let form = document.querySelector("#form");

form.addEventListener("submit", function(e){

    // 1. Pegamos os ELEMENTOS do DOM para poder manipular classes e spans depois
    let inputSenha = document.getElementById("senha");
    let inputConfirmarSenha = document.getElementById("confirmar-senha");

    // 2. Pegamos os VALORES para checagem rápida
    let nome = document.getElementById("nome").value;
    let cpf = document.getElementById("cpf").value;
    let email = document.getElementById("email").value;
    let cep = document.getElementById("cep").value;
    let rua = document.getElementById("rua").value;
    let bairro = document.getElementById("bairro").value;
    let numero = document.getElementById("numero").value;
    let cidade = document.getElementById("cidade").value;
    let uf = document.getElementById("uf").value;
    let senha = inputSenha.value;
    let confirmarSenha = inputConfirmarSenha.value;

    // Impede o formulário de enviar imediatamente
    e.preventDefault(); 

    let isValid = true;
    
    // Pega todos os inputs
    let inputs = form.querySelectorAll("input");

    // 1. Vê se tem algum vazio nesse bglh
    inputs.forEach(function(input) {
        // Pega o elemento <span> que está exatamente abaixo do input atual no HTML
        let spanErro = input.nextElementSibling; 
        
        // Verifica se está vazio
        if (input.value.trim() === "") {
            input.classList.add("erro-borda"); // Pinta a borda de vermelho
            if (spanErro && spanErro.tagName === "SPAN") {
                spanErro.innerText = "Preencha este campo para poder enviar";
                
            }
            Swal.fire({
                    title: "Erro de formulário...",
                    text: "Preencha todos os campos antes de confirmar o cadastro.",
                    icon: "error",
                    confirmButtonColor: "#d33"
                    });
            isValid = false; // Bloqueia o envio
        } else {
            input.classList.remove("erro-borda"); // Remove a borda vermelha se estiver preenchido
            if (spanErro && spanErro.tagName === "SPAN") {
                spanErro.innerText = ""; // Limpa a mensagem
            }
        }
    });

    // 2. VERIFICA SE AS SENHAS BATEM
    // Ajustado para aplicar o erro no elemento correto (inputConfirmarSenha)
    if (senha !== "" && confirmarSenha !== "" && senha !== confirmarSenha) {
        inputConfirmarSenha.classList.add("erro-borda");
        if (inputConfirmarSenha.nextElementSibling && inputConfirmarSenha.nextElementSibling.tagName === "SPAN") {
            inputConfirmarSenha.nextElementSibling.innerText = "Ambas as senhas devem ser iguais!";
        }
        isValid = false;
    }

    // 3. SE TUDO ESTIVER CERTO, ENVIA!
    if (isValid) {
        // SweetAlert de Sucesso 🎉
        Swal.fire({
            title: "Show!",
            text: "Cadastro validado com sucesso.",
            icon: "success",
            confirmButtonColor: "#3085d6",
            confirmButtonText: "Legal!"
        });
        
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
        
        // Se precisar limpar o formulário após o sucesso:
        // form.reset();
        // [Opcional] SweetAlert de Erro se o usuário tentar enviar com campos inválidos
    }
});

// Máscara pros bglh do cpf e pro CEP
const inputCpf = document.getElementById('cpf');
const inputCep = document.getElementById('cep');

// Cria as máscaras
const mascaraCpf = IMask(inputCpf, { mask: '000.000.000-00' });
const mascaraCep = IMask(inputCep, { mask: '00000-000' });