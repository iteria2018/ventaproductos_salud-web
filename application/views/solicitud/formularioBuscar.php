<form id="formBusqueda" name="formBusqueda" method="post">   
<div class="row">
    <div class="col-sm-6">
        <label>Número de solicitud</label>
        <input type="text" id="txtNumeroSolicitud" name="txtNumeroSolicitud" class="form-control campo-vd" maxlength="10" value="">
    </div>
    <div class="col-sm-6">
        <label>Estado</label>
        <select id="cmbEstado" name="cmbEstado" class="form-control lista-vd">
            <option value="-1">Seleccione estado</option>
            <?php for ($i = 0; $i < count($estados); $i++): ?>
                <option value="<?php echo $estados[$i]['COD_ESTADO']; ?>">
                    <?php echo $estados[$i]['DES_ESTADO']; ?>
                </option>
            <?php endfor;?>
        </select>
    </div>
    
</div>
<div class="row">
    <div class="col-sm-6">
        <label>Fecha Inicial</label>
        <input type="text" id="txtFechaInicial" name="txtFechaInicial" class="form-control campo-vd" maxlength="10" value="">
    </div>
    <div class="col-sm-6">
        <label>Fecha Final</label>
        <input type="text" id="txtFechaFinal" name="txtFechaFinal" class="form-control campo-vd" maxlength="10" value="">
    </div>
</div>
<div class="row pull-right">
    <div class="col-md-12">
        <br>
        <button id="consultarSolicitudes" class="btn btn-primary boton-vd" type="button">
            <i class="fa fa-search" aria-hidden="true"></i> &nbsp; Consultar
        </button>
        <br>
        <br>
    </div> 
</div>
</form>