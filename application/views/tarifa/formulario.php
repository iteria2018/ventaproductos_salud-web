<form id="formTarifas" name="formTarifas" method="post" enctype="multipart/form-data">   
<input id="txtTipoAccion" name="txtTipoAccion" type="hidden" value="<?php echo $tipoAccion; ?>" readonly>  
<input id="txtCodTarifa" name="txtCodTarifa" type="hidden" value="<?php if (isset($tarifa[0]['COD_TARIFA'])): echo $tarifa[0]['COD_TARIFA']; endif;?>" readonly>
<fieldset> 
	<div class="container" id="divContratante">
    	<div class="row">
			<div class="col-sm-6">
			    <label class="">Código de tarifa</label>
				<input type="text" id="txtCodTarifaMP" name="txtCodTarifaMP" class="form-control campo-vd" maxlength="20" value="<?php if (isset($tarifa[0]['COD_TARIFA_MP'])): echo $tarifa[0]['COD_TARIFA_MP']; endif;?>" <?php if (isset($tarifa[0]['COD_TARIFA_MP'])): echo  "disabled";  endif;?>>
			</div>
			<div class="col-sm-6">
			    <label class="obligatorio">Valor tarifa</label>
				<input type="text" id="txtValorTarifa" name="txtValorTarifa" class="form-control campo-vd" maxlength="15" value="<?php if (isset($tarifa[0]['VALOR'])): echo $tarifa[0]['VALOR']; endif;?>" onkeypress="return validar_solonumeros(event);"  <?php if (isset($tarifa[0]['COD_TARIFA_MP'])): echo  "readonly";  endif;?>>
           	</div>			
		</div>
		<div class="row">
			<div class="col-sm-6">
				<label class="obligatorio">Tipo tarifa</label>
				<select id="cmbTipoTarifa" name="cmbTipoTarifa" class="form-control lista-vd" <?php if (isset($tarifa[0]['COD_TARIFA_MP'])): echo  "disabled";  endif;?>>
				    <option value="">Seleccione tipo tarifa</option>
					<?php for ($i = 0; $i < count($tiposTarifas); $i++): ?>
						<option value="<?php echo $tiposTarifas[$i]['COD_TIPO_TARIFA']; ?>" <?php if (isset($tarifa[0]['COD_TIPO_TARIFA'])): echo $res = ($tarifa[0]['COD_TIPO_TARIFA'] == $tiposTarifas[$i]['COD_TIPO_TARIFA']) ? "selected" : ""; endif; ?>>
							<?php echo $tiposTarifas[$i]['DES_TIPO_TARIFA']; ?>
						</option>
					<?php endfor;?>	
				</select>
			</div>
			<div class="col-sm-6">
                <label class="obligatorio">Plan</label>
				<select id="cmbPlan" name="cmbPlan" class="form-control lista-vd" <?php if (isset($tarifa[0]['COD_TARIFA_MP'])): echo  "disabled";  endif;?>>
				    <option value="">Seleccione plan</option>
					<?php for ($i = 0; $i < count($planes); $i++): ?>
						<option value="<?php echo $planes[$i]['COD_PLAN']; ?>" <?php if (isset($tarifa[0]['COD_PLAN'])): echo $res = ($tarifa[0]['COD_PLAN'] == $planes[$i]['COD_PLAN']) ? "selected" : ""; endif; ?>>
							<?php echo $planes[$i]['DES_PLAN']; ?>
						</option>
					<?php endfor;?>	
				</select>
			</div>			
		</div>
		<div class="row">
			<div class="col-sm-6">
				<label class="obligatorio">Producto</label>
				<select id="cmbProductos" name="cmbProductos" class="form-control lista-vd"  <?php if (isset($tarifa[0]['COD_TARIFA_MP'])): echo  "disabled";  endif;?>>
                    <option value="">Seleccione producto</option>
					<?php for ($i = 0; $i < count($programasPlan); $i++): ?>
						<option value="<?php echo $programasPlan[$i]['COD_PLAN_PROGRAMA']; ?>" <?php if (isset($tarifa[0]['COD_PLAN_PROGRAMA'])): echo $res = ($tarifa[0]['COD_PLAN_PROGRAMA'] == $programasPlan[$i]['COD_PLAN_PROGRAMA']) ? "selected" : ""; endif; ?>>
							<?php echo $programasPlan[$i]['DES_PLAN_PROGRAMA']; ?>
						</option>
					<?php endfor;?>	
				</select>
			</div>
			<div class="col-sm-6">
		        <label class="obligatorio">Tipo</label>
				<select id="cmbTipoCondicion" name="cmbTipoCondicion" class="form-control lista-vd" <?php if (isset($tarifa[0]['COD_TARIFA_MP'])): echo  "disabled";  endif;?>>
			    	<option value="">Seleccione tipo</option>
					<?php for ($i = 0; $i < count($tipoCondiciones); $i++): ?>
						<option value="<?php echo $tipoCondiciones[$i]['COD_CONDICION_TARIFA']; ?>" <?php if (isset($tarifa[0]['COD_CONDICION_TARIFA'])): echo $res = ($tarifa[0]['COD_CONDICION_TARIFA'] == $tipoCondiciones[$i]['COD_CONDICION_TARIFA']) ? "selected" : ""; endif; ?>>
							<?php echo $tipoCondiciones[$i]['DES_CONDICION_TARIFA']; ?>
						</option>
					<?php endfor;?>
				</select>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-6">
                <label class="">Número de usuarios</label>
				<select id="cmbNumUsuarios" name="cmbNumUsuarios" class="form-control lista-vd" <?php if (isset($tarifa[0]['COD_CONDICION_TARIFA'])): echo $res = ($tarifa[0]['COD_CONDICION_TARIFA'] == 2) ? "disabled" : ""; endif; ?> <?php if (isset($tarifa[0]['COD_TARIFA_MP'])): echo  "disabled";  endif;?>>
			    	<option value="">Seleccione número de usuarios</option>
					<?php for ($i = 0; $i < count($numUsuarios); $i++): ?>
						<option value="<?php echo $numUsuarios[$i]['COD_NUM_USUARIOS_TARIFA']; ?>" <?php if (isset($tarifa[0]['COD_NUM_USUARIOS_TARIFA'])): echo $res = ($tarifa[0]['COD_NUM_USUARIOS_TARIFA'] == $numUsuarios[$i]['COD_NUM_USUARIOS_TARIFA']) ? "selected" : ""; endif; ?>>
							<?php echo $numUsuarios[$i]['DES_NUM_USUARIOS_TARIFA']; ?>
						</option>
					<?php endfor;?>
				</select>
			</div>
			<div class="col-sm-6">
                <label class="">Sexo</label>
				<select id="cmbGenero" name="cmbGenero" class="form-control lista-vd" <?php if (isset($tarifa[0]['COD_CONDICION_TARIFA'])): echo $res = ($tarifa[0]['COD_CONDICION_TARIFA'] == 1) ? "disabled" : ""; endif; ?> <?php if (isset($tarifa[0]['COD_TARIFA_MP'])): echo  "disabled";  endif;?>>
			    	<option value="">Seleccione sexo</option>
					<?php for ($i = 0; $i < count($generos); $i++): ?>
						<option value="<?php echo $generos[$i]['COD_SEXO']; ?>" <?php if (isset($tarifa[0]['COD_SEXO'])): echo $res = ($tarifa[0]['COD_SEXO'] == $generos[$i]['COD_SEXO']) ? "selected" : ""; endif; ?>>
							<?php echo $generos[$i]['DES_SEXO']; ?>
						</option>
					<?php endfor;?>
				</select>
          	</div>
		</div>
        <div class="row">
			<div class="col-sm-6">
                <label class="">Edad m&iacute;nima</label>
				<input type="text" id="txtEdadMinima" name="txtEdadMinima" class="form-control campo-vd" maxlength="3" value="<?php if (isset($tarifa[0]['EDAD_INICIAL'])): echo $tarifa[0]['EDAD_INICIAL']; endif;?>" onkeypress="return validar_solonumeros(event);" <?php if (isset($tarifa[0]['COD_CONDICION_TARIFA'])): echo $res = ($tarifa[0]['COD_CONDICION_TARIFA'] == 1) ? "disabled" : ""; endif;?> <?php if (isset($tarifa[0]['COD_TARIFA_MP'])): echo  "readonly";  endif;?>>
			</div>
			<div class="col-sm-6">
                <label class="">Edad m&aacute;xima</label>
				<input type="text" id="txtEdadMaxima" name="txtEdadMaxima" class="form-control campo-vd" maxlength="3" value="<?php if (isset($tarifa[0]['EDAD_FINAL'])): echo $tarifa[0]['EDAD_FINAL']; endif;?>" onkeypress="return validar_solonumeros(event);" <?php if (isset($tarifa[0]['COD_CONDICION_TARIFA'])): echo $res = ($tarifa[0]['COD_CONDICION_TARIFA'] == 1) ? "disabled" : ""; endif; ?> <?php if (isset($tarifa[0]['COD_TARIFA_MP'])): echo  "readonly";  endif;?>>
			</div>
		</div>
        <div class="row">
			<div class="col-sm-6">
                <label class="obligatorio">Vigencia Fecha inicial</label>
				<input type="text" id="txtVigenciaInicial" name="txtVigenciaInicial" class="form-control campo-vd" maxlength="12" value="<?php if (isset($tarifa[0]['FECHA_VIGE_INICIAL'])): echo $tarifa[0]['FECHA_VIGE_INICIAL']; endif;?>" disabled>
			</div>
			<div class="col-sm-6">
                <label class="obligatorio">Vigencia Fecha final</label>
				<input type="text" id="txtVigenciaFinal" name="txtVigenciaFinal" class="form-control campo-vd" maxlength="12" value="<?php if (isset($tarifa[0]['FECHA_VIGE_FIN'])): echo $tarifa[0]['FECHA_VIGE_FIN']; endif;?>" disabled>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-6">
			    <label class="obligatorio">Estado</label>
				<select id="cmbEstado" name="cmbEstado" class="form-control lista-vd">
			    	<option value="">Seleccione estado</option>
					<?php for ($i = 0; $i < count($estados); $i++): ?>
						<option value="<?php echo $estados[$i]['COD_ESTADO']; ?>" <?php if (isset($tarifa[0]['COD_ESTADO'])): echo $res = ($tarifa[0]['COD_ESTADO'] == $estados[$i]['COD_ESTADO']) ? "selected" : ""; endif; ?>>
							<?php echo $estados[$i]['DES_ESTADO']; ?>
						</option>
					<?php endfor;?>
				</select>
			</div>
			<div class="col-sm-6">
                
			</div>
		</div>
	</div>
</fieldset>
</form>