<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HydroFlow - Cadastro</title>
    <!-- Fonte Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,300;0,400;0,500;0,600;0,700;1,600&display=swap" rel="stylesheet">
    <!-- Ícones Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- CSS Externo (Mesmo CSS Unificado de Login e Cadastro) -->
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
                <span class="badge"><i class="fa-solid fa-droplet"></i> Nova Conta</span>
                <h1>Cadastre-se na plataforma!</h1>
                <p>Crie sua conta para monitorar consumos, evitar desperdícios e gerenciar seus recursos hídricos.</p>
            </div>

            <a class="log_adm" href="<?= base_url('login') ?>">
                <i class="fa-solid fa-arrow-left"></i> Voltar ao login
            </a>
        </div>

        <!-- Painel Direito (Formulário Lado a Lado) -->
        <div class="login-right">
            <div class="login-card signup-card">
                <h2>Criar Conta</h2>
                <p class="subtitle">Preencha os campos abaixo para concluir o registro</p>
                
                <form action="<?= base_url('cadastro/salvar') ?>" method="post" id="form">
                    
                    <!-- Dados Pessoais -->
                    <div class="form-row">
                        <div class="input-group nome-group">
                            <label for="nome">Nome Completo</label>
                            <div class="input-wrapper">
                                <i class="fa-regular fa-user input-icon"></i>
                                <input type="text" id="nome" name="USU_NOME" placeholder="Digite seu nome" value="<?= old('USU_NOME') ?>">
                            </div>
                            <span id="faltaNome"></span>
                        </div>

                        <div class="input-group cpf-group">
                            <label for="cpf">CPF</label>
                            <div class="input-wrapper">
                                <i class="fa-regular fa-id-card input-icon"></i>
                                <input type="text" id="cpf" name="USU_CPF" placeholder="000.000.000-00" value="<?= old('USU_CPF') ?>">
                            </div>
                            <span id="faltaCPF"></span>
                        </div>
                    </div>

                    <div class="input-group email-group">
                        <label for="email">E-mail</label>
                        <div class="input-wrapper">
                            <i class="fa-regular fa-envelope input-icon"></i>
                            <input type="email" id="email" name="USU_EMAIL" placeholder="exemplo@email.com" value="<?= old('USU_EMAIL') ?>">
                        </div>
                        <span id="faltaEmail"></span>
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
                                <input type="text" id="cep" name="USU_CEP" placeholder="00000-000" value="<?= old('USU_CEP') ?>">
                            </div>
                            <span id="faltaCEP"></span>
                        </div>

                        <div class="input-group rua-group">
                            <label for="rua">Rua</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-road input-icon"></i>
                                <input type="text" id="rua" name="USU_RUA" placeholder="Nome da rua" value="<?= old('USU_RUA') ?>" readonly>
                            </div>
                            <span id="faltaRua"></span>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="input-group bairro-group">
                            <label for="bairro">Bairro</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-building input-icon"></i>
                                <input type="text" id="bairro" name="USU_BAIRRO" placeholder="Seu bairro" value="<?= old('USU_BAIRRO') ?>" readonly>
                            </div>
                            <span id="faltaBairro"></span>
                        </div>

                        <div class="input-group numero-group">
                            <label for="numero">Número</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-hashtag input-icon"></i>
                                <input type="text" id="numero" name="USU_NUM" placeholder="123" value="<?= old('USU_NUM') ?>">
                            </div>
                            <span id="faltaNumero"></span>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="input-group cidade-group">
                            <label for="cidade">Cidade</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-city input-icon"></i>
                                <input type="text" id="cidade" name="USU_CIDADE" placeholder="Sua cidade" value="<?= old('USU_CIDADE') ?>" readonly>
                            </div>
                            <span id="faltaCidade"></span>
                        </div>

                        <div class="input-group uf-group">
                            <label for="uf">UF</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-flag input-icon"></i>
                                <input type="text" id="uf" name="USU_UF" placeholder="SP" maxlength="2" value="<?= old('USU_UF') ?>" readonly>
                            </div>
                            <span id="faltaUF"></span>
                        </div>
                    </div>

                    <!-- Divisor: Segurança -->
                    <div class="form-section-title">
                        <span><i class="fa-solid fa-shield-halved"></i> Segurança</span>
                    </div>

                    <div class="form-row">
                        <div class="input-group">
                            <label for="senha">Senha</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-lock input-icon"></i>
                                <input type="password" id="senha" name="USU_SENHA" placeholder="••••••••">
                                <i class="fa-regular fa-eye toggle-password" id="toggleSenha"></i>
                            </div>
                            <span id="faltaSenha"></span>
                        </div>

                        <div class="input-group">
                            <label for="confirmar-senha">Confirmar Senha</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-lock input-icon"></i>
                                <input type="password" id="confirmar-senha" placeholder="••••••••">
                                <i class="fa-regular fa-eye toggle-password" id="toggleConfirmarSenha"></i>
                            </div>
                            <span id="faltaConfirmarSenha"></span>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn-main">
                        <span>Finalizar Cadastro</span>
                        <i class="fa-solid fa-arrow-right"></i>
                    </button>
                </form>

                <p class="signup-link">Já tem uma conta? <a href="<?= base_url('login') ?>">Faça login</a></p>
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

    <!-- SweetAlert2 para erros de validação vindo do backend -->
    <?php if (session()->getFlashdata('errors')): ?>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                Swal.fire({
                    icon: 'error',
                    title: 'Erro de Validação!',
                    html: '<?= implode("<br>", session()->getFlashdata('errors')) ?>',
                    confirmButtonText: 'Corrigir',
                    confirmButtonColor: '#0284c7'
                });
            });
        </script>
    <?php endif; ?>
    
    <script>
        document.getElementById('cep').addEventListener('blur', async function() {
        const cepInput = this.value;
        const cep = cepInput.replace(/\D/g, ''); // Remove tudo que não for número

        // Limpa avisos de erro anteriores do CEP
        document.getElementById('faltaCEP').innerText = '';

        if (cep === '') return;

        // Validação básica do tamanho do CEP
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
            // Mostra estado de carregamento simples nos inputs
            document.getElementById('rua').placeholder = "Buscando...";
            document.getElementById('bairro').placeholder = "Buscando...";

            const response = await fetch(`https://viacep.com.br/ws/${cep}/json/`);
            const data = await response.json();

            // Caso o CEP não exista na base de dados do ViaCEP
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

            // Auto-preenche os campos mapeados com o seu HTML
            document.getElementById('rua').value = data.logradouro;
            document.getElementById('bairro').value = data.bairro;
            document.getElementById('cidade').value = data.localidade;
            document.getElementById('uf').value = data.uf;

            // Move o foco pro número, que é o único dado manual do endereço
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
            // Restaura os placeholders padrão
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