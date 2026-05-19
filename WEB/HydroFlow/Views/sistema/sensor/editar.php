<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-header bg-warning text-dark">
                    <h4 class="mb-0">✏️ Editar Sensor: <?= esc($sensor['SEN_NOME']) ?></h4>
                </div>
                <div class="card-body">
                    <form action="<?= base_url('sensores/atualizar/' . $sensor['SEN_ID']) ?>" method="post">
                        <?= csrf_field() ?>

                        <div class="mb-3">
                            <label for="SEN_NOME" class="form-label">Nome do Sensor</label>
                            <input type="text" class="form-control" id="SEN_NOME" name="SEN_NOME" value="<?= esc($sensor['SEN_NOME']) ?>" maxlength="50" required>
                        </div>

                        <div class="mb-3">
                            <label for="SEN_TIPO" class="form-label">Tipo / Grandeza Medida</label>
                            <input type="text" class="form-control" id="SEN_TIPO" name="SEN_TIPO" value="<?= esc($sensor['SEN_TIPO']) ?>" maxlength="30" required>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="FK_DIS_ID" class="form-label">ID do Dispositivo (Placa)</label>
                                <input type="number" class="form-control" id="FK_DIS_ID" name="FK_DIS_ID" value="<?= esc($sensor['FK_DIS_ID']) ?>" required>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="SEN_STATUS" class="form-label">Status do Sensor</label>
                                <select class="form-select" id="SEN_STATUS" name="SEN_STATUS">
                                    <option value="ATIVO" <?= ($sensor['SEN_STATUS'] === 'ATIVO') ? 'selected' : '' ?>>ATIVO</option>
                                    <option value="INATIVO" <?= ($sensor['SEN_STATUS'] === 'INATIVO') ? 'selected' : '' ?>>INATIVO</option>
                                </select>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-3">
                            <a href="<?= base_url('sensores') ?>" class="btn btn-secondary">Voltar</a>
                            <button type="submit" class="btn btn-warning">Salvar Alterações</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>