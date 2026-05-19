<main style="padding: 20px; font-family: Arial, sans-serif;">
    <h2>Cadastrar Novo Sensor</h2>

    <form action="<?= base_url('adm/salvarSensor') ?>" method="POST" style="max-width: 400px;">
        <?= csrf_field() ?>

        <div style="margin-bottom: 15px;">
            <label>Nome identificador do Sensor:</label><br>
            <input type="text" name="NOME_SENSOR" placeholder="Ex: DHT22 - Fluxo de Ar" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <div style="margin-bottom: 15px;">
            <label>Tipo de Sensor:</label><br>
            <select name="TIPO_SENSOR" style="width: 100%; padding: 8px; margin-top: 5px;">
                <option value="Temperatura">Temperatura</option>
                <option value="Umidade">Umidade</option>
                <option value="Presença">Presença</option>
                <option value="Luminosidade">Luminosidade</option>
            </select>
        </div>

        <div style="margin-bottom: 15px;">
            <label>Localização Física / Setor:</label><br>
            <input type="text" name="LOCALIZACAO_SENSOR" placeholder="Ex: Servidores - Sala Amarela" required style="width: 100%; padding: 8px; margin-top: 5px;">
        </div>

        <button type="submit" style="background: #28a745; color: white; padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer;">
            Registrar Sensor
        </button>
    </form>

    <br>
    <a href="<?= base_url('adm') ?>">← Voltar ao Painel</a>
</main>
