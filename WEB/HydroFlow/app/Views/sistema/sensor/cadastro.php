<?= view("sistema/layout/dashboard/adm/header") ?>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css" />

<style>
    /* Ajuste fino para o Choices.js casar perfeitamente com o seu design premium */
    .choices__inner {
        background-color: #fff !important;
        border: 1px solid #ccc !important;
        border-radius: 6px !important;
        padding: 4px 10px !important;
        min-height: 44px !important;
        display: flex;
        align-items: center;
    }
    .choices__input {
        background-color: transparent !important;
        font-size: 0.95rem !important;
    }
    .choices__list--dropdown .choices__item--selectable.is-highlighted {
        background-color: #1e3c72 !important; /* Cor azul do seu tema */
        color: #fff !important;
    }
    .choices[data-type*="select-one"] .choices__inner {
        padding-bottom: 4px !important;
    }
</style>

<main class="main-content">
    
    <?php if (session()->getFlashdata('errors')): ?>
        <div style="background: #fce4d6; color: #721c24; border: 1px solid #f5c6cb; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; flex-direction: column; gap: 5px; font-weight: 600;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <i class="fa-solid fa-circle-xmark"></i> 
                <span>Por favor, corrija os erros abaixo:</span>
            </div>
            <ul style="margin: 5px 0 0 25px; font-weight: 500; font-size: 0.9rem;">
                <?php foreach (session()->getFlashdata('errors') as $erro): ?>
                    <li><?= esc($erro) ?></li>
                <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>

    <div class="page-header" style="margin-bottom: 25px;">
        <div>
            <h2 style="color: #1e3c72; font-size: 1.6rem; font-weight: 600;">
                <i class="fa-solid fa-square-plus"></i> Cadastro de Sensores
            </h2>
            <p style="color: #666; margin-top: 5px;">
                Registre novos sensores para monitoramento de campo de forma sequencial.
            </p>
        </div>
    </div>

    <div class="adm-card-container">
    <?php 
        // Detecta se é edição ou novo cadastro
        $isEdicao = isset($sensor) && !empty($sensor); 
        $actionUrl = $isEdicao ? base_url('admin/sensores/salvar') : base_url('admin/sensores/salvar-duplo');
    ?>

    <form id="form-cadastro" action="<?= $actionUrl ?>" method="post">
        <?= csrf_field() ?>

        <?php if ($isEdicao): ?>
            <input type="hidden" name="SEN_ID" value="<?= $sensor['SEN_ID'] ?>">
            <input type="hidden" name="SEN_TIPO" value="<?= esc($sensor['SEN_TIPO']) ?>">

            <div class="adm-section-divider" style="margin-top: 10px;">
                <span>
                    <i class="fa-solid fa-pen-to-square"></i> 
                    Editando Dados: <?= esc($sensor['SEN_TIPO']) ?>
                </span>
            </div>
            <div class="adm-form-row">
                <div class="adm-input-group flex-2">
                    <label for="SEN_NOME">Nome do Sensor</label>
                    <input type="text" id="SEN_NOME" name="SEN_NOME" maxlength="50" required 
                           value="<?= esc($sensor['SEN_NOME']) ?>" placeholder="Ex: Sensor de Umidade Solo A1">
                </div>
            </div>

        <?php else: ?>
            <div class="adm-section-divider" style="margin-top: 10px;">
                <span><i class="fa-solid fa-seedling"></i> Sensor de Umidade do Solo</span>
            </div>
            <div class="adm-form-row">
                <div class="adm-input-group flex-2">
                    <label for="NOME_SOLO">Nome do Sensor</label>
                    <input type="text" id="NOME_SOLO" name="NOME_SOLO" maxlength="50" required placeholder="Ex: Sensor de Umidade Solo A1">
                </div>
            </div>

            <div class="adm-section-divider" style="margin-top: 30px;">
                <span><i class="fa-solid fa-cloud-sun"></i> Sensor de Umidade do Ar e Temperatura</span>
            </div>
            <div class="adm-form-row">
                <div class="adm-input-group flex-2">
                    <label for="NOME_AR">Nome do Sensor</label>
                    <input type="text" id="NOME_AR" name="NOME_AR" maxlength="50" required placeholder="Ex: Sensor de Temperatura A1">
                </div>
            </div>
        <?php endif; ?>

        <div class="adm-section-divider" style="margin-top: 30px;">
            <span>Vínculo de Hardware</span>
        </div>
        <div class="adm-form-row">
            <div class="adm-input-group">
                <label for="FK_DIS_ID">Buscar Dispositivo (Placa)</label>
                <select id="FK_DIS_ID" name="FK_DIS_ID" class="choices-select" required>
                    <option value="">Digite o nome do dispositivo ou ID...</option>
                    <?php if (!empty($dispositivos)): ?>
                        <?php foreach ($dispositivos as $dispositivo): ?>
                            <?php 
                                // Verifica o ID selecionado seja vindo do "old()" ou do banco de dados na edição
                                $selected = '';
                                if ($isEdicao && $sensor['FK_DIS_ID'] == $dispositivo['DIS_ID']) {
                                    $selected = 'selected';
                                } elseif (old('FK_DIS_ID') == $dispositivo['DIS_ID']) {
                                    $selected = 'selected';
                                }
                            ?>
                            <option value="<?= esc($dispositivo['DIS_ID']) ?>" <?= $selected ?>>
                                <?= esc($dispositivo['DIS_NOME']) ?> (ID: <?= esc($dispositivo['DIS_ID']) ?>)
                            </option>
                        <?php endforeach; ?>
                    <?php endif; ?>
                </select>
                <div style="color: #888; font-size: 0.8rem; margin-top: 5px;">A placa onde o hardware está conectado.</div>
            </div>

            <div class="adm-input-group">
                <label for="SEN_STATUS">Status</label>
                <select id="SEN_STATUS" name="SEN_STATUS">
                    <?php 
                        $statusAtual = $isEdicao ? $sensor['SEN_STATUS'] : 'ATIVO'; 
                    ?>
                    <option value="ATIVO" <?= $statusAtual === 'ATIVO' ? 'selected' : '' ?>>ATIVO</option>
                    <option value="INATIVO" <?= $statusAtual === 'INATIVO' ? 'selected' : '' ?>>INATIVO</option>
                </select>
            </div>
        </div>

        <div style="margin-top: 30px; display: flex; align-items: center; gap: 20px;">
            <button type="submit" class="adm-btn-submit">
                <i class="fa-solid <?= $isEdicao ? 'fa-floppy-disk' : 'fa-plus' ?>"></i> 
                <?= $isEdicao ? 'Salvar Alterações' : 'Cadastrar Sensores' ?>
            </button>
            <a href="<?= base_url('admin/sensores') ?>" style="text-decoration: none; color: #666; font-weight: 600; font-size: 0.95rem; display: inline-flex; align-items: center; gap: 6px; transition: color 0.2s;" onmouseover="this.style.color='#1e3c72'" onmouseout="this.style.color='#666'">
                <i class="fa-solid fa-arrow-left"></i> Cancelar
            </a>
        </div>
    </form>
</div>
</main>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>

<script>
// Inicializa o campo de busca dentro do Select assim que a página carregar
document.addEventListener('DOMContentLoaded', function() {
    const element = document.querySelector('.choices-select');
    if (element) {
        new Choices(element, {
            searchEnabled: true,          // Ativa o campo de busca interno
            noResultsText: 'Nenhum dispositivo encontrado',
            noChoicesText: 'Não há opções para escolher',
            itemSelectText: 'Clique para selecionar',
            searchPlaceholderValue: 'Digite para pesquisar...',
            shouldSort: false             // Mantém a ordenação vinda do banco de dados
        });
    }
});

// Altere o listener do submit para isso:
document.getElementById('form-cadastro').addEventListener('submit', function(e) {
    const isEdicao = <?= isset($sensor) ? 'true' : 'false' ?>;
    
    if (isEdicao) {
        // Se for edição, deixa o formulário ir direto ou põe um alert de salvando...
        return true; 
    }

    // Se for cadastro novo, roda o SweetAlert duplo original
    e.preventDefault();
    const form = this;

    Swal.fire({
        title: 'Confirmar Cadastro Múltiplo?',
        text: "Isso criará os 2 registros de sensores vinculados a esta placa.",
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#1e3c72',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Sim, cadastrar ambos!',
        cancelButtonText: 'Voltar'
    }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire({
                title: 'Cadastrando hardwares...',
                text: 'Processando inserção dupla no banco de dados.',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            form.submit();
        }
    });
});
</script>