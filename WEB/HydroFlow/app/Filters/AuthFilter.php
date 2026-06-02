<?php

namespace App\Filters;

use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use CodeIgniter\Filters\FilterInterface;

class AuthFilter implements FilterInterface
{
    /**
     * Filtro responsável por:
     * - Verificar rotas de Administrador (ADM)
     * - Verificar rotas de Usuários Comuns (Operador/Visitante)
     * - Controlar permissões da irrigação
     */
    public function before(RequestInterface $request, $arguments = null)
    {
        // 1. Captura os segmentos da URL atual para saber onde o usuário está tentando entrar
        // service('uri')->getSegment(1) pode retornar nulo na home, usamos "fallback" para evitar erros
        $url1 = service('uri')->getSegment(1) ?? '';
        $url2 = service('uri')->getSegment(2) ?? '';

        // ==========================================
        //  PROTEÇÃO DA ÁREA ADMINISTRATIVA (ADM)
        // ==========================================
        if ($url1 == 'admin' || $url1 == 'adm') {
            // Se tentar acessar rotas de admin e NÃO tiver a sessão de ADM ativa, chuta pro login do admin
            if (!session()->get('logado_adm')) {
                return redirect()->to('/admin/login')->with('erro', 'Acesso restrito a administradores.');
            }
            
            // Se ele for um ADM logado válido, encerra o filtro aqui e dá PERMISSÃO TOTAL para as rotas abaixo
            return; 
        }

        // ==========================================
        //  PROTEÇÃO DA ÁREA DO USUÁRIO COMUM
        // ==========================================
        // Se NÃO estiver tentando acessar o admin, obrigatoriamente precisa do login comum
        if (!session()->get('logado')) {
            return redirect()->to('/login');
        }

        // Pega o tipo de usuário logado na sessão comum
        $tipo = session()->get('usuario_tipo');

        // 4. Regras de Permissão para Operador
        if ($tipo == 'operador') {
            
            // Operador NÃO acessa de forma alguma a área de gerenciamento de usuários comuns ou admin externo
            if ($url1 == 'usuario' || $url1 == 'adm' || $url1 == 'admin') {
                return redirect()->to('/dashboard');
            }

            // Operador pode VER os sensores, mas NÃO pode alterar nada (cadastro, editar, excluir)
            if ($url1 == 'sensor') {
                if (
                    $url2 == 'cadastro' || 
                    $url2 == 'editar'   || 
                    $url2 == 'excluir'  || 
                    $url2 == 'inserir'  || 
                    $url2 == 'novo'
                ) {
                    return redirect()->to('/dashboard');
                }
            }
            
            // Operador NÃO pode alterar as configurações dos dispositivos de fluxo de água
            if ($url1 == 'dispositivos') {
                if ($url2 == 'editar' || $url2 == 'excluir' || $url2 == 'configurar') {
                    return redirect()->to('/dashboard');
                }
            }
        }
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
        // Mantido vazio para pós-processamento
    }
}