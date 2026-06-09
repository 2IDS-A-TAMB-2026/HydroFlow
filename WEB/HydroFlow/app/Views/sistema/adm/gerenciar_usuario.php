<?= view('sistema/layout/dashboard/adm/header') ?>
<?php 
/**
 * Hydroflow - Gerenciamento e Edição de Usuário
 * Utiliza classes exclusivas e dedicadas 'adm-' mapeadas no CSS externo.
 */
$user = $usuario ?? $usuario_selecionado ?? [];
$idUsuario = $user['USU_ID'] ?? $user['id'] ?? '';
$nomeUsuario = $user['USU_NOME'] ?? $user['nome'] ?? '';
?>

<main class="main-content">
    
    <?php if (session()->getFlashdata('sucesso') || session()->getFlashdata('success')): ?>
        <div style="background: #e2f0d9; color: #155724; border: 1px solid #c3e6cb; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; font-weight: 600;">
            <i class="fa-solid fa-circle-check"></i> 
            <?= session()->getFlashdata('sucesso') ?? session()->getFlashdata('success') ?>
        </div>
    <?php endif; ?>

    <?php if (session()->getFlashdata('erro') || session()->getFlashdata('error')): ?>
        <div style="background: #fce4d6; color: #721c24; border: 1px solid #f5c6cb; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; font-weight: 600;">
            <i class="fa-solid fa-circle-xmark"></i> 
            <?= session()->getFlashdata('erro') ?? session()->getFlashdata('error') ?>
        </div>
    <?php endif; ?>

    <div class="page-header" style="margin-bottom: 25px;">
        <div>
            <h2 style="color: #1e3c72; font-size: 1.6rem; font-weight: 600;">
                <i class="fa-solid fa-user-gear"></i> Gerenciar Conta de Usuário
            </h2>
            <p style="color: #666; margin-top: 5px;">
                Editando o cadastro de: <strong><?= esc($nomeUsuario ?: 'Novo Usuário') ?></strong>
            </p>
        </div>
    </div>

    <div class="adm-card-container">
        
        <form action="<?= base_url('admin/usuarios/' . $idUsuario) ?>" method="POST" id="formGerenciarUsuario">
            <?= csrf_field() ?>

            <div class="adm-form-row">
                <div class="adm-input-group flex-2">
                    <label for="nome">Nome Completo</label>
                    <input type="text" id="nome" name="NOME_USUARIO" value="<?= esc($nomeUsuario) ?>" placeholder="Digite seu nome" required>
                    <span id="faltaNome"></span>
                </div>
                <div class="adm-input-group">
                    <label for="cpf">CPF</label>
                    <input type="text" id="cpf" name="CPF_USUARIO" value="<?= esc($user['USU_CPF'] ?? $user['cpf'] ?? '') ?>" placeholder="000.000.000-00">
                    <span id="faltaCPF"></span>
                </div>
            </div>

            <div class="adm-form-row">
                <div class="adm-input-group flex-2">
                    <label for="email">E-mail</label>
                    <input type="email" id="email" name="EMAIL_USUARIO" value="<?= esc($user['USU_EMAIL'] ?? $user['email'] ?? '') ?>" placeholder="exemplo@email.com" required>
                    <span id="faltaEmail"></span>
                </div>
                <div class="adm-input-group">
                    <label for="status">Status da Conta</label>
                    <?php $statusAtual = strtoupper($user['USU_STATUS'] ?? $user['status'] ?? 'ATIVO'); ?>
                    <select id="status" name="STATUS_USUARIO">
                        <option value="ATIVO" <?= $statusAtual === 'ATIVO' ? 'selected' : '' ?>>Ativo</option>
                        <option value="INATIVO" <?= $statusAtual === 'INATIVO' ? 'selected' : '' ?>>Inativo</option>
                    </select>
                </div>
            </div>

            <div class="adm-section-divider">
                <span>Endereço</span>
            </div>

            <div class="adm-form-row">
                <div class="adm-input-group">
                    <label for="cep">CEP</label>
                    <input type="text" id="cep" name="CEP_USUARIO" value="<?= esc($user['USU_CEP'] ?? $user['cep'] ?? '') ?>" placeholder="00000-000">
                    <span id="faltaCEP"></span>
                </div>
                <div class="adm-input-group">
                    <label for="rua">Rua</label>
                    <input type="text" id="rua" name="RUA_USUARIO" value="<?= esc($user['USU_RUA'] ?? $user['rua'] ?? '') ?>" placeholder="Nome da rua">
                    <span id="faltaRua"></span>
                </div>
                <div class="adm-input-group">
                    <label for="bairro">Bairro</label>
                    <input type="text" id="bairro" name="BAIRRO_USUARIO" value="<?= esc($user['USU_BAIRRO'] ?? $user['bairro'] ?? '') ?>" placeholder="Seu bairro">
                    <span id="faltaBairro"></span>
                </div>
                <div class="adm-input-group">
                    <label for="numero">Número</label>
                    <input type="text" id="numero" name="NUMERO_USUARIO" value="<?= esc($user['USU_NUM'] ?? $user['numero'] ?? '') ?>" placeholder="123">
                    <span id="faltaNumero"></span>
                </div>
            </div>

            <div class="adm-form-row">
                <div class="adm-input-group flex-3">
                    <label for="cidade">Cidade</label>
                    <input type="text" id="cidade" name="CIDADE_USUARIO" value="<?= esc($user['USU_CIDADE'] ?? $user['cidade'] ?? '') ?>" placeholder="Sua cidade">
                    <span id="faltaCidade"></span>
                </div>
                <div class="adm-input-group">
                    <label for="uf">UF</label>
                    <input type="text" id="uf" name="UF_USUARIO" value="<?= esc($user['USU_UF'] ?? $user['uf'] ?? '') ?>" placeholder="Ex: SP" maxlength="2">
                    <span id="faltaUF"></span>
                </div>
            </div>

            <div class="adm-section-divider">
                <span>Segurança</span>
            </div>

            <div class="adm-form-row">
                <div class="adm-input-group">
                    <label for="senha">Senha (Deixe vazio para manter atual)</label>
                    <input type="password" id="senha" name="SENHA_USUARIO" placeholder="••••••••">
                    <span id="faltaSenha"></span>
                </div>
                <div class="adm-input-group">
                    <label for="confirmar-senha">Confirmar Senha</label>
                    <input type="password" id="confirmar-senha" name="CONFIRMAR_SENHA" placeholder="••••••••">
                    <span id="faltaSenha"></span>
                </div>
            </div>
            
            <div style="margin-top: 25px;">
                <button type="submit" id="btnSalvarAlteracoes" class="adm-btn-submit">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar Alterações
                </button>
            </div>
        </form>
    </div>

    <div class="widget card-big" style="background: #fff5f5; padding: 25px; border-radius: 12px; border: 1px solid #f5c6cb; margin-top: 35px;">
        <h3 style="color: #721c24; margin-bottom: 5px; font-weight: 700;">
            <i class="fa-solid fa-triangle-exclamation"></i> Zona Crítica
        </h3>
        <p style="color: #666; font-size: 0.9rem; margin-bottom: 15px;">
            A exclusão da conta removerá permanentemente o usuário do sistema Hydroflow. Esta ação não pode ser desfeita.
        </p>
        
        <a href="#" 
           class="btnExcluirUsuario"
           data-url="<?= base_url('admin/excluirUsuario/' . $idUsuario) ?>" 
           data-nome="<?= esc($nomeUsuario) ?>"
           style="display: inline-flex; align-items: center; gap: 8px; background-color: #dc3545; color: white; text-decoration: none; padding: 12px 22px; border-radius: 6px; font-weight: bold; font-size: 0.9rem; border: none; transition: background 0.2s;">
            <i class="fa-solid fa-trash-can"></i> Excluir Conta Permanentemente
        </a>
    </div>

    <div style="margin-top: 25px; margin-bottom: 10px;">
        <a href="<?= base_url('admin/usuarios') ?>" style="text-decoration: none; color: #1e3c72; font-weight: bold; font-size: 0.9rem; display: inline-flex; align-items: center; gap: 6px;">
            <i class="fa-solid fa-arrow-left"></i> Voltar à Lista de Usuários
        </a>
    </div>

</main>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://unpkg.com/imask"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // ==========================================
    // MÁSCARAS DE INPUT (IMask)
    // ==========================================
    const elementCpf = document.getElementById('cpf');
    if (elementCpf) IMask(elementCpf, { mask: '000.000.000-00' });

    const elementCep = document.getElementById('cep');
    if (elementCep) IMask(elementCep, { mask: '00000-000' });


    // ==========================================
    // CONFIRMAÇÃO DE EDIÇÃO (SALVAR ALTERAÇÕES)
    // ==========================================
    const form = document.getElementById('formGerenciarUsuario');
    
    if (form) {
        form.addEventListener('submit', function(e) {
            // Impede o envio imediato do formulário HTML
            e.preventDefault(); 

            Swal.fire({
                title: 'Confirmar alterações?',
                text: 'Os dados cadastrais deste usuário serão atualizados no sistema.',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#1e3c72',
                cancelButtonColor: '#6c757d',
                confirmButtonText: '<i class="fa-solid fa-check"></i> Sim, salvar!',
                cancelButtonText: 'Cancelar',
                background: '#ffffff',
                borderRadius: '8px'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Dispara o envio real do formulário nativo
                    form.submit();
                }
            });
        });
    }


    // ==========================================
    // CONFIRMAÇÃO DE EXCLUSÃO PERMANENTE
    // ==========================================
    const botaoExcluir = document.querySelector('.btnExcluirUsuario');

    if (botaoExcluir) {
        botaoExcluir.addEventListener('click', function(e) {
            e.preventDefault();

            const urlExclusao = this.getAttribute('data-url');
            const nomeUsuario = this.getAttribute('data-nome');

            Swal.fire({
                title: 'Tem certeza absoluta?',
                html: `Você está prestes a remover permanentemente o usuário <strong>"${nomeUsuario}"</strong>.<br><br><span style="color:#d33; font-weight:bold;">Todos os logs e acessos vinculados serão deletados. Esta ação não é revertível!</span>`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#3085d6',
                confirmButtonText: '<i class="fa-solid fa-trash"></i> Sim, excluir permanentemente!',
                cancelButtonText: 'Cancelar',
                background: '#ffffff',
                borderRadius: '8px'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Redireciona para a URL de exclusão do controller
                    window.location.href = urlExclusao;
                }
            });
        });
    }
});
</script>