<!-- DATOS CONTRATANTE -->
<?php $this->load->view('datos_contratante', array('abr_tab' => '_cot', 'bloquea' => 'SI'));?>

<div class="container">
	<div class="row text-center">
		<div class="col-md-6">
			<h3>Diligencia la siguiente informaci&oacute;n:</h3>
			<button id="btn_encuesta" class="btn btn-primary boton-vd" type="button" >
				<i class="fa fa-check-square-o" aria-hidden="true"></i> &nbsp; Encuesta SARLAFT
			</button>
		</div>
		<div class="col-md-6 align-self-end">			
			<button id="btn_cotizacion" class="btn btn-primary boton-vd" type="button" >
				<i class="fa fa-file-pdf-o" aria-hidden="true"></i> &nbsp; Ver Cotización
			</button>
		</div>
	</div>
</div>

<!-- DATOS BENEFICIARIOS -->
<?php $this->load->view('datos_beneficiarios', array('abr_tab' => '_cot'));?>

<!-- Botones navegacion -->
<div class="container">
	<div class="row"> 
		<div class="col-sm-4 col-md-12 col-lg-12 text-center">
			<button type="button" class="btn btn-primary boton-vd paginaAnterior" id="_2">
				<i class="fa fa-angle-left" aria-hidden="true"></i> &nbsp; Atras
			</button>
			<button type="button" class="btn btn-primary boton-vd" id="guardaCotizacion">
			 	Siguiente  &nbsp; <i class="fa fa-angle-right" aria-hidden="true"></i> 
			</button>
		</div>
	</div>
</div>