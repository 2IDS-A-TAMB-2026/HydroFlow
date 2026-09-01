<?php

namespace App\Filters;

use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use CodeIgniter\Filters\FilterInterface;

class Cors implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        // Responde à requisição OPTIONS do navegador
        if ($request->getMethod() === 'options') {
            return service('response')
                ->setStatusCode(200);
        }
    }

    public function after(
        RequestInterface $request,
        ResponseInterface $response,
        $arguments = null
    ) {
        $response
            ->setHeader('Access-Control-Allow-Origin', '*')
            ->setHeader(
                'Access-Control-Allow-Methods',
                'GET, POST, PUT, DELETE, OPTIONS'
            )
            ->setHeader(
                'Access-Control-Allow-Headers',
                'Content-Type, Authorization, X-Requested-With, Accept'
            );

        return $response;
    }
}