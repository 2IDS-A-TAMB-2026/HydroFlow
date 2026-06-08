<?php if (session()->getFlashdata('sucesso')): ?>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            Swal.fire({
                title: 'Sucesso!',
                text: '<?= session()->getFlashdata('sucesso') ?>',
                icon: 'success',
                confirmButtonColor: '#00a65a',
                timer: 3000 // Fecha sozinho depois de 3 segundos se o usuário não clicar
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

<main style="padding: 20px; font-family: Arial, sans-serif;">
    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
        <div>
            <h2 style="color: #1e3c72; margin: 0; font-weight: 600;">Módulo de Dispositivos (IoT)</h2>
            <p style="color: #666; margin: 5px 0 0 0;">Gerencie a telemetria, localização e propriedade dos dispositivos integrados.</p>
        </div>
        
        <a href="<?= base_url('admin/dispositivos/novo') ?>" class="btn-add-user" style="text-decoration: none; display: inline-flex; align-items: center; gap: 8px;">
            <i class="fa-solid fa-plus"></i> Novo Cadastro
        </a>
    </div>

    <?php if (session()->getFlashdata('sucesso')): ?>
        <div style="background: #d4edda; color: #155724; border: 1px solid #c3e6cb; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; font-weight: 500;">
            <i class="fa-solid fa-circle-check"></i> <?= session()->getFlashdata('sucesso') ?>
        </div>
    <?php endif; ?>

    <div class="widget form-widget full-width-form" style="margin-bottom: 20px;">
        <h3 class="form-title" style="margin-bottom: 15px; font-size: 1.1rem; font-weight: bold; color: #333;">
            <i class="fa-solid fa-filter" style="color: #6c757d;"></i> Filtros de Busca
        </h3>
        <form class="filter-bar" method="get" action="<?= base_url('admin/dispositivos') ?>" style="display: flex; gap: 15px; flex-wrap: wrap; align-items: flex-end;">
            
            <div class="form-group" style="flex: 3; min-width: 250px; display: flex; flex-direction: column; gap: 5px;">
                <label style="font-size: 0.9rem; font-weight: bold; color: #444;">Buscar por Nome / Descrição</label>
                <div style="position: relative; width: 100%;">
                    <input type="text" class="form-control" name="busca" placeholder="Ex: Sensor Alpha..." value="<?= esc($filtro_valores['busca'] ?? '') ?>" style="width: 100%; padding: 10px 40px 10px 12px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px;">
                    <i class="fa-solid fa-magnifying-glass" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #888;"></i>
                </div>
            </div>

            <div class="form-group" style="flex: 2; min-width: 200px; display: flex; flex-direction: column; gap: 5px;">
                <label style="font-size: 0.9rem; font-weight: bold; color: #444;">Dono / Proprietário</label>
                <select class="form-control" name="dono_id" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px; background-color: #fff;">
                    <option value="todos" <?= (isset($filtro_valores['dono_id']) && $filtro_valores['dono_id'] == 'todos') ? 'selected' : '' ?>>Todos os Proprietários</option>
                    <?php if (!empty($usuarios_disponiveis)): ?>
                        <?php foreach ($usuarios_disponiveis as $usu): ?>
                            <option value="<?= $usu['USU_ID'] ?>" <?= (isset($filtro_valores['dono_id']) && $filtro_valores['dono_id'] == $usu['USU_ID']) ? 'selected' : '' ?>>
                                <?= esc($usu['USU_NOME']) ?>
                            </option>
                        <?php endforeach; ?>
                    <?php endif; ?>
                </select>
            </div>

            <div class="form-group" style="flex: 1; min-width: 150px; display: flex; flex-direction: column; gap: 5px;">
                <label style="font-size: 0.9rem; font-weight: bold; color: #444;">Status</label>
                <select class="form-control" name="status_filtro" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px; background-color: #fff;">
                    <option value="todos" <?= (isset($filtro_valores['status_filtro']) && $filtro_valores['status_filtro'] == 'todos') ? 'selected' : '' ?>>Todos os Status</option>
                    <option value="ativo" <?= (isset($filtro_valores['status_filtro']) && $filtro_valores['status_filtro'] == 'ativo') ? 'selected' : '' ?>>Ativo</option>
                    <option value="alerta" <?= (isset($filtro_valores['status_filtro']) && $filtro_valores['status_filtro'] == 'alerta') ? 'selected' : '' ?>>Alerta</option>
                    <option value="inativo" <?= (isset($filtro_valores['status_filtro']) && $filtro_valores['status_filtro'] == 'inativo') ? 'selected' : '' ?>>Inativo</option>
                </select>
            </div>

            <div class="form-group" style="flex: 0 0 auto; display: flex; gap: 8px;">
                <button type="submit" class="btn-submit" style="height: 42px; padding: 0 20px; background-color: #00a65a; color: #fff; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; display: flex; align-items: center; gap: 8px;">
                    Filtrar
                </button>
                
                <?php if (!empty($filtro_valores['busca']) || (isset($filtro_valores['dono_id']) && $filtro_valores['dono_id'] !== 'todos') || (isset($filtro_valores['status_filtro']) && $filtro_valores['status_filtro'] !== 'todos')): ?>
                    <a href="<?= base_url('admin/dispositivos') ?>" style="display: flex; align-items: center; justify-content: center; height: 42px; width: 42px; border: 1px solid #ccc; border-radius: 6px; background: #f5f5f5; color: #333; text-decoration: none;" title="Limpar Filtros">
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
                    <th>ID</th>
                    <th>Nome do Dispositivo</th>
                    <th>Localização / Tanque</th>
                    <th>Última Telemetria</th>
                    <th>Status</th>
                    <th style="text-align: center;">Ações</th>
                </tr>
            </thead>
            <tbody>
                <?php if (!empty($dispositivos) && is_array($dispositivos)): ?>
                    <?php foreach ($dispositivos as $disp): ?>
                        <tr>
                           <td>#<?= str_pad($disp['DIS_ID'], 3, '0', STR_PAD_LEFT) ?></td>
                            <td><strong><?= esc($disp['DIS_NOME']) ?></strong></td>
                            <td>
                                <?= esc($disp['DIS_DESCRICAO'] ?: 'Sem descrição informada') ?>
                                <br>
                                <small style="color: #888;">
                                    <i class="fa-solid fa-user"></i> Dono: <?= esc($disp['dono_nome'] ?? 'Não vinculado') ?>
                                </small>
                            </td>
                            <td>
                                <?= esc($disp['DIS_NIVEL_TANQUE']) ?>% (<?= number_format(($disp['DIS_NIVEL_TANQUE'] * 0.147), 1, ',', '.') ?>L)
                            </td>
                            <td>
                                <?php if (strtoupper($disp['DIS_STATUS']) === 'ATIVO'): ?>
                                    <span class="status-badge badge-green">Ativo</span>
                                <?php else: ?>
                                    <span class="status-badge badge-red">Inativo</span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <div class="actions-cell">
                                    <a href="<?= base_url('admin/dispositivos/novo/' . $disp['DIS_ID']) ?>" class="btn-icon btn-edit" title="Editar" style="text-decoration: none;">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </a>
                                    
                                    <a href="#" 
                                    class="btn-icon btn-delete btn-deletar-custom" 
                                    title="Excluir" 
                                    style="text-decoration: none;"
                                    data-url="<?= base_url('admin/dispositivos/excluir/' . $disp['DIS_ID']) ?>" 
                                    data-nome="<?= esc($disp['DIS_NOME']) ?>">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                <?php else: ?>
                    <tr>
                        <td colspan="6" style="text-align: center; color: #999; padding: 30px;">
                            <i class="fa-solid fa-folder-open" style="font-size: 1.5rem; display: block; margin-bottom: 10px;"></i>
                            Nenhum dispositivo encontrado.
                        </td>
                    </tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</main>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Captura todos os botões de excluir que têm a nossa classe customizada
    const botoesExcluir = document.querySelectorAll('.btn-deletar-custom');

    botoesExcluir.forEach(botao => {
        botao.addEventListener('click', function(e) {
            e.preventDefault(); // Impede o link de navegar imediatamente

            const urlExclusao = this.getAttribute('data-url');
            const nomeDispositivo = this.getAttribute('data-nome');

            // Dispara o SweetAlert2 bonitão
            Swal.fire({
                title: 'Tem certeza?',
                text: `Você está prestes a remover o dispositivo "${nomeDispositivo}". Esta ação não pode ser desfeita!`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33', // Vermelho para ação destrutiva
                cancelButtonColor: '#3085d6', // Azul para cancelar
                confirmButtonText: '<i class="fa-solid fa-trash"></i> Sim, deletar!',
                cancelButtonText: 'Cancelar',
                background: '#fff',
                borderRadius: '8px'
            }).then((result) => {
                // Se o usuário confirmou, redireciona para a rota de exclusão do controller
                if (result.isConfirmed) {
                    window.location.href = urlExclusao;
                }
            });
        });
    });
});
</script>