<!DOCTYPE html>
<html lang="pt-BR">

<head>

    <meta charset="UTF-8">

    <meta 
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>Hydroflow | Irrigação e Tecnologia</title>

    <!-- Fonte -->
    <link 
        href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap"
        rel="stylesheet"
    >

    <!-- Ícones -->
    <link 
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
    >

    <!-- CSS -->
    <link 
        rel="stylesheet"
        href="<?= base_url('assets/css/style1.css') ?>"
    >

    <link 
        rel="stylesheet"
        href="<?= base_url('assets/css/waves.css') ?>"
    >

</head>

<body>

    <!-- Barra superior -->
    <div class="top-bar" aria-label="Informações principais">

        <span aria-label="Mensagem institucional">
            Gestão inteligente de recursos hídricos
        </span>

        <span aria-label="E-mail de contato">
            E-mail: hydroflowsenai@gmail.com
        </span>

    </div>

    <!-- Cabeçalho -->
    <header aria-label="Cabeçalho principal do site">

        <!-- Logo -->
        <div class="logo" aria-label="Logo HydroFlow">
            HYDRO<span>FLOW</span>
        </div>

        <!-- Navegação -->
        <nav aria-label="Menu principal">

            <a href="#inicio" aria-label="Ir para início">
                Início
            </a>

            <a 
                href="<?= base_url('sobre') ?>"
                aria-label="Ir para página sobre"
            >
                Sobre
            </a>

            <!-- Contraste -->
            <button 
                id="btn-contraste"
                class="btn-acessibilidade"
                aria-label="Ativar ou desativar alto contraste"
                title="Contraste"
            >
                ◐
            </button>

            <!-- Aumentar fonte -->
            <button 
                id="aumentar-fonte"
                class="btn-acessibilidade"
                aria-label="Aumentar tamanho da fonte"
                title="Aumentar fonte"
            >
                +
            </button>

            <!-- Diminuir fonte -->
            <button 
                id="diminuir-fonte"
                class="btn-acessibilidade"
                aria-label="Diminuir tamanho da fonte"
                title="Diminuir fonte"
            >
                -
            </button>

           

            <!-- Login -->
            <a 
                href="<?= base_url('login') ?>"
                aria-label="Ir para página de login"
            >
                Login
            </a>

        </nav>

    </header>

    <!-- Hero -->
    <section 
        id="inicio"
        class="hero"
        aria-label="Seção principal HydroFlow"
    >

        <img 
            src="<?= base_url('assets/images/irrigador.jpeg') ?>"
            alt="Plantação sendo irrigada automaticamente por sistema de irrigação no campo durante o pôr do sol"
            class="hero-img"
        >

        <div class="hero-content">

            <h1>Hydroflow</h1>

            <p>
                Sistema de irrigação automática.
            </p>

        </div>

    </section>

    <!-- Cards -->
    <section 
        class="cards-container"
        aria-label="Benefícios do sistema HydroFlow"
    >

        <div class="card">

        <div 
                class="card-icon"
                aria-label="Ícone representando automação fluida"
            >
                ⚙️
            </div>

            <h3>Automação Fluida</h3>

            <p>
                Sistemas que trabalham em harmonia com a natureza,
                eliminando falhas manuais e desperdícios.
            </p>

        </div>

        <div class="card">

            <div 
                class="card-icon"
                aria-label="Ícone representando constância do fluxo"
            >
                🌀
            </div>

            <h3>Constância Flow</h3>

            <p>
                Garantia de que a irrigação ocorra no tempo certo
                e na medida exata.
            </p>

        </div>

        <div class="card">

            <div 
                class="card-icon"
                aria-label="Ícone representando confiança"
            >
                🤝
            </div>

            <h3>Solidez e Confiança</h3>

            <p>
                Tecnologia Hydroflow unindo engenharia avançada
                para segurança do negócio agrícola.
            </p>

        </div>

    </section>

    <!-- Conteúdo -->
    <main 
        id="servicos"
        class="container"
        style="margin-top: 50px;"
    >

        <!-- Problema e solução -->
        <section 
            class="problem-solution"
            aria-label="Problema e solução HydroFlow"
        >

            <div class="problem-box">

                <h2>O Desafio</h2>

                <p>
                    Muitos produtores enfrentam desperdício de água
                    e dependência de mão de obra manual.
                </p>

            </div>

            <div class="solution-box">

                <h2>Nossa Resposta</h2>

                <p>
                    O <strong>Smart Irrigation Hydroflow</strong>
                    monitora a umidade do solo em tempo real.
                </p>

            </div>

        </section>

        <!-- Escopo -->
        <section 
            class="content-split"
            aria-label="Escopo do projeto HydroFlow"
        >

            <div class="text-side">

                <h2>Escopo do Projeto</h2>

                <p>
                    Nosso sistema utiliza
                    <strong>Internet das Coisas (IoT)</strong>,
                    sensores capacitivos e ESP32.
                </p>

                <p>
                    A automação local continua funcionando
                    mesmo sem internet.
                </p>

                <ul 
                    style="list-style: none; padding: 0; margin-top: 20px;"
                    aria-label="Características do sistema"
                >

                    <li>
                        ° <strong>Válvulas Solenoides</strong>
                        de alta precisão.
                    </li>

                    <li>
                        ° <strong>Telemetria</strong>
                        de consumo de água.
                    </li>

                    <li>
                        ° <strong>Hardware Acessível</strong>
                        para microempreendedores.
                    </li>

                </ul>

            </div>

            <div class="image-side">

                <img 
                    src="<?= base_url('assets/images/diagrama.png') ?>"
                    alt="Diagrama do funcionamento do sistema HydroFlow mostrando sensor de umidade conectado ao ESP32, envio de dados para nuvem (api), dashboard e acionamento automático da irrigação"
                >

            </div>

        </section>

        <!-- Serviços -->
        <section 
            class="services-grid"
            aria-label="Serviços da HydroFlow"
        >

            <div class="service-card">

                <div 
                    class="icon"
                    aria-label="Ícone de monitoramento"
                >
                    📡
                </div>

                <h3>Monitoramento IoT</h3>

                <p>
                    Sensores conectados ao ESP32 enviando dados
                    constantes do solo.
                </p>

            </div>

            <div class="service-card">

                <div 
                    class="icon"
                    aria-label="Ícone de celular"
                >
                    📱
                </div>

                <h3>Gestão Remota</h3>

                <p>
                    Dashboard Web e App Mobile para controle remoto.
                </p>

            </div>

            <div class="service-card">

                <div 
                    class="icon"
                    aria-label="Ícone de automação"
                >
                    ⚙️
                </div>

                <h3>Controle Híbrido</h3>

                <p>
                    Sistema inteligente funcionando com ou sem internet.
                </p>

            </div>

            <div class="service-card">

                <div 
                    class="icon"
                    aria-label="Ícone de redução de custos"
                >
                    📉
                </div>

                <h3>Eficiência de Custos</h3>

                <p>
                    Redução do desperdício de água e energia.
                </p>

            </div>

            <div class="service-card">

                <div 
                    class="icon"
                    aria-label="Ícone de alertas"
                >
                    🔔
                </div>

                <h3>Alertas e Resiliência</h3>

                <p>
                    Notificações em tempo real sobre falhas e riscos.
                </p>

            </div>

            <div class="service-card">

                <div 
                    class="icon"
                    aria-label="Ícone de sustentabilidade"
                >
                    🌱
                </div>

                <h3>Sustentabilidade</h3>

                <p>
                    Precisão na irrigação preservando nutrientes do solo.
                </p>

            </div>

        </section>

        <!-- Funcionamento -->
        <section 
            class="how-it-works"
            aria-label="Como o HydroFlow funciona"
        >

            <div class="container">

                <h2 class="section-title">
                    Como o Hydroflow funciona?
                </h2>

                <div class="steps-wrapper">

                    <div class="step-item">

                        <div 
                            class="step-number"
                            aria-label="Passo 1"
                        >
                            1
                        </div>

                        <h4>Conexão do Hardware</h4>

                        <p>
                            Instalação do ESP32 e sensores no solo.
                        </p>

                    </div>

                    <div class="step-arrow">

                        <i 
                            class="fa-solid fa-chevron-right"
                            aria-hidden="true"
                        ></i>

                    </div>

                    <div class="step-item">

                        <div 
                            class="step-number"
                            aria-label="Passo 2"
                        >
                            2
                        </div>

                        <h4>Sincronização Nuvem</h4>

                        <p>
                            Dados enviados em tempo real pela internet.
                        </p>

                    </div>

                    <div class="step-arrow">

                        <i 
                            class="fa-solid fa-chevron-right"
                            aria-hidden="true"
                        ></i>

                    </div>

                    <div class="step-item">

                        <div 
                            class="step-number"
                            aria-label="Passo 3"
                        >
                            3
                        </div>

                        <h4>Automação Inteligente</h4>

                        <p>
                            O sistema controla automaticamente a irrigação.
                        </p>

                    </div>

                </div>

            </div>

        </section>

        <!-- Público -->
        <section 
            class="target-audience"
            aria-label="Público alvo HydroFlow"
        >

            <h2>Para quem é a Hydroflow?</h2>

            <div class="carousel-container">

                <div class="carousel-track">

                    <div class="audience-card">
                        <span>Microempresas Agrícolas</span>
                    </div>

                    <div class="audience-card">
                        <span>Pequenos Produtores</span>
                    </div>

                    <div class="audience-card">
                        <span>Hortas Comunitárias</span>
                    </div>

                    <div class="audience-card">
                        <span>Condomínios</span>
                    </div>

                    <div class="audience-card">
                        <span>Escolas & Hotéis</span>
                    </div>

                    <div class="audience-card">
                        <span>Jardinagem Profissional</span>
                    </div>

                    <div class="audience-card">
                        <span>Microempresas Agrícolas</span>
                    </div>

                    <div class="audience-card">
                        <span>Pequenos Produtores</span>
                    </div>

                    <div class="audience-card">
                        <span>Hortas Comunitárias</span>
                    </div>

                    <div class="audience-card">
                        <span>Condomínios</span>
                    </div>

                    <div class="audience-card">
                        <span>Escolas & Hotéis</span>
                    </div>

                    <div class="audience-card">
                        <span>Jardinagem Profissional</span>
                    </div>

                </div>

            </div>

        </section>

    </main>

    <!-- Ondas -->
    <div style="margin-bottom: 50px;">

        <svg 
            class="waves"
            xmlns="http://www.w3.org/2000/svg"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            viewBox="0 24 150 28"
            preserveAspectRatio="none"
            shape-rendering="auto"
            role="img"
            aria-label="Ondas decorativas"
        >

            <title>Ondas decorativas</title>

            <defs>

                <path 
                    id="gentle-wave"
                    d="M-160 44c30 0 58-18 88-18s58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z"
                />

            </defs>

            <g class="parallax">

                <use xlink:href="#gentle-wave" x="48" y="0"></use>

                <use xlink:href="#gentle-wave" x="48" y="3"></use>

                <use xlink:href="#gentle-wave" x="48" y="5"></use>

                <use xlink:href="#gentle-wave" x="48" y="7"></use>

            </g>

        </svg>

    </div>

    <!-- Rodapé -->
    <div class="content flex">

        <footer 
            class="main-footer"
            aria-label="Rodapé do site"
        >

            <div class="footer-content">

                <div class="footer-brand">

                    <div 
                        class="logo"
                        aria-label="Logo HydroFlow"
                    >
                        HYDRO<span>FLOW</span>
                    </div>

                    <p>
                        Tecnologia IoT para um futuro sustentável no campo.
                    </p>

                </div>

                <nav 
                    class="footer-links"
                    aria-label="Links do rodapé"
                >

                    <h4>Navegação</h4>

                    <a href="#inicio" aria-label="Ir para início">
                        Início
                    </a>

                    <a href="#servicos" aria-label="Ir para serviços">
                        Serviços
                    </a>

                    <a 
                        href="<?= base_url('sobre') ?>"
                        aria-label="Ir para página sobre"
                    >
                        Sobre
                    </a>

                </nav>

                <div class="footer-contact">

                    <h4>Contato</h4>

                    <p>
                        <i 
                            class="fa-solid fa-envelope"
                            aria-hidden="true"
                        ></i>

                        <span aria-label="E-mail para contato">
                            hydroflowsenai@gmail.com
                        </span>
                    </p>

                    <p>
                        <i 
                            class="fa-solid fa-location-dot"
                            aria-hidden="true"
                        ></i>

                        <span aria-label="Localização">
                            Tambaú, SP
                        </span>
                    </p>

                </div>

                <div class="footer-social">

                    <h4>Redes</h4>

                    <div class="social-icons">

                        <a 
                            href="https://github.com/2IDS-A-TAMB-2026/HydroFlow"
                            aria-label="GitHub da HydroFlow"
                        >
                            <i 
                                class="fa-brands fa-github"
                                aria-hidden="true"
                            ></i>
                        </a>

                        <a 
                            href="https://www.instagram.com/hydroflow.senai?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="
                            aria-label="Instagram da HydroFlow"
                        >
                            <i 
                                class="fa-brands fa-instagram"
                                aria-hidden="true"
                            ></i>
                        </a>

                    </div>

                </div>

            </div>

            <div class="footer-bottom">

                <p>
                    &copy; 2026 Hydroflow - Irrigação Inteligente e Tecnologia.
                </p>

            </div>

        </footer>

    </div>

    <!-- Script -->
    <script src="<?= base_url('assets/js/alto_contraste.js') ?>"></script>
    <script src="<?= base_url('assets/js/acessibilidade.js') ?>"></script>
</body>
</html>