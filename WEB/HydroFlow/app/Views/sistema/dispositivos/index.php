<main style="padding: 20px; font-family: Arial, sans-serif;">
    <h2>Módulo de Dispositivos (IoT)</h2>
    <p>Gerencie a telemetria, localização e propriedade dos dispositivos integrados.</p>

    <div style="display: flex; gap: 20px; margin-top: 20px;">
        <!-- Card para Listagem -->
        <div style="border: 1px solid #ccc; padding: 20px; border-radius: 8px; width: 220px; box-shadow: 2px 2px 5px rgba(0,0,0,0.05);">
            <h3>Ver Dispositivos</h3>
            <p>Consulte a tabela de todos os dispositivos e níveis de tanque.</p>
            <a href="<?= base_url('dispositivos/listagem') ?>" style="display:inline-block; background:#007bff; color:white; padding:8px 12px; text-decoration:none; border-radius:4px;">Abrir Lista</a>
        </div>

        <!-- Card para Novo Cadastro -->
        <div style="border: 1px solid #ccc; padding: 20px; border-radius: 8px; width: 220px; box-shadow: 2px 2px 5px rgba(0,0,0,0.05);">
            <h3>Novo Cadastro</h3>
            <p>Registrar um novo dispositivo no banco de dados.</p>
            <a href="<?= base_url('dispositivos/novo') ?>" style="display:inline-block; background:#28a745; color:white; padding:8px 12px; text-decoration:none; border-radius:4px;">Cadastrar</a>
        </div>
    </div>
</main>