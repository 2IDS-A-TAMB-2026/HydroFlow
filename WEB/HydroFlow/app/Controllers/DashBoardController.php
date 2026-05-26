<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\DadosSensoresModel;

class DashBoardController extends BaseController{
    public function index(){
        return view('sistema/dashboard/usuario/index');
    }
}