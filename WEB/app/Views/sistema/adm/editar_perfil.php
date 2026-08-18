<div class="profile-card-container">
    <div class="profile-form-row">
        <div class="profile-input-group">
            <label>Nome Completo (ADM):</label>
            <input type="text" name="nome" value="Diego">
        </div>
        <div class="profile-input-group">
            <label>E-mail de Acesso:</label>
            <input type="email" name="email" value="Diego@gmail.com">
        </div>
    </div>

    <div class="profile-section-divider">
        <span><i class="fas fa-lock"></i> Segurança e Credenciais</span>
    </div>

    <div class="profile-form-row">
        <div class="profile-input-group password-row">
            <label>Nova Senha (Mínimo 8 caracteres):</label>
            <input type="password" name="senha" placeholder="Deixe em branco se não quiser alterar">
        </div>
    </div>

    <div class="form-actions">
        <button
            type="button"
            class="btn-voltar"
            onclick="window.location.href='<?= base_url('admin/dashboard') ?>'">
            <i class="fas fa-arrow-left"></i> Voltar ao Painel
        </button>
        <button type="submit" class="profile-btn-submit"><i class="fas fa-save"></i> Atualizar Meus Dados</button>
    </div>
</div>

<style>
/* ==========================================================================
   HYDROFLOW - ESTILOS EXCLUSIVOS DA TELA DE EDIÇÃO DE PERFIL DO ADM
   ========================================================================== */

/* Container que envolve o formulário de perfil */
.profile-card-container {
    background: #ffffff;
    padding: 35px;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.04);
}

/* Linha do formulário de perfil */
.profile-form-row {
    display: flex;
    gap: 20px;
    margin-bottom: 20px;
    flex-wrap: wrap;
    width: 100%;
}

/* Grupo de entrada de dados (label + input) */
.profile-input-group {
    display: flex;
    flex-direction: column;
    flex: 1;
    min-width: calc(50% - 10px); /* Força Nome e E-mail a dividirem a linha meio a meio */
    box-sizing: border-box;
}

/* Força o campo de senha a ficar na esquerda, alinhado com o Nome */
.profile-input-group.password-row {
    flex: none;
    width: calc(50% - 10px);
}

/* Rótulos dos campos */
.profile-input-group label {
    font-weight: 600;
    color: #333333;
    margin-bottom: 8px;
    font-size: 0.9rem;
}

/* Inputs de texto e senha */
.profile-input-group input {
    width: 100%;
    padding: 12px;
    border: 1px solid #cccccc;
    border-radius: 6px;
    background: #ffffff;
    height: 46px;
    color: #333333;
    font-size: 0.95rem;
    box-sizing: border-box;
    transition: border-color 0.2s;
}

.profile-input-group input:focus {
    border-color: #1e3c72;
    outline: none;
}

/* Separadores de seção internos do perfil */
.profile-section-divider {
    margin: 35px 0 20px 0;
    border-bottom: 2px solid #4dd0e1;
    padding-bottom: 6px;
    width: 100%; /* Força o título a ocupar a largura total sozinho */
}

.profile-section-divider span {
    font-weight: 700;
    color: #1e3c72;
    text-transform: uppercase;
    font-size: 0.8rem;
    letter-spacing: 0.8px;
}

/* Botão de salvar alterações do perfil */
.profile-btn-submit {
    background-color: #1e3c72;
    color: #ffffff;
    border: none;
    cursor: pointer;
    padding: 14px 30px;
    font-weight: 600;
    font-size: 0.95rem;
    width: auto;
    min-width: 200px;
    text-align: center;
    border-radius: 6px;
    transition: background-color 0.2s;
    margin-top: 10px;
}

.profile-btn-submit:hover {
    background-color: #152b52;
}

/* Ajustes para os botões secundários da barra inferior (Voltar) */
.btn-voltar {
    background-color: #f8f9fa;
    color: #495057;
    border: 1px solid #ced4da;
    padding: 11px 20px;
    border-radius: 6px;
    font-size: 0.95rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}

.btn-voltar:hover {
    background-color: #e2e6ea;
    color: #212529;
}

/* Alinhamento dos botões (Voltar e Atualizar) no final */
.form-actions {
    display: flex;
    justify-content: flex-start;
    align-items: center;
    gap: 15px;
    margin-top: 25px;
}
</style>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const form = document.getElementById("formPerfil");
        
        // 1. Mostrar Erros de Validação do CodeIgniter
        <?php if (session()->getFlashdata('erros_validacao')): ?>
            const erros = <?= json_encode(session()->getFlashdata('erros_validacao')) ?>;
            Swal.fire({
                icon: 'error',
                title: 'Erro na Validação',
                html: `<ul style="text-align: left; margin-left: 20px;">${Object.values(erros).map(e => `<li>${e}</li>`).join('')}</ul>`,
                confirmButtonColor: '#1e3c72'
            });
        <?php endif; ?>

        // 2. Confirmação com SweetAlert antes de enviar
        form.addEventListener("submit", function(e) {
            e.preventDefault();

            const senhaInserida = document.getElementById("SENHA_ADM").value;
            let mensagem = "Deseja atualizar as informações do seu perfil?";
            
            if (senhaInserida.length > 0) {
                if(senhaInserida.length < 8) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Senha Curta',
                        text: 'A nova senha precisa ter no mínimo 8 caracteres.',
                        confirmButtonColor: '#1e3c72'
                    });
                    return;
                }
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