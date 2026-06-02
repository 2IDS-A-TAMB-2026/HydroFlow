<main style="padding: 20px; font-family: Arial, sans-serif;">
    <h2>Editar Meu Perfil</h2>

    <form id="formPerfil" action="<?= base_url('adm/salvarPerfil') ?>" method="POST" style="max-width: 400px;">
        <?= csrf_field() ?>

        <div style="margin-bottom: 15px;">
            <label>Nome Completo (ADM):</label><br>
            <input type="text" name="NOME_ADM" id="NOME_ADM" value="<?= esc($adm['NOME_ADM'] ?? '') ?>" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div style="margin-bottom: 15px;">
            <label>E-mail de Acesso:</label><br>
            <input type="email" name="EMAIL_ADM" value="<?= esc($adm['EMAIL_ADM'] ?? '') ?>" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div style="margin-bottom: 15px;">
            <label>Nova Senha (Mínimo 8 caracteres):</label><br>
            <small style="color: #666;">Deixe em branco se não quiser alterar a senha atual.</small>
            <input type="password" name="SENHA_ADM" id="SENHA_ADM" style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <button type="submit" style="background: #007bff; color: white; padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer;">
            Atualizar Meus Dados
        </button>
    </form>

    <br>
    <a href="<?= base_url('adm') ?>" style="text-decoration: none; color: #666;">← Voltar ao Painel</a>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const form = document.getElementById("formPerfil");
            
            // 1. Mostrar Erros de Validação do CodeIgniter em um Alerta
            <?php if (session()->getFlashdata('erros_validacao')): ?>
                const erros = <?= json_encode(session()->getFlashdata('erros_validacao')) ?>;
                Swal.fire({
                    icon: 'error',
                    title: 'Erro na Validação',
                    html: `<ul style="text-align: left;">${Object.values(erros).map(e => `<li>${e}</li>`).join('')}</ul>`,
                    confirmButtonColor: '#007bff'
                });
            <?php endif; ?>

            // 2. Confirmação antes de Salvar
            form.addEventListener("submit", function(e) {
                e.preventDefault();

                const senhaInserida = document.getElementById("SENHA_ADM").value;
                let mensagem = "Deseja atualizar as informações do seu perfil?";
                
                // Alerta extra se o usuário estiver mudando a senha
                if (senhaInserida.length > 0) {
                    mensagem = "Você inseriu uma nova senha. Tem certeza que deseja alterá-la?";
                }

                Swal.fire({
                    title: 'Confirmar Alteração?',
                    text: mensagem,
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#007bff',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Sim, atualizar!',
                    cancelButtonText: 'Cancelar',
                    reverseButtons: true
                }).then((result) => {
                    if (result.isConfirmed) {
                        Swal.fire({
                            title: 'Processando...',
                            didOpen: () => { Swal.showLoading(); }
                        });
                        form.submit();
                    }
                });
            });
        });
    </script>
</main>