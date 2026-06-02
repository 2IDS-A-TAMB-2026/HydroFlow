<?= view("sistema/layout/dashboard/usuario/header") ?>

<div class="widget form-widget full-width-form" style="margin-bottom: 20px;">
                <h3 class="form-title" style="margin-bottom: 15px; font-size: 1.1rem;">
                    <i class="fa-solid fa-filter" style="color: #6c757d;"></i> Filtros de Busca
                </h3>
                <form class="filter-bar" method="get" action="<?= base_url('historico') ?>">
                    <div class="form-group">
                        <label>Data Inicial</label>
                        <input type="date" class="form-control" name="data_inicial" value="<?= esc($filtro_valores['data_inicial'] ?? '') ?>">
                    </div>
                    <div class="form-group">
                        <label>Data Final</label>
                        <input type="date" class="form-control" name="data_final" value="<?= esc($filtro_valores['data_final'] ?? '') ?>">
                    </div>
                    <div class="form-group">
                        <label>Setor / Área</label>
                        <?php $setor = $filtro_valores['setor_filtro'] ?? 'todos'; ?>
                        <select class="form-control" name="setor_filtro">
                            <option value="todos" <?= $setor == 'todos' ? 'selected' : '' ?>>Todos os Setores</option>
                            <option value="1" <?= $setor == '1' ? 'selected' : '' ?>>Estufa 1 (Hortaliças)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Status</label>
                        <?php $status = $filtro_valores['status_filtro'] ?? 'todos'; ?>
                        <select class="form-control" name="status_filtro">
                            <option value="todos" <?= $status == 'todos' ? 'selected' : '' ?>>Todos</option>
                            <option value="Concluído" <?= $status == 'Concluído' ? 'selected' : '' ?>>Concluído</option>
                            <option value="Falha" <?= $status == 'Falha' ? 'selected' : '' ?>>Falha</option>
                            <option value="Interrompido" <?= $status == 'Interrompido' ? 'selected' : '' ?>>Interrompido</option>
                        </select>
                    </div>
                    <div class="form-group" style="display: flex; align-items: flex-end;">
                        <button type="submit" class="btn-submit" style="width: 100%; margin: 0; padding: 12px;">
                            <i class="fa-solid fa-magnifying-glass"></i> Filtrar
                        </button>
                    </div>
                </form>
            </div>

            <div class="widget form-widget full-width-form">
    <div class="form-header-flex">
        <h3 class="form-title">
            <i class="fa-solid fa-clipboard-list" style="color: #1e3c72;"></i> Registros de Irrigação
        </h3>
        <button id="btn-exportar" class="btn-cancelar" style="margin: 0;">
            <i class="fa-solid fa-download"></i> Exportar PDF
        </button>
    </div>
    <hr class="divider">
    
    <div class="table-responsive" id="tabela-historico">
        <table class="data-table">
            <thead>
                <tr>
                    <th>Data e Hora</th>
                    <th>Setor / Cultura</th>
                    <th>Duração</th>
                    <th>Volume Estimado</th>
                    <th>Acionamento</th>
                    <th style="text-align: center;">Status</th>
                </tr>
            </thead>
            <tbody>
                <?php if (!empty($irrigacoes) && is_array($irrigacoes)): ?>
                    <?php foreach ($irrigacoes as $item): ?>
                        <tr>
                            <td>
                                <strong>
                                    <?= date('d/m/Y', strtotime($item['IRR_DATA'])) ?> - <?= date('H:i', strtotime($item['IRR_HORA'])) ?>
                                </strong>
                            </td>
                            <td><?= esc($item['nome_planta']) ?> (<?= esc($item['cultura'] ?? 'Geral') ?>)</td>
                            <td><?= esc($item['IRR_DURACAO']) ?> min</td>
                            <td><?= esc($item['IRR_VOLUME'] ?? '0.00') ?> Litros</td>
                            <td>
                                <?php if ($item['IRR_ACIONAMENTO'] === 'Automático'): ?>
                                    <i class="fa-solid fa-robot" title="Automático"></i> Automático
                                <?php else: ?>
                                    <i class="fa-solid fa-hand-pointer" title="Manual"></i> Manual
                                <?php endif; ?>
                            </td>
                            <td style="text-align: center;">
                                <?php 
                                    $badge = 'badge-green';
                                    if ($item['IRR_STATUS'] === 'Falha') $badge = 'badge-red';
                                    if ($item['IRR_STATUS'] === 'Interrompido') $badge = 'badge-yellow';
                                ?>
                                <span class="status-badge <?= $badge ?>"><?= esc($item['IRR_STATUS']) ?></span>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                <?php else: ?>
                    <tr>
                        <td colspan="6" style="text-align: center; color: #888; padding: 30px;">
                            <i class="fa-regular fa-folder-open" style="font-size: 24px; display: block; margin-bottom: 10px;"></i>
                            Nenhum registro de irrigação encontrado para os filtros selecionados.
                        </td>
                    </tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>
        </main>
    </div>

</body>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
</html>