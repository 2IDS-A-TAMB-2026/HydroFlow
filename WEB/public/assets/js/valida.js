document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector("#form");
    const inputCpf = document.getElementById('cpf');
    const inputCep = document.getElementById('cep');

    // Inicialização das Máscaras (IMask)
    let mascaraCpf, mascaraCep;
    if (inputCpf) mascaraCpf = IMask(inputCpf, { mask: '000.000.000-00' });
    if (inputCep) mascaraCep = IMask(inputCep, { mask: '00000-000' });

    // -------------------------------------------------------------
    // FUNÇÕES AUXILIARES DE VALIDAÇÃO
    // -------------------------------------------------------------

    // Função para buscar o span de erro correspondente ao campo
    function getSpanErro(input) {
        const group = input.closest('.input-group');
        if (group) {
            return group.querySelector('span[id^="falta"]');
        }
        return null;
    }

    // Exibe mensagem de erro e marca o input
    function setError(input, message) {
        input.classList.add("erro-borda");
        const span = getSpanErro(input);
        if (span) {
            span.innerText = message;
        }
    }

    // Limpa a mensagem de erro e remove destaque do input
    function clearError(input) {
        input.classList.remove("erro-borda");
        const span = getSpanErro(input);
        if (span) {
            span.innerText = "";
        }
    }

    // Validador de E-mail por Regex
    function validarEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(String(email).toLowerCase());
    }

    // Algoritmo Real de Validação de CPF
    function validarCPF(cpf) {
        cpf = cpf.replace(/[^\d]+/g, '');
        if (cpf.length !== 11 || /^(\d)\1+$/.test(cpf)) return false;
        let add = 0;
        for (let i = 0; i < 9; i++) add += parseInt(cpf.charAt(i)) * (10 - i);
        let rev = 11 - (add % 11);
        if (rev === 10 || rev === 11) rev = 0;
        if (rev !== parseInt(cpf.charAt(9))) return false;
        add = 0;
        for (let i = 0; i < 10; i++) add += parseInt(cpf.charAt(i)) * (11 - i);
        rev = 11 - (add % 11);
        if (rev === 10 || rev === 11) rev = 0;
        if (rev !== parseInt(cpf.charAt(10))) return false;
        return true;
    }

    // -------------------------------------------------------------
    // AUTO-PREENCHIMENTO POR CEP (ViaCEP)
    // -------------------------------------------------------------
    if (inputCep) {
        inputCep.addEventListener('blur', function () {
            const cepLimpo = mascaraCep ? mascaraCep.unmaskedValue : inputCep.value.replace(/\D/g, '');
            if (cepLimpo.length === 8) {
                fetch(`https://viacep.com.br/ws/${cepLimpo}/json/`)
                    .then(res => res.json())
                    .then(data => {
                        if (!data.erro) {
                            document.getElementById('rua').value = data.logradouro || '';
                            document.getElementById('bairro').value = data.bairro || '';
                            document.getElementById('cidade').value = data.localidade || '';
                            document.getElementById('uf').value = data.uf || '';

                            // Limpa erros dos campos autopreenchidos
                            ['rua', 'bairro', 'cidade', 'uf'].forEach(id => {
                                const el = document.getElementById(id);
                                if (el) clearError(el);
                            });

                            // Foca no número automaticamente
                            document.getElementById('numero').focus();
                        } else {
                            setError(inputCep, "CEP não encontrado.");
                        }
                    })
                    .catch(() => {
                        // Ignora falhas de rede de forma silenciosa
                    });
            }
        });
    }

    // -------------------------------------------------------------
    // LIMPEZA DE ERRO EM TEMPO REAL AO DIGITAR
    // -------------------------------------------------------------
    const allInputs = form.querySelectorAll("input");
    allInputs.forEach(input => {
        input.addEventListener("input", function () {
            clearError(this);
        });
    });

    // -------------------------------------------------------------
    // SUBMIT DO FORMULÁRIO
    // -------------------------------------------------------------
    form.addEventListener("submit", function (e) {
        e.preventDefault();

        let isValid = true;
        let temCampoVazio = false;

        // 1. Checagem de Campos Vazios
        allInputs.forEach(function (input) {
            if (input.value.trim() === "") {
                setError(input, "Campo obrigatório");
                temCampoVazio = true;
                isValid = false;
            } else {
                clearError(input);
            }
        });

        if (temCampoVazio) {
            Swal.fire({
                title: "Campos incompletos",
                text: "Por favor, preencha todos os campos destacados em vermelho.",
                icon: "warning",
                confirmButtonColor: "#0284c7"
            });
            return;
        }

        // 2. Validação de E-mail
        const inputEmail = document.getElementById("email");
        if (inputEmail && !validarEmail(inputEmail.value.trim())) {
            setError(inputEmail, "Informe um e-mail válido (exemplo@dominio.com)");
            isValid = false;
        }

        // 3. Validação de CPF
        const rawCpf = mascaraCpf ? mascaraCpf.unmaskedValue : inputCpf.value.replace(/\D/g, '');
        if (inputCpf && !validarCPF(rawCpf)) {
            setError(inputCpf, "CPF inválido.");
            isValid = false;
        }

        // 4. Validação de CEP (deve ter 8 dígitos)
        const rawCep = mascaraCep ? mascaraCep.unmaskedValue : inputCep.value.replace(/\D/g, '');
        if (inputCep && rawCep.length !== 8) {
            setError(inputCep, "CEP deve ter 8 dígitos.");
            isValid = false;
        }

        // 5. Validação de Senha (tamanho mínimo)
        const inputSenha = document.getElementById("senha");
        const inputConfirmarSenha = document.getElementById("confirmar-senha");

        if (inputSenha && inputSenha.value.length < 6) {
            setError(inputSenha, "A senha deve ter pelo menos 6 caracteres.");
            isValid = false;
        }

        // 6. Confirmação de Senha
        if (inputSenha && inputConfirmarSenha && inputSenha.value !== inputConfirmarSenha.value) {
            setError(inputConfirmarSenha, "As senhas não coincidem.");
            isValid = false;
        }

        // Se houver erros específicos de regra (CPF inválido, senha curta, etc.)
        if (!isValid) {
            Swal.fire({
                title: "Atenção!",
                text: "Verifique os erros apontados no formulário antes de continuar.",
                icon: "error",
                confirmButtonColor: "#0284c7"
            });
            return;
        }

        // 7. ENVIO DE SUCESSO
        Swal.fire({
            title: "Tudo certo!",
            text: "Seu cadastro foi validado com sucesso. Enviando dados...",
            icon: "success",
            confirmButtonColor: "#0284c7",
            confirmButtonText: "Continuar"
        }).then((result) => {
            if (result.isConfirmed) {
                form.submit();
            }
        });
    });
});