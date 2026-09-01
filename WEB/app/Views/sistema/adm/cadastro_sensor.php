<main style="padding: 20px; font-family: Arial, sans-serif;">
    <h2>Cadastrar Novo Sensor</h2>

    <form id="formSensor" action="<?= base_url('adm/salvarSensor') ?>" method="POST" style="max-width: 400px;">
        <?= csrf_field() ?>

        <div style="margin-bottom: 15px;">
            <label>Nome identificador do Sensor:</label><br>
            <input type="text" id="NOME_SENSOR" name="NOME_SENSOR" placeholder="Ex: DHT22 - Fluxo de Ar" required style="width: 100%; padding: 8px; margin-top: 5px;">
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
    <a href="<?= base_url('adm') ?>" style="text-decoration: none; color: #666;">← Voltar ao Painel</a>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const form = document.getElementById("formSensor");

            form.addEventListener("submit", function(e) {
                e.preventDefault(); 
                const nomeSensor = document.getElementById("NOME_SENSOR").value;

                Swal.fire({
                    title: 'Confirmar Registro?',
                    text: `Deseja cadastrar o sensor "${nomeSensor}" no sistema?`,
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#28a745',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Sim, registrar!',
                    cancelButtonText: 'Cancelar',
                    reverseButtons: true
                }).then((result) => {
                    if (result.isConfirmed) {
                        Swal.fire({
                            title: 'Registrando...',
                            text: 'Aguarde um momento.',
                            allowOutsideClick: false,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        });

                        form.submit();
                    }
                });
            });
        });
    </script>
</main>