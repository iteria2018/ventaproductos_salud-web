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
				<label class="obligatorio">Programa</label>
				<select id="cmbPrograma" name="cmbPrograma" class="form-control lista-vd" <?php if($tipoAccion != 1) echo 'readonly'; ?> >
				    <option value="">Seleccione programa</option>
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
				<label class="<?php if($tipoAccion == 1) echo 'obligatorio'; ?>">Cobertura Inicial</label>
				<div class="file-field">
                    <a class="btn-floating btn-lg blue lighten-1 mt-0 float-left">
                        <i class="fa fa-paperclip" aria-hidden="true"></i>
                        <input class="adjuntarDocumentos" id="CoberturaInicial" name="CoberturaInicial" type="file"  accept="<?php echo $arrayExtensiones; ?>">
                    </a>
                    <div class="file-path-wrapper"  style="width: 16.8rem">
                        <input id="showFileCoberturaInicial" class="form-control file-path validate" type="text" placeholder="Adjuntar cobertura Inicial"> 
                    </div>
                    <button id="btnVerFileCoberturaInicial" class="verArchivo btn btn-primary disabled btn-sm" upload="CoberturaInicial" type="button" title="Ver Adjunto" style="padding: 0.40625rem 0.6rem;">
                        <i class="fa fa-file-image-o" aria-hidden="true"></i>
                    </button>
				</div>
			</div>
			<div class="col-sm-6">
				<label class="<?php if($tipoAccion == 1) echo 'obligatorio'; ?>">Cobertura Final</label>
				<div class="file-field">
                    <a class="btn-floating btn-lg blue lighten-1 mt-0 float-left">
                        <i class="fa fa-paperclip" aria-hidden="true"></i>
                        <input class="adjuntarDocumentos" id="CoberturaFinal" name="CoberturaFinal" type="file"  accept="<?php echo $arrayExtensiones; ?>">
                    </a>
                    <div class="file-path-wrapper" style="width: 16.8rem">
                        <input id="showFileCoberturaFinal" class="form-control file-path" type="text" placeholder="Adjuntar cobertura Final"> 
                    </div>
                    <button id="btnVerFileCoberturaFinal" class="verArchivo btn btn-primary disabled" upload="CoberturaFinal" type="button" title="Ver Adjunto" style="padding: 0.40625rem 0.6rem;">
                        <i class="fa fa-file-image-o" aria-hidden="true"></i>
                    </button>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-6">
				<label class="obligatorio">C&oacute;digo de homolaci&oacute;n programa</label>
				<div>
					<input class="form-control campo-vd" id="programaHomologa" name="programaHomologa" type="text" max-length="100" value="<?php echo $codProgramaHomologa; ?>">				
				</div>
			</div>
		</div>
	</div>
</fieldset>
</form>