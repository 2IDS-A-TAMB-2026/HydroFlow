<?php if (session()->getFlashdata('sucesso') || session()->getFlashdata('success')): ?>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            Swal.fire({
                title: 'Sucesso!',
                text: '<?= session()->getFlashdata('sucesso') ?? session()->getFlashdata('success') ?>',
                icon: 'success',
                confirmButtonColor: '#00a65a',
                timer: 3000
            });
        });
    </script>
<?php endif; ?>

<?php if (session()->getFlashdata('erro') || session()->getFlashdata('error')): ?>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            Swal.fire({
                title: 'Erro!',
                text: '<?= session()->getFlashdata('erro') ?? session()->getFlashdata('error') ?>',
                icon: 'error',
                confirmButtonColor: '#d33'
            });
        });
    </script>
<?php endif; ?>

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
    .data-table tbody tr {
        background-color: #ffffff !important;
        transition: background-color 0.2s ease;
    }
    .data-table tbody tr:hover {
        background-color: #f8f9fa !important;
    }
</style>

<main style="padding: 20px; font-family: Arial, sans-serif;">
            
    <?php if (!empty($usuario)): ?>
        <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
            <div>
                <h2 style="color: #1e3c72; margin: 0; font-weight: 600;"><i class="fa-solid fa-user-pen"></i> Editar Cadastro de Usuário</h2>
                <p style="color: #666; margin: 5px 0 0 0;">Editando o cadastro de: <b><?= esc($usuario['USU_NOME'] ?? $usuario['NOME_USUARIO'] ?? '') ?></b></p>
            </div>
        </div>

        <?php if (session()->getFlashdata('sucesso') || session()->getFlashdata('success')): ?>
            <div style="background: #d4edda; color: #155724; border: 1px solid #c3e6cb; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; font-weight: 500; max-width: 600px;">
                <i class="fa-solid fa-circle-check"></i> <?= session()->getFlashdata('sucesso') ?? session()->getFlashdata('success') ?>
            </div>
        <?php endif; ?>

        <?php if (session()->getFlashdata('erro') || session()->getFlashdata('error')): ?>
            <div style="background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; font-weight: 500; max-width: 600px;">
                <i class="fa-solid fa-circle-xmark"></i> <?= session()->getFlashdata('erro') ?? session()->getFlashdata('error') ?>
            </div>
        <?php endif; ?>

        <div class="unified-card" style="max-width: 600px;">
            <form id="formGerenciarUsuario" action="<?= base_url('admin/usuarios/' . ($usuario['USU_ID'] ?? $usuario['ID_USUARIO'] ?? '')) ?>" method="POST">
                <?= csrf_field() ?>

                <div style="margin-bottom: 15px; display: flex; flex-direction: column; gap: 5px;">
                    <label style="font-size: 0.9rem; font-weight: bold; color: #444;">Nome do Usuário:</label>
                    <input type="text" name="NOME_USUARIO" value="<?= esc($usuario['USU_NOME'] ?? $usuario['NOME_USUARIO'] ?? '') ?>" required style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px;">
                </div>

                <div style="margin-bottom: 15px; display: flex; flex-direction: column; gap: 5px;">
                    <label style="font-size: 0.9rem; font-weight: bold; color: #444;">E-mail corporativo:</label>
                    <input type="email" name="EMAIL_USUARIO" value="<?= esc($usuario['USU_EMAIL'] ?? $usuario['EMAIL_USUARIO'] ?? '') ?>" required style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px;">
                </div>

                <div style="margin-bottom: 25px; display: flex; flex-direction: column; gap: 5px;">
                    <label style="font-size: 0.9rem; font-weight: bold; color: #444;">Status da Conta:</label>
                    <?php $statusAtual = $usuario['USU_STATUS'] ?? $usuario['STATUS_USUARIO'] ?? 'ATIVO'; ?>
                    <select name="STATUS_USUARIO" id="STATUS_USUARIO" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; background: white; height: 42px; cursor: pointer;">
                        <option value="ATIVO" <?= strtoupper($statusAtual) === 'ATIVO' ? 'selected' : '' ?>>ATIVO</option>
                        <option value="INATIVO" <?= strtoupper($statusAtual) === 'INATIVO' ? 'selected' : '' ?>>INATIVO</option>
                    </select>
                </div>

                <button type="submit" class="btn-submit" style="width: 100%; height: 45px; background-color: #1e3c72; color: #fff; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 8px; font-size: 1rem;">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar Alterações
                </button>
            </form>

            <hr style="margin: 30px 0; border: 0; border-top: 1px solid #f1f3f5;">

            <div style="background: #fdf2f2; padding: 15px; border: 1px solid #f5c6cb; border-radius: 6px;">
                <h4 style="color: #721c24; margin-top: 0; margin-bottom: 5px; font-weight: bold;"><i class="fa-solid fa-triangle-exclamation"></i> Zona Crítica</h4>
                <p style="font-size: 13px; color: #721c24; margin-bottom: 12px;">A remoção do usuário do sistema é uma ação definitiva.</p>
                <a href="#" 
                   class="status-badge badge-red btnExcluirUsuario"
                   style="display: inline-flex; text-decoration: none; align-items: center; padding: 8px 16px; border-radius: 6px; font-weight: bold; font-size: 0.85rem;"
                   data-url="<?= base_url('admin/excluirUsuario/' . ($usuario['USU_ID'] ?? $usuario['ID_USUARIO'] ?? '')) ?>"
                   data-nome="<?= esc($usuario['USU_NOME'] ?? $usuario['NOME_USUARIO'] ?? '') ?>">
                     Excluir Conta Permanentemente
                </a>
            </div>

            <div style="margin-top: 20px;">
                <a href="<?= base_url('admin/usuarios') ?>" style="text-decoration: none; color: #666; font-size: 0.9rem; display: inline-flex; align-items: center; gap: 5px;">← Cancelar e Voltar para Lista</a>
            </div>
        </div>

    <?php else: ?>
        <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
            <div>
                <h2 style="color: #1e3c72; margin: 0; font-weight: 600;"><i class="fa-solid fa-users-gear"></i> Gerenciamento de Usuários</h2>
                <p style="color: #666; margin: 5px 0 0 0;">Adicione, edite ou remova acessos ao sistema Hydroflow.</p>
            </div>
        </div>

        <?php if (session()->getFlashdata('sucesso') || session()->getFlashdata('success')): ?>
            <div style="background: #d4edda; color: #155724; border: 1px solid #c3e6cb; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; font-weight: 500;">
                <i class="fa-solid fa-circle-check"></i> <?= session()->getFlashdata('sucesso') ?? session()->getFlashdata('success') ?>
            </div>
        <?php endif; ?>

        <?php if (session()->getFlashdata('erro') || session()->getFlashdata('error')): ?>
            <div style="background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; font-weight: 500;">
                <i class="fa-solid fa-circle-xmark"></i> <?= session()->getFlashdata('erro') ?? session()->getFlashdata('error') ?>
            </div>
        <?php endif; ?>

        <div class="unified-card">
            
            <div class="filter-section">
                <h3 style="margin-top: 0; margin-bottom: 15px; font-size: 1.1rem; font-weight: bold; color: #333;">
                    <i class="fa-solid fa-filter" style="color: #6c757d;"></i> Filtros de Busca
                </h3>
                
                <form method="GET" action="<?= base_url('admin/usuarios') ?>" style="display: flex; gap: 15px; align-items: flex-end; flex-wrap: wrap; width: 100%;">
                    
                    <div style="flex: 3; min-width: 250px; display: flex; flex-direction: column; gap: 5px;">
                        <label style="font-size: 0.9rem; font-weight: bold; color: #444;">Buscar Usuário</label>
                        <div style="position: relative; width: 100%;">
                            <input type="text" name="busca_nome" value="<?= esc($busca_nome ?? '') ?>" placeholder="Digite o nome ou e-mail..." style="width: 100%; padding: 10px 40px 10px 12px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px;">
                            <i class="fa-solid fa-magnifying-glass" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #888;"></i>
                        </div>
                    </div>

                    <div style="flex: 1; min-width: 180px; display: flex; flex-direction: column; gap: 5px;">
                        <label style="font-size: 0.9rem; font-weight: bold; color: #444;">UF (Estado)</label>
                        <select name="busca_uf" onchange="this.form.submit()" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; background: white; height: 42px; cursor: pointer;">
                            <option value="">Todos os Estados</option>
                            <?php if (!empty($ufs_disponiveis)): ?>
                                <?php foreach ($ufs_disponiveis as $ufItem): ?>
                                    <?php $ufValor = $ufItem['USU_UF'] ?? ''; ?>
                                    <?php if (!empty($ufValor)): ?>
                                        <option value="<?= esc($ufValor) ?>" <?= ($busca_uf ?? '') === $ufValor ? 'selected' : '' ?>>
                                            <?= esc($ufValor) ?>
                                        </option>
                                    <?php endif; ?>
                                <?php endforeach; ?>
                            <?php endif; ?>
                        </select>
                    </div>

                    <div style="flex: 0 0 auto; display: flex; gap: 8px;">
                        <button type="submit" class="btn-submit" style="height: 42px; padding: 0 20px; background-color: #00a65a; color: #fff; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; display: flex; align-items: center; gap: 8px;">
                            Filtrar
                        </button>
                        <?php if(!empty($busca_nome) || !empty($busca_uf)): ?>
                            <a href="<?= base_url('admin/usuarios') ?>" style="display: flex; align-items: center; justify-content: center; height: 42px; width: 42px; border: 1px solid #ccc; border-radius: 6px; background: #f5f5f5; color: #333; text-decoration: none;" title="Limpar Filtros">
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
                            <th>Usuário</th>
                            <th>Cidade</th>
                            <th>UF</th>
                            <th>Status</th>
                            <th style="text-align: center;">Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if(!empty($usuarios) && is_array($usuarios)): ?>
                            <?php foreach($usuarios as $user): ?>
                                <tr>
                                    <td>
                                        <div class="user-info" style="display: flex; align-items: center; gap: 12px;">
                                            <div class="user-avatar">
                                                <?= mb_strtoupper(mb_substr($user['USU_NOME'] ?? 'U', 0, 2)) ?>
                                            </div>
                                            <div>
                                                <strong style="display: block; color: #333;"><?= esc($user['USU_NOME'] ?? '') ?></strong>
                                                <span style="font-size: 0.85rem; color: #777;"><?= esc($user['USU_EMAIL'] ?? '') ?></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="color: #555; font-size: 0.95rem;">
                                        <?= esc($user['USU_CIDADE'] ?? 'Não informada') ?>
                                    </td>
                                    <td style="font-weight: 600; color: #444;">
                                        <?= esc($user['USU_UF'] ?? '-') ?>
                                    </td>
                                    <td>
                                        <?php $status = $user['USU_STATUS'] ?? 'ATIVO'; ?>
                                        <?php if(strtoupper($status) === 'ATIVO'): ?>
                                            <span class="status-badge badge-green">Ativo</span>
                                        <?php else: ?>
                                            <span class="status-badge badge-red">Inativo</span>
                                        <?php endif; ?>
                                    </td>
                                    <td>
                                        <div class="actions-cell" style="display: flex; gap: 8px; justify-content: center;">
                                            <a href="<?= base_url('admin/usuarios/' . ($user['USU_ID'] ?? '')) ?>" 
                                               class="btn-icon btn-edit"
                                               title="Editar" style="text-decoration: none;">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>

                                            <a href="#"
                                               class="btn-icon btn-delete btnExcluirUsuario"
                                               data-url="<?= base_url('admin/excluirUsuario/' . ($user['USU_ID'] ?? '')) ?>"
                                               data-nome="<?= esc($user['USU_NOME'] ?? '') ?>"
                                               title="Excluir" style="text-decoration: none;">
                                                <i class="fa-solid fa-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <tr>
                                <td colspan="5" style="text-align: center; color: #999; padding: 40px 20px;">
                                    <div style="margin-bottom: 10px;">
                                        <i class="fa-solid fa-folder-open" style="font-size: 1.5rem; color: #adb5bd;"></i>
                                    </div>
                                    Nenhum usuário encontrado com os filtros aplicados.
                                </td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>

        </div>
    <?php endif; ?>
</main>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
document.addEventListener('DOMContentLoaded', function () {
    const botoesExcluir = document.querySelectorAll('.btnExcluirUsuario');

    botoesExcluir.forEach(function(botao) {
        botao.addEventListener('click', function(e) {
            e.preventDefault();

            const urlExclusao = this.getAttribute('data-url');
            const nomeUsuario = this.getAttribute('data-nome');

            Swal.fire({
                title: 'Tem certeza?',
                html: `Você está prestes a remover o usuário <strong>"${nomeUsuario}"</strong>. Esta ação não pode ser desfeita!`,
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