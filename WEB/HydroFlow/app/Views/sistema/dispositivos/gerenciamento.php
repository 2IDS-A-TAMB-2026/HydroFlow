<main style="padding: 20px; font-family: Arial, sans-serif;">
    <h2>Gerenciamento do Dispositivo: <span style="color: #007bff;"><?= esc($dispositivo['DIS_NOME']) ?></span></h2>
    <p>ID Único: <b>#<?= $dispositivo['DIS_ID'] ?></b> | Dono: <b><?= esc($dispositivo['dono_nome']) ?> (ID: <?= $dispositivo['FK_USU_ID'] ?>)</b></p>

    <!-- Indicador Visual do Nível do Tanque (Simulação IoT) -->
    <div style="background: #f4f4f4; border: 1px solid #ccc; padding: 20px; border-radius: 8px; margin-bottom: 25px; max-width: 400px;">
        <h4>Telemetria em Tempo Real</h4>
        <label>Nível Atual do Volumétrico:</label>
        <div style="background: #ddd; border-radius: 10px; height: 25px; width: 100%; margin-top: 8px; overflow: hidden; position: relative;">
            <div style="background: #007bff; width: <?= floatval($dispositivo['DIS_NIVEL_TANQUE']) ?>%; height: 100%; transition: width 0.5s;"></div>
            <span style="position: absolute; width: 100%; text-align: center; top: 3px; font-weight: bold; font-size: 14px; color: #000;">
                <?= $dispositivo['DIS_NIVEL_TANQUE'] ?>%
            </span>
        </div>
    </div>

    <h3>Atualizar Configurações / Endereço</h3>
    <form action="<?= base_url('dispositivos/salvar') ?>" method="POST" style="max-width: 600px; display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
        <?= csrf_field() ?>
        
        <!-- Input oculto com a Primary Key para que o CodeIgniter entenda que é uma ATUALIZAÇÃO e não um novo insert -->
        <input type="hidden" name="DIS_ID" value="<?= $dispositivo['DIS_ID'] ?>">
        <input type="hidden" name="FK_USU_ID" value="<?= $dispositivo['FK_USU_ID'] ?>">

        <div style="grid-column: span 2;">
            <label>Nome do Dispositivo:</label>
            <input type="text" name="DIS_NOME" value="<?= esc($dispositivo['DIS_NOME']) ?>" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div>
            <label>Status Operacional:</label>
            <select name="DIS_STATUS" style="width: 100%; padding: 8px; margin-top: 5px;">
                <option value="ATIVO" <?= $dispositivo['DIS_STATUS'] == 'ATIVO' ? 'selected' : '' ?>>ATIVO</option>
                <option value="INATIVO" <?= $dispositivo['DIS_STATUS'] == 'INATIVO' ? 'selected' : '' ?>>INATIVO</option>
            </select>
        </div>

        <div>
            <label>Forçar Nível do Tanque:</label>
            <input type="number" step="0.01" name="DIS_NIVEL_TANQUE" value="<?= $dispositivo['DIS_NIVEL_TANQUE'] ?>" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div>
            <label>Cidade:</label>
            <input type="text" name="DIS_CIDADE" value="<?= esc($dispositivo['DIS_CIDADE']) ?>" style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div>
            <label>UF:</label>
            <input type="text" name="DIS_UF" value="<?= esc($dispositivo['DIS_UF']) ?>" style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div>
            <label>Latitude:</label>
            <input type="text" name="DIS_LATITUDE" value="<?= esc($dispositivo['DIS_LATITUDE']) ?>" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div>
            <label>Longitude:</label>
            <input type="text" name="DIS_LONGITUDE" value="<?= esc($dispositivo['DIS_LONGITUDE']) ?>" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div style="grid-column: span 2; margin-top: 10px;">
            <button type="submit" style="background: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">Salvar Alterações</button>
            <a href="<?= base_url('dispositivos') ?>" style="margin-left: 15px; color: #666; text-decoration: none;">Voltar para Lista</a>
        </div>
    </form>
</main>