<!-- DATOS CONTRATANTE -->
<fieldset> 
	<legend> Informaci&oacute;n contratante </legend>
	<br>
	<div class="container" id="divContratante">
		<div class="row">
			<div class="col-sm-12 col-md-6 col-lg-3">
				<label class="obligatorio">Tipo de identificaci&oacute;n</label>
				<select id="tipoDocumento<?php echo $abr_tab; ?>" class="form-control lista-vd" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
					<?php echo $opTipoId; ?>
				</select>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-3 ">
				<label class="obligatorio">N&uacute;mero de identificaci&oacute;n</label>
				<input type="text" id="numeroDocumento<?php echo $abr_tab; ?>" class="form-control campo-vd" maxlength="12" placeholder="" onkeypress="return validar_solonumeros(event);" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-3">
				<label class="obligatorio">Primer nombre</label>
				<input type="text" id="nombre1<?php echo $abr_tab; ?>" class="form-control campo-vd" maxlength="50" placeholder="" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-3">
				<label class="" >Segundo nombre</label>
				<input type="text" id="nombre2<?php echo $abr_tab; ?>" class="form-control campo-vd" maxlength="50" placeholder="" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12 col-md-6 col-lg-3">
				<label class="obligatorio">Primer apellido</label>
				<input type="text" id="apellido1<?php echo $abr_tab; ?>" class="form-control campo-vd" maxlength="50" placeholder="" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-3">
				<label class="">Segundo apellido</label>
				<input type="text" id="apellido2<?php echo $abr_tab; ?>" class="form-control campo-vd" maxlength="50" placeholder="" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-3">
				<label class="obligatorio">Fecha nacimiento</label>
				<input type="text" id="fechaNacimiento<?php echo $abr_tab; ?>" class="form-control campo-vd" maxlength="12" placeholder="" onKeyPress="return false;" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-3">
				<label class="obligatorio" >Sexo</label>
				<select id="tipoSexo<?php echo $abr_tab; ?>" class="form-control lista-vd" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
					<?php echo $opSexo; ?>
				</select>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12 col-md-6 col-lg-3">
				<label class="">Tel&eacute;fono fijo</label>
				<input type="text" id="telefono<?php echo $abr_tab; ?>" class="form-control campo-vd" maxlength="10" placeholder="" onkeypress="return validar_solonumeros(event);" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-3">
				<label class="obligatorio">Celular</label>
				<input type="text" id="celular<?php echo $abr_tab; ?>" class="form-control campo-vd" maxlength="10" placeholder="" onkeypress="return validar_solonumeros(event);" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-3">
				<label class="obligatorio">Correo</label>
				<input type="text" id="correo<?php echo $abr_tab; ?>" class="form-control campo-vd" maxlength="100" placeholder="" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-3">
				<label class="obligatorio" >Nacionalidad</label>
				<select id="pais<?php echo $abr_tab; ?>" class="form-control lista-vd" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
					<?php echo $opPais; ?>
				</select>
			</div>
		</div>
		<div class="row">                        
			<div class="col-sm-12 col-md-12 col-xs-6 col-lg-6">
				<label class="obligatorio">Direcci&oacute;n</label>
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-3">
						<select id="tipoVia<?php echo $abr_tab; ?>" class="form-control lista-vd select-dir" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
							<?php echo $opTipoVia; ?>
						</select>
					</div>
					<div class="col-sm-12 col-md-4 col-lg-3">
						<span class="ej-direccion">Ej: 45, 68D, 4 bis</span>
						<input type="text" id="numeroTipoVia<?php echo $abr_tab; ?>" class="form-control campo-vd input-dir" maxlength="10" placeholder="N&uacute;mero" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
					</div>
					<div class="col-sm-12 col-md-4 col-lg-3">
						<span class="ej-direccion">Ej: 23 - 34, 34a - 23</span>
						<input type="text" id="numeroPlaca<?php echo $abr_tab; ?>" class="form-control campo-vd input-dir" maxlength="20" placeholder="N&uacute;mero de la placa" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
					</div>
					<div class="col-sm-12 col-md-4 col-lg-3">
						<span class="ej-direccion">Ej: Apto 2, Bloque 2</span>
						<input type="text" id="complemento<?php echo $abr_tab; ?>" class="form-control campo-vd input-dir" maxlength="30" placeholder="Complemento" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
					</div>
				</div>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-3">
				<label class="obligatorio">Municipio</label>
				<select id="municipio<?php echo $abr_tab; ?>" class="form-control lista-vd" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
					<!--<option value="-1" disabled selected hidden> Seleccione municipio </option>-->
					<?php echo $opMunicipio; ?>
				</select>
			</div>
			<div class="col-sm-12 col-md-6 col-lg-3">
				<label class="obligatorio" >Estado civil</label>
				<select id="estado_civil<?php echo $abr_tab; ?>" class="form-control lista-vd" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
					<?php echo $opEstadoCivil; ?>
				</select>
			</div>
		</div>
		<div class="row" id="div_row_add<?php echo $abr_tab; ?>">
			<div class="col-sm-12 col-md-6 col-lg-3">
				<label class="obligatorio">Eps</label>
				<select id="eps<?php echo $abr_tab; ?>" class="form-control lista-vd" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>>
					<?php echo $opEps; ?>
				</select>
			</div>

            <?php if ($bloquea == 'NO'): ?>
                <div class="col-sm-12 col-md-6 col-lg-3" id="div_inBeneficiario<?php echo $abr_tab; ?>">
                    <label>Incluir como beneficiario</label>
                    <div class="container" style="padding-top: 5px;">
                        <div class="row">
                            <div class="form-check col-sm-6 col-md-3">
                                <label class="radio-inline form-check-label">
                                    <input type="radio" id="inBeneficiario" name="inBeneficiario" value="1" class="form-check-input"> Si
                                    <span class="circle">
                                        <span class="check"></span>
                                    </span>
                                </label>
                            </div>
                            <div class="form-check col-sm-6 col-md-3">
                                <label class="radio-inline form-check-label">
                                    <input type="radio" id="inBeneficiario" name="inBeneficiario" value="0" class="form-check-input"> No
                                    <span class="circle">
                                        <span class="check"></span>
                                    </span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            <?php endif; ?>

			<div class="col-sm-12 col-md-6 col-lg-3 hideComponent" id="div_tieneMascota<?php echo $abr_tab; ?>">
				<label class="obligatorio">Tiene mascota</label>
				<div class="container" style="padding-top: 5px;">
					<div class="row">
						<div class="form-check col-sm-6 col-md-3">
							<label class="radio-inline form-check-label">
								<input type="radio" id="mascota<?php echo $abr_tab; ?>" name="mascota<?php echo $abr_tab; ?>" value="1" class="form-check-input" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>> Si
								<span class="circle">
									<span class="check"></span>
								</span>
							</label>
						</div>
						<div class="form-check col-sm-6 col-md-3">
							<label class="radio-inline form-check-label">
								<input type="radio" id="mascota<?php echo $abr_tab; ?>" name="mascota<?php echo $abr_tab; ?>" value="0" class="form-check-input" <?php echo $res = ($bloquea == 'SI') ? "disabled" : ""; ?>> No
								<span class="circle">
									<span class="check"></span>
								</span>
							</label>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</fieldset>