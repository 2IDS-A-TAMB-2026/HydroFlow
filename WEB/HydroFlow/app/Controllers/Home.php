<?php

namespace App\Controllers;

class Home extends BaseController
{
    public function index()
    {
        return view('sistema/site/home');
    }

    public function irParaSobre()
    {
        return view('sistema/site/sobre');
    }

    public function irParaLoginUsu()
    {
        return view('sistema/usuario/login');
    }

    public function irParaLoginadm()
    {
        return view('sistema/adm/login_adm');
    }

    public function irParaCadastro(){
        return view('sistema/cadastro');
    }
}