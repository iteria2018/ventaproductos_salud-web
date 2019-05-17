<div class="row">
    <div class="col-md-12 text-center">
        <div style="background: #dadcdd !important" class="alert alert-primary" role="alert">
            Pago realizado exitosamente
        </div>
    </div>
    <div class="col-md-12 text-center">               
        <button id="btn_cotizacion" class="btn btn-primary boton-vd" type="button" >
                <i class="fa fa-file-pdf-o" aria-hidden="true"></i> &nbsp; Ver Cotización
        </button>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        <h3>Para finalizar tu compra, selecciona los contratos de tus productos y fírmalos</h3>
    </div>
</div>
<br>
<!-- DATOS PRODUCTOS -->
<?php $this->load->view('datos_productos', array('abr_tab' => '_con'));?>

<div class="container">
	<div class="row"> 
		<div class="col-sm-4 col-md-12 col-lg-12 text-center">
			<button type="button" class="btn btn-primary boton-vd" id="btnFinalizarVenta">
                <i class="fa fa-check" aria-hidden="true"></i> &nbsp; Finalizar
			</button>			
		</div>
	</div>
</div>

<hr/>
	

<input type="hidden" id="txtMsgInicioServicio" name="txtMsgInicioServicio" value="" readonly>
<input type="hidden" id="txtCodProgramaFirma" name="txtCodProgramaFirma" value="" readonly>
<input type="hidden" id="txtIdWidget" name="txtIdWidget" value="" readonly>