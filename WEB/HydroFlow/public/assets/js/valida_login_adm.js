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
            window.location.href = "dashboard_usu.html";
        } else {
            const erro = document.createElement("p");
            erro.innerText = "Email ou senha incorretos!";
            erro.style.color = "red";
            form.appendChild(erro);
        }
    });

});