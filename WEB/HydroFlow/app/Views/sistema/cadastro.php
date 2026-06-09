<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página de Cadastro</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,400;0,600;0,700;1,600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<?= base_url('assets/css/style.css') ?>">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

    <div class="login-container">
        
        <div class="login-left">
            <div class="logo"><span>HYDRO</span>FLOW</div>
            
            <div class="left-content">
                <h1>Cadastre-se!</h1>
                <p></p>
            </div>
        </div>

        <div class="login-right">
            
            <div class="login-card signup-card">
                <h2>Cadastro</h2>
                
                <form action="<?= base_url('cadastro/salvar') ?>" method="post" id="form">
                    
                    <div class="form-row">
                        <div class="input-group nome-group">
                            <label for="nome">Nome Completo</label>
                            <input type="text" id="nome" name="USU_NOME" placeholder="Digite seu nome" value="<?= old('USU_NOME') ?>">
                            <span id="faltaNome"></span>
                        </div>
                        <div class="input-group cpf-group">
                            <label for="cpf">CPF</label>
                            <input type="text" id="cpf" name="USU_CPF" placeholder="000.000.000-00" value="<?= old('USU_CPF') ?>">
                            <span id="faltaCPF"></span>
                        </div>
                    </div>
                    <div class="input-group email-group">
                        <label for="email">E-mail</label>
                        <input type="email" id="email" name="USU_EMAIL" placeholder="exemplo@email.com" value="<?= old('USU_EMAIL') ?>">
                        <span id="faltaEmail"></span>
                    </div>
                    
                    <div class="form-section-title">
                        <span>Endereço</span>
                    </div>

                    <div class="form-row">
                        <div class="input-group cep-group">
                            <label for="cep">CEP</label>
                            <input type="text" id="cep" name="USU_CEP" placeholder="00000-000" value="<?= old('USU_CEP') ?>">
                            <span id="faltaCEP"></span>
                        </div>
                        <div class="input-group rua-group">
                            <label for="rua">Rua</label>
                            <input type="text" id="rua" name="USU_RUA" placeholder="Nome da rua" value="<?= old('USU_RUA') ?>">
                            <span id="faltaRua"></span>
                        </div>
                        <div class="input-group bairro-group">
                            <label for="bairro">Bairro</label>
                            <input type="text" id="bairro" name="USU_BAIRRO" placeholder="Seu bairro" value="<?= old('USU_BAIRRO') ?>">
                            <span id="faltaBairro"></span>
                        </div>
                        <div class="input-group numero-group">
                            <label for="numero">Número</label>
                            <input type="text" id="numero" name="USU_NUM" placeholder="123" value="<?= old('USU_NUM') ?>">
                            <span id="faltaNumero"></span>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="input-group cidade-group">
                            <label for="cidade">Cidade</label>
                            <input type="text" id="cidade" name="USU_CIDADE" placeholder="Sua cidade" value="<?= old('USU_CIDADE') ?>">
                            <span id="faltaCidade"></span>
                        </div>
                        <div class="input-group uf-group">
                            <label for="uf">UF</label>
                            <input type="text" id="uf" name="USU_UF" placeholder="Ex: SP" maxlength="2" value="<?= old('USU_UF') ?>">
                            <span id="faltaUF"></span>
                        </div>
                    </div>

                    <div class="form-section-title">
                        <span>Segurança</span>
                    </div>

                    <div class="form-row">
                        <div class="input-group">
                            <label for="senha">Senha</label>
                            <input type="password" id="senha" name="USU_SENHA" placeholder="••••••••">
                            <span id="faltaSenha"></span>
                        </div>
                        <div class="input-group">
                            <label for="confirmar-senha">Confirmar Senha</label>
                            <input type="password" id="confirmar-senha" placeholder="••••••••">
                            <span id="faltaSenha"></span>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn-main" style="margin-top: 10px;">Finalizar Cadastro</button>
                </form>

                <p class="signup-link">Já tem uma conta? <a href="<?= base_url('login') ?>">Faça login</a></p>
            </div>
        </div>
        
    </div>

    <?php if (session()->getFlashdata('errors')): ?>
        <script>
            Swal.fire({
                title: 'Erro de Validação!',
                html: '<?= implode("<br>", session()->getFlashdata('errors')) ?>',
                icon: 'error'
            });
        </script>
    <?php endif; ?>

    <script src="https://unpkg.com/imask"></script>
    <script src="<?= base_url('assets/js/valida.js') ?>"></script>
</body>
</html>