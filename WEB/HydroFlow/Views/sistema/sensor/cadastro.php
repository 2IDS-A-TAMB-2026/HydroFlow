<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">🔌 Cadastrar Novo Sensor</h4>
                </div>
                <div class="card-body">
                    <form action="<?= base_url('sensores/salvar') ?>" method="post">
                        <?= csrf_field() ?>

                        <div class="mb-3">
                            <label for="SEN_NOME" class="form-label">Nome do Sensor</label>
                            <input type="text" class="form-control" id="SEN_NOME" name="SEN_NOME" maxlength="50" required placeholder="Ex: Sensor de Solo Umidade A1">
                        </div>

                        <div class="mb-3">
                            <label for="SEN_TIPO" class="form-label">Tipo / Grandeza Medida</label>
                            <input type="text" class="form-control" id="SEN_TIPO" name="SEN_TIPO" maxlength="30" required placeholder="Ex: Temperatura, Umidade, LDR">
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="FK_DIS_ID" class="form-label">ID do Dispositivo (Placa)</label>
                                <input type="number" class="form-control" id="FK_DIS_ID" name="FK_DIS_ID" required placeholder="Ex: 1">
                                <div class="form-text">O ID da placa cadastrada no sistema.</div>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="SEN_STATUS" class="form-label">Status Inicial</label>
                                <select class="form-select" id="SEN_STATUS" name="SEN_STATUS">
                                    <option value="ATIVO" selected>ATIVO</option>
                                    <option value="INATIVO">INATIVO</option>
                                </select>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-3">
                            <a href="<?= base_url('sensores') ?>" class="btn btn-secondary">Cancelar</a>
                            <button type="submit" class="btn btn-primary">Cadastrar Hardware</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>