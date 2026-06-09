<?= view("sistema/layout/dashboard/usuario/header") ?>

<main class="main-content">
    <header class="top-nav">
        <div class="nav-left">
            <button class="menu-btn"><i class="fa-solid fa-bars"></i></button>
            <h2><?= esc($titulo) ?></h2>
        </div>
    </header>

    <div class="widget form-widget full-width-form" style="margin-bottom: 20px;">
        <h3 class="form-title" style="margin-bottom: 15px; font-size: 1.1rem;">
            <i class="fa-solid fa-filter" style="color: #6c757d;"></i> Filtros de Busca
        </h3>
        
        <form class="filter-bar" method="get" action="<?= base_url('dados_sensores') ?>">
            <div class="form-group">
                <label>Data Inicial</label>
                <input type="date" class="form-control" name="data_inicial" value="<?= esc($filtro_valores['data_inicial']) ?>">
            </div>

            <div class="form-group">
                <label>Data Final</label>
                <input type="date" class="form-control" name="data_final" value="<?= esc($filtro_valores['data_final']) ?>">
            </div>

            <div class="form-group">
                <label>Temperatura Acima de (°C)</label>
                <input type="number" class="form-control" name="temp_min" placeholder="Ex: 25" min="0" max="100" value="<?= esc($filtro_valores['temp_min']) ?>">
            </div>

            <div class="form-group">
                <label>Umidade Abaixo de (%)</label>
                <input type="number" class="form-control" name="umidade_max" placeholder="Ex: 40" min="0" max="100" value="<?= esc($filtro_valores['umidade_max']) ?>">
            </div>

            <div class="form-group">
                <label>Classificação da Umidade</label>
                <?php $statusAtual = $filtro_valores['status_filtro'] ?? 'todos'; ?>
                <select class="form-control" name="status_filtro">
                    <option value="todos" <?= $statusAtual === 'todos' ? 'selected' : '' ?>>Todos</option>
                    <option value="otimo" <?= $statusAtual === 'otimo' ? 'selected' : '' ?>>Ótimo (>70%)</option>
                    <option value="bom" <?= $statusAtual === 'bom' ? 'selected' : '' ?>>Bom (40% - 70%)</option>
                    <option value="ruim" <?= $statusAtual === 'ruim' ? 'selected' : '' ?>>Ruim (<40%)</option>
                </select>
            </div>

            <div class="form-group" style="display: flex; align-items: flex-end;">
                <button type="submit" class="btn-submit" style="width: 100%; margin: 0; padding: 12px; background-color: #00a65a; border: none; color: white; cursor: pointer; font-weight: bold; border-radius: 4px;">
                    <i class="fa-solid fa-magnifying-glass"></i> Filtrar
                </button>
            </div>
        </form>
    </div>

    <div class="widget form-widget full-width-form">
        <div class="form-header-flex">
            <h3 class="form-title">
                <i class="fa-solid fa-clipboard-list" style="color: #1e3c72;"></i> Registros dos Sensores (ESP32)
            </h3>
            <button class="btn-cancelar" style="margin: 0;"><i class="fa-solid fa-download"></i> Exportar PDF</button>
        </div>
        <hr class="divider">
        
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Data e Hora</th>
                        <th>Sensor / Área</th>
                        <th>Temperatura</th>
                        <th>Umidade Coletada</th>
                        <th style="text-align: center;">Status / Saúde</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($medicoes) && is_array($medicoes)): ?>
                        <?php foreach ($medicoes as $medicao): ?>
                            <tr>
                                <td>
                                    <strong>
                                        <?= date('d/m/Y', strtotime($medicao['DDS_DATA'])) ?> - <?= date('H:i', strtotime($medicao['DDS_HORA'])) ?>
                                    </strong>
                                </td>
                                <td><?= esc($medicao['nome_sensor'] ?? 'Sensor #' . $medicao['FK_SEN_ID']) ?></td>
                                <td><?= esc($medicao['DDS_TEMP'] ?? '0') ?> °C</td>
                                <td><?= esc($medicao['DDS_UMIDADE'] ?? '0') ?> %</td>
                                
                                <td style="text-align: center;">
                                    <?php 
                                    // Conversão direta para float sem firula, já que o banco entrega número puro
                                    $umidade = (float)($medicao['DDS_UMIDADE'] ?? 0);
                                    
                                    if ($umidade < 40.00): ?>
                                        <span class="status-badge badge-red" style="background-color: #f8d7da; color: #721c24; padding: 6px 12px; border-radius: 4px; font-weight: bold; display: inline-block; min-width: 70px;">Ruim</span>
                                    <?php elseif ($umidade <= 70.00): ?>
                                        <span class="status-badge badge-yellow" style="background-color: #fff3cd; color: #856404; padding: 6px 12px; border-radius: 4px; font-weight: bold; display: inline-block; min-width: 70px;">Bom</span>
                                    <?php else: ?>
                                        <span class="status-badge badge-green" style="background-color: #d4edda; color: #155724; padding: 6px 12px; border-radius: 4px; font-weight: bold; display: inline-block; min-width: 70px;">Ótimo</span>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="5" class="text-center text-muted" style="padding: 20px; text-align: center;">Nenhuma medição encontrada para os seus dispositivos.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</main>