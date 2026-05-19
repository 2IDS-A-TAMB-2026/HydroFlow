<main style="padding: 20px; font-family: Arial, sans-serif;">
    <h2>Editar Meu Perfil</h2>

    <!-- Listagem de Erros de validação (regras definidas no AdmModel) -->
    <?php if (session()->getFlashdata('erros_validacao')): ?>
        <div style="color: red; background: #fce4d6; padding: 10px; margin-bottom: 15px; border-radius: 4px;">
            <ul>
            <?php foreach (session()->getFlashdata('erros_validacao') as $erro): ?>
                <li><?= esc($erro) ?></li>
            <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>

    <form action="<?= base_url('adm/salvarPerfil') ?>" method="POST" style="max-width: 400px;">
        <?= csrf_field() ?>

        <div style="margin-bottom: 15px;">
            <label>Nome Completo (ADM):</label><br>
            <input type="text" name="NOME_ADM" value="<?= esc($adm['NOME_ADM'] ?? '') ?>" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div style="margin-bottom: 15px;">
            <label>E-mail de Acesso:</label><br>
            <input type="email" name="EMAIL_ADM" value="<?= esc($adm['EMAIL_ADM'] ?? '') ?>" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div style="margin-bottom: 15px;">
            <label>Nova Senha (Mínimo 8 caracteres):</label><br>
            <small style="color: #666;">Deixe em branco se não quiser alterar a senha atual.</small>
            <input type="password" name="SENHA_ADM" style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <button type="submit" style="background: #007bff; color: white; padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer;">
            Atualizar Meus Dados
        </button>
    </form>

    <br>
    <a href="<?= base_url('adm') ?>">← Voltar ao Painel</a>
</main>