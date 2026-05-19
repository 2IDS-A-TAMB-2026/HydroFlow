<main style="padding: 20px; font-family: Arial, sans-serif;">
    <h2>Gerenciar Conta de Usuário</h2>
    <p>Editando o cadastro de: <b><?= esc($usuario['NOME_USUARIO'] ?? $usuario['nome']) ?></b></p>

    <!-- Formulário para atualizar dados -->
    <form action="<?= base_url('adm/atualizarUsuario/' . ($usuario['ID_USUARIO'] ?? $usuario['id'])) ?>" method="POST" style="max-width: 400px;">
        <?= csrf_field() ?> <!-- Proteção CSRF nativa do CI4 -->

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
            <select name="STATUS_USUARIO" style="width: 100%; padding: 8px; margin-top: 5px;">
                <option value="ATIVO" <?= $statusAtual === 'ATIVO' ? 'selected' : '' ?>>ATIVO</option>
                <option value="INATIVO" <?= $statusAtual === 'INATIVO' ? 'selected' : '' ?>>INATIVO</option>
            </select>
        </div>

        <button type="submit" style="background: #007bff; color: white; padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer;">
            Salvar Alterações
        </button>
    </form>

    <hr style="margin: 30px 0; border: 0; border-top: 1px solid #ccc;">

    <!-- Zona de Exclusão Física ou Lógica -->
    <div style="background: #fdf2f2; padding: 15px; border: 1px solid #f5c6cb; border-radius: 4px;">
        <h4 style="color: #721c24; margin-top: 0;">Zona Crítica</h4>
        <p style="font-size: 14px; color: #721c24;">A remoção do usuário do sistema é uma ação definitiva.</p>
        <a href="<?= base_url('adm/excluirUsuario/' . ($usuario['ID_USUARIO'] ?? $usuario['id'])) ?>" 
           onclick="return confirm('Tem certeza absoluta que deseja excluir permanentemente este usuário?')" 
           style="display: inline-block; background: #dc3545; color: white; padding: 8px 12px; text-decoration: none; border-radius: 4px; font-weight: bold;">
           Excluir Conta Permanentemente
        </a>
    </div>

    <br>
    <a href="<?= base_url('adm/gerenciarUsuarios') ?>">← Cancelar e Voltar para Lista</a>
</main>