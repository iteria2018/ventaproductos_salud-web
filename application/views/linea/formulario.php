<form id="formProductos" name="formProductos" method="post" enctype="multipart/form-data">   
<input id="txtTipoAccion" name="txtTipoAccion" id="txtTipoAccion" type="hidden" value="<?php echo $tipoAccion; ?>" readonly>  
<input id="txtCodPlanPrograma" name="txtCodPlanPrograma" type="hidden" value="<?php if (isset($planPrograma[0]['COD_PLAN_PROGRAMA'])): echo $planPrograma[0]['COD_PLAN_PROGRAMA']; endif;?>" readonly>
<input type="hidden" id="txtRutaCoberturaIni" name="txtRutaCoberturaIni" value="<?php if (isset($planPrograma[0]['COBERTURA_INICIAL'])): echo $planPrograma[0]['COBERTURA_INICIAL']; endif;?>" readonly>
<input type="hidden" id="txtRutaCoberturaFin" name="txtRutaCoberturaFin" value="<?php if (isset($planPrograma[0]['COBERTURA_FINAL'])): echo $planPrograma[0]['COBERTURA_FINAL']; endif;?>" readonly>
<fieldset> 
	<div class="container" id="divContratante">
		<div class="row">
			<div class="col-sm-6">
				<label class="obligatorio">L&iacute;nea</label>
				<select id="cmbLinea" name="cmbLinea" class="form-control lista-vd" <?php if($tipoAccion != 1) echo 'readonly'; ?> >
				    <option value="">Seleccione l&iacute;nea</option>
					<?php for ($i = 0; $i < count($productos); $i++): ?>
						<option value="<?php echo $productos[$i]['COD_PRODUCTO']; ?>" <?php if (isset($planPrograma[0]['COD_PRODUCTO'])): echo $res = ($planPrograma[0]['COD_PRODUCTO'] == $productos[$i]['COD_PRODUCTO']) ? "selected" : ""; endif; ?>>
							<?php echo $productos[$i]['DES_PRODUCTO']; ?>
						</option>
					<?php endfor;?>	
				</select>
			</div>
			<div class="col-sm-6">
				<label class="obligatorio">Producto</label>
				<select id="cmbPrograma" name="cmbPrograma" class="form-control lista-vd" <?php if($tipoAccion != 1) echo 'readonly'; ?> >
				    <option value="">Seleccione producto</option>
					<?php for ($i = 0; $i < count($programas); $i++): ?>
						<option value="<?php echo $programas[$i]['COD_PROGRAMA']; ?>" <?php if (isset($planPrograma[0]['COD_PROGRAMA'])): echo $res = ($planPrograma[0]['COD_PROGRAMA'] == $programas[$i]['COD_PROGRAMA']) ? "selected" : ""; endif; ?>>
							<?php echo $programas[$i]['DES_PROGRAMA']; ?>
						</option>
					<?php endfor;?>	
				</select>
			</div>
			
		</div>
		<div class="row">
			<div class="col-sm-6">
				<label class="obligatorio">Plan</label>
				<select id="cmbPlan" name="cmbPlan" class="form-control lista-vd" <?php if($tipoAccion != 1) echo 'readonly'; ?> >
				    <option value="">Seleccione plan</option>
					<?php for ($i = 0; $i < count($planes); $i++): ?>
						<option value="<?php echo $planes[$i]['COD_PLAN']; ?>" <?php if (isset($planPrograma[0]['COD_PLAN'])): echo $res = ($planPrograma[0]['COD_PLAN'] == $planes[$i]['COD_PLAN']) ? "selected" : ""; endif; ?>>
							<?php echo $planes[$i]['DES_PLAN']; ?>
						</option>
					<?php endfor;?>	
				</select>
			</div>
			<div class="col-sm-6">
				<label class="obligatorio">Estado</label>
				<select id="cmbEstado" name="cmbEstado" class="form-control lista-vd">
			    	<option value="">Seleccione estado</option>
					<?php for ($i = 0; $i < count($estados); $i++): ?>
						<option value="<?php echo $estados[$i]['COD_ESTADO']; ?>" <?php if (isset($planPrograma[0]['COD_ESTADO'])): echo $res = ($planPrograma[0]['COD_ESTADO'] == $estados[$i]['COD_ESTADO']) ? "selected" : ""; endif; ?>>
							<?php echo $estados[$i]['DES_ESTADO']; ?>
						</option>
					<?php endfor;?>
				</select>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-6">
				<label class="<?php if($tipoAccion == 1) echo 'obligatorio'; ?>">Cobertura</label>
				<div class="file-field">
                    <a class="btn-floating btn-lg blue lighten-1 mt-0 float-left">
                        <i class="fa fa-paperclip" aria-hidden="true"></i>
                        <input class="adjuntarDocumentos" id="CoberturaInicial" name="CoberturaInicial" type="file"  accept="<?php echo $arrayExtensiones; ?>">
                    </a>
                    <div class="file-path-wrapper"  style="width: 16.8rem">
                        <input id="showFileCoberturaInicial" class="form-control file-path validate" type="text" placeholder="Adjuntar cobertura"> 
                    </div>
                    
				</div>
			</div>
			<div class="col-sm-6">
				<label class="obligatorio">C&oacute;digo de homolaci&oacute;n programa</label>
				<div>
					<input class="form-control campo-vd" id="programaHomologa" name="programaHomologa" type="text" max-length="100" value="<?php echo $codProgramaHomologa; ?>">				
				</div>
			</div>			
		</div>
		<div class="row">
			<div class="col-sm-3">
				<label >Cuenta</label>
				<div>
					<input class="form-control campo-vd" id="cuenta" name="cuenta" type="text" max-length="100" value="<?php echo $opeclave; ?>">				
				</div>
			</div>	
			<div class="col-sm-3">
				<label >Sub-cuenta</label>
				<div>
					<input class="form-control campo-vd" id="sub_cuenta" name="sub_cuenta" type="text" max-length="100" value="<?php echo $opesubclave; ?>">				
				</div>
			</div>
			<div class="col-sm-3">
				<label >Programa</label>
				<div>
					<input class="form-control campo-vd" id="programa" name="programa" type="text" max-length="100" value="<?php echo $opeprograma; ?>">				
				</div>
			</div>	
			<div class="col-sm-3">
				<label >Tarifa</label>
				<div>
					<input class="form-control campo-vd" id="tarifa" name="tarifa" type="text" max-length="100" value="<?php echo $opetarifa; ?>">				
				</div>
			</div>
		</div>
	</div>
</fieldset>
</form>