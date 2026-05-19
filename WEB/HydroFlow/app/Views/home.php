<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hydroflow | Irrigação e Tecnologia</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <link rel="stylesheet" href="<?= base_url('assets/css/style1.css') ?>">

    <link rel="stylesheet" href="<?= base_url('assets/css/wave.css') ?>">
</head>

<body>

    <div class="top-bar">
        <span>Gestão inteligente de recursos hídricos</span>
        <span>E-mail: hydroflowsenai@gmail.com</span>
    </div>

    <header>
        <div class="logo">HYDRO<span>FLOW</span></div>

        <nav>
            <a href="#inicio">Início</a>

            <a href="#servicos">Serviços</a>

            <a href="<?= base_url('sobre') ?>">Sobre</a>

            <button id="btn-contraste" class="btn-acessibilidade">
                ◐ Alto Contraste
            </button>

            <a href="<?= base_url('login') ?>">Login</a>
        </nav>
    </header>

    <section id="inicio" class="hero">

        <img src="<?= base_url('assets/images/irrigador.jpeg') ?>" alt="Irrigador" class="hero-img">

        <div class="hero-content">
            <h1>Hydroflow</h1>
            <p>Sistema de Irrigação automática!.</p>
        </div>
    </section>

    <section class="cards-container">

        <div class="card">
            <i class="fa-solid fa-droplet"></i>

            <h3>Automação Fluida</h3>

            <p>
                Sistemas que trabalham em harmonia com a natureza,
                eliminando falhas manuais e desperdícios.
            </p>
        </div>

        <div class="card">
            <div class="card-icon">🌀</div>

            <h3>Constância Flow</h3>

            <p>
                Garantia de que a irrigação ocorra no tempo certo e na
                medida exata, sem interrupções técnicas.
            </p>
        </div>

        <div class="card">
            <i class="fa-solid fa-shield"></i>

            <h3>Solidez e Confiança</h3>

            <p>
                Tecnologia Hydroflow: unindo engenharia avançada para
                a segurança do seu negócio agrícola.
            </p>
        </div>

    </section>

    <main id="servicos" class="container" style="margin-top: 50px;">

        <section class="problem-solution">

            <div class="problem-box">
                <h2>O Desafio</h2>

                <p>
                    Muitos produtores enfrentam desperdício de água e
                    dependência de mão de obra manual.
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

        <section class="content-split">

            <div class="text-side">

                <h2>Escopo do Projeto</h2>

                <p>
                    Nosso sistema é baseado em
                    <strong>Internet das Coisas (IoT)</strong>.
                </p>

                <ul style="list-style: none; padding: 0; margin-top: 20px;">

                    <li>° <strong>Válvulas Solenoides</strong></li>

                    <li>° <strong>Telemetria</strong></li>

                    <li>° <strong>Hardware Acessível</strong></li>

                </ul>

            </div>

            <div class="image-side">

                <img src="<?= base_url('assets/images/diagrama.png') ?>" alt="Diagrama Hydroflow">

            </div>

        </section>

    </main>

    <div style="margin-bottom: 50px;">

        <svg class="waves"
            xmlns="http://www.w3.org/2000/svg"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            viewBox="0 24 150 28"
            preserveAspectRatio="none"
            shape-rendering="auto">

            <defs>

                <path
                    id="gentle-wave"
                    d="M-160 44c30 0 58-18 88-18s
                    58 18 88 18 58-18 88-18
                    58 18 88 18 v44h-352z" />

            </defs>

            <g class="parallax">

                <use xlink:href="#gentle-wave" x="48" y="0"/>

                <use xlink:href="#gentle-wave" x="48" y="3"/>

                <use xlink:href="#gentle-wave" x="48" y="5"/>

                <use xlink:href="#gentle-wave" x="48" y="7"/>

            </g>

        </svg>

    </div>

    <footer class="main-footer">

        <div class="footer-content">

            <div class="footer-brand">
                <div class="logo">HYDRO<span>FLOW</span></div>

                <p>
                    Tecnologia IoT para um futuro sustentável no campo.
                </p>
            </div>

            <div class="footer-links">

                <h4>Navegação</h4>

                <a href="#inicio">Início</a>

                <a href="#servicos">Serviços</a>

                <a href="<?= base_url('sobre') ?>">Sobre</a>

            </div>

            <div class="footer-contact">

                <h4>Contato</h4>

                <p>
                    <i class="fa-solid fa-envelope"></i>
                    hydroflowsenai@gmail.com
                </p>

                <p>
                    <i class="fa-solid fa-location-dot"></i>
                    São Paulo, SP
                </p>

            </div>

        </div>

        <div class="footer-bottom">
            <p>&copy; 2026 Hydroflow</p>
        </div>

    </footer>

    <script src="<?= base_url('assets/js/alto_contraste.js') ?>"></script>

</body>
</html>