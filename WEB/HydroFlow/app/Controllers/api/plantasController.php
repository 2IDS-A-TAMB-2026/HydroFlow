<?php
namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;

class PlantasController extends ResourceController{
    protected $modelName = 'App\\Models\\PlantaModel';
    protected $format = "json";

    public function index(){
            return $this->respond($this->model->findAll());
        }

        public function show($id = null){
            $planta = $this->model->find($id);

            if ($planta === null){
                return $this->failNotFound("Planta não encontrada");
            }

            return $this->respond($planta);
        }
}
?>