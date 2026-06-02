<main style="padding: 20px; font-family: Arial, sans-serif;">
    <h2>Painel do Administrador</h2>
    <p>Olá, <b><?= session()->get('usuario_nome') ?? 'Administrador' ?></b>. Selecione uma opção para gerenciar o sistema:</p>

    <div style="display: flex; gap: 20px; margin-top: 20px; flex-wrap: wrap;">
        <div style="border: 1px solid #ccc; padding: 20px; border-radius: 8px; width: 220px; box-shadow: 2px 2px 5px rgba(0,0,0,0.05);">
            <h3>Usuários</h3>
            <p>Visualizar, editar ou remover usuários cadastrados.</p>
            <a href="<?= base_url('adm/gerenciarUsuarios') ?>" style="display:inline-block; background:#007bff; color:white; padding:8px 12px; text-decoration:none; border-radius:4px;">Gerenciar</a>
        </div>

        <div style="border: 1px solid #ccc; padding: 20px; border-radius: 8px; width: 220px; box-shadow: 2px 2px 5px rgba(0,0,0,0.05);">
            <h3>Sensores</h3>
            <p>Cadastrar e gerenciar novos sensores no sistema.</p>
            <a href="<?= base_url('adm/cadastroSensor') ?>" style="display:inline-block; background:#28a745; color:white; padding:8px 12px; text-decoration:none; border-radius:4px;">Novo Sensor</a>
        </div>

        <div style="border: 1px solid #ccc; padding: 20px; border-radius: 8px; width: 220px; box-shadow: 2px 2px 5px rgba(0,0,0,0.05);">
            <h3>Meu Perfil</h3>
            <p>Alterar seus dados cadastrais e senha de acesso.</p>
            <a href="<?= base_url('adm/editarPerfil') ?>" style="display:inline-block; background:#6c757d; color:white; padding:8px 12px; text-decoration:none; border-radius:4px;">Editar Perfil</a>
        </div>
    </div>

    <div style="margin-top: 30px;">
        <a href="<?= base_url('login/logout') ?>" id="btn-logout" style="color: #dc3545; text-decoration: none; font-weight: bold;">
            <i class="fas fa-sign-out-alt"></i> Sair do Sistema
        </a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            
            <?php if (session()->getFlashdata('login_sucesso')): ?>
                const Toast = Swal.mixin({
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: 3000,
                    timerProgressBar: true,
                });

                Toast.fire({
                    icon: 'success',
                    title: 'Bem-vindo ao Painel ADM!'
                });
            <?php endif; ?>

            const btnLogout = document.getElementById('btn-logout');
            if (btnLogout) {
                btnLogout.addEventListener('click', function(e) {
                    e.preventDefault();
                    const url = this.getAttribute('href');

                    Swal.fire({
                        title: 'Deseja sair?',
                        text: "Sua sessão será encerrada.",
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#dc3545',
                        cancelButtonColor: '#6c757d',
                        confirmButtonText: 'Sair',
                        cancelButtonText: 'Ficar',
                        reverseButtons: true
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location.href = url;
                        }
                    });
                });
            }
        });
    </script>
</main>