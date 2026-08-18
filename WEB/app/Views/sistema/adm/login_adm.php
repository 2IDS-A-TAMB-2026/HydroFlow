<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HydroFlow - Login</title>
    <!-- Fonte Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,300;0,400;0,500;0,600;0,700;1,600&display=swap" rel="stylesheet">
    <!-- Ícones Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- CSS Externo -->
    <link rel="stylesheet" href="<?= base_url('assets/css/login.css') ?>">
    <!-- CDN do SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

    <div class="login-container">
        
        <!-- Painel Esquerdo -->
        <div class="login-left">
            <div class="logo">Hydro<span>Flow</span></div>
            
            <div class="left-content">
                <span class="badge"><i class="fa-solid fa-droplet"></i> Plataforma de Gestão</span>
                <h1>Gestão inteligente da sua água.</h1>
                <p>Monitore consumos, evite desperdícios e potencialize a eficiência hídrica do seu negócio.</p>
            </div>


            <a class="log_adm" href="<?= base_url('/login') ?>">
                <i class="fa-solid fa-user-shield"></i> Voltar ao login de usuário
            </a>
        </div>

        <!-- Painel Direito (Formulário) -->
        <div class="login-right">
            <div class="login-card">
                <h2>Administrador</h2>
                <p class="subtitle">Insira suas credenciais para continuar</p>
                
                <form action="<?= base_url('admin/auth/autenticar') ?>" id="form" method="POST">
                    <div class="input-group">
                        <label for="email">E-mail</label>
                        <div class="input-wrapper">
                            <i class="fa-regular fa-envelope input-icon"></i>
                            <input type="email" id="email" placeholder="exemplo@email.com" required name="email">
                        </div>
                    </div>
                    
                    <div class="input-group">
                        <div class="label-row">
                            <label for="password">Senha</label>
                            <a href="<?= base_url('esqueci-senha') ?>" class="forgot-password">Esqueceu a senha?</a>
                        </div>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-lock input-icon"></i>
                            <input type="password" id="password" placeholder="••••••••" required name="senha">
                            <i class="fa-regular fa-eye toggle-password" id="togglePassword"></i>
                        </div>
                    </div>

                    <div class="remember-box">
                        <input type="checkbox" id="remember" name="remember">
                        <label for="remember">Lembrar de mim</label>
                    </div>
                    
                    <button type="submit" class="btn-main">
                        <span>Entrar</span>
                        <i class="fa-solid fa-arrow-right"></i>
                    </button>
                </form>

                <p class="signup-link">Ainda não tem uma conta? <a href="<?= base_url('cadastro') ?>">Cadastre-se</a></p>
            </div>
        </div>
        
    </div>

    <script src="https://unpkg.com/imask"></script>
    <script src="<?= base_url('assets/js/valida_login_usu.js') ?>"></script>

    <!-- Toggle de mostrar/ocultar senha -->
    <script>
        const togglePassword = document.querySelector('#togglePassword');
        const password = document.querySelector('#password');

        togglePassword.addEventListener('click', function () {
            const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
            password.setAttribute('type', type);
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });
    </script>

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

     <!-- SweetAlert de erro: credenciais inválidas (vem do backend via flashdata) -->
    <?php $erro = session()->getFlashdata('erro') ?? null; ?>
    <?php if (!empty($erro)): ?>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            Swal.fire({
                icon: 'error',
                title: 'Não foi possível entrar',
                text: '<?= addslashes($erro) ?>',
                confirmButtonText: 'Tentar novamente',
                confirmButtonColor: '#0284c7'
            });
        });
    </script>
    <?php endif; ?>
</body>
</html>