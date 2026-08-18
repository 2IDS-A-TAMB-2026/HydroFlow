<header>
    <style>
    *{
        margin:0;
        padding:0;
        box-sizing:border-box;
        font-family:'Segoe UI',sans-serif;
    }

    body{
        height:100vh;
        background:#f5f5f5;
    }

    .container{
        display:flex;
        height:100vh;
    }

    /* ESQUERDA */

    .left-panel{
        width:50%;
        background:linear-gradient(
            135deg,
            #002855,
            #001f45
        );
        color:white;
        padding:60px;
        display:flex;
        flex-direction:column;
        justify-content:space-between;
        }

        .logo{
            font-size:26px;
            font-weight:bold;
        }

        .logo span{
            color:#4DD0E1;
        }

        .welcome h1{
            font-size:72px;
            font-style:italic;
            margin-bottom:15px;
        }

        .welcome p{
            font-size:22px;
            color:#b9e8f0;
            font-weight:600;
        }

        /* DIREITA */

        .right-panel{
            width:50%;
            background:#f1f1f1;
            display:flex;
            align-items:center;
            justify-content:center;
        }

        .card{
            width:500px;
            background:white;
            padding:45px;
            border-radius:18px;
            box-shadow:0 8px 25px rgba(0,0,0,.08);
        }

        .card h2{
            color:#002855;
            margin-bottom:35px;
        }

        .campo{
            margin-bottom:20px;
        }

        .campo label{
            display:block;
            margin-bottom:8px;
            font-weight:600;
            color:#002855;
        }

        .campo input{
            width:100%;
            height:55px;
            border:1px solid #ddd;
            border-radius:8px;
            padding:0 15px;
            font-size:16px;
        }

        button{
            width:100%;
            height:60px;
            border:none;
            border-radius:8px;
            background:#1565C0;
            color:white;
            font-size:22px;
            font-weight:600;
            cursor:pointer;
            margin-top:15px;
        }

        button:hover{
            opacity:.95;
        }

        .footer-link{
            margin-top:30px;
            text-align:center;
        }

        .footer-link a{
            color:#1565C0;
            text-decoration:none;
            font-weight:bold;
        }
    </style>
</header>
<body>
<div class="container">

    <!-- LADO ESQUERDO -->
    <div class="left-panel">
        <div class="logo">
            Hydro<span>Flow</span>
        </div>

        <div class="welcome">
            <h1>Nova Senha</h1>
            <p>Defina uma nova senha para sua conta</p>
        </div>
    </div>

    <!-- LADO DIREITO -->
    <div class="right-panel">

        <div class="card">

            <h2>Redefinir Senha</h2>

            <form id="formNovaSenha">

                <div class="campo">
                    <label>Nova senha</label>
                    <input
                        type="password"
                        id="novaSenha"
                        placeholder="••••••••">
                </div>

                <div class="campo">
                    <label>Confirmar senha</label>
                    <input
                        type="password"
                        id="confirmarSenha"
                        placeholder="••••••••">
                </div>

                <button type="submit">
                    Salvar nova senha
                </button>

            </form>

            <div class="footer-link">
                Voltar para
                <a href="login.html">Login</a>
            </div>

        </div>

    </div>

</div>
</body>