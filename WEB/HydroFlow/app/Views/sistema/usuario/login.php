<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página de Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght=0,400;0,600;0,700;1,600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<?= base_url('assets/css/login.css') ?>">
    
    <!-- CDN do SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

    <div class="login-container">
        
        <div class="login-left">
            <div class="logo">Hydro<span class="logo">Flow</span></div>
            
            <div class="left-content">
                <h1>Bem vindo!</h1>
                <p>Entre e dê um passo à frente na eficiência</p>
            </div>
            <span class="pequeno"><a class="log_adm" href="<?= base_url('admin/login') ?>">Login de ADM</a></span>
        </div>

        <div class="login-right">
            
            <div class="login-card">
                <h2>Login</h2>
                
                <form action="<?= base_url('login/autenticar') ?>" id="form" method="POST">
                    <div class="input-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" placeholder="exemplo@email.com" required name="email">
                    </div>
                    
                    <div class="input-group">
                        <label for="password">Senha</label>
                        <input type="password" id="password" placeholder="••••••••" required name="senha">
                    </div>
                    
                    <button type="submit" class="btn-main">Entrar</button>
                </form>

                <div class="divider">ou</div>
                <p class="signup-link">Não tem uma conta? <a href="<?= base_url('cadastro') ?>">Cadastre-se</a></p>
            </div>
        </div>
        
    </div>

    <script src="https://unpkg.com/imask"></script>
    <script src="<?= base_url('assets/js/valida_login_usu.js') ?>"></script>

    <!-- Script de Validação com SweetAlert2 -->
    <script>
        document.getElementById('form').addEventListener('submit', function(event) {
            // Impede o envio imediato apenas para mostrar um feedback visual de carregamento
            event.preventDefault(); 

            // Mostra o SweetAlert de "Carregando" enquanto o PHP processa no banco
            Swal.fire({
                title: 'Verificando credenciais...',
                text: 'Aguarde um momento.',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            // Envia o formulário de verdade para o PHP (login/autenticar) fazer a mágica no banco!
            event.target.submit();
        });
    </script>
</body>
</html>