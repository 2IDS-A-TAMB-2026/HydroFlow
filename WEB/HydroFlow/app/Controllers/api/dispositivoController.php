<?php

namespace App\Controllers\Api;

use App\Controllers\BaseController;
use App\Models\DispositivoModel;
use CodeIgniter\API\ResponseTrait;

class DispositivoController extends BaseController
{
    use ResponseTrait;

    protected $dispositivoModel;

    public function __construct()
    {
        $this->dispositivoModel = new DispositivoModel();
    }

    /**
     * GET /api/dispositivos
     * Listagem geral (admin) com os mesmos filtros da tela web: busca, dono_id, status_filtro
     */
    public function index()
    {
        $busca         = $this->request->getGet('busca');
        $donoId        = $this->request->getGet('dono_id') ?? 'todos';
        $statusFiltro  = $this->request->getGet('status_filtro') ?? 'todos';

        $query = $this->dispositivoModel;

        if (!empty($busca)) {
            $query = $query->groupStart()
                           ->like('DIS_NOME', $busca)
                           ->orLike('DIS_DESCRICAO', $busca)
                           ->groupEnd();
        }

        if ($donoId !== 'todos') {
            $query = $query->where('FK_USU_ID', $donoId);
        }

        if ($statusFiltro !== 'todos') {
            $query = $query->where('DIS_STATUS', $statusFiltro);
        }

        $dispositivos = $query->getDispositivoComDono()->findAll();

        return $this->respond([
            'status' => true,
            'total'  => count($dispositivos),
            'data'   => $dispositivos,
        ]);
    }

    /**
     * GET /api/dispositivos/meus
     * Dispositivos vinculados ao usuário logado (sessão), com join em SENSOR
     * e filtros de busca/status/nivel — equivalente ao meusDispositivos() da tela web.
     */
    public function meus()
    {
        if (!session()->get('logado') && !session()->get('id')) {
            return $this->failUnauthorized('Acesso restrito. Faça login para continuar.');
        }

        $usuarioId = session()->get('id') ?? session()->get('id_usuario') ?? session()->get('USU_ID');

        $busca  = $this->request->getGet('busca');
        $status = $this->request->getGet('status');
        $nivel  = $this->request->getGet('nivel');

        $query = $this->dispositivoModel
                      ->select('DISPOSITIVO.*, SENSOR.SEN_NOME as sensor_nome, SENSOR.SEN_TIPO as sensor_tipo, SENSOR.SEN_STATUS as sensor_status')
                      ->join('SENSOR', 'SENSOR.FK_DIS_ID = DISPOSITIVO.DIS_ID', 'left')
                      ->where('DISPOSITIVO.FK_USU_ID', $usuarioId);

        if (!empty($busca)) {
            $query = $query->groupStart()
                           ->like('DISPOSITIVO.DIS_NOME', $busca)
                           ->orLike('DISPOSITIVO.DIS_DESCRICAO', $busca)
                           ->groupEnd();
        }

        if (!empty($status)) {
            $query = $query->where('DISPOSITIVO.DIS_STATUS', strtoupper($status));
        }

        if (!empty($nivel)) {
            if ($nivel === 'critico') {
                $query = $query->where('DISPOSITIVO.DIS_NIVEL_TANQUE <', 30);
            } elseif ($nivel === 'alerta') {
                $query = $query->where('DISPOSITIVO.DIS_NIVEL_TANQUE >=', 30)
                                ->where('DISPOSITIVO.DIS_NIVEL_TANQUE <=', 50);
            } elseif ($nivel === 'ideal') {
                $query = $query->where('DISPOSITIVO.DIS_NIVEL_TANQUE >', 50);
            }
        }

        $dispositivos = $query->findAll();

        return $this->respond([
            'status' => true,
            'total'  => count($dispositivos),
            'data'   => $dispositivos,
        ]);
    }

    /**
     * GET /api/dispositivos/(:num)
     * Detalhe de um dispositivo específico
     */
    public function show($id = null)
    {
        $dispositivo = $this->dispositivoModel->getDispositivoComDono($id);

        if (!$dispositivo) {
            return $this->failNotFound('Dispositivo não encontrado.');
        }

        return $this->respond([
            'status' => true,
            'data'   => $dispositivo,
        ]);
    }

    /**
     * POST /api/dispositivos
     * Cria um novo dispositivo
     */
    public function create()
    {
        $dados = $this->request->getJSON(true) ?? $this->request->getPost();
        unset($dados['csrf_test_name']);

        if (empty($dados)) {
            return $this->fail('Nenhum dado enviado.', 400);
        }

        if (!$this->dispositivoModel->save($dados)) {
            return $this->failValidationErrors($this->dispositivoModel->errors());
        }

        $id = $this->dispositivoModel->getInsertID();

        return $this->respondCreated([
            'status'  => true,
            'mensagem' => 'Dispositivo cadastrado com sucesso!',
            'data'    => $this->dispositivoModel->find($id),
        ]);
    }

    /**
     * PUT/PATCH /api/dispositivos/(:num)
     * Atualiza um dispositivo existente
     */
    public function update($id = null)
    {
        $registroAtual = $this->dispositivoModel->find($id);

        if (!$registroAtual) {
            return $this->failNotFound('Dispositivo não encontrado.');
        }

        $dados = $this->request->getJSON(true) ?? $this->request->getRawInput();
        unset($dados['csrf_test_name']);

        if (empty($dados)) {
            return $this->fail('Nenhum dado enviado para atualização.', 400);
        }

        // Verifica se houve alteração real, evitando erro "There is no data to update"
        $alterado = false;
        foreach ($dados as $key => $value) {
            if (array_key_exists($key, $registroAtual) && (string) $registroAtual[$key] !== (string) $value) {
                $alterado = true;
                break;
            }
        }

        if (!$alterado) {
            return $this->respond([
                'status'   => true,
                'mensagem' => 'Nenhuma alteração detectada. Dispositivo mantido como estava.',
                'data'     => $registroAtual,
            ]);
        }

        // Mescla com o registro atual: como as validationRules exigem vários campos (required),
        // um PATCH parcial (ex: só DIS_STATUS) quebraria a validação se não completarmos o restante.
        $dadosCompletos = array_merge($registroAtual, $dados);
        $dadosCompletos['DIS_ID'] = $id;

        if (!$this->dispositivoModel->save($dadosCompletos)) {
            return $this->failValidationErrors($this->dispositivoModel->errors());
        }

        return $this->respond([
            'status'   => true,
            'mensagem' => 'Dispositivo atualizado com sucesso!',
            'data'     => $this->dispositivoModel->find($id),
        ]);
    }

    /**
     * DELETE /api/dispositivos/(:num)
     * Remove definitivamente um dispositivo
     */
    public function delete($id = null)
    {
        $dispositivo = $this->dispositivoModel->find($id);

        if (!$dispositivo) {
            return $this->failNotFound('Dispositivo não encontrado.');
        }

        if (!$this->dispositivoModel->delete($id)) {
            return $this->failServerError('Erro ao tentar excluir o dispositivo.');
        }

        return $this->respondDeleted([
            'status'   => true,
            'mensagem' => 'Dispositivo removido do sistema com sucesso.',
        ]);
    }
}