<div class="container container-micar">
    <div class="row">        
        <div class="col-sm-12 col-md-6 col-lg-3 offset-lg-9 offset-md-3 micar-vd">
            <div> Mi carrito compra </div>
            <div> <label id="lbCantidadProd">(0) Productos </label> <span> <img class="imgcar-vd" src="<?php echo base_url()?>asset/public/images/vd/carrito_compra.png"> </span> </div>
            <div> <label id="lbValProd">Total $ 0</label> </div>
            </span><span class="iva-incluido"> IVA incluido </span>
        </div>
    </div>
</div>

<fieldset>
<legend>Selecciona tus productos</legend>

    <!-- DATOS PRODUCTOS -->
    <?php $this->load->view('datos_productos', array('abr_tab' => '_pro'));?>
    
    <!-- Botones navegacion -->
    <div class="container" div="botones_paso2">
        <div class="row"> 
            <div class="col-sm-4 col-md-12 col-lg-12 text-center">
                <button type="button" class="btn btn-primary boton-vd paginaAnterior" id="_1">
                    <i class="fa fa-angle-left" aria-hidden="true"></i> &nbsp; Atras
                </button>
                <button type="button" class="btn btn-primary boton-vd" id="siguiente_paso2">
                    Siguiente  &nbsp; <i class="fa fa-angle-right" aria-hidden="true"></i> 
                </button>
            </div>
        </div>
    </div>

</fieldset>