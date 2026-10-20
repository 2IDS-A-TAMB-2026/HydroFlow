<?php
namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;

class historicoController extends ResourceController {
    protected $modelName = 'App\\Models\\HistoricoIrrigacaoModel';
    protected $format    = 'json';

   public function index()
{
    try {

        $idUsuarioLogado = $this->request->getGet('usuario_id');

        if (!$idUsuarioLogado) {
            return $this->failValidationErrors(
                'ID do usuário não informado.'
            );
        }

        $filtros = [
            'data_inicial' => $this->request->getGet('data_inicial'),
            'data_final' => $this->request->getGet('data_final'),
            'setor_filtro' => $this->request->getGet('setor_filtro'),
            'status_filtro' => $this->request->getGet('status_filtro'),
        ];

        $dados = $this->model->getHistoricoCompleto(
            $idUsuarioLogado,
            $filtros
        );

        return $this->respond($dados);

    } catch (\Throwable $e) {

        return $this->failServerError(
            $e->getMessage()
        );
    }
}

    public function show($id = null) {
        $historico = $this->model->find($id);

        if ($historico === null) {
            return $this->failNotFound("Irrigação não encontrada");
        }

        return $this->respond($historico);
    }
}
?>