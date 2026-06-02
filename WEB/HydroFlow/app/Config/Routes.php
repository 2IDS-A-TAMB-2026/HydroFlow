<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */

// ==========================================
//  ROTAS PÚBLICAS / INSTITUCIONAIS
// ==========================================
$routes->get('/', 'Home::index');
$routes->get('sobre', 'Home::irParaSobre');
$routes->get('cadastro', 'Home::irParaCadastro');

// ==========================================
//  SISTEMA DE AUTENTICAÇÃO (LOGIN / LOGOUT)
// ==========================================
// Autenticação de Usuários Comuns
$routes->get('login', 'Home::irParaLoginUsu');
$routes->post('login/autenticar', 'AuthController::autenticar');

// Autenticação de Administradores (ADM)
$routes->get('admin/login', 'Home::irParaLoginadm'); // URL padronizada com o filtro
$routes->post('admin/auth/autenticar', 'AdmAuthController::autenticar');

// ==========================================
//  ÁREA LOGADA: USUÁRIO COMUM & OPERADOR
// ==========================================
$routes->get('dashboard', 'DashBoardController::index');
$routes->get('agendamento', 'DashBoardController::agendamentos');
$routes->get('historico', 'HistoricoController::index');

// Módulo: Perfil do Usuário
$routes->group('perfil', function($routes) {
    $routes->get('/', 'UsuarioController::index');
    $routes->get('dashboard', 'DashBoardController::index');
    $routes->get('editar', 'UsuarioController::editar');
    $routes->post('atualizar', 'UsuarioController::atualizar');
    $routes->get('alterar-senha', 'UsuarioController::alterarSenha');
    $routes->post('salvar-senha', 'UsuarioController::salvarSenha');
});

// Módulo: Dispositivos
$routes->group('dispositivos', function($routes) {
    $routes->get('/', 'DispositivoController::index');
    $routes->get('listagem', 'DispositivoController::listagemDispositivos');
    $routes->get('gerenciamento', 'DispositivoController::gerenciamento');
    $routes->get('novo', 'DispositivoController::novo');
    $routes->post('salvar', 'DispositivoController::salvar');
});

// Módulo: Plantas
$routes->group('planta', function($routes) {
    $routes->get('/', 'PlantaController::index');
    $routes->get('novo', 'PlantaController::novo');
    $routes->post('salvar', 'PlantaController::salvar');
    $routes->get('detalhes/(:num)', 'PlantaController::detalhes/$1');
    $routes->get('editar/(:num)', 'PlantaController::editar/$1');
    $routes->post('atualizar/(:num)', 'PlantaController::atualizar/$1');
    $routes->get('excluir/(:num)', 'PlantaController::excluir/$1');
});

// Módulo: Sensores (Visualização e Edição Geral)
$routes->group('sensores', function($routes) {
    $routes->get('/', 'SensorController::index');
    $routes->get('novo', 'SensorController::novo');
    $routes->post('salvar', 'SensorController::salvar');
    $routes->get('editar/(:num)', 'SensorController::editar/$1');
    $routes->post('atualizar/(:num)', 'SensorController::atualizar/$1');
});

// Módulo: Dados dos Sensores (Leituras de Telemetria)
$routes->group('dados-sensores', function($routes) {
    $routes->get('/', 'Dados_SenssoresController::index');
});

// ==========================================
//  ÁREA LOGADA EXCLUSIVA: RESTRITA AO ADM
// ==========================================
// Protegido pelo prefixo 'admin' mapeado no seu AuthFilter
$routes->group('admin', function($routes) {
    $routes->get('/', 'AdmController::index');
    $routes->get('usuarios', 'AdmController::listaUsuarios');
    $routes->get('usuarios/gerenciar/(:num)', 'AdmController::gerenciarUsuario/$1');
    $routes->get('usuarios/editar-perfil', 'AdmController::editarPerfil');
    $routes->get('sensor/cadastro', 'AdmController::cadastroSensor');
});