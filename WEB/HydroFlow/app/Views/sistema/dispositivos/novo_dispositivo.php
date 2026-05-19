<main style="padding: 20px; font-family: Arial, sans-serif;">
    <h2>Cadastrar Novo Dispositivo</h2>

    <!-- Exibição de Erros de Validação da Model -->
    <?php if (session()->getFlashdata('errors')): ?>
        <div style="color: red; background: #fce4d6; padding: 10px; margin-bottom: 15px; border-radius: 4px;">
            <ul>
            <?php foreach (session()->getFlashdata('errors') as $erro): ?>
                <li><?= esc($erro) ?></li>
            <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>

    <form action="<?= base_url('dispositivos/salvar') ?>" method="POST" style="max-width: 600px; display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
        <?= csrf_field() ?>

        <!-- Dados Básicos -->
        <div style="grid-column: span 2;">
            <label>Nome do Dispositivo:</label>
            <input type="text" name="DIS_NOME" value="<?= old('DIS_NOME') ?>" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div style="grid-column: span 2;">
            <label>Descrição:</label>
            <textarea name="DIS_DESCRICAO" style="width: 100%; padding: 8px; margin-top: 5px; height: 60px;"><?= old('DIS_DESCRICAO') ?></textarea>
        </div>

        <div>
            <label>Status:</label>
            <select name="DIS_STATUS" style="width: 100%; padding: 8px; margin-top: 5px;">
                <option value="ATIVO" <?= old('DIS_STATUS') == 'ATIVO' ? 'selected' : '' ?>>ATIVO</option>
                <option value="INATIVO" <?= old('DIS_STATUS') == 'INATIVO' ? 'selected' : '' ?>>INATIVO</option>
            </select>
        </div>

        <div>
            <label>Nível Inicial do Tanque (% ou decimal):</label>
            <input type="number" step="0.01" name="DIS_NIVEL_TANQUE" value="<?= old('DIS_NIVEL_TANQUE') ?>" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <!-- Endereço -->
        <div>
            <label>CEP:</label>
            <input type="text" name="DIS_CEP" value="<?= old('DIS_CEP') ?>" style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div>
            <label>Rua/Logradouro:</label>
            <input type="text" name="DIS_RUA" value="<?= old('DIS_RUA') ?>" style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div>
            <label>Número:</label>
            <input type="text" name="DIS_NUM" value="<?= old('DIS_NUM') ?>" style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div>
            <label>Cidade:</label>
            <input type="text" name="DIS_CIDADE" value="<?= old('DIS_CIDADE') ?>" style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div>
            <label>UF:</label>
            <input type="text" name="DIS_UF" maxlength="2" value="<?= old('DIS_UF') ?>" style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div>
            <label>ID do Usuário Proprietário (FK):</label>
            <input type="number" name="FK_USU_ID" value="<?= old('FK_USU_ID') ?>" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <!-- Coordenadas Geográficas -->
        <div>
            <label>Latitude:</label>
            <input type="text" name="DIS_LATITUDE" value="<?= old('DIS_LATITUDE') ?>" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div>
            <label>Longitude:</label>
            <input type="text" name="DIS_LONGITUDE" value="<?= old('DIS_LONGITUDE') ?>" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div style="grid-column: span 2; margin-top: 10px;">
            <button type="submit" style="background: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">Salvar Dispositivo</button>
            <a href="<?= base_url('dispositivos') ?>" style="margin-left: 15px; color: #666; text-decoration: none;">Voltar</a>
        </div>
    </form>
</main>