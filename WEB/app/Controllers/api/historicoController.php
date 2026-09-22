<?php
namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;

class historicoController extends ResourceController {
    protected $modelName = 'App\\Models\\HistoricoIrrigacaoModel';
    protected $format    = 'json';

    public function index() {
        try {
            // Usa o JOIN correto ajustado para a tabela PLANTA e DISPOSITIVO
            $dados = $this->model
                ->select('HISTORICO_IRRIGACAO.*, PLANTA.PLANTA_NOME as nome_planta, PLANTA.PLANTA_CULTURA as cultura')
                ->join('PLANTA', 'PLANTA.PLANTA_ID = HISTORICO_IRRIGACAO.FK_PLANTA_ID', 'left')
                ->findAll();

            return $this->respond($dados);
        } catch (\Throwable $e) {
            // Em caso de erro, retorna a mensagem em JSON sem quebrar a API
            return $this->failServerError($e->getMessage());
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