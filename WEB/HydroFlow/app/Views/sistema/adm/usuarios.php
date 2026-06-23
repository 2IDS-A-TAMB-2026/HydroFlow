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


/* As classes que o seu script injeta para os estados ativos vão sobrescrever isso abaixo */

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
        transition: background-color 0.2s ease;
        border-bottom: 1px solid #edf2f7;
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
</style>

<main style="padding: 20px; font-family: Arial, sans-serif;">
            
    <?php if (!empty($usuario)): ?>
        <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
            <div>
                <h2 style="color: #1e3c72; margin: 0; font-weight: 600;"><i class="fa-solid fa-user-pen"></i> Editar Cadastro de Usuário</h2>
                <p style="color: #666; margin: 5px 0 0 0;">Editando o cadastro de: <b><?= esc($usuario['USU_NOME'] ?? $usuario['NOME_USUARIO'] ?? '') ?></b></p>
            </div>
        </div>

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
                   data-url="<?= base_url('adm/excluirUsuario/' . ($usuario['USU_ID'] ?? $usuario['ID_USUARIO'] ?? '')) ?>"
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

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(450px, 1fr)); gap: 20px; margin-bottom: 20px;">
            
            <div style="background: #ffffff; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05); padding: 20px; border: 1px solid #eef2f5; display: flex; align-items: center; min-height: 280px; box-sizing: border-box;">
                <div style="width: 45%; height: 100%; max-height: 200px;">
                    <canvas id="chartStatusUsuarios"></canvas>
                </div>
                <div style="width: 55%; padding-left: 20px; box-sizing: border-box;">
                    <h4 style="margin: 0 0 12px 0; color: #4a5568; font-size: 0.95rem; text-transform: uppercase; letter-spacing: 0.5px; font-weight: 700;">Status das Contas</h4>
                    <div style="font-size: 0.9rem; color: #666;">
                        <p style="margin: 6px 0;"><span style="display:inline-block; width:10px; height:10px; background:#00a65a; border-radius:50%; margin-right:6px;"></span> Ativos: <strong><?= $grafico_status['valores'][0] ?? 0 ?></strong></p>
                        <p style="margin: 6px 0;"><span style="display:inline-block; width:10px; height:10px; background:#d33; border-radius:50%; margin-right:6px;"></span> Inativos: <strong><?= $grafico_status['valores'][1] ?? 0 ?></strong></p>
                    </div>
                </div>
            </div>

            <div style="background: #ffffff; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05); padding: 20px; border: 1px solid #eef2f5; display: flex; flex-direction: column; min-height: 280px; justify-content: flex-start; box-sizing: border-box;">
                <h4 style="margin: 0 0 5px 0; color: #4a5568; font-size: 0.95rem; text-transform: uppercase; letter-spacing: 0.5px; font-weight: 700;">Distribuição Geográfica</h4>
                
                <div style="width: 100%; height: 100%; min-height: 220px;">
                    <div id="mapa-brasil-container" style="width: 100%; height: 100%; min-height: 220px; margin: 0 auto;"></div>
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
                            <input type="text" name="busca_nome" value="<?= esc($busca_nome ?? '') ?>" placeholder="Digite o nome ou e-mail..." style="width: 100%; padding: 10px; padding-right: 40px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; height: 42px;">
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
                                               data-url="<?= base_url('adm/excluirUsuario/' . ($user['USU_ID'] ?? '')) ?>"
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

<script src="https://code.highcharts.com/maps/highmaps.js"></script>
<script src="https://code.highcharts.com/mapdata/countries/br/br-all.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function () {
    
    // --- POPUP DO SWEETALERT PARA EXCLUSÃO DE USUÁRIO ---
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

    // --- CARREGAMENTO DOS GRÁFICOS (APENAS NA VIEW DE LISTAGEM) ---
    <?php if (empty($usuario)): ?>
    
    // 1. Gráfico de Rosca (Chart.js)
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

    // 2. Integração Profissional do Mapa com Highmaps
    const dadosUsuariosUf = <?= json_encode($mapa_uf_dados ?? []) ?>;
    
    // Formatando os dados de entrada do PHP ['SP' => 10] para o padrão Highmaps ['br-sp' => 10]
    const dadosFormatadosParaMapas = Object.keys(dadosUsuariosUf).map(sigla => {
        return {
            'hc-key': 'br-' + sigla.toLowerCase(),
            'value': parseInt(dadosUsuariosUf[sigla]) || 0
        };
    });

    // 🔥 CORREÇÃO AQUI: Descobre o maior valor real, mas garante que o teto seja pelo menos 1
    const maiorValorData = Math.max(1, ...dadosFormatadosParaMapas.map(d => d.value));

    Highcharts.mapChart('mapa-brasil-container', {
        chart: {
            map: 'countries/br/br-all',
            backgroundColor: 'transparent',
            spacingTop: 0,
            spacingBottom: 0,
            spacingLeft: 0,
            spacingRight: 0
        },
        title: {
            text: null
        },
        credits: {
            enabled: false
        },
        mapNavigation: {
            enabled: false 
        },
        colorAxis: {
            min: 0,
            minColor: '#e2e8f0', // Um cinza/azul bem elegante para estados com 0 usuários
            maxColor: '#1e3a8a', // Um azul escuro fechado (Navy), mas sem parecer preto/vazio
            stops: [
                [0, '#e2e8f0'],   // 0 usuários
                [0.1, '#93c5fd'], // Poucos usuários (azul claro com boa visibilidade)
                [0.5, '#3b82f6'], // Média de usuários (azul padrão HydroFlow)
                [1, '#4567c5']    // Pico de usuários (azul escuro destacado)
            ]
        },
        legend: {
            enabled: false 
        },
        tooltip: {
            backgroundColor: 'rgba(30, 60, 114, 0.95)',
            borderColor: '#4299e1',
            borderRadius: 6,
            style: {
                color: '#ffffff',
                fontFamily: 'Arial, sans-serif',
                fontSize: '12px',
                fontWeight: 'bold'
            },
            headerFormat: '',
            pointFormat: '● {point.name}: {point.value} {window.pluralUser}' 
        },
        plotOptions: {
            map: {
                dataLabels: {
                    enabled: true,
                    format: '{point.properties.sigla}', // Ou o formato que você usou para a sigla
                    style: {
                        fontSize: '10px',
                        fontWeight: 'bold',
                        color: '#ffffff', // Força o texto a ser branco para contrastar com os azuis
                        textOutline: '1px solid #334155' // Cria um contorno cinza escuro para ler bem mesmo nos estados claros!
                    }
                }
            }
        },
        series: [{
            data: dadosFormatadosParaMapas,
            name: 'Usuários',
            cursor: 'pointer',
            borderWidth: 1,          // 🔥 ADICIONE ISSO: Define a espessura da linha do estado
            borderColor: '#cbd5e1',  // 🔥 ADICIONE ISSO: Um cinza médio perfeito para contornar os estados vazios
            states: {
                hover: {
                    color: '#38bdf8', 
                    borderWidth: 2.5
                }
            },
            dataLabels: {
                enabled: true,
                format: '{point.properties.hc-a2}', 
                style: {
                    fontSize: '10px',
                    fontWeight: 'bold',
                    textOutline: 'none',
                    color: '#000000'
                }
            }
        }]
    });
    // Pequeno ajuste para lidar dinamicamente com singular/plural no tooltip do Highmaps
    Highcharts.wrap(Highcharts.Point.prototype, 'getZone', function (proceed) {
        window.pluralUser = this.value === 1 ? 'usuário' : 'usuários';
        return proceed.apply(this, Array.prototype.slice.call(arguments, 1));
    });

    <?php endif; ?>
});
</script>