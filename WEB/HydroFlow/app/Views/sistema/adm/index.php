<main style="padding: 20px; font-family: Arial, sans-serif;">
    <h2>Painel do Administrador</h2>
    <p>Olá, <b><?= session()->get('usuario_nome') ?? 'Administrador' ?></b>. Selecione uma opção para gerenciar o sistema:</p>

    <div style="display: flex; gap: 20px; margin-top: 20px; flex-wrap: wrap;">
        <!-- Card Usuários -->
        <div style="border: 1px solid #ccc; padding: 20px; border-radius: 8px; width: 220px; box-shadow: 2px 2px 5px rgba(0,0,0,0.05);">
            <h3>Usuários</h3>
            <p>Visualizar, editar ou remover usuários cadastrados.</p>
            <a href="<?= base_url('adm/gerenciarUsuarios') ?>" style="display:inline-block; background:#007bff; color:white; padding:8px 12px; text-decoration:none; border-radius:4px;">Gerenciar</a>
        </div>

        <!-- Card Sensores -->
        <div style="border: 1px solid #ccc; padding: 20px; border-radius: 8px; width: 220px; box-shadow: 2px 2px 5px rgba(0,0,0,0.05);">
            <h3>Sensores</h3>
            <p>Cadastrar e gerenciar novos sensores no sistema.</p>
            <a href="<?= base_url('adm/cadastroSensor') ?>" style="display:inline-block; background:#28a745; color:white; padding:8px 12px; text-decoration:none; border-radius:4px;">Novo Sensor</a>
        </div>

        <!-- Card Perfil -->
        <div style="border: 1px solid #ccc; padding: 20px; border-radius: 8px; width: 220px; box-shadow: 2px 2px 5px rgba(0,0,0,0.05);">
            <h3>Meu Perfil</h3>
            <p>Alterar seus dados cadastrais e senha de acesso.</p>
            <a href="<?= base_url('adm/editarPerfil') ?>" style="display:inline-block; background:#6c757d; color:white; padding:8px 12px; text-decoration:none; border-radius:4px;">Editar Perfil</a>
        </div>
    </div>
</main>