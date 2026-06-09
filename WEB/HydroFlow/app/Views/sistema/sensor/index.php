<?php if (session()->getFlashdata('sucesso')): ?>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            Swal.fire({
                title: 'Sucesso!',
                text: '<?= session()->getFlashdata('sucesso') ?>',
                icon: 'success',
                confirmButtonColor: '#00a65a',
                timer: 3000
            });
        });
    </script>
<?php endif; ?>

<?php if (session()->getFlashdata('erro')): ?>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            Swal.fire({
                title: 'Erro!',
                text: '<?= session()->getFlashdata('erro') ?>',
                icon: 'error',
                confirmButtonColor: '#d33'
            });
        });
    </script>
<?php endif; ?>

<?= view('sistema/layout/dashboard/adm/header') ?>

<style>
    .unified-card {
        background: #ffffff;
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        padding: 20px;
        margin-bottom: 20px;
        border: 1px solid #eef2f5;
    }
    .filter-section {
        padding-bottom: 20px;
        margin-bottom: 20px;
        border-bottom: 1px solid #f1f3f5;
    }
    .data-table {
        width: 100%;
        border-collapse: collapse;
    }
    .data-table thead tr {
        border-bottom: 2px solid #edf2f7;
        text-align: left;
    }
    .data-table th {
        padding: 12px;
        color: #4a5568;
        font-weight: 600;
        font-size: 0.85rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .data-table tbody tr {
        background-color: #ffffff !important;
        border-bottom: 1px solid #edf2f7;
        transition: background-color 0.2s ease;
    }
    .data-table tbody tr:hover {
        background-color: #f8f9fa !important;
    }
    .data-table td {
        padding: 12px;
        font-size: 0.95rem;
    }
    .status-badge {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 6px;
        font-size: 0.78rem;
        font-weight: 700;
        text-transform: uppercase;
    }
    .badge-green {
        background: #e6fffa;
        color: #047857;
        border: 1px solid #b1f5e3;
    }
    .badge-red {
        background: #fef2f2;
        color: #b91c1c;
        border: 1px solid #fee2e2;
    }
    .sensor-badge {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 0.82rem;
        font-weight: 600;
    }
    .badge-solo {
        background: #e6fffa;
        color: #00a389;
    }
    .badge-ar {
        background: #ebf8ff;
        color: #2b6cb0;
    }
    .actions-cell {
        display: flex;
        gap: 8px;
        justify-content: center;
    }
    .btn-icon {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        height: 32px;
        width: 32px;
        border-radius: 6px;
        border: 1px solid #e2e8f0;
        background: #fff;
        transition: all 0.2s;
    }
    .btn-edit { color: #dd6b20; }
    .btn-edit:hover { background: #fffaf0; border-color: #f6ad55; }
    .btn-delete { color: #e53e3e; }
    .btn-delete:hover { background: #fff5f5; border-color: #feb2b2; }
</style>

<main style="padding: 20px; font-family: Arial, sans-serif;">
    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
        <div>
            <h2 style="color: #1e3c72; margin: 0; font-weight: 600;">Módulo de Sensores (Hardware)</h2>
            <p style="color: #666; margin: 5px 0 0 0;">Gerencie as grandezas, tipos e vínculos com as placas coletoras da rede.</p>
        </div>
        
        <a href="<?= base_url('admin/sensores/novo') ?>" class="btn-add-user" style="text-decoration: none; display: inline-flex; align-items: center; gap: 8px;">
            <i class="fa-solid fa-plus"></i> Novo Cadastro
        </a>
    </div>

    <div class="unified-card">
        
        <?php if (session()->getFlashdata('sucesso')): ?>
            <div style="background: #d4edda; color: #155724; border: 1px solid #c3e6cb; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; font-weight: 500;">
                <i class="fa-solid fa-circle-check"></i> <?= session()->getFlashdata('sucesso') ?>
            </div>
        <?php endif; ?>
        
        <div class="filter-section">
            <h3 class="form-title" style="margin-top: 0; margin-bottom: 15px; font-size: 1.1rem; font-weight: bold; color: #333;">
                <i class="fa-solid fa-filter" style="color: #6c757d;"></i> Filtros de Busca
            </h3>
            <form class="filter-bar" method="get" action="<?= base_url('admin/sensores') ?>" style="display: flex; gap: 15px; flex-wrap: wrap; align-items: flex-end;">
                
                <div class="form-group" style="flex: 3; min-width: 250px; display: flex; flex-direction: column; gap: 5px;">
                    <label style="font-size: 0.9rem; font-weight: bold; color: #444;">Buscar por Nome do Sensor</label>
                    <div style="position: relative; width: 100%;">
                        <input type="text" class="form-control" name="busca" placeholder="Ex: Higrômetro Solo A1..." value="<?= esc($filtro_valores['busca'] ?? '') ?>" style="width: 100%; padding: 10px 40px 10px 12px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px;">
                        <i class="fa-solid fa-magnifying-glass" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #888;"></i>
                    </div>
                </div>

                <div class="form-group" style="flex: 2; min-width: 200px; display: flex; flex-direction: column; gap: 5px;">
                    <label style="font-size: 0.9rem; font-weight: bold; color: #444;">Módulo / Placa Vinculada</label>
                    <select class="form-control" name="dispositivo_id" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px; background-color: #fff;">
                        <option value="todos">Todos os Dispositivos</option>
                        <?php if (!empty($dispositivos_disponiveis)): ?>
                            <?php foreach ($dispositivos_disponiveis as $disp): ?>
                                <option value="<?= $disp['DIS_ID'] ?>" <?= (isset($filtro_valores['dispositivo_id']) && $filtro_valores['dispositivo_id'] == $disp['DIS_ID']) ? 'selected' : '' ?>>
                                    <?= esc($disp['DIS_NOME']) ?>
                                </option>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </select>
                </div>

                <div class="form-group" style="flex: 1; min-width: 150px; display: flex; flex-direction: column; gap: 5px;">
                    <label style="font-size: 0.9rem; font-weight: bold; color: #444;">Status</label>
                    <select class="form-control" name="status_filtro" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px; background-color: #fff;">
                        <option value="todos" <?= (isset($filtro_valores['status_filtro']) && $filtro_valores['status_filtro'] == 'todos') ? 'selected' : '' ?>>Todos</option>
                        <option value="ATIVO" <?= (isset($filtro_valores['status_filtro']) && $filtro_valores['status_filtro'] == 'ATIVO') ? 'selected' : '' ?>>Ativo</option>
                        <option value="INATIVO" <?= (isset($filtro_valores['status_filtro']) && $filtro_valores['status_filtro'] == 'INATIVO') ? 'selected' : '' ?>>Inativo</option>
                    </select>
                </div>

                <div class="form-group" style="flex: 0 0 auto; display: flex; gap: 8px;">
                    <button type="submit" class="btn-submit" style="height: 42px; padding: 0 20px; background-color: #00a65a; color: #fff; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; display: flex; align-items: center; gap: 8px;">
                        Filtrar
                    </button>
                    
                    <?php if (!empty($filtro_valores['busca']) || (isset($filtro_valores['dispositivo_id']) && $filtro_valores['dispositivo_id'] !== 'todos') || (isset($filtro_valores['status_filtro']) && $filtro_valores['status_filtro'] !== 'todos')): ?>
                        <a href="<?= base_url('admin/sensores') ?>" style="display: flex; align-items: center; justify-content: center; height: 42px; width: 42px; border: 1px solid #ccc; border-radius: 6px; background: #f5f5f5; color: #333; text-decoration: none;" title="Limpar Filtros">
                            <i class="fa-solid fa-xmark"></i>
                        </a>
                    <?php endif; ?>
                </div>
            </form>
        </div>

        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width: 80px;">ID</th>
                        <th>Nome do Sensor</th>
                        <th>Tipo / Grandeza</th>
                        <th>Dispositivo Vinculado</th>
                        <th style="width: 120px;">Status</th>
                        <th style="text-align: center; width: 120px;">Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($sensores) && is_array($sensores)): ?>
                        <?php foreach ($sensores as $sensor): ?>
                            <tr>
                                <td style="color: #718096; font-weight: 500;">
                                    #<?= str_pad($sensor['SEN_ID'], 3, '0', STR_PAD_LEFT) ?>
                                </td>
                                <td><strong><?= esc($sensor['SEN_NOME']) ?></strong></td>
                                <td>
                                    <?php if (strpos(strtolower($sensor['SEN_TIPO']), 'solo') !== false): ?>
                                        <span class="sensor-badge badge-solo">
                                            <i class="fa-solid fa-seedling"></i> Umidade do Solo
                                        </span>
                                    <?php else: ?>
                                        <span class="sensor-badge badge-ar">
                                            <i class="fa-solid fa-cloud-sun"></i> Ar e Temp
                                        </span>
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <span style="color: #4a5568; font-weight: 500;">
                                        <i class="fa-solid fa-box" style="color: #adb5bd; margin-right: 4px;"></i>
                                        <?= esc($sensor['DIS_NOME'] ?? 'Dispositivo #' . $sensor['FK_DIS_ID']) ?>
                                    </span>
                                </td>
                                <td>
                                    <?php if (strtoupper($sensor['SEN_STATUS'] ?? 'ATIVO') === 'ATIVO'): ?>
                                        <span class="status-badge badge-green">Ativo</span>
                                    <?php else: ?>
                                        <span class="status-badge badge-red">Inativo</span>
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <div class="actions-cell">
                                        <a href="<?= base_url('admin/sensores/editar/' . $sensor['SEN_ID']) ?>" class="btn-icon btn-edit" title="Editar">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>
                                        
                                        <a href="#" 
                                           class="btn-icon btn-delete btn-deletar-custom" 
                                           title="Excluir"
                                           data-url="<?= base_url('admin/sensores/excluir/' . $sensor['SEN_ID']) ?>" 
                                           data-nome="<?= esc($sensor['SEN_NOME']) ?>">
                                            <i class="fa-solid fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="6" style="text-align: center; color: #999; padding: 40px 20px;">
                                <div style="margin-bottom: 10px;">
                                    <i class="fa-solid fa-folder-open" style="font-size: 1.5rem; color: #adb5bd;"></i>
                                </div>
                                Nenhum sensor encontrado.
                            </td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>

    </div>
</main>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const botoesExcluir = document.querySelectorAll('.btn-deletar-custom');

    botoesExcluir.forEach(botao => {
        botao.addEventListener('click', function(e) {
            e.preventDefault();

            const urlExclusao = this.getAttribute('data-url');
            const nomeSensor = this.getAttribute('data-nome');

            Swal.fire({
                title: 'Tem certeza?',
                text: `Você está prestes a remover o sensor "${nomeSensor}". Esta ação não pode ser desfeita!`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: '<i class="fa-solid fa-trash"></i> Sim, deletar!',
                cancelButtonText: 'Cancelar',
                background: '#fff',
                borderRadius: '8px'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = urlExclusao;
                }
            });
        });
    });
});
</script>