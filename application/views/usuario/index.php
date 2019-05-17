<?php $this->load->view('header'); ?>  
 
<div class="main main-raised">

	<div class="container">
		<fieldset> 
			<legend> Administrar Usuarios </legend>
			<br>
			<div class="container">
				<div class="row">
					<div class="col-md-12">
						<button id="parametrizarUsuarioAg" class="btn btn-primary boton-vd" type="button">
							<i class="fa fa-user-plus" aria-hidden="true"></i> &nbsp; Agregar
						</button>
					</div>
				</div>
			</div>
			<br>
			<div class="container" >

				<table width="100%" class="table table-striped table-bordered table-hover" id="tablaParametrizacionUsuarios">
					<thead>
						<tr>
							<th>Tipo de identificación</th>
							<th>Número de identificación</th>
							<th>Primer Nombre</th>
							<th>Primer Apellido</th>
                            <th>Usuario</th>
                            <th>Correo electrónico</th>
                            <th>Perfil</th>
							<th>Modificar</th>
						</tr>
					</thead>	
					<tbody>
					    <?php for ($i = 0; $i < count($usuarios); $i++): ?>
							<tr>
								<td><?php echo $usuarios[$i]['DES_ABR']; ?></td>
								<td><?php echo $usuarios[$i]['NUMERO_IDENTIFICACION']; ?></td>
								<td><?php echo $usuarios[$i]['NOMBRE_1']; ?></td>
								<td><?php echo $usuarios[$i]['APELLIDO_1']; ?></td>
                                <td><?php echo $usuarios[$i]['LOGIN']; ?></td>
                                <td><?php echo $usuarios[$i]['EMAIL']; ?></td>
                                <td><?php echo $usuarios[$i]['DES_ROL']; ?></td>
								<td style="text-align:center">
									<i class="parametrizarUsuarioEd fa fa-pencil-square-o" aria-hidden="true" style="cursor:pointer;" codUsuario="<?php echo $usuarios[$i]['COD_USUARIO']; ?>" codPersona="<?php echo $usuarios[$i]['COD_PERSONA']; ?>" codRol="<?php echo $usuarios[$i]['COD_ROL']; ?>"></i>
								</td>
							</tr>
						<?php endfor;?>		
					</tbody>
                </table>	
							
			</div>
			<hr/>	
			
			<div class="row">
				<div class="col-md-12">
					<br>
				</div>
			</div>
			
			<div class="row">
				<div class="col-md-12">
					<br>
				</div>
			</div>
		</fieldset>
	</div>
</div>   

<?php $this->load->view('footer');?>
<script src="<?php echo site_url() ?>asset/public/user/js/usuario.js"></script>