<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hydroflow | Irrigação e Tecnologia</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<?= base_url('assets/css/style1.css') ?>"></link>
</head>
<body>
    <div class="top-bar">
        <span>📍 Gestão inteligente de recursos hídricos</span>
        <span>E-mail: hydroflowsenai@gmail.com</span>
    </div>

    <header>
        <div class="logo">HYDRO<span>FLOW</span></div>
        <nav>
            <a href="#">Sobre</a>
        
            <button id="btn-contraste" class="btn-acessibilidade">
                    ◐ 
            </button>

            <button id="aumentar-fonte" class="btn-acessibilidade">
                    +
            </button>

            <button id="diminuir-fonte" class="btn-acessibilidade">
                    -
            </button>
            <a href="<?= base_url('login') ?>">Login</a>
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
        <h2 style="text-align: center;">Equipe Técnica</h2>
        <div class="underline" style="margin: 0 auto;"></div>
    </div>
</section>

    <br><br><br><br><br>

    <div class="cards-container">
        <div class="card team-card">
            <div class="img-container">
                <img src="<?= base_url('assets/images/mariana.jpeg') ?>" alt="Mariana Ribeiro - Programadora Back-end e P.O" width="100px">
            </div>
            <h3>Mariana Ribeiro</h3>
            <p class="role">PO / Programadora BACK-END</p>
            <div class="social-links">
                <a href="https://github.com/ribeiromari14"><i class="fa-brands fa-github"></i></a>
            </div>
        </div>

        <div class="card team-card">
            <div class="img-container">
                <img src="<?= base_url('assets/images/anarita.jpeg') ?>" alt="Ana Rita Boiago - Programadora Back-end e S.M" width="100px">
            </div>
            <h3>Ana Rita Boiago</h3>
            <p class="role">SM / Programadora BACK-END</p>
            <div class="social-links">
                <a href="https://github.com/AnaBoiago15"><i class="fa-brands fa-github"></i></a>
            </div>
        </div>

        <div class="card team-card">
            <div class="img-container">
                <img src="<?= base_url('assets/images/giulia.jpeg') ?>" alt="Giulia Ribeiro - Analista de Sistemas e Designer" width="100px">
            </div>
            <h3>Giulia Ribeiro</h3>
            <p class="role"> Analista de Sistemas e Designer</p>
            <div class="social-links">
                <a href="https://github.com/GiuliaRibeiro16"><i class="fa-brands fa-github"></i></a>
            </div>
        </div>

        <div class="card team-card">
            <div class="img-container">
                <img src="<?= base_url('assets/images/neto.jpeg') ?>" alt="Rubens Neto - Analista de Sistemas e Designer" width="100px">
            </div>
            <h3>Rubens Neto</h3>
            <p class="role">Analista de Sistemas e Designer</p>
            <div class="social-links">
                <a href="https://github.com/rubsmosca"><i class="fa-brands fa-github"></i></a>
            </div>
        </div>

        <div class="card team-card">
            <div class="img-container">
                <img src="<?= base_url('assets/images/diego.jpeg') ?>" alt="Diego Bortolotti - Programador Full-stack" width="100px">
            </div>
            <h3>Diego Bortolotti</h3>
            <p class="role">Programador FULL-STACK</p>
            <div class="social-links">
                <a href="https://github.com/Dg29-alt"><i class="fa-brands fa-github"></i></a>
            </div>
        </div>

        <div class="card team-card">
            <div class="img-container">
                <img src="<?= base_url('assets/images/felipe.jpeg') ?>" alt="Felipe Ribeiro - Programador Full-stack" width="100px">
            </div>
            <h3>Felipe Ribeiro</h3>
            <p class="role">Programador FULL-STACK</p>
            <div class="social-links">
                <a href="https://github.com/Lip3-Ribeiro"><i class="fa-brands fa-github"></i></a>
            </div>
        </div>
    </div>
</section>
<script src="<?=base_url('assets/js/alto_contraste.js') ?>"></script>
<script src="<?=base_url('assets/js/acessibilidade.js') ?>"></script>
</body>
</html>