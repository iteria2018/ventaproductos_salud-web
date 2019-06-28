<!-- DATOS CONTRATANTE -->
<input type="hidden" id="txtcodAfiliacion" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['COD_AFILIACION'] ?>" readonly>
<fieldset> 
	
	<br>
	<div class="container" id="divContratante">
	<legend> Informaci&oacute;n domilcilio</legend>
		<div class="row">			
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Tipo vía</label>
				<input type="text" id="txtTipoVia" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['ABR_TIPO_VIA'] ?>" disabled>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Número</label>
				<input type="text" id="txtNumero" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['DIR_NUM_VIA'] ?>" disabled>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Número de Placa</label>
				<input type="text" id="txtNroPlaca" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['DIR_NUM_PLACA'] ?>" disabled>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Complemento</label>
				<input type="text" id="txtComplemento" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['DIR_COMPLEMENTO'] ?>" disabled>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>País</label>
				<input type="text" id="txtPais" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['PAIS'] ?>" disabled>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-2">
				<label>Fecha de radicación</label>
				<input type="text" id="txtFechaRadicacion" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['FECHA_RADICACION'] ?>" disabled>
			</div>
		</div>
		<div class="row">						
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Municipio</label>
				<input type="text" id="txtMunicipio" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['COD_MUNICIPIO'] ?>" disabled>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Barrio</label>
				<input type="text" id="txtBarrio" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['BARRIO'] ?>" disabled>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Código DANE</label>
				<input type="text" id="txtCodigoDane" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['CODIGO_DANE'] ?>" disabled>
			</div>	
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Código Cobertura</label>
				<input type="text" id="txtCodigoCobertura" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['COD_DIRECCION'] ?>" disabled>
			</div>	
		</div><br>		
		<legend> E-mail</legend>
		<div class="row">
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Email</label>
				<input type="text" id="txtEmail" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['EMAIL'] ?>" disabled>
			</div>	
		</div><br>
		<legend> Informaci&oacute;n del contratante </legend>
		<div class="row">
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Tipo Documento</label>
				<input type="text" id="txtTipoDocumento" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['TIPO_IDENTIFICACION'] ?>" disabled>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Número Documento</label>
				<input type="text" id="txtNroDocumento" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['NUMERO_IDENTIFICACION'] ?>" disabled>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-2">
				<label>Primer Apellido</label>
				<input type="text" id="txtPrimerApellido" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['APELLIDO_1'] ?>" disabled>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-2">
				<label>Segundo Apellido</label>
				<input type="text" id="txtSegundoApellido" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['APELLIDO_2'] ?>" disabled>
			</div>	
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Primer Nombre</label>
				<input type="text" id="txtPrimerNombre" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['NOMBRE_1'] ?>" disabled>
			</div>	
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Segundo Nombre</label>
				<input type="text" id="txtSegundoNombre" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['NOMBRE_2'] ?>" disabled>
			</div>	
		</div>
		<div class="row">																		
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Fecha Nacimiento</label>
				<input type="text" id="txtFechaNacimiento" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['FECHA_NACIMIENTO'] ?>" disabled>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Estado Civil</label>
				<input type="text" id="txtEstadoCivil" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['ABR_ESTADO_CIVIL'] ?>" disabled>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Género</label>
				<input type="text" id="txtGenero" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['GENERO'] ?>" disabled>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Nacionalidad</label>
				<input type="text" id="txtNacionalidad" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['NACIONALIDAD'] ?>" disabled>
			</div>
			
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>EPS</label>
				<input type="text" id="txtEps" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['DES_EPS'] ?>" disabled>
			</div>	
			<div class="col-sm-12 col-md-6 col-lg-2">
			    <label>Tel&eacute;fono Fijo</label>
				<input type="text" id="txtTelefono" class="form-control campo-vd-sm" value="<?php echo $contratante[0]['TELEFONO'] ?>" disabled>
			</div>
		</div>				
		<div class="row">															
			<div class="col-sm-12 col-md-6 col-lg-3 text-center">
			    <label></label><br>
				<button id="btnEncuestaSarlaf" codAfiliacion="<?php echo $contratante[0]['COD_AFILIACION'] ?>" codPersona="<?php echo $contratante[0]['COD_PERSONA'] ?>" class="btn btn-primary boton-vd btn-sm" type="button" >
					<i class="fa fa-check-square-o" aria-hidden="true"></i> &nbsp; Encuesta SARLAFT
				</button>				
			</div>
			<div class="col-sm-12 col-md-6 col-lg-2 text-center">
				<label></label><br>
				<button  id="btnInfoPago" codAfiliacion="<?php echo $contratante[0]['COD_AFILIACION'] ?>" codPersona="<?php echo $contratante[0]['COD_PERSONA'] ?>" class="btn btn-primary boton-vd btn-sm" type="button" >
					<i class="fa fa-credit-card-alt" aria-hidden="true"></i> &nbsp; Informacion de pago
				</button>
			</div>
		</div>				
	</div>	
</fieldset>