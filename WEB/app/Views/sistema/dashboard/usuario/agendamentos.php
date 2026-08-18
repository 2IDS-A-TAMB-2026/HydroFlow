<?= view("sistema/layout/dashboard/usuario/header") ?>
<main class="main-content">
    <header class="top-nav">
        <div class="nav-left">
            <button class="menu-btn"><i class="fa-solid fa-bars"></i></button>
            <h2>Agendamento de Irrigações</h2>
        </div>
        <div class="nav-right">
            <span>Manual Sistema Gestão Online</span>
            <i class="fa-solid fa-user"></i>
            <i class="fa-solid fa-bell"></i>
        </div>
    </header>

    <div class="agenda-grid">
        <div class="widget form-widget">
            <h3 class="form-title">
                <i class="fa-solid fa-droplet" style="color: #0e4c5c;"></i> Novo Agendamento
            </h3>
            <hr class="divider">
            
            <form id="formIrrigacao">
                <div class="form-group">
                    <label for="setor">Setor / Área</label>
                    <select id="setor" class="form-control" required>
                        <option value="">Selecione o setor...</option>
                        <option value="estufa1">Estufa 1 (Hortaliças)</option>
                        <option value="estufa2">Estufa 2 (Morangos)</option>
                        <option value="campo">Campo Aberto</option>
                    </select>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="data">Data</label>
                        <input type="date" id="data" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="hora">Horário</label>
                        <input type="time" id="hora" class="form-control" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="disp">Dispositivo responsável</label>
                    <select id="disp" class="form-control" required>
                        <option value="">Selecione o Dispositivo...</option>
                        <option value="disp1">Irriga 1000</option>
                        <option value="disp2">Hortas irrigadas 03012</option>
                        <option value="disp3">Irrigation daora</option>
                        <option value="disp4">Irrigator bonito</option>
                    </select>
                </div>

                <button type="submit" class="btn-submit">
                    <i class="fa-solid fa-check"></i> Salvar Agendamento
                </button>
            </form>
        </div>

        <div class="widget table-widget">
            <h3><i class="fa-solid fa-list-check" style="color: #f39c12;"></i> Próximas Irrigações</h3>
            <hr class="divider">
            <table>
                <thead>
                    <tr>
                        <th>Setor</th>
                        <th>Data/Hora</th>
                        <th>Duração</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Estufa 1</td>
                        <td>14/04/2026 - 06:00</td>
                        <td>30 min</td>
                        <td><span class="badge badge-green">CONCLUÍDO</span></td>
                    </tr>
                    <tr>
                        <td>Pomar</td>
                        <td>14/04/2026 - 16:30</td>
                        <td>60 min</td>
                        <td><span class="badge badge-orange">AGENDADO</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("formIrrigacao");

    form.addEventListener("submit", function (e) {
        e.preventDefault();

        // Pega os dados para mostrar no alerta
        const setorNome = document.getElementById("setor").options[document.getElementById("setor").selectedIndex].text;
        const dataVal = document.getElementById("data").value;
        const horaVal = document.getElementById("hora").value;

        Swal.fire({
            title: 'Confirmar Agendamento?',
            html: `Deseja programar a irrigação para:<br><b>${setorNome}</b><br>em <b>${dataVal}</b> às <b>${horaVal}</b>?`,
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#0e4c5c', // Cor azul do seu tema
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Sim, agendar!',
            cancelButtonText: 'Cancelar',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                // Simulação de salvamento
                Swal.fire({
                    title: 'Salvando agendamento...',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                setTimeout(() => {
                    Swal.fire({
                        icon: 'success',
                        title: 'Agendado!',
                        text: 'A irrigação foi salva com sucesso.',
                        confirmButtonColor: '#0e4c5c'
                    });
                    form.reset(); 
                }, 1500);
            }
        });
    });
});
</script>