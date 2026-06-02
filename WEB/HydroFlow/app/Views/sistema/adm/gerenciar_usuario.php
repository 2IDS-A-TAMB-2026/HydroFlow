<main style="padding: 20px; font-family: Arial, sans-serif;">
    <h2>Gerenciar Conta de Usuário</h2>
    <p>Editando o cadastro de: <b><?= esc($usuario['NOME_USUARIO'] ?? $usuario['nome']) ?></b></p>

    <form id="formGerenciarUsuario" action="<?= base_url('adm/atualizarUsuario/' . ($usuario['ID_USUARIO'] ?? $usuario['id'])) ?>" method="POST" style="max-width: 400px;">
        <?= csrf_field() ?>

        <div style="margin-bottom: 15px;">
            <label>Nome do Usuário:</label><br>
            <input type="text" name="NOME_USUARIO" value="<?= esc($usuario['NOME_USUARIO'] ?? $usuario['nome']) ?>" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div style="margin-bottom: 15px;">
            <label>E-mail corporativo:</label><br>
            <input type="email" name="EMAIL_USUARIO" value="<?= esc($usuario['EMAIL_USUARIO'] ?? $usuario['email']) ?>" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div style="margin-bottom: 15px;">
            <label>Status da Conta:</label><br>
            <?php $statusAtual = $usuario['STATUS_USUARIO'] ?? $usuario['status'] ?? 'ATIVO'; ?>
            <select name="STATUS_USUARIO" id="STATUS_USUARIO" style="width: 100%; padding: 8px; margin-top: 5px;">
                <option value="ATIVO" <?= $statusAtual === 'ATIVO' ? 'selected' : '' ?>>ATIVO</option>
                <option value="INATIVO" <?= $statusAtual === 'INATIVO' ? 'selected' : '' ?>>INATIVO</option>
            </select>
        </div>

        <button type="submit" style="background: #007bff; color: white; padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer;">
            Salvar Alterações
        </button>
    </form>

    <hr style="margin: 30px 0; border: 0; border-top: 1px solid #ccc;">

    <div style="background: #fdf2f2; padding: 15px; border: 1px solid #f5c6cb; border-radius: 4px;">
        <h4 style="color: #721c24; margin-top: 0;">Zona Crítica</h4>
        <p style="font-size: 14px; color: #721c24;">A remoção do usuário do sistema é uma ação definitiva.</p>
        <a href="<?= base_url('adm/excluirUsuario/' . ($usuario['ID_USUARIO'] ?? $usuario['id'])) ?>" 
           id="btnExcluirUsuario"
           data-nome="<?= esc($usuario['NOME_USUARIO'] ?? $usuario['nome']) ?>"
           style="display: inline-block; background: #dc3545; color: white; padding: 8px 12px; text-decoration: none; border-radius: 4px; font-weight: bold;">
           Excluir Conta Permanentemente
        </a>
    </div>

    <br>
    <a href="<?= base_url('adm/gerenciarUsuarios') ?>" style="text-decoration: none; color: #666;">← Cancelar e Voltar para Lista</a>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const form = document.getElementById("formGerenciarUsuario");
            const btnExcluir = document.getElementById("btnExcluirUsuario");

            form.addEventListener("submit", function(e) {
                e.preventDefault();
                
                const status = document.getElementById("STATUS_USUARIO").value;
                let tituloAlerta = 'Salvar Alterações?';
                let iconeAlerta = 'question';

                if (status === 'INATIVO') {
                    tituloAlerta = 'Inativar Usuário?';
                    iconeAlerta = 'warning';
                }

                Swal.fire({
                    title: tituloAlerta,
                    text: status === 'INATIVO' ? "O usuário perderá o acesso ao sistema imediatamente." : "Deseja aplicar as novas informações?",
                    icon: iconeAlerta,
                    showCancelButton: true,
                    confirmButtonColor: '#007bff',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Sim, salvar',
                    cancelButtonText: 'Revisar',
                    reverseButtons: true
                }).then((result) => {
                    if (result.isConfirmed) {
                        form.submit();
                    }
                });
            });

            btnExcluir.addEventListener("click", function(e) {
                e.preventDefault();
                const url = this.getAttribute('href');
                const nome = this.getAttribute('data-nome');

                Swal.fire({
                    title: 'Excluir permanentemente?',
                    html: `Você está prestes a apagar a conta de <b>${nome}</b>.<br><span style="color: red;">Esta ação não pode ser desfeita!</span>`,
                    icon: 'error',
                    showCancelButton: true,
                    confirmButtonColor: '#dc3545',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Sim, EXCLUIR!',
                    cancelButtonText: 'Cancelar',
                    reverseButtons: true
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = url;
                    }
                });
            });
        });
    </script>
</main>