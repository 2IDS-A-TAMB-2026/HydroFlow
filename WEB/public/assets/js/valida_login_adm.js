document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("form");

    form.addEventListener("submit", function (e) {
        e.preventDefault();

        const email = document.getElementById("email").value;
        const senha = document.getElementById("password").value;

        // Dados fixos (pra demo)
        const emailCorreto = "Hydroflow@email.com";
        const senhaCorreta = "Hydroflow";

        if (email === emailCorreto && senha === senhaCorreta) {
            // Alerta de sucesso antes de redirecionar
            Swal.fire({
                icon: 'success',
                title: 'Login realizado!',
                text: 'Redirecionando para o dashboard...',
                showConfirmButton: false
            });

        } else {
            // Alerta de erro amigável
            Swal.fire({
                icon: 'error',
                title: 'Erro',
                text: 'Email ou senha incorretos!',
                confirmButtonColor: '#d33'
            });
        }
    });
});