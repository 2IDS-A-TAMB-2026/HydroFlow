<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HydroFlow - Editar Usuário</title>
    <!-- Fonte Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,300;0,400;0,500;0,600;0,700;1,600&display=swap" rel="stylesheet">
    <!-- Ícones Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- CSS Externo -->
    <link rel="stylesheet" href="<?= base_url('assets/css/style.css') ?>">
    <!-- CDN do SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

    <div class="login-container">
        
        <!-- Painel Esquerdo -->
        <div class="login-left">
            <div class="logo">Hydro<span>Flow</span></div>
            
            <div class="left-content">
                <span class="badge"><i class="fa-solid fa-user-pen"></i> Edição</span>
                <h1>Editar Usuário</h1>
                <p>Atualize as informações cadastrais e permissões de acesso do usuário no sistema.</p>
            </div>

            <a class="log_adm" href="<?= base_url('adm/usuarios') ?>">
                <i class="fa-solid fa-arrow-left"></i> Voltar à lista
            </a>
        </div>

        <!-- Painel Direito (Formulário Lado a Lado) -->
        <div class="login-right">
            <div class="login-card signup-card">
                <h2>Editar Dados</h2>
                <p class="subtitle">Altere os campos necessários para atualizar o cadastro</p>
                
                <form action="<?= base_url('adm/usuarios/atualizar/' . $usuario['USU_ID']) ?>" method="post" id="form">
                    
                    <!-- Dados Pessoais & Conta -->
                    <div class="form-row">
                        <div class="input-group nome-group">
                            <label for="nome">Nome Completo</label>
                            <div class="input-wrapper">
                                <i class="fa-regular fa-user input-icon"></i>
                                <input type="text" id="nome" name="NOME_USUARIO" placeholder="Digite o nome" value="<?= old('NOME_USUARIO', $data['USU_NOME'] ?? '') ?>" required>
                            </div>
                            <span id="faltaNome"></span>
                        </div>

                        <div class="input-group cpf-group">
                            <label for="cpf">CPF</label>
                            <div class="input-wrapper">
                                <i class="fa-regular fa-id-card input-icon"></i>
                                <input type="text" id="cpf" name="CPF_USUARIO" placeholder="000.000.000-00" value="<?= old('CPF_USUARIO', $usuario['USU_CPF'] ?? '') ?>">
                            </div>
                            <span id="faltaCPF"></span>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="input-group email-group">
                            <label for="email">E-mail</label>
                            <div class="input-wrapper">
                                <i class="fa-regular fa-envelope input-icon"></i>
                                <input type="email" id="email" name="EMAIL_USUARIO" placeholder="exemplo@email.com" value="<?= old('EMAIL_USUARIO', $usuario['USU_EMAIL'] ?? '') ?>" required>
                            </div>
                            <span id="faltaEmail"></span>
                        </div>

                        <div class="input-group status-group">
                            <label for="status">Status da Conta</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-toggle-on input-icon"></i>
                                <select id="status" name="STATUS_USUARIO" style="width: 100%; border: none; background: transparent; outline: none; font-family: 'Poppins', sans-serif;">
                                    <option value="ATIVO" <?= (old('STATUS_USUARIO', $usuario['USU_STATUS'] ?? '') === 'ATIVO') ? 'selected' : '' ?>>ATIVO</option>
                                    <option value="INATIVO" <?= (old('STATUS_USUARIO', $usuario['USU_STATUS'] ?? '') === 'INATIVO') ? 'selected' : '' ?>>INATIVO</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Divisor: Endereço -->
                    <div class="form-section-title">
                        <span><i class="fa-solid fa-location-dot"></i> Endereço</span>
                    </div>

                    <div class="form-row">
                        <div class="input-group cep-group">
                            <label for="cep">CEP</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-map-pin input-icon"></i>
                                <input type="text" id="cep" name="CEP_USUARIO" placeholder="00000-000" value="<?= old('CEP_USUARIO', $usuario['USU_CEP'] ?? '') ?>">
                            </div>
                            <span id="faltaCEP"></span>
                        </div>

                        <div class="input-group rua-group">
                            <label for="rua">Rua</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-road input-icon"></i>
                                <input type="text" id="rua" name="RUA_USUARIO" placeholder="Nome da rua" value="<?= old('RUA_USUARIO', $usuario['USU_RUA'] ?? '') ?>" readonly>
                            </div>
                            <span id="faltaRua"></span>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="input-group bairro-group">
                            <label for="bairro">Bairro</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-building input-icon"></i>
                                <input type="text" id="bairro" name="BAIRRO_USUARIO" placeholder="Seu bairro" value="<?= old('BAIRRO_USUARIO', $usuario['USU_BAIRRO'] ?? '') ?>" readonly>
                            </div>
                            <span id="faltaBairro"></span>
                        </div>

                        <div class="input-group numero-group">
                            <label for="numero">Número</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-hashtag input-icon"></i>
                                <input type="text" id="numero" name="NUMERO_USUARIO" placeholder="123" value="<?= old('NUMERO_USUARIO', $usuario['USU_NUM'] ?? '') ?>">
                            </div>
                            <span id="faltaNumero"></span>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="input-group cidade-group">
                            <label for="cidade">Cidade</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-city input-icon"></i>
                                <input type="text" id="cidade" name="CIDADE_USUARIO" placeholder="Sua cidade" value="<?= old('CIDADE_USUARIO', $usuario['USU_CIDADE'] ?? '') ?>" readonly>
                            </div>
                            <span id="faltaCidade"></span>
                        </div>

                        <div class="input-group uf-group">
                            <label for="uf">UF</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-flag input-icon"></i>
                                <input type="text" id="uf" name="UF_USUARIO" placeholder="SP" maxlength="2" value="<?= old('UF_USUARIO', $usuario['USU_UF'] ?? '') ?>" readonly>
                            </div>
                            <span id="faltaUF"></span>
                        </div>
                    </div>

                    <!-- Divisor: Segurança (Opcional na edição) -->
                    <div class="form-section-title">
                        <span><i class="fa-solid fa-shield-halved"></i> Segurança (Deixe em branco para manter a atual)</span>
                    </div>

                    <div class="form-row">
                        <div class="input-group">
                            <label for="senha">Nova Senha</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-lock input-icon"></i>
                                <input type="password" id="senha" name="SENHA_USUARIO" placeholder="••••••••">
                                <i class="fa-regular fa-eye toggle-password" id="toggleSenha"></i>
                            </div>
                            <span id="faltaSenha"></span>
                        </div>

                        <div class="input-group">
                            <label for="confirmar-senha">Confirmar Nova Senha</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-lock input-icon"></i>
                                <input type="password" id="confirmar-senha" placeholder="••••••••">
                                <i class="fa-regular fa-eye toggle-password" id="toggleConfirmarSenha"></i>
                            </div>
                            <span id="faltaConfirmarSenha"></span>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn-main">
                        <span>Salvar Alterações</span>
                        <i class="fa-solid fa-check"></i>
                    </button>
                </form>

            </div>
        </div>
        
    </div>

    <!-- Toggle de mostrar/ocultar senha -->
    <script>
        function setupPasswordToggle(toggleId, inputId) {
            const toggle = document.querySelector(toggleId);
            const input = document.querySelector(inputId);
            if (toggle && input) {
                toggle.addEventListener('click', function () {
                    const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
                    input.setAttribute('type', type);
                    this.classList.toggle('fa-eye');
                    this.classList.toggle('fa-eye-slash');
                });
            }
        }

        setupPasswordToggle('#toggleSenha', '#senha');
        setupPasswordToggle('#toggleConfirmarSenha', '#confirmar-senha');
    </script>

    <!-- Alert de Erro da Sessão -->
    <?php if (session()->getFlashdata('erro')): ?>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                Swal.fire({
                    icon: 'error',
                    title: 'Atenção!',
                    text: '<?= session()->getFlashdata('erro') ?>',
                    confirmButtonColor: '#0284c7'
                });
            });
        </script>
    <?php endif; ?>

    <!-- Busca CEP via API -->
    <script>
        document.getElementById('cep').addEventListener('blur', async function() {
            const cepInput = this.value;
            const cep = cepInput.replace(/\D/g, '');

            document.getElementById('faltaCEP').innerText = '';

            if (cep === '') return;

            if (cep.length !== 8) {
                Swal.fire({
                    icon: 'warning',
                    title: 'CEP Inválido',
                    text: 'O CEP deve conter 8 dígitos.',
                    confirmButtonColor: '#0284c7'
                });
                return;
            }

            try {
                document.getElementById('rua').placeholder = "Buscando...";
                document.getElementById('bairro').placeholder = "Buscando...";

                const response = await fetch(`https://viacep.com.br/ws/${cep}/json/`);
                const data = await response.json();

                if (data.erro) {
                    Swal.fire({
                        icon: 'error',
                        title: 'CEP não encontrado',
                        text: 'Verifique o número informado e tente novamente.',
                        confirmButtonColor: '#0284c7'
                    });
                    limpaFormularioEndereco();
                    return;
                }

                document.getElementById('rua').value = data.logradouro;
                document.getElementById('bairro').value = data.bairro;
                document.getElementById('cidade').value = data.localidade;
                document.getElementById('uf').value = data.uf;

                document.getElementById('numero').focus();

            } catch (error) {
                console.error("Erro na busca do CEP:", error);
                Swal.fire({
                    icon: 'error',
                    title: 'Erro de Conexão',
                    text: 'Não foi possível buscar o CEP automaticamente. Digite manualmente.',
                    confirmButtonColor: '#0284c7'
                });
            } finally {
                document.getElementById('rua').placeholder = "Nome da rua";
                document.getElementById('bairro').placeholder = "Seu bairro";
            }
        });

        function limpaFormularioEndereco() {
            document.getElementById('rua').value = '';
            document.getElementById('bairro').value = '';
            document.getElementById('cidade').value = '';
            document.getElementById('uf').value = '';
        }
    </script>

    <script src="https://unpkg.com/imask"></script>
    <script src="<?= base_url('assets/js/valida.js') ?>"></script>
</body>
</html>