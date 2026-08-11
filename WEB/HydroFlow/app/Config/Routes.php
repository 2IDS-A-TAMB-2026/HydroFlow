<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */

// ==========================================
//  ROTAS PÚBLICAS / INSTITUCIONAIS
// ==========================================
$routes->get('/', 'Home::index');
$routes->get('index', 'Home::index');
$routes->get('sobre', 'Home::irParaSobre');
$routes->get('cadastro', 'Home::irParaCadastro');
$routes->post('cadastro/salvar', 'UsuarioController::salvar');

// API (Em andamento fiott)
$routes->get('/api/usuarios', 'api\usuarioController::index');
$routes->get('/api/usuarios/(:num)', 'api\usuarioController::show/$1');
$routes->get('/api/plantas', 'api\plantasController::index');
$routes->get('/api/plantas/(:num)', 'api\plantasController::show/$1');
$routes->get('/api/historico', 'api\historicoController::index');
$routes->get('/api/historico/(:num)', 'api\historicoController::show/$1');

$routes->get('/api/dados_sensores', 'api\dadosSensoresController::index');
$routes->get('/api/dados_sensores/(:num)', 'api\dadosSensoresController::show/$1');
$routes->post('/api/dados_sensores', 'api\dadosSensoresController::create');
$routes->put('/api/dados_sensores/(:num)', 'api\dadosSensoresController::update/$1');
$routes->patch('/api/dados_sensores/(:num)', 'api\dadosSensoresController::update/$1');
$routes->delete('/api/dados_sensores/(:num)', 'api\dadosSensoresController::delete/$1');

$routes->group('api/dispositivos', function ($routes) {
    $routes->get('/', 'Api\DispositivoController::index');
    $routes->get('meus', 'Api\DispositivoController::meus');
    $routes->get('(:num)', 'Api\DispositivoController::show/$1');
    $routes->post('/', 'Api\DispositivoController::create');
    $routes->put('(:num)', 'Api\DispositivoController::update/$1');
    $routes->patch('(:num)', 'Api\DispositivoController::update/$1');
    $routes->delete('(:num)', 'Api\DispositivoController::delete/$1');
});

// ==========================================
//  SISTEMA DE AUTENTICAÇÃO (LOGIN / LOGOUT)
// ==========================================
// Autenticação de Usuários Comuns
$routes->get('login', 'Home::irParaLoginUsu');
$routes->post('login/autenticar', 'AuthController::autenticar');
$routes->get('logout', 'AuthController::logout');

// Autenticação de Administradores (ADM)
$routes->get('admin/login', 'Home::irParaLoginadm'); 
$routes->post('admin/auth/autenticar', 'AdmAuthController::autenticar');
$routes->get('logout_adm', 'AuthController::logout');

// ==========================================
//  ÁREA LOGADA: USUÁRIO COMUM & OPERADOR
// ==========================================
$routes->get('dashboard', 'DashBoardController::index');
//$routes->get('agendamentos', 'DashBoardController::agendamentos'); // CORRIGIDO: Plural para bater com o menu lateral
$routes->get('historico', 'HistoricoController::index');

$routes->get('dados_sensores', 'Dados_SensoresController::index');

$routes->get('meus-dispositivos', 'DispositivoController::meusDispositivos');

// Módulo: Perfil do Usuário
$routes->group('perfil', ['filter' => 'auth'], function($routes) {
    $routes->get('/', 'UsuarioController::index');
    $routes->get('dashboard', 'DashBoardController::index');
    $routes->get('editar', 'UsuarioController::editar');
    $routes->post('atualizar', 'UsuarioController::atualizar');
    $routes->get('alterar-senha', 'UsuarioController::alterarSenha');
    $routes->post('salvar-senha', 'UsuarioController::salvarSenha');
});

// Módulo: Plantas
$routes->group('planta', ['filter' => 'auth'], function($routes) {
    $routes->get('/', 'PlantaController::index');
    $routes->get('novo', 'PlantaController::novo');
    $routes->post('salvar', 'PlantaController::salvar');
    $routes->get('detalhes/(:num)', 'PlantaController::detalhes/$1');
    $routes->get('editar/(:num)', 'PlantaController::editar/$1'); // Reaproveita a função "novo" para mostrar o formulário de edição
    $routes->post('atualizar/(:num)', 'PlantaController::atualizar/$1');
    $routes->get('excluir/(:num)', 'PlantaController::excluir/$1');
});



// Módulo: Dados dos Sensores (Leituras de Telemetria)
$routes->group('dados-sensores', ['filter' => 'auth'], function($routes) {
    $routes->get('/', 'Dados_SensoresController::index'); // CORRIGIDO: Removido o "s" duplo digitado errado
});

// ==========================================
//  ÁREA LOGADA EXCLUSIVA: RESTRITA AO ADM
// ==========================================
$routes->group('admin', ['filter' => 'auth'], function($routes) {
    // URL: localhost/admin ou localhost/admin/dashboard -> Abre o Dashboard Geral do Admin
    $routes->get('/', 'AdmController::index');
    $routes->get('dashboard', 'AdmController::index');
    
    // MODO 1 (Listagem): URL: localhost/admin/usuarios -> Mostra a tabela com todos
    $routes->get('usuarios', 'AdmController::gerenciarUsuarios'); 
    
    $routes->get('usuarios/(:num)', 'AdmController::editarUsuario/$1');
    $routes->post('usuarios/(:num)', 'AdmController::atualizarUsuario/$1');
    
    // Outras rotas do escopo de admin
    $routes->get('usuarios/editar-perfil', 'AdmController::editarPerfil');
    $routes->get('excluirUsuario/(:num)', 'AdmController::excluirUsuario/$1');
    
    // ============================================================
    // ROTA ADICIONADA: Resolve o erro 404 do botão "Perfil" do ADM
    // ============================================================
    $routes->get('perfil', 'AdmController::editarPerfil');
    $routes->post('perfil/salvar', 'AdmController::salvarPerfil');

    // Módulo: Dispositivos
    $routes->group('dispositivos', ['filter' => 'auth'], function($routes) {
    $routes->get('/', 'DispositivoController::index');
    $routes->get('listagem', 'DispositivoController::listagemDispositivos');
    $routes->get('gerenciamento', 'DispositivoController::gerenciamento');
    
    // CORRIGIDO: Agora aceita tanto "novo" quanto "novo/38" de forma opcional
    $routes->get('novo', 'DispositivoController::cadastrarDispositivo');
    $routes->get('novo/(:num)', 'DispositivoController::cadastrarDispositivo/$1');
    
    $routes->get('excluir/(:num)', 'DispositivoController::excluir/$1');
    $routes->post('salvar', 'DispositivoController::salvar'); 


    });
    // Módulo: Sensores (Visualização e Edição Geral)
        $routes->group('sensores', ['filter' => 'auth'], function($routes) {
        $routes->get('/', 'SensorController::index');
        $routes->get('novo', 'SensorController::novo');
        $routes->post('salvar', 'SensorController::salvar');
        $routes->get('editar/(:num)', 'SensorController::editar/$1');
        $routes->post('atualizar/(:num)', 'SensorController::atualizar/$1');
        $routes->post('salvar-duplo', 'SensorController::salvarDuplo');
        $routes->get('excluir/(:num)', 'SensorController::excluir/$1');
    });
});