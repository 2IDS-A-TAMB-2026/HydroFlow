<?= view('layout/dashboard/header') ?>

<!DOCTYPE html>
        <!-- Conteúdo -->
        <main class="main-content">
            <!-- Cards -->
            <section class="kpi-cards">

                <div class="card card-cyan">

                    <div class="card-content">
                        <h3><?= $ativos ?? 66 ?></h3>
                        <p>Dispositivos Ativos</p>
                    </div>

                    <i class="fa-solid fa-hard-drive card-icon"></i>

                    <div class="card-footer"></div>

                </div>

                <div class="card card-orange">

                    <div class="card-content">
                        <h3><?= $alertas ?? 68 ?></h3>
                        <p>Alertas não verificados</p>
                    </div>

                    <i class="fa-solid fa-triangle-exclamation card-icon"></i>

                    <div class="card-footer"></div>

                </div>

                <div class="card card-green">

                    <div class="card-content">
                        <h3><?= $plantas ?? 30 ?></h3>
                        <p>Plantas Cadastradas</p>
                    </div>

                    <i class="fa-solid fa-seedling card-icon"></i>

                    <div class="card-footer"></div>

                </div>

                <div class="card card-red">

                    <div class="card-content">
                        <h3><?= $inativos ?? 30 ?></h3>
                        <p>Dispositivos Inativos</p>
                    </div>

                    <i class="fa-solid fa-bug card-icon"></i>

                    <div class="card-footer"></div>

                </div>

            </section>

            <!-- Área Inferior -->
            <section class="bottom-grid">

                <!-- Tabela -->
                <div class="widget table-widget">

                    <h3>Status</h3>

                    <table>

                        <thead>
                            <tr>
                                <th>Planta</th>
                                <th>Dispositivo</th>
                                <th>Status</th>
                            </tr>
                        </thead>

                        <tbody>

                            <?php if (!empty($status)): ?>

                                <?php foreach ($status as $item): ?>

                                    <tr>

                                        <td><?= esc($item['planta']) ?></td>

                                        <td><?= esc($item['dispositivo']) ?></td>

                                        <td>

                                            <?php if ($item['status'] == 'IRRIGADO'): ?>

                                                <span class="badge badge-green">
                                                    IRRIGADO
                                                </span>

                                            <?php else: ?>

                                                <span class="badge badge-red">
                                                    FALHA
                                                </span>

                                            <?php endif; ?>

                                        </td>

                                    </tr>

                                <?php endforeach; ?>

                            <?php else: ?>

                                <tr>
                                    <td>Samambaia</td>
                                    <td>Irriga 1000</td>
                                    <td>
                                        <span class="badge badge-green">
                                            IRRIGADO
                                        </span>
                                    </td>
                                </tr>

                                <tr>
                                    <td>Tomateira</td>
                                    <td>Irrigador Lest</td>
                                    <td>
                                        <span class="badge badge-green">
                                            IRRIGADO
                                        </span>
                                    </td>
                                </tr>

                                <tr>
                                    <td>Cliente Modelo 2</td>
                                    <td>2,00</td>
                                    <td>
                                        <span class="badge badge-red">
                                            FALHA
                                        </span>
                                    </td>
                                </tr>

                            <?php endif; ?>

                        </tbody>

                    </table>

                </div>

                <!-- Gráfico -->
                <div class="widget chart-widget">

                    <h3 class="chart-title">
                        Monitoramento Geral
                    </h3>

                    <div class="chart-container">
                        <canvas id="vendasChart"></canvas>
                    </div>

                </div>

            </section>

        </main>

    </div>

    <!-- JS -->
    <script src="<?= base_url('assts/ejs/dashboard.js') ?>"></script>

</body>

</html>