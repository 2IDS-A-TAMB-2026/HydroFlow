<?php
namespace App\Controllers\api;

use CodeIgniter\RESTful\ResourceController;

/**
 * Controller API
 * Retorna JSON ao inves de HTML
 */
class dadosSensoresController extends ResourceController
{
    protected $modelName = 'App\\Models\\DadosSensoresModel';
    protected $format = 'json';

    public function index()
    {
        return $this->respond($this->model->findAll());
    }

    public function show($id = null)
    {
        $medida_sensor = $this->model->find($id);

        if ($medida_sensor === null) {
            return $this->failNotFound('Medidas dos Sensores nao encontradas');
        }

        return $this->respond($medida_sensor);
    }

    public function create()
    {
        $dados = $this->request->getJSON(true);

        if (! is_array($dados) || $dados === []) {
            $dados = $this->request->getPost();
        }

        $dados = array_intersect_key($dados, array_flip([
            'DDS_TEMP', 'DDS_UMIDADE', 'DDS_UMIDADE_SOLO', 'FK_SEN_ID'
        ]));

        if (   /* empty($dados['DDS_HORA']) 
            ||  empty($dados['DDS_DATA'] */
             ! isset($dados['DDS_TEMP'])
            ||  ! isset($dados['DDS_UMIDADE'])
            ||  ! isset($dados['DDS_UMIDADE_SOLO'])
            ||  empty($dados['FK_SEN_ID'])) {
            return $this->failValidationErrors('existem dados obrigatorios não preenchidos!');
        }

        $id = $this->model->insert($dados);

        if ($id === false) {
            return $this->failValidationErrors($this->model->errors());
        }

        $medida_sensor = $this->model->find($id);

        return $this->respondCreated($medida_sensor);
    }

    public function update($id = null)
    {
        $medida_sensor = $this->model->find($id);

        if ($medida_sensor === null) {
            return $this->failNotFound('Medidas dos Sensores nao encontradas');
        }

        $dados = $this->request->getJSON(true);

        if (! is_array($dados) || $dados === []) {
            $dados = $this->request->getRawInput();
        }

        $dados = array_intersect_key($dados, array_flip([
            'DDS_TEMP', 'DDS_UMIDADE', 'DDS_UMIDADE_SOLO', 'FK_SEN_ID'
        ]));

        if (empty($dados)) {
            return $this->failValidationErrors('nenhum dado valido foi enviado para atualizacao!');
        }

        if (! $this->model->update($id, $dados)) {
            return $this->failValidationErrors($this->model->errors());
        }

        $medida_sensor = $this->model->find($id);

        return $this->respond($medida_sensor);
    }

    public function delete($id = null)
    {
        $medida_sensor = $this->model->find($id);

        if ($medida_sensor === null) {
            return $this->failNotFound('Medidas dos Sensores nao encontradas');
        }

        if (! $this->model->delete($id)) {
            return $this->failValidationErrors($this->model->errors());
        }

        return $this->respondDeleted($medida_sensor);
    }
}