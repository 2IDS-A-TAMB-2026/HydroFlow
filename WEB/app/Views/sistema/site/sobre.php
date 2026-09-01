<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hydroflow | Irrigação e Tecnologia</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<?= base_url('assets/css/style1.css') ?>">
    <link rel="stylesheet"href="<?= base_url('assets/css/waves.css') ?>">

    <style>
        /* Container principal limitado para travar a largura máxima */
        .cards-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 30px;
            padding: 20px;
            max-width: 1000px; /* Garante espaço ideal para 3 por linha */
            margin: 0 auto;
        }

        /* Configuração para forçar 3 por linha no desktop */
        .team-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 25px 20px;
            /* Calcula o tamanho para caber exatamente 3 tirando o gap */
            flex: 1 1 calc(33.333% - 30px); 
            max-width: 280px; /* Limite individual de largura */
            text-align: center;
            transition: transform 0.3s ease;
            box-sizing: border-box;
        }

        .team-card:hover {
            transform: translateY(-5px);
        }

        /* Container da foto */
        .img-container {
            width: 110px;
            height: 110px;
            margin: 0 auto 15px auto;
            border-radius: 50%;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 3px solid #0d6efd;
        }

        .img-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .team-card h3 {
            font-size: 1.15rem;
            margin: 10px 0 5px 0;
            color: #333;
        }

        .team-card .role {
            font-size: 0.85rem;
            color: #666;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 15px;
        }

        /* Responsividade: Se a tela for pequena (celular), vira lista */
        @media (max-width: 768px) {
            .team-card {
                flex: 1 1 100%;
                max-width: 300px;
            }
        }
    </style>
</head>
<body>
    <div class="top-bar">
        <span>Gestão inteligente de recursos hídricos</span>
        <span>E-mail: hydroflowsenai@gmail.com</span>
    </div>

    <header>
        <div class="logo">HYDRO<span>FLOW</span></div>
        <nav>
            <a href="<?= base_url('/') ?>" aria-label="Ir para início">
                Início
            </a>
            
            <a href="<?= base_url('sobre') ?>">Sobre</a>
        
            <button id="btn-contraste" class="btn-acessibilidade">
                    ◐ 
            </button>

            <button id="aumentar-fonte" class="btn-acessibilidade">
                    +
            </button>

            <button id="diminuir-fonte" class="btn-acessibilidade">
                    -
            </button>
            <a href="<?= base_url('login')?>">Login</a>
        </nav>
    </header>

    <section class="hero">
        <img src="<?= base_url('assets/images/irrigador.jpeg') ?>" alt="Irrigador" class="hero-img">
        
        <div class="hero-content">
            <h1>Hydroflow</h1>
            <p>Sistema de Irrigação automática!</p>
        </div>
    </section>

    <br><br>

    <section class="team-section" style="text-align: center;">
        <div class="team-header">
            <h2>Equipe Técnica</h2>
            <div class="underline" style="margin: 0 auto;"></div>
        </div>
    </section>

    <br><br>

    <div class="cards-container">
        <div class="card team-card">
            <div class="img-container">
                <img src="<?= base_url('assets/images/mariana.jpeg') ?>" alt="Mariana Ribeiro - Programadora Back-end e P.O">
            </div>
            <h3>Mariana Ribeiro</h3>
            <p class="role">PO / Programadora BACK-END</p>
            <div class="social-links">
                <a href="https://github.com/ribeiromari14"><i class="fa-brands fa-github"></i></a>
            </div>
        </div>

        <div class="card team-card">
            <div class="img-container">
                <img src="<?= base_url('assets/images/anarita.jpeg') ?>" alt="Ana Rita Boiago - Programadora Back-end e S.M">
            </div>
            <h3>Ana Rita Boiago</h3>
            <p class="role">SM / Programadora BACK-END</p>
            <div class="social-links">
                <a href="https://github.com/AnaBoiago15"><i class="fa-brands fa-github"></i></a>
            </div>
        </div>

        <div class="card team-card">
            <div class="img-container">
                <img src="<?= base_url('assets/images/giulia.jpeg') ?>" alt="Giulia Ribeiro - Analista de Sistemas e Designer">
            </div>
            <h3>Giulia Ribeiro</h3>
            <p class="role">Analista de Sistemas e Designer</p>
            <div class="social-links">
                <a href="https://github.com/GiuliaRibeiro16"><i class="fa-brands fa-github"></i></a>
            </div>
        </div>

        <div class="card team-card">
            <div class="img-container">
                <img src="<?= base_url('assets/images/neto.jpeg') ?>" alt="Rubens Neto - Analista de Sistemas e Designer">
            </div>
            <h3>Rubens Neto</h3>
            <p class="role">Analista de Sistemas e Designer</p>
            <div class="social-links">
                <a href="https://github.com/rubsmosca"><i class="fa-brands fa-github"></i></a>
            </div>
        </div>

        <div class="card team-card">
            <div class="img-container">
                <img src="<?= base_url('assets/images/diego.jpeg') ?>" alt="Diego Bortolotti - Programador Full-stack">
            </div>
            <h3>Diego Bortolotti</h3>
            <p class="role">Programador FULL-STACK</p>
            <div class="social-links">
                <a href="https://github.com/Dg29-alt"><i class="fa-brands fa-github"></i></a>
            </div>
        </div>

        <div class="card team-card">
            <div class="img-container">
                <img src="<?= base_url('assets/images/felipe.jpeg') ?>" alt="Felipe Ribeiro - Programador Full-stack">
            </div>
            <h3>Felipe Ribeiro</h3>
            <p class="role">Programador FULL-STACK</p>
            <div class="social-links">
                <a href="https://github.com/Lip3-Ribeiro"><i class="fa-brands fa-github"></i></a>
            </div>
        </div>
    </div>

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

    <script src="<?=base_url('assets/js/alto_contraste.js') ?>"></script>
    <script src="<?=base_url('assets/js/acessibilidade.js') ?>"></script>
</body>
</html>