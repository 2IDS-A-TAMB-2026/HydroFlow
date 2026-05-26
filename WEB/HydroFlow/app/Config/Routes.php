<?php

$routes->get('/', 'Home::index');

$routes->get('login', 'Home::irParaLoginUsu');
$routes->post('login/autenticar', 'AuthController::autenticar');
$routes->get('login_adm', 'Home::irParaLoginadm');

$routes->get('cadastro', 'Home::irParaCadastro');

$routes->get('sobre', 'Home::irParaSobre'); 
// DASHBOARD
$routes->get('dashboard', 'DashBoardController::index');


//ADM
$routes->group('adm', function($routes) {
    $routes->get('/', 'AdmController::index');                                       // index
    $routes->get('usuarios', 'AdmController::listaUsuarios');                       // lista de usuários
    $routes->get('usuarios/gerenciar/(:num)', 'AdmController::gerenciarUsuario/$1'); // gerenciar usuário
    $routes->get('usuarios/editar-perfil', 'AdmController::editarPerfil');          // editar perfil
    $routes->get('sensor/cadastro', 'AdmController::cadastroSensor');               // cadastro de sensor
});


// DADOS SENSORES 
$routes->group('dados-sensores', function($routes) {
    $routes->get('/', 'Dados_SensoresController::index');                           // index
    $routes->get('ativacoes', 'Dados_SensoresController::listagemAtivacoes');        // listagem de ativações
});


// DISPOSITIVOS
$routes->group('dispositivos', function($routes) {
    $routes->get('/', 'DispositivoController::index');                              // index
    $routes->get('listagem', 'DispositivoController::listagemDispositivos');        // listagem de dispositivos
    $routes->get('gerenciamento', 'DispositivoController::gerenciamento');          // gerenciamento
    $routes->get('novo', 'DispositivoController::novo');                            // novo
    $routes->post('salvar', 'DispositivoController::salvar');                       // processar cadastro
});


//PLANTA
$routes->group('plantas', function($routes) {
    $routes->get('/', 'PlantaController::index');                                   // index
    $routes->get('novo', 'PlantaController::novo');                                 // formulário novo
    $routes->post('salvar', 'PlantaController::salvar');                            // processar cadastro
    $routes->get('editar/(:num)', 'PlantaController::editar/$1');                   // formulário editar
    $routes->post('atualizar/(:num)', 'PlantaController::atualizar/$1');           // processar edição
    $routes->get('detalhes/(:num)', 'PlantaController::detalhes/$1');               // detalhes da planta
});


// SENSOR
$routes->group('sensores', function($routes) {
    $routes->get('/', 'SensorController::index');                                   // index
    $routes->get('novo', 'SensorController::novo');                                 // formulário novo
    $routes->post('salvar', 'SensorController::salvar');                            // processar cadastro
    $routes->get('editar/(:num)', 'SensorController::editar/$1');                   // formulário editar
    $routes->post('atualizar/(:num)', 'SensorController::atualizar/$1');           // processar edição
});


// USUÁRIO
$routes->group('perfil', function($routes) {
    $routes->get('/', 'UsuarioController::index');                                  // index
    $routes->get('editar', 'UsuarioController::editar');                            // editar perfil
    $routes->post('atualizar', 'UsuarioController::atualizar');                     // processar edição
    $routes->get('alterar-senha', 'UsuarioController::alterarSenha');               // alterar senha
    $routes->post('salvar-senha', 'UsuarioController::salvarSenha');               // processar nova senha
});
