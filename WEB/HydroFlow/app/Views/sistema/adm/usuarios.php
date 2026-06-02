<main class="main-content">
            
    <?php if (!empty($usuario)): ?>
        <div class="page-header">
            <div>
                <h2><i class="fa-solid fa-user-pen"></i> Editar Cadastro de Usuário</h2>
                <p style="color: #666; margin-top: 5px;">Editando o cadastro de: <b><?= esc($usuario['USU_NOME'] ?? $usuario['NOME_USUARIO'] ?? '') ?></b></p>
            </div>
        </div>

        <div class="widget card-big" style="max-width: 500px; margin-top: 20px;">
            <form id="formGerenciarUsuario" action="<?= base_url('admin/atualizarUsuario/' . ($usuario['USU_ID'] ?? $usuario['ID_USUARIO'] ?? '')) ?>" method="POST">
                <?= csrf_field() ?>

                <div style="margin-bottom: 15px;">
                    <label style="font-weight: bold; color: #444; display: block; margin-bottom: 5px;">Nome do Usuário:</label>
                    <input type="text" name="NOME_USUARIO" value="<?= esc($usuario['USU_NOME'] ?? $usuario['NOME_USUARIO'] ?? '') ?>" required style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box;">
                </div>

                <div style="margin-bottom: 15px;">
                    <label style="font-weight: bold; color: #444; display: block; margin-bottom: 5px;">E-mail corporativo:</label>
                    <input type="email" name="EMAIL_USUARIO" value="<?= esc($usuario['USU_EMAIL'] ?? $usuario['EMAIL_USUARIO'] ?? '') ?>" required style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box;">
                </div>

                <div style="margin-bottom: 20px;">
                    <label style="font-weight: bold; color: #444; display: block; margin-bottom: 5px;">Status da Conta:</label>
                    <?php $statusAtual = $usuario['USU_STATUS'] ?? $usuario['STATUS_USUARIO'] ?? 'ATIVO'; ?>
                    <select name="STATUS_USUARIO" id="STATUS_USUARIO" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; background: white; height: 42px;">
                        <option value="ATIVO" <?= strtoupper($statusAtual) === 'ATIVO' ? 'selected' : '' ?>>ATIVO</option>
                        <option value="INATIVO" <?= strtoupper($statusAtual) === 'INATIVO' ? 'selected' : '' ?>>INATIVO</option>
                    </select>
                </div>

                <button type="submit" class="btn-add-user" style="width: 100%; justify-content: center; height: 45px; background-color: #1e3c72;">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar Alterações
                </button>
            </form>

            <hr style="margin: 30px 0; border: 0; border-top: 1px solid #eee;">

            <div style="background: #fdf2f2; padding: 15px; border: 1px solid #f5c6cb; border-radius: 6px;">
                <h4 style="color: #721c24; margin-top: 0; margin-bottom: 5px;"><i class="fa-solid fa-triangle-exclamation"></i> Zona Crítica</h4>
                <p style="font-size: 13px; color: #721c24; margin-bottom: 12px;">A remoção do usuário do sistema é uma ação definitiva.</p>
                <a href="<?= base_url('admin/excluirUsuario/' . ($usuario['USU_ID'] ?? $usuario['ID_USUARIO'] ?? '')) ?>" 
                   id="btnExcluirUsuario"
                   data-nome="<?= esc($usuario['USU_NOME'] ?? $usuario['NOME_USUARIO'] ?? '') ?>"
                   class="badge-red"
                   style="display: inline-block; text-decoration: none; padding: 6px 12px; border-radius: 12px;">
                    Excluir Conta Permanentemente
                </a>
            </div>

            <br>
            <a href="<?= base_url('admin/usuarios') ?>" style="text-decoration: none; color: #666; font-size: 0.9rem; display: inline-block; margin-top: 10px;">← Cancelar e Voltar para Lista</a>
        </div>

    <?php else: ?>
        <div class="page-header">
            <div>
                <h2><i class="fa-solid fa-users-gear"></i> Gerenciamento de Usuários</h2>
                <p style="color: #666; margin-top: 5px;">Adicione, edite ou remova acessos ao sistema Hydroflow.</p>
            </div>
            <button class="btn-add-user">
                <i class="fa-solid fa-user-plus"></i> Novo Usuário
            </button>
        </div>

        <div class="widget card-big">
            
            <form method="GET" action="<?= base_url('admin/usuarios') ?>" style="display: flex; gap: 15px; align-items: flex-end; flex-wrap: wrap; margin-bottom: 25px; width: 100%;">
                
                <div style="flex: 1; min-width: 250px;">
                    <label style="display: block; font-size: 0.85rem; color: #555; font-weight: 600; margin-bottom: 6px;">Buscar Usuário</label>
                    <div style="position: relative;">
                        <input type="text" name="busca_nome" value="<?= esc($busca_nome ?? '') ?>" placeholder="Digite o nome ou e-mail..." style="width: 100%; padding: 10px 40px 10px 12px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px;">
                        <i class="fa-solid fa-magnifying-glass" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #888;"></i>
                    </div>
                </div>

                <div style="width: 180px; min-width: 140px;">
                    <label style="display: block; font-size: 0.85rem; color: #555; font-weight: 600; margin-bottom: 6px;">UF (Estado)</label>
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

                <div style="display: flex; gap: 10px;">
                    <button type="submit" class="btn-add-user" style="height: 42px; background-color: #1e3c72; padding: 0 20px; white-space: nowrap;">
                        Filtrar
                    </button>
                    <?php if(!empty($busca_nome) || !empty($busca_uf)): ?>
                        <a href="<?= base_url('admin/usuarios') ?>" style="display: flex; align-items: center; justify-content: center; height: 42px; padding: 0 15px; border: 1px solid #ccc; border-radius: 6px; background: #f5f5f5; color: #333; text-decoration: none; font-size: 0.9rem;" title="Limpar Filtros">
                            <i class="fa-solid fa-xmark"></i>
                        </a>
                    <?php endif; ?>
                </div>
            </form>

            <table class="users-table">
                <thead>
                    <tr>
                        <th>Usuário</th>
                        <th>Cidade</th>
                        <th>UF</th>
                        <th>Status</th>
                        <th>Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if(!empty($usuarios) && is_array($usuarios)): ?>
                        <?php foreach($usuarios as $user): ?>
                            <tr>
                                <td>
                                    <div class="user-info">
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
                                        <span class="badge-green">Ativo</span>
                                    <?php else: ?>
                                        <span class="badge-red">Inativo</span>
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <div class="action-btns">
                                        <a href="<?= base_url('admin/usuarios/' . ($user['USU_ID'] ?? '')) ?>" 
                                           class="btn-icon btn-edit" title="Editar">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="5" style="padding: 20px; text-align: center; color: #999;">Nenhum usuário encontrado com os filtros aplicados.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>

        </div>

    <?php endif; ?>

</main>