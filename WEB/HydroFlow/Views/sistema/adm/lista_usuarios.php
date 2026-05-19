<main style="padding: 20px; font-family: Arial, sans-serif;">
    <h2><?= esc($titulo); ?></h2>

    <!-- Feedback de Mensagens do CodeIgniter (Flashdata) -->
    <?php if (session()->getFlashdata('sucesso')): ?>
        <p style="color: green; background: #e2f0d9; padding: 10px; border-radius: 4px;"><b><?= session()->getFlashdata('sucesso') ?></b></p>
    <?php endif; ?>
    <?php if (session()->getFlashdata('erro')): ?>
        <p style="color: red; background: #fce4d6; padding: 10px; border-radius: 4px;"><b><?= session()->getFlashdata('erro') ?></b></p>
    <?php endif; ?>

    <table border="1" cellpadding="10" style="width: 100%; border-collapse: collapse; margin-top: 20px; border: 1px solid #ddd;">
        <thead>
            <tr style="background-color: #f2f2f2; text-align: left;">
                <th>ID</th>
                <th>Nome</th>
                <th>E-mail</th>
                <th>Status</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
            <?php if (!empty($usuarios) && is_array($usuarios)): ?>
                <?php foreach ($usuarios as $usuario): ?>
                    <tr>
                        <!-- Faz a leitura tolerando índices alternativos (maísculos/minúsculos) -->
                        <td><?= $usuario['ID_USUARIO'] ?? $usuario['id'] ?></td>
                        <td><?= esc($usuario['NOME_USUARIO'] ?? $usuario['nome']) ?></td>
                        <td><?= esc($usuario['EMAIL_USUARIO'] ?? $usuario['email']) ?></td>
                        <td><?= esc($usuario['STATUS_USUARIO'] ?? $usuario['status'] ?? 'ATIVO') ?></td>
                        <td>
                            <!-- Redireciona para o formulário de edição passando o ID via segmento de URL -->
                            <a href="<?= base_url('adm/gerenciarUsuario/' . ($usuario['ID_USUARIO'] ?? $usuario['id'])) ?>">Gerenciar / Editar</a>
                        </td>
                    </tr>
                <?php endforeach; ?>
            <?php else: ?>
                <tr>
                    <td colspan="5" style="text-align: center;">Nenhum usuário encontrado no sistema.</td>
                </tr>
            <?php endif; ?>
        </tbody>
    </table>
    
    <br>
    <a href="<?= base_url('adm') ?>">← Voltar ao Painel</a>
</main>