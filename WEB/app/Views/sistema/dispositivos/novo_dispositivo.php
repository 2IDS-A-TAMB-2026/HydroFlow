<?= view('sistema/layout/dashboard/adm/header') ?>

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
                <i class="fa-solid fa-microchip"></i> <?= isset($dispositivo) ? 'Editar Dispositivo' : 'Cadastrar Novo Dispositivo' ?>
            </h2>
            <p style="color: #666; margin-top: 5px;">
                Gerencie as informações técnicas do módulo de irrigação Hydroflow.
            </p>
        </div>
    </div>

    <div class="adm-card-container">
        
        <form action="<?= base_url('admin/dispositivos/salvar') ?>" method="POST" id="form">
            <?= csrf_field() ?>

            <input type="hidden" name="DIS_ID" value="<?= esc($dispositivo['DIS_ID'] ?? '') ?>">

            <div class="adm-form-row">
                <div class="adm-input-group flex-2">
                    <label for="dis_nome">Nome do Dispositivo</label>
                    <input type="text" id="dis_nome" name="DIS_NOME" value="<?= old('DIS_NOME', $dispositivo['DIS_NOME'] ?? '') ?>" placeholder="Ex: Módulo Setor Sul" required>
                </div>
                <div style="display: flex; gap: 20px; flex: 2;">
                    <div class="adm-input-group">
                        <label for="dis_status">Status</label>
                        <select id="dis_status" name="DIS_STATUS">
                            <option value="ATIVO" <?= old('DIS_STATUS', $dispositivo['DIS_STATUS'] ?? '') == 'ATIVO' ? 'selected' : '' ?>>ATIVO</option>
                            <option value="INATIVO" <?= old('DIS_STATUS', $dispositivo['DIS_STATUS'] ?? '') == 'INATIVO' ? 'selected' : '' ?>>INATIVO</option>
                        </select>
                    </div>
                    <div class="adm-input-group">
                        <label for="dis_nivel">Nível Inicial do Tanque (%)</label>
                        <input type="number" step="0.01" id="dis_nivel" name="DIS_NIVEL_TANQUE" value="<?= old('DIS_NIVEL_TANQUE', $dispositivo['DIS_NIVEL_TANQUE'] ?? '') ?>" placeholder="Ex: 100.00" required>
                    </div>
                </div>
            </div>

            <div class="adm-form-row">
                <div class="adm-input-group">
                    <label for="dis_descricao">Descrição do Dispositivo</label>
                    <input type="text" id="dis_descricao" name="DIS_DESCRICAO" value="<?= old('DIS_DESCRICAO', $dispositivo['DIS_DESCRICAO'] ?? '') ?>" placeholder="Breve resumo sobre a localização ou função do dispositivo">
                </div>
            </div>

            <div class="adm-section-divider">
                <span>Localização e Endereço</span>
            </div>

            <div class="adm-form-row">
                <div class="adm-input-group">
                    <label for="dis_cep">CEP</label>
                    <input type="text" id="dis_cep" name="DIS_CEP" class="mascara-cep" value="<?= old('DIS_CEP', $dispositivo['DIS_CEP'] ?? '') ?>" placeholder="00000-000">
                </div>
                <div class="adm-input-group flex-2">
                    <label for="dis_rua">Rua/Logradouro</label>
                    <input type="text" id="dis_rua" name="DIS_RUA" value="<?= old('DIS_RUA', $dispositivo['DIS_RUA'] ?? '') ?>" placeholder="Nome da rua ou avenida">
                </div>
                <div class="adm-input-group">
                    <label for="dis_num">Número</label>
                    <input type="text" id="dis_num" name="DIS_NUM" value="<?= old('DIS_NUM', $dispositivo['DIS_NUM'] ?? '') ?>" placeholder="Ex: 123 ou S/N">
                </div>
            </div>

            <div class="adm-form-row">
                <div class="adm-input-group flex-3">
                    <label for="dis_cidade">Cidade</label>
                    <input type="text" id="dis_cidade" name="DIS_CIDADE" value="<?= old('DIS_CIDADE', $dispositivo['DIS_CIDADE'] ?? '') ?>" placeholder="Cidade de instalação">
                </div>
                <div class="adm-input-group">
                    <label for="dis_uf">UF</label>
                    <input type="text" id="dis_uf" name="DIS_UF" maxlength="2" value="<?= old('DIS_UF', $dispositivo['DIS_UF'] ?? '') ?>" placeholder="Ex: SP" max="2">
                </div>
            </div>

            <div class="adm-section-divider">
                <span>Vínculo Geográfico e Proprietário</span>
            </div>

            <div class="adm-form-row" style="overflow: visible !important;">
                <div class="adm-input-group" style="position: relative !important; overflow: visible !important;">
                    <label for="fk_usu_id">Usuário Proprietário</label>
                    <select id="fk_usu_id" name="FK_USU_ID" placeholder="Digite para buscar um proprietário..." autocomplete="off" required>
                        <option value="">Digite para buscar um proprietário...</option>
                        
                        <?php if (!empty($usuarios_disponiveis)): ?>
                            <?php foreach ($usuarios_disponiveis as $userItem): ?>
                                <?php 
                                    $idOption   = $userItem['USU_ID'] ?? $userItem['id'];
                                    $nomeOption = $userItem['USU_NOME'] ?? $userItem['nome'];
                                    $selected   = (old('FK_USU_ID', $dispositivo['FK_USU_ID'] ?? '') == $idOption) ? 'selected' : '';
                                ?>
                                <option value="<?= esc($idOption) ?>" <?= $selected ?>>
                                    <?= esc($nomeOption) ?> (ID: <?= esc($idOption) ?>)
                                </option>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </select>
                </div>

                <div class="adm-input-group">
                    <label for="dis_latitude">Latitude</label>
                    <input type="text" id="dis_latitude" name="DIS_LATITUDE" class="mascara-coordenada" value="<?= old('DIS_LATITUDE', $dispositivo['DIS_LATITUDE'] ?? '') ?>" placeholder="Ex: -23.550520" required>
                </div>
                <div class="adm-input-group">
                    <label for="dis_longitude">Longitude</label>
                    <input type="text" id="dis_longitude" name="DIS_LONGITUDE" class="mascara-coordenada" value="<?= old('DIS_LONGITUDE', $dispositivo['DIS_LONGITUDE'] ?? '') ?>" placeholder="Ex: -46.633308" required>
                </div>
            </div>
            
            <div style="margin-top: 30px; display: flex; align-items: center; gap: 20px;">
                <button type="submit" class="adm-btn-submit">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar Dispositivo
                </button>
                <a href="<?= base_url('admin/dispositivos') ?>" style="text-decoration: none; color: #666; font-weight: 600; font-size: 0.95rem; display: inline-flex; align-items: center; gap: 6px; transition: color 0.2s;" onmouseover="this.style.color='#1e3c72'" onmouseout="this.style.color='#666'">
                    <i class="fa-solid fa-arrow-left"></i> Voltar para Lista
                </a>
            </div>
        </form>
    </div>

</main>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.16/jquery.mask.min.js"></script>

<script>
document.addEventListener("DOMContentLoaded", function() {
    // 1. Inicialização do TomSelect
    if (document.getElementById('fk_usu_id')) {
        if (document.getElementById('fk_usu_id').tomselect) {
            document.getElementById('fk_usu_id').tomselect.destroy();
        }

        new TomSelect("#fk_usu_id", {
            create: false,
            sortField: { field: "text", direction: "asc" },
            dropdownParent: null, 
            direction: 'up',      
            openOnFocus: true,
            controlInput: '<input type="text" autocomplete="off">'
        });
    }

    // 2. Aplicação das Máscaras via jQuery Mask
    $(document).ready(function(){
        // Máscara do CEP Padrão
        $('.mascara-cep').mask('00000-000');

        // Máscara Inteligente para Coordenadas Geográficas (Latitude e Longitude)
        // Permite o sinal de menos opcional no início, até 3 dígitos antes do ponto e até 6 casas decimais.
        $('.mascara-coordenada').mask('~Z00.000000', {
            translation: {
                '~': { pattern: /[-]/, optional: true },
                'Z': { pattern: /[0-9]/, optional: true }
            },
            placeholder: ""
        });
    });
});
</script>

<style>
/* Seus estilos do TomSelect mantidos intactos */
.ts-dropdown {
    position: absolute !important;
    top: auto !important;
    bottom: 100% !important; 
    margin-bottom: 5px !important;
    z-index: 999999 !important; 
    background-color: #ffffff !important;
    border: 1px solid #ced4da !important;
    border-radius: 6px !important;
    box-shadow: 0 -8px 24px rgba(0, 0, 0, 0.18) !important;
}

.ts-control {
    min-height: 44px !important;
    border: 1px solid #ced4da !important;
    border-radius: 6px !important;
    padding: 10px 12px !important;
    background-color: #fff !important;
    display: flex;
    align-items: center;
}

.ts-wrapper.focus .ts-control {
    border-color: #1e3c72 !important;
    box-shadow: 0 0 0 3px rgba(30, 60, 114, 0.15) !important;
}

.ts-dropdown .option {
    padding: 10px 15px !important;
    cursor: pointer;
}

.ts-dropdown .active {
    background-color: #1e3c72 !important;
    color: #fff !important;
}
</style>