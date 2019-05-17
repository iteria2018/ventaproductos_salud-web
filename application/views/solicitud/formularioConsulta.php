<form id="formBusqueda" name="formBusqueda" method="post">   
<div class="row">
    <div class="col-sm-6">
        <label>Número de solicitud</label>
        <input type="text" id="txtNumeroSolicitud" name="txtNumeroSolicitud" class="form-control campo-vd" maxlength="10" value="" onkeypress="return validar_solonumeros(event);">
    </div>
    <div class="col-sm-6">
        <label>Estado</label>
        <select id="cmbEstado" name="cmbEstado" class="form-control lista-vd">
            <option value="">Seleccione estado</option>
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
        <label>Fecha Inicial radicaci&oacute;n</label>  
        <input type="text" id="txtFecRadicaIni" name="txtFecRadicaIni" class="form-control campo-vd" maxlength="10" value="" >
    </div>
    <div class="col-sm-6">
        <label>Fecha Final radicaci&oacute;n</label>
        <input type="text" id="txtFecRadicaFin" name="txtFecRadicaFin" class="form-control campo-vd" maxlength="10" value="" >
    </div>
</div>
<div class="row">
    <div class="col-sm-6">
        <label>Fecha Inicial gesti&oacute;n</label>
        <input type="text" id="txtFecGestionIni" name="txtFecGestionIni" class="form-control campo-vd" maxlength="10" value="" >
    </div>
    <div class="col-sm-6">
        <label>Fecha Final gesti&oacute;n</label>
        <input type="text" id="txtFecGestionFin" name="txtFecGestionFin" class="form-control campo-vd" maxlength="10" value="" >
    </div>
</div>
<div class="row pull-right">
    <div class="col-md-12">
        <br>
        <button id="buscarSolicitudes" class="btn btn-primary boton-vd" type="button">
            <i class="fa fa-search" aria-hidden="true"></i> &nbsp; Consultar
        </button>
        <br>
        <br>
    </div> 
</div>
</form>