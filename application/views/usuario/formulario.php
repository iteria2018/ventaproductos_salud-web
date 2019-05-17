<form id="formUsuarios" name="formUsuarios" method="post" enctype="multipart/form-data">   
<input id="txtTipoAccion" name="txtTipoAccion" type="hidden" value="<?php echo $tipoAccion; ?>" readonly>  
<input id="txtCodusuario" name="txtCodusuario" type="hidden" value="<?php if (isset($usuario[0]['COD_USUARIO'])): echo $usuario[0]['COD_USUARIO']; endif;?>" readonly>
<input id="txtCodPersona" name="txtCodPersona" type="hidden" value="<?php if (isset($usuario[0]['COD_PERSONA'])): echo $usuario[0]['COD_PERSONA']; endif;?>" readonly>
<input id="txtCodPerfil" name="txtCodPerfil" type="hidden" value="<?php if (isset($usuario[0]['COD_PERFIL'])): echo $usuario[0]['COD_PERFIL']; endif;?>" readonly>
<input id="txtNombrePerfil" name="txtNombrePerfil" type="hidden" value="" readonly>
<fieldset> 
	<div class="container" id="divUsuario">
		<div class="row">
			<div class="col-sm-6">
				<label class="obligatorio">Tipo de identificación</label>
				<select id="cmbTipoIdentificacion" name="cmbTipoIdentificacion" class="form-control lista-vd" <?php if (isset($usuario[0]['COD_TIPO_IDENTIFICACION'])): echo 'disabled'; endif;?>>
				    <option value="">Seleccione tipo identificación</option>
					<?php for ($i = 0; $i < count($tiposidentificacion); $i++): ?>
						<option value="<?php echo $tiposidentificacion[$i]['COD_TIPO_IDENTIFICACION']; ?>" <?php if (isset($usuario[0]['COD_TIPO_IDENTIFICACION'])): echo $res = ($usuario[0]['COD_TIPO_IDENTIFICACION'] == $tiposidentificacion[$i]['COD_TIPO_IDENTIFICACION']) ? "selected" : ""; endif; ?>>
							<?php echo $tiposidentificacion[$i]['DES_TIPO_IDENTIFICACION']; ?>
						</option>
					<?php endfor;?>	
				</select>
			</div>
			<div class="col-sm-6">
                <label class="obligatorio">Número de identificación</label>
				<input type="text" id="txtNroIdentificacion" name="txtNroIdentificacion" class="form-control campo-vd" maxlength="11" value="<?php if (isset($usuario[0]['NUMERO_IDENTIFICACION'])): echo $usuario[0]['NUMERO_IDENTIFICACION']; endif;?>" onkeypress="return validar_solonumeros(event);" <?php if (isset($usuario[0]['NUMERO_IDENTIFICACION'])): echo 'disabled'; endif;?>>
			</div>
			
		</div>
		<div class="row">
			<div class="col-sm-6">
				<label class="obligatorio">Primer Nombre</label>
				<input type="text" id="txtPrimerNombre" name="txtPrimerNombre" class="form-control campo-vd" maxlength="50" value="<?php if (isset($usuario[0]['NOMBRE_1'])): echo $usuario[0]['NOMBRE_1']; endif;?>" <?php if (isset($usuario[0]['NOMBRE_1'])): echo 'disabled'; endif;?>>
			</div>
			<div class="col-sm-6">
		        <label class="">Segundo Nombre</label>
				<input type="text" id="txtSegundoNombre" name="txtSegundoNombre" class="form-control campo-vd" maxlength="50" value="<?php if (isset($usuario[0]['NOMBRE_2'])): echo $usuario[0]['NOMBRE_2']; endif;?>" <?php if (isset($usuario[0]['NOMBRE_1'])): echo 'disabled'; endif;?>>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-6">
                <label class="obligatorio">Primer Apellido</label>
				<input type="text" id="txtPrimerApellido" name="txtPrimerApellido" class="form-control campo-vd" maxlength="50" value="<?php if (isset($usuario[0]['APELLIDO_1'])): echo $usuario[0]['APELLIDO_1']; endif;?>" <?php if (isset($usuario[0]['APELLIDO_1'])): echo 'disabled'; endif;?>>
			</div>
			<div class="col-sm-6">
                <label class="">Segundo Apellido</label>
				<input type="text" id="txtSegundoApellido" name="txtSegundoApellido" class="form-control campo-vd" maxlength="50" value="<?php if (isset($usuario[0]['APELLIDO_2'])): echo $usuario[0]['APELLIDO_2']; endif;?>" <?php if (isset($usuario[0]['APELLIDO_1'])): echo 'disabled'; endif;?>>
          	</div>
		</div>
        <div class="row">
			<div class="col-sm-6">
                <label class="obligatorio">Correo electr&oacute;nico</label>
				<input type="text" id="txtCorreoElectronico" name="txtCorreoElectronico" class="form-control campo-vd" maxlength="100" value="<?php if (isset($usuario[0]['EMAIL'])): echo $usuario[0]['EMAIL']; endif;?>" <?php if (isset($usuario[0]['EMAIL'])): echo 'disabled'; endif;?>>
			</div>
			<div class="col-sm-6">
                <label class="">Tel&eacute;fono</label>
				<input type="text" id="txtTelefono" name="txtTelefono" class="form-control campo-vd" maxlength="10" value="<?php if (isset($usuario[0]['TELEFONO'])): echo $usuario[0]['TELEFONO']; endif;?>" onkeypress="return validar_solonumeros(event);" <?php if (isset($usuario[0]['NUMERO_IDENTIFICACION'])): echo 'disabled'; endif;?>>
			</div>
		</div>
        <div class="row">
			<div class="col-sm-6">
                <label class="obligatorio">Login de usuario</label>
				<input type="text" id="txtUsuario" name="txtUsuario" class="form-control campo-vd" maxlength="50" value="<?php if (isset($usuario[0]['LOGIN'])): echo $usuario[0]['LOGIN']; endif;?>" <?php if (isset($usuario[0]['LOGIN'])): echo 'disabled'; endif;?>>
         	</div>
			<div class="col-sm-6" id="div_contrasena">
                <label class="obligatorio">Contraseña</label>
				<input type="password" id="txtContrasena" name="txtContrasena" class="form-control campo-vd" maxlength="50" value="<?php if (isset($usuario[0]['CLAVE'])): echo $usuario[0]['CLAVE']; endif;?>" <?php if (isset($usuario[0]['LOGIN'])): echo 'disabled'; endif;?>>
			</div>
		</div>
        <div class="row">
			<div class="col-sm-6" id="div_perfil">
               <label class="obligatorio">Perfil</label>
				<select id="cmbPerfil" name="cmbPerfil" class="form-control lista-vd">
				    <option value="">Seleccione perfil</option>				   
					<?php for ($i = 0; $i < count($perfiles); $i++): ?>
						<option value="<?php echo $perfiles[$i]['COD_ROL']; ?>" <?php if (isset($usuario[0]['COD_ROL'])): echo $res = ($usuario[0]['COD_ROL'] == $perfiles[$i]['COD_ROL']) ? "selected" : ""; endif; ?>>
							<?php echo $perfiles[$i]['DES_ROL']; ?>
						</option>
					<?php endfor;?>	
				</select>               
			</div>
            <div class="col-sm-6" id="div_estado">
				<label class="obligatorio">Estado</label>
				<select id="cmbEstado" name="cmbEstado" class="form-control lista-vd">
			    	<option value="">Seleccione estado</option>
					<?php for ($i = 0; $i < count($estados); $i++): ?>
						<option value="<?php echo $estados[$i]['COD_ESTADO']; ?>" <?php if (isset($usuario[0]['COD_ESTADO'])): echo $res = ($usuario[0]['COD_ESTADO'] == $estados[$i]['COD_ESTADO']) ? "selected" : ""; endif; ?>>
							<?php echo $estados[$i]['DES_ESTADO']; ?>
						</option>
					<?php endfor;?>
				</select>
			</div>
		</div>
	</div>
</fieldset>
</form>