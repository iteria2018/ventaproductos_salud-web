
<h3>Registrar pago</h3>	
<fieldset>	
	
	<legend>Informaci&oacute;n contratante</legend>
	<br>
	
	<div class="container">
		<form id="form_pago" name="form_pago">
			<div class="row">
				<div class="col-sm-12 col-md-6 col-lg-3">
					<label class="obligatorio">Tipo de identificaci&oacute;n</label>
					<select id="tipoDocumento_pago" name="tipoDocumento_pago" class="form-control lista-vd">
						<?php echo $opTipoId; ?>
					</select>
				</div>
				<div class="col-sm-12 col-md-6 col-lg-3 ">
					<label class="obligatorio">N&uacute;mero de identificaci&oacute;n</label>
					<input type="text" id="numeroDocumento_pago" name="numeroDocumento_pago" class="form-control campo-vd" maxlength="12" placeholder="" onkeypress="return validar_solonumeros(event);">
				</div>
				<div class="col-sm-12 col-md-6 col-lg-3">
					<label class="obligatorio">Primer nombre</label>
					<input type="text" id="nombre1_pago" name="nombre1_pago" class="form-control campo-vd" maxlength="50" placeholder="">
				</div>
				<div class="col-sm-12 col-md-6 col-lg-3">
					<label class="">Segundo nombre</label>
					<input type="text" id="nombre2_pago" name="nombre2_pago" class="form-control campo-vd" maxlength="50" placeholder="">
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12 col-md-6 col-lg-3">
					<label class="obligatorio">Primer apellido</label>
					<input type="text" id="apellido1_pago" name="apellido1_pago" class="form-control campo-vd" maxlength="50" placeholder="">
				</div>
				<div class="col-sm-12 col-md-6 col-lg-3">
					<label class="">Segundo apellido</label>
					<input type="text" id="apellido2_pago" name="apellido2_pago" class="form-control campo-vd" maxlength="50" placeholder="">
				</div>
				<div class="col-sm-12 col-md-6 col-lg-3">
					<label class="obligatorio">Correo</label>
					<input type="text" id="correo_pago" name="correo_pago" class="form-control campo-vd" maxlength="12" placeholder="">
				</div>
				<div class="col-sm-12 col-md-6 col-lg-3">
					<label class="obligatorio">Tel&eacute;fono</label>
					<input type="text" id="telefono_pago" name="telefono_pago" class="form-control campo-vd" maxlength="12" placeholder="">
				</div>
				
			</div>
			<div class="row">
				<div class="col-sm-12 col-md-3 col-lg-3">
					<label class="obligatorio">Tipo de pago</label>
					<select id="tipoTipoPago" name="tipoTipoPago" class="form-control lista-vd">
						<?php echo $opTipoPago; ?>
					</select>        
				</div>        
			</div>    	
		</form>
	</div> 
</fieldset>
<fieldset>	
	
	<legend>Servicios solicitados</legend>
	<br>
	<div class="container">
		<div class="row">
			<div class="col-sm-8 align-self-center" id="contenedor_table_pago">     	
			</div>
			<div class="col-sm-4 align-self-center text-center">   
				<h3>Total a pagar</h3>				
				<label id="label_sum" style="font-size: 20px;">$ 0</label> 
				</span><span class="iva-incluido"> IVA incluido </span>    
			</div>
		</div>
	</div>
	
</fieldset>
<br>
<div class="container">
	<div class="row">
		<div class="col-sm-12 text-right">
			<button type="button" class="btn btn-primary boton-vd paginaAnterior" id="_3"> 
				<i class="fa fa-angle-left" aria-hidden="true"></i> &nbsp; Atras
			</button>				
			<button type="button" class="btn btn-primary boton-vd" id="btn_pago"> 
				Pagar
			</button>
		</div>   
	</div>
</div>
<br>
<div class="container" id="container_formulario">	
</div>