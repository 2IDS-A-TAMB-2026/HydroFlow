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
        vertical-align: middle;
    }
    .status-badge {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 6px;
        font-size: 0.78rem;
        font-weight: 700;
        text-transform: uppercase;
    }
    .badge-green { background: #e6fffa; color: #047857; border: 1px solid #b1f5e3; }
    .badge-red { background: #fef2f2; color: #b91c1c; border: 1px solid #fee2e2; }
    
    .user-avatar {
        width: 38px;
        height: 38px;
        background: #ebf8ff;
        color: #2b6cb0;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        font-size: 0.9rem;
        border: 1px solid #bee3f8;
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

    /* --- ESTILIZAÇÃO DO MAPA INTERATIVO --- */
    .estado-mapa {
        fill: #e2e8f0; /* Cor cinza padrão para estados vazios */
        stroke: #ffffff;
        stroke-width: 1.5;
        transition: fill 0.2s ease, stroke 0.2s ease;
        cursor: pointer;
    }
    .estado-mapa:hover {
        stroke: #1e3c72;
        stroke-width: 2.5;
    }
    /* Ativado dinamicamente via JS se houver > 0 usuários */
    .estado-com-usuario {
        fill: #90cdf4; /* Tom de azul suave corporativo */
    }
    .estado-com-usuario:hover {
        fill: #3182ce; /* Azul destacado no hover */
    }
    /* Estilo do Tooltip Flutuante */
    #mapa-tooltip {
        position: absolute;
        background: rgba(30, 60, 114, 0.95);
        color: #fff;
        padding: 8px 12px;
        border-radius: 6px;
        font-size: 0.85rem;
        font-family: Arial, sans-serif;
        pointer-events: none;
        box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        display: none;
        z-index: 9999;
        font-weight: bold;
        border: 1px solid #4299e1;
    }
</style>

<div id="mapa-tooltip"></div>

<main style="padding: 20px; font-family: Arial, sans-serif;">
            
    <?php if (!empty($usuario)): ?>
        <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
            <div>
                <h2 style="color: #1e3c72; margin: 0; font-weight: 600;"><i class="fa-solid fa-user-pen"></i> Editar Cadastro de Usuário</h2>
                <p style="color: #666; margin: 5px 0 0 0;">Editando o cadastro de: <b><?= esc($usuario['USU_NOME'] ?? '') ?></b></p>
            </div>
        </div>

        <div class="unified-card" style="max-width: 600px;">
            <form id="formGerenciarUsuario" action="<?= base_url('admin/usuarios/' . ($usuario['USU_ID'] ?? '')) ?>" method="POST">
                <?= csrf_field() ?>

                <div style="margin-bottom: 15px; display: flex; flex-direction: column; gap: 5px;">
                    <label style="font-size: 0.9rem; font-weight: bold; color: #444;">Nome do Usuário:</label>
                    <input type="text" name="NOME_USUARIO" value="<?= esc($usuario['USU_NOME'] ?? '') ?>" required style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px;">
                </div>

                <div style="margin-bottom: 15px; display: flex; flex-direction: column; gap: 5px;">
                    <label style="font-size: 0.9rem; font-weight: bold; color: #444;">E-mail corporativo:</label>
                    <input type="email" name="EMAIL_USUARIO" value="<?= esc($usuario['USU_EMAIL'] ?? '') ?>" required style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px;">
                </div>

                <div style="margin-bottom: 25px; display: flex; flex-direction: column; gap: 5px;">
                    <label style="font-size: 0.9rem; font-weight: bold; color: #444;">Status da Conta:</label>
                    <?php $statusAtual = $usuario['USU_STATUS'] ?? 'ATIVO'; ?>
                    <select name="STATUS_USUARIO" id="STATUS_USUARIO" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; background: white; height: 42px; cursor: pointer;">
                        <option value="ATIVO" <?= strtoupper($statusAtual) === 'ATIVO' ? 'selected' : '' ?>>ATIVO</option>
                        <option value="INATIVO" <?= strtoupper($statusAtual) === 'INATIVO' ? 'selected' : '' ?>>INATIVO</option>
                    </select>
                </div>

                <button type="submit" class="btn-submit" style="width: 100%; height: 45px; background-color: #1e3c72; color: #fff; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 8px; font-size: 1rem;">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar Alterações
                </button>
            </form>

            <div style="margin-top: 20px;">
                <a href="<?= base_url('admin/usuarios') ?>" style="text-decoration: none; color: #666; font-size: 0.9rem; display: inline-flex; align-items: center; gap: 5px;">← Cancelar e Voltar para Lista</a>
            </div>
        </div>

    <?php else: ?>
        <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
            <div>
                <h2 style="color: #1e3c72; margin: 0; font-weight: 600;"><i class="fa-solid fa-users-gear"></i> Gerenciamento de Usuários</h2>
                <p style="color: #666; margin: 5px 0 0 0;">Gerencie permissões, analise a distribuição e monitore acessos do Hydroflow.</p>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 20px; margin-bottom: 20px;">
            
            <div style="background: #ffffff; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05); padding: 20px; border: 1px solid #eef2f5; display: flex; align-items: center; height: 220px;">
                <div style="width: 45%; height: 100%;">
                    <canvas id="chartStatusUsuarios"></canvas>
                </div>
                <div style="width: 55%; padding-left: 20px;">
                    <h4 style="margin: 0 0 12px 0; color: #4a5568; font-size: 0.95rem; text-transform: uppercase; letter-spacing: 0.5px; font-weight: 700;">Status das Contas</h4>
                    <div style="font-size: 0.9rem; color: #666;">
                        <p style="margin: 6px 0;"><span style="display:inline-block; width:10px; height:10px; background:#00a65a; border-radius:50%; margin-right:6px;"></span> Ativos: <strong><?= $grafico_status['valores'][0] ?></strong></p>
                        <p style="margin: 6px 0;"><span style="display:inline-block; width:10px; height:10px; background:#d33; border-radius:50%; margin-right:6px;"></span> Inativos: <strong><?= $grafico_status['valores'][1] ?></strong></p>
                    </div>
                </div>
            </div>

            <div style="background: #ffffff; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05); padding: 15px; border: 1px solid #eef2f5; display: flex; flex-direction: column; height: 220px; justify-content: center; position: relative;">
                <h4 style="margin: 0; color: #4a5568; font-size: 0.95rem; text-transform: uppercase; letter-spacing: 0.5px; font-weight: 700; position: absolute; top: 15px; left: 15px;">Distribuição Geográfica</h4>
                
                <div style="width: 100%; height: 85%; display: flex; justify-content: center; align-items: center; margin-top: 20px;">
                    <svg id="mapa-brasil" viewBox="0 0 550 550" style="width: auto; height: 100%; max-width: 100%;">
                        <g id="Estados">
                            <path id="AC" class="estado-mapa" d="M101.4,127.3l-2.4-7.1l-10-1.7l-4.1,4.4l-3.3-3.1l-5.6,5.1l0.3,5.1l-11.4,3.3l1.8,4.3l11.4-1.2l6.2,8l13.1,1.9l4.5-5.8l9.6-1.3L101.4,127.3z"/>
                            <path id="AL" class="estado-mapa" d="M495.1,192.5l-2.9-2.2l-8.6,3.6l-2.9-4.8l-4,1l0.3,4.2l-4.6,0.3l3,4.8l13,1l5.5-5L495.1,192.5z"/>
                            <path id="AM" class="estado-mapa" d="M181.7,113.8l-1.3-9.4l-7.7-1.1l-4-9.3l-10.4,1.8l-2.2-7.8l-15.3,1.9l-6.2-7.5l-6.7,2.2l-2.7-5.5l-16.7,3.6l-5.3-4.4l-15.1,9.4l-14,3.1l-10.5-4l-7.1,5.3l10,1.7l2.4,7.1l10.1,11.8l-9.6,1.3l-4.5,5.8l-13.1-1.9l-6.2-8l-11.4,1.2l5.6,13.7l11.9,6.5l4-1.9l3.4,4.3l12.7-3.4l8.2,5.1l5.8-3.4l10.7,5.5l3.6-2.9l12.5,3.6l0.2,7.6l10,2.1l4.9-5.1l15.1,5.6l9.3-5.3l13-0.2l1.6-4.9l8.6-2.1l3.3-11.2l-5.5-12.8l3.6-5.8l10.2,2.7l3.6-4L181.7,113.8z"/>
                            <path id="AP" class="estado-mapa" d="M304.1,38.1l-10.9,4.2l2.2,8.9l-8.5,14.7l5.3,4.2l12.9-5.5l3.8,4.2l5.1-4.9l7.3,7.5l2.4-7.1l-6.5-12l3.4-10.5L304.1,38.1z"/>
                            <path id="BA" class="estado-mapa" d="M466.8,197.8l-3.3-10l-12.2-5.1l-2.7-10l-11.1-2.9l0.2-11.1l-7.3-1.6l-1-7.1l-10-8.9l-19,5.5l-5.8,11.6l1.3,7.3l-5.1,13.7l-9.8-3.6l-3.3,4.2l-12.4-2l-1.3,4.5l-11.1-2.7l-3.1,8.9l-7.5-3.3l-13.6,15.8l8,10.2l-2.7,4l4,14l7.1,5.8l0.9,13.8l8,7.3l2.2,16.2l14.2,1.3l8.7-12.7l17,6.4l5.3-4.5l9.3,2.7l2.2-4.5l9.3,2.9l10.9-10.4l-4.7-16l6.7-5.3l-0.7-9.3l12-3.8l4.4,2.9l8.9-12.4l1.3-12.9l8.9-6.9L466.8,197.8z"/>
                            <path id="CE" class="estado-mapa" d="M441,123.4l-7.6-6.4l-11.4,2.7l-12-6.4l-15.8,11.8l0.7,11.3l13.1,11.1l11.1,2.7l1.3-4.5l12.4,2l3.3-4.2l9.8,3.6L441,123.4z"/>
                            <path id="DF" class="estado-mapa" d="M365.1,293.1l4.9-1.3l0.3-4.9l-4.9-1.1L365.1,293.1z"/>
                            <path id="ES" class="estado-mapa" d="M428.2,333l-2.2-16.2l-8-7.3l-0.9-13.8l-7.1-5.8l-4-14l2.7-4l-8-10.2l-4.5,1.8l-5.5,11.1l1,11.3l-4,1.8l2,14.5l8.7,11.4l5.5,0.4l3.1,10.2l9,4.4L428.2,333z"/>
                            <path id="GO" class="estado-mapa" d="M351.4,264.4l-1.3-7.3l5.8-11.6l19-5.5l10,8.9l1,7.1l7.3,1.6l-0.2,11.1l11.1,2.9l2.7,10l12.2,5.1l3.3,10l1.3,13.8l-8.9,6.9l-1.3,12.9l-8.9,12.4l-4.4-2.9l-12,3.8l0.7,9.3l-6.7,5.3l4.7,16l-10.9,10.4l-9.3-2.9l-2.2,4.5l-9.3-2.7l-5.3,4.5l-17-6.4l-8.7,12.7l-14.2-1.3l1.8-9.3l-10.4-1.6l1.8-9.6l-5.8-4.2l12.7-16.7l-5.3-10l5.8-8.2l-5.3-17.1l8.4-15.1l-2.9-14l6-11.1L351.4,264.4z"/>
                            <path id="MA" class="estado-mapa" d="M362.5,91.8l-18.7,12.7l-8,14.9l7.6,13.1l-4.4,17.8l5.8,7.6l-2.2,21.6l21.3,20l1.6,13.8l8.2,5.1l4.9-5.3l12,5.8l7.5,15.1l15.8-11.8l12,6.4l11.4-2.7l7.6,6.4l1.3-12.7l-10.5-12l4.9-13.8l-4-9.3l1.8-14.7l-9.8-1.6l-4-15.8l-17.3-11.8l-23.8-16.9l-10.4,1.1L362.5,91.8z"/>
                            <path id="MG" class="estado-mapa" d="M410.5,335.5l-9-4.4l-3.1-10.2l-5.5-0.4l-8.7-11.4l-2-14.5l4-1.8l-1-11.3l5.5-11.1l4.5-1.8l-8-10.2l13.6-15.8l7.5,3.3l3.1-8.9l11.1,2.7l1.3-4.5l-11.1-2.7l-13.1-11.1l-0.7-11.3l-7.5-15.1l-12-5.8l-4.9,5.3l-8.2-5.1l-1.6-13.8l-21.3-20l2.2-21.6l-5.8-7.6l4.4-17.8l-7.6-13.1l8-14.9l18.7-12.7l-6.4-10.5l-20.9,4l-9.1-8l-14,4.2l-2.7,11.1l-11.1-1.3l2.2-8.4l-11.8,2l3.1,10.2l-7.1,3.8L304.1,38.1z"/>
                            <path id="MS" class="estado-mapa" d="M285.5,348.6l-1.8,9.3l-11.6,4.5l-5.1-4.7l-15.8,4l0.2,7.3l-10,2l-3.3-4.2l-14,1.8l-5.3-7.5l-13,0.4l-4.5-5.3l0.2-12.9l-9.6-1.1l-1-7.1l6.7-9.1l-3.3-7.1l5.5-14l12.4,1.1l6.4-7.8l9.6,4.9l8.4-5.3l12.2,9.3l15.3-1.6l5.3,10l-12.7,16.7l5.8,4.2l-1.8,9.6l10.4,1.6L285.5,348.6z"/>
                            <path id="MT" class="estado-mapa" d="M266.3,191.1l-12.2-9.3l-8.4,5.3l-9.6-4.9l-6.4,7.8l-12.4-1.1l-5.5,14l3.3,7.1l-6.7,9.1l1,7.1l9.6,1.1l-0.2,12.9l4.5,5.3l13-0.4l5.3,7.5l14-1.8l3.3,4.2l10-2l-0.2-7.3l15.8-4l5.1,4.7l11.6-4.5l6-11.1l2.9,14l-8.4,15.1l5.3,17.1l-5.8,8.2l-1.3-13.8l0.5-16.7l8.2-14.7l-3.8-13.6l10-18.7l-4.2-13.6l6-13.1l-7.3-12.9l6.7-21.8l-13.8-17.1L266.3,191.1z"/>
                            <path id="PA" class="estado-mapa" d="M295.4,53.8l-2.2-8.9l10.9-4.2l-12.2-13.6l-14,4l-4.5,8.9l-22,0.9l-1-7.1l-14.9,3.6l-3.3,10.2l-8.9,0.7l-3.1,10.2l7.1,3.8L215,70.9l4.7,14.5l-5.1,15.6l9.1,8l20.9-4l6.4,10.5l15.6-7.3l10.4-1.1l23.8,16.9l17.3,11.8l4,15.8l9.8,1.6l-1.8,14.7l4,9.3l-4.9,13.8l10.5,12l-1.3,12.7l13.6-15.8l7.5,3.3l3.1-8.9l11.1,2.7l1.3-4.5l12.4,2l3.3-4.2l9.8,3.6l5.1-13.7l-1.3-7.3l5.8-11.6l19-5.5l10-8.9l1-7.1l7.3-1.6l0.2-11.1l11.1-2.9l-3.4,10.5l6.5,12l-2.4,7.1l-7.3-7.5l-5.1,4.9l-3.8-4.2l-12.9,5.5l-5.3-4.2l8.5-14.7L295.4,53.8z"/>
                            <path id="PB" class="estado-mapa" d="M485.6,145.4l-3.8-5.3l-16,4l-1,4.9l4.7,16l10.9-10.4l9.3-2.9l2.2-4.5l-2.2-1.6L485.6,145.4z"/>
                            <path id="PE" class="estado-mapa" d="M465.8,165l-4.7-16l1-4.9l16-4l3.8,5.3l1.8,12l-5.5,5l-13,1l-3-4.8l4.6-0.3l-0.3-4.2l4-1l2.9,4.8l8.6-3.6l2.9,2.2l-6.2,8l-1.3,12.9l-8.9,12.4l-4.4-2.9l-12,3.8l0.7,9.3L465.8,165z"/>
                            <path id="PI" class="estado-mapa" d="M414,136.7l-13.1-11.1l-0.7-11.3l-15.8,11.8l-12-6.4l-11.4,2.7l-7.6-6.4l1.3-12.7l-10.5-12l4.9-13.8l-4-9.3l1.8-14.7l-9.8-1.6l-4-15.8l13.8,17.1l-6.7,21.8l7.3,12.9l-6,13.1l4.2,13.6l-10,18.7l3.8,13.6l-8.2,14.7l-0.5,16.7l1.3,7.3l5.8,11.6l19-5.5l10,8.9l1,7.1l7.3,1.6l-0.2,11.1l11.1,2.9l2.7,10l12.2,5.1l3.3,10l1.3,13.8l8.9-6.9l1.3-12.9l8.9-12.4l4.4,2.9l12-3.8l-0.7-9.3l6.7-5.3l-4.7-16L414,136.7z"/>
                            <path id="PR" class="estado-mapa" d="M281.9,403.2l-3.3-7.1l5.5-14l12.4,1.1l6.4-7.8l9.6,4.9l8.4-5.3l12.2,9.3l15.3-1.6l5.3,10l-12.7,16.7l5.8,4.2l-1.8,9.6l10.4,1.6l1.8-9.3l11.6-4.5l5.1,4.7l15.8-4l-0.2-7.3l10-2l3.3,4.2l14-1.8l5.3,7.5l13-0.4l4.5,5.3l-0.2,12.9l9.6,1.1l1,7.1l-6.7,9.1l3.3,7.1l-5.5,14l-12.4-1.1l-6.4,7.8l-9.6-4.9l-8.4,5.3l-12.2-9.3L281.9,403.2z"/>
                            <path id="RJ" class="estado-mapa" d="M399.1,385.4l-8.7-11.4l-5.5-0.4l-3.1-10.2l-9-4.4l-13.1,1.1l2.4,8.4l-4.2,2.7l13.6,12.7l0.2,5.1l11.8,3.6l3.3,10.2l10.4,0.4L399.1,385.4z"/>
                            <path id="RN" class="estado-mapa" d="M473.6,134.1l-1.8-12l5.5-5l13,1l3,4.8l-4.6,0.3l0.3,4.2l-4,1l-2.9-4.8l-8.6,3.6l-2.9-2.2L473.6,134.1z"/>
                            <path id="RS" class="estado-mapa" d="M294.6,464.4l-9.6-4.9l-8.4,5.3l-12.2-9.3l-15.3,1.6l-5.3-10l12.7-16.7l-5.8-4.2l1.8-9.6l-10.4-1.6l-1.8,9.3l-11.6,4.5l-5.1-4.7l-15.8,4l0.2,7.3l-10,2l3.3,4.2l14-1.8l5.3,7.5l13-0.4L294.6,464.4z"/>
                            <path id="SC" class="estado-mapa" d="M304.1,422.3l8.4-5.3l12.2,9.3l15.3-1.6l5.3,10l-12.7,16.7l5.8,4.2l-1.8,9.6l10.4,1.6l1.8-9.3l11.6-4.5l5.1,4.7l15.8-4l-0.2-7.3l10-2l-3.3-4.2L304.1,422.3z"/>
                            <path id="SE" class="estado-mapa" d="M473.1,208.7l-13-1l-3-4.8l4.6-0.3l-0.3-4.2l4-1l2.9,4.8l8.6-3.6l2.9,2.2l-6.2,8L473.1,208.7z"/>
                            <path id="SP" class="estado-mapa" d="M327.9,376.1l14-1.8l5.3,7.5l13-0.4l4.5,5.3l-0.2,12.9l9.6,1.1l1,7.1l-6.7,9.1l3.3,7.1l-5.5,14l-12.4-1.1l-6.4,7.8l-9.6-4.9l-8.4,5.3l-12.2-9.3L327.9,376.1z"/>
                            <path id="TO" class="estado-mapa" d="M325.4,149.8l19-5.5l10,8.9l1,7.1l7.3,1.6l-0.2,11.1l11.1,2.9l2.7,10l12.2,5.1l3.3,10l1.3,13.8l-8.9,6.9l-1.3,12.9l-8.9,12.4l-4.4-2.9L325.4,149.8z"/>
                        </g>
                    </svg>
                </div>
            </div>

        </div>

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
                            <th style="text-align: center; width: 120px;">Ações</th>
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
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function () {
    
    // --- LÓGICA DO POPUP DE CONFIRMAÇÃO DE EXCLUSÃO ---
    const botoesExcluir = document.querySelectorAll('.btnExcluirUsuario');
    botoesExcluir.forEach(function(botao) {
        botao.addEventListener('click', function(e) {
            e.preventDefault();
            const urlExclusao = this.getAttribute('data-url');
            const nomeUsuario = this.getAttribute('data-nome');

            Swal.fire({
                title: 'Tem certeza?',
                html: `Você está prestes a remover o usuário <strong>"${nomeUsuario}"</strong>. Esta ação é permanente!`,
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

    // --- MONTAGEM DOS DASHBOARDS SE ESTIVER EM MODO LISTAGEM ---
    <?php if (empty($usuario)): ?>
    
    // 1. Inicializa o gráfico de rosca das contas
    const ctxStatus = document.getElementById('chartStatusUsuarios').getContext('2d');
    new Chart(ctxStatus, {
        type: 'doughnut',
        data: {
            labels: ['Ativos', 'Inativos'],
            datasets: [{
                data: <?= json_encode($grafico_status['valores'] ?? [0,0]) ?>,
                backgroundColor: ['#00a65a', '#d33'],
                borderWidth: 0,
                spacing: 3,
                borderRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '72%',
            plugins: {
                legend: { display: false }
            }
        }
    });

    // 2. Mapeamento do Dicionário e Interatividade do Mapa SVG
    const nomesEstados = {
        'AC': 'Acre', 'AL': 'Alagoas', 'AP': 'Amapá', 'AM': 'Amazonas', 'BA': 'Bahia', 'CE': 'Ceará',
        'DF': 'Distrito Federal', 'ES': 'Espírito Santo', 'GO': 'Goiás', 'MA': 'Maranhão', 'MT': 'Mato Grosso',
        'MS': 'Mato Grosso do Sul', 'MG': 'Minas Gerais', 'PA': 'Pará', 'PB': 'Paraíba', 'PR': 'Paraná',
        'PE': 'Pernambuco', 'PI': 'Piauí', 'RJ': 'Rio de Janeiro', 'RN': 'Rio Grande do Norte',
        'RS': 'Rio Grande do Sul', 'RO': 'Rondônia', 'RR': 'Roraima', 'SC': 'Santa Catarina',
        'SP': 'São Paulo', 'SE': 'Sergipe', 'TO': 'Tocantins'
    };

    // Dados das contagens associativas injetadas via PHP Controller
    const dadosUsuariosUf = <?= json_encode($mapa_uf_dados ?? []) ?>;
    const tooltip = document.getElementById('mapa-tooltip');
    const estados = document.querySelectorAll('.estado-mapa');

    estados.forEach(function(estado) {
        const sigla = estado.id;
        const totalUsuarios = dadosUsuariosUf[sigla] || 0;

        // Se houver usuários na região, acende a classe azulada
        if (totalUsuarios > 0) {
            estado.classList.add('estado-com-usuario');
        }

        // Rastreia o ponteiro e atualiza as coordenadas e textos do Tooltip
        estado.addEventListener('mousemove', function(e) {
            const nomeCompleto = nomesEstados[sigla] || sigla;
            tooltip.innerHTML = `<i class="fa-solid fa-location-dot"></i> ${nomeCompleto}: ${totalUsuarios} ${totalUsuarios === 1 ? 'usuário' : 'usuários'}`;
            tooltip.style.display = 'block';
            tooltip.style.left = (e.pageX + 15) + 'px';
            tooltip.style.top = (e.pageY - 35) + 'px';
        });

        // Some ao retirar o cursor
        estado.addEventListener('mouseleave', function() {
            tooltip.style.display = 'none';
        });

        // Atalho Inteligente: Ao clicar no estado do mapa, filtra a listagem na hora!
        estado.addEventListener('click', function() {
            window.location.href = `<?= base_url('admin/usuarios') ?>?busca_uf=${sigla}`;
        });
    });

    <?php endif; ?>
});
</script>