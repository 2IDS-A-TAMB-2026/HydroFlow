<main style="padding: 20px; font-family: Arial, sans-serif;">
    <div style="display: flex; justify-content: space-between; align-items: center;">
        <h2>Dispositivos Registrados</h2>
        <div>
            <a href="<?= base_url('dispositivos') ?>" style="color: #666; text-decoration: none; margin-right: 15px;">← Voltar ao Menu</a>
            <a href="<?= base_url('dispositivos/novo') ?>" style="background: #28a745; color: white; padding: 8px 12px; text-decoration: none; border-radius: 4px; font-weight: bold;">+ Novo Dispositivo</a>
        </div>
    </div>

    <!-- Mensagens de Sucesso -->
    <?php if (session()->getFlashdata('success')): ?>
        <p style="color: green; background: #e2f0d9; padding: 10px; border-radius: 4px; margin-top: 15px;"><b><?= session()->getFlashdata('success') ?></b></p>
    <?php endif; ?>

    <table border="1" cellpadding="10" style="width: 100%; border-collapse: collapse; margin-top: 20px; border: 1px solid #ddd;">
        <thead>
            <tr style="background-color: #f2f2f2; text-align: left;">
                <th>ID</th>
                <th>Nome do Dispositivo</th>
                <th>Status</th>
                <th>Nível do Tanque</th>
                <th>Localização</th>
                <th>Proprietário</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
            <?php if (!empty($dispositivos) && is_array($dispositivos)): ?>
                <?php foreach ($dispositivos as $disp): ?>
                    <tr>
                        <td><?= $disp['DIS_ID'] ?></td>
                        <td>
                            <b><?= esc($disp['DIS_NOME']) ?></b><br>
                            <small style="color: #666;"><?= esc($disp['DIS_DESCRICAO']) ?></small>
                        </td>
                        <td>
                            <span style="padding: 4px 8px; border-radius: 4px; color: white; font-size: 12px; background: <?= $disp['DIS_STATUS'] === 'ATIVO' ? '#28a745' : '#dc3545' ?>;">
                                <?= $disp['DIS_STATUS'] ?>
                            </span>
                        </td>
                        <td><b><?= esc($disp['DIS_NIVEL_TANQUE']) ?>%</b></td>
                        <td>
                            <small>
                                <?= esc($disp['DIS_RUA']) ?>, № <?= esc($disp['DIS_NUM']) ?><br>
                                <?= esc($disp['DIS_CIDADE']) ?> - <?= esc($disp['DIS_UF']) ?>
                            </small>
                        </td>
                        <td>
                            <?= esc($disp['dono_nome']) ?><br>
                            <small style="color: #666;"><?= esc($disp['dono_email']) ?></small>
                        </td>
                        <td>
                            <a href="<?= base_url('dispositivos/gerenciamento/' . $disp['DIS_ID']) ?>" style="color: #007bff; text-decoration: none; font-weight: bold;">Gerenciar</a> | 
                            <a href="<?= base_url('dispositivos/excluir/' . $disp['DIS_ID']) ?>" onclick="return confirm('Deseja mesmo excluir este dispositivo?')" style="color: #dc3545; text-decoration: none;">Excluir</a>
                        </td>
                    </tr>
                <?php endforeach; ?>
            <?php else: ?>
                <tr>
                    <td colspan="7" style="text-align: center; color: #666;">Nenhum dispositivo encontrado no sistema.</td>
                </tr>
            <?php endif; ?>
        </tbody>
    </table>
</main>