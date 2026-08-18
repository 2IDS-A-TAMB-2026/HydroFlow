<?php
namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;

class sensoresController extends ResourceController{
    protected $modelName = 'App\\Models\\SensoresModel';
    protected $format = "json";

    public function index(){
            return $this->respond($this->model->findAll());
        }

        public function show($id = null){
            $sensor = $this->model->find($id);

            if ($sensor === null){
                return $this->failNotFound("Sensor não encontrado");
            }

            return $this->respond($sensor);
        }
}
?>