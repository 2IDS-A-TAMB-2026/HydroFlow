    <?= view("sistema/layout/dashboard/header") ?>
            <section class="kpi-cards">
                <div class="card card-cyan">
                    <div class="card-content">
                        <h3>66</h3>
                        <p>Dispositivos Ativos</p>
                    </div>
                    <i class="fa-solid fa-hard-drive card-icon"></i>
                    <div class="card-footer"></div>
                </div>
                <div class="card card-orange">
                    <div class="card-content">
                        <h3>68</h3>
                        <p>Alertas não verificados</p>
                    </div>
                    <i class="fa-solid fa-triangle-exclamation card-icon"></i>
                    <div class="card-footer"></div>
                </div>
                <div class="card card-green">
                    <div class="card-content">
                        <h3>30</h3>
                        <p>Plantas Cadastradas</p>
                    </div>
                    <i class="fa-solid fa-seedling card-icon"></i>
                    <div class="card-footer"></div>
                </div>
                <div class="card card-red">
                    <div class="card-content">
                        <h3>30</h3>
                        <p>Dispositivos Inativos</p>
                    </div>
                    <i class="fa-solid fa-bug card-icon"></i>
                    <div class="card-footer"></div>
                </div>
            </section>

            <section class="bottom-grid">
                <div class="widget table-widget">
                    <h3>Status</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Planta</th>
                                <th>Dispositivo</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Samabaia</td>
                                <td>Irriga 1000</td>
                                <td><span class="badge badge-green">IRRIGADO</span></td>
                            </tr>
                            <tr>
                                <td>Tomateira</td>
                                <td>Irrigador Lest</td>
                                <td><span class="badge badge-green">IRRIGADO</span></td>
                            </tr>
                            <tr>
                                <td>Cliente Modelo 2</td>
                                <td>2,00</td>
                                <td><span class="badge badge-red">FALHA</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="widget chart-widget">
                    <h3 class="chart-title"></h3>
                    <div class="chart-container">
                        <canvas id="vendasChart"></canvas>
                    </div>
                </div>
            </section>
        </main>
    </div>

    <script src="<?= base_url('assets/js/dashboard.js') ?>"></script>
</body>
</html>