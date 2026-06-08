<div class="main-content">
    <div class="page-header">
        <h2>Editar Meu Perfil</h2>
        <p>Gerencie suas credenciais de segurança e acesso do sistema HydroFlow</p>
    </div>

    <div class="profile-card-container">
        
        <form id="formPerfil" action="<?= base_url('adm/salvarPerfil') ?>" method="POST">
            <?= csrf_field() ?>

            <div class="profile-section-divider">
                <span>Dados de Identificação</span>
            </div>

            <div class="profile-form-row">
                <div class="profile-input-group flex-2">
                    <label for="NOME_ADM">Nome Completo (ADM):</label>
                    <input type="text" name="NOME_ADM" id="NOME_ADM" value="<?= esc($adm['NOME_ADM'] ?? '') ?>" required>
                </div>
                
                <div class="profile-input-group flex-2">
                    <label for="EMAIL_ADM">E-mail de Acesso:</label>
                    <input type="email" name="EMAIL_ADM" id="EMAIL_ADM" value="<?= esc($adm['EMAIL_ADM'] ?? '') ?>" required>
                </div>
            </div>

            <div class="profile-section-divider">
                <span>Segurança e Credenciais</span>
            </div>

            <div class="profile-form-row">
                <div class="profile-input-group" style="flex: 1;">
                    <label for="SENHA_ADM">Nova Senha (Mínimo 8 caracteres):</label>
                    <input type="password" name="SENHA_ADM" id="SENHA_ADM" placeholder="Deixe em branco se não quiser alterar a senha atual">
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="profile-btn-submit">
                    Atualizar Meus Dados
                </button>
            </div>
        </form>

        <div style="margin-top: 25px;">
            <a href="<?= base_url('adm') ?>" class="btn-cancelar" style="display: inline-flex; width: auto; text-decoration: none;">
                ← Voltar ao Painel
            </a>
        </div>
    </div>
</div>

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
                html: `<ul style="text-align: left; margin-left: 20px;">${Object.values(erros).map(e => `<li>${e}</li>`).join('')}</ul>`,
                confirmButtonColor: '#1e3c72'
            });
        <?php endif; ?>

        // 2. Confirmação antes de Salvar com cores do tema (#1e3c72)
        form.addEventListener("submit", function(e) {
            e.preventDefault();

            const senhaInserida = document.getElementById("SENHA_ADM").value;
            let mensagem = "Deseja atualizar as informações do seu perfil?";
            
            if (senhaInserida.length > 0) {
                mensagem = "Você inseriu uma nova senha. Tem certeza que deseja alterá-la?";
            }

            Swal.fire({
                title: 'Confirmar Alteração?',
                text: mensagem,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#1e3c72',
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