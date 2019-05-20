<?php $this->load->view('header'); ?>  
 
<div class="main main-raised">

	<div class="container">
		<fieldset> 
			<legend> Parametrizar Productos </legend>
			<br>
			<div class="container">
				<div class="row">
					<div class="col-md-12">
						<button id="parametrizarProductoAg" class="btn btn-primary boton-vd" type="button">
							<i class="fa fa-cart-plus" aria-hidden="true"></i> &nbsp; Agregar
						</button>
					</div>
				</div>
			</div>
			<br>
			<div class="container" >

				<table width="100%" class="table table-striped table-bordered table-hover" id="tablaParametrizacionlineas">
					<thead>
						<tr>
							<th>L&iacute;neas</th>
							<th>Programas</th>
							<th>Plan</th>
							<th>Estado</th>
							<th>Cobertura Inicial</th>
							<th>Cobertura Final</th>
							<th>Modificar</th>
						</tr>
					</thead>	
					<tbody>
					    <?php for ($i = 0; $i < count($lineas); $i++): ?>
							<tr>
								<td><?php echo $lineas[$i]['DES_PRODUCTO']; ?></td>
								<td><?php echo $lineas[$i]['DES_PROGRAMA']; ?></td>
								<td><?php echo $lineas[$i]['DES_PLAN']; ?></td>
								<td><?php echo $lineas[$i]['DES_ESTADO']; ?></td>
								<td>
							        <img src="<?php echo $lineas[$i]['COBERTURA_INICIAL']; ?>" class="img-fluid" alt="Cobertura Inicial">
								</td>
								<td>
							        <img src="<?php echo $lineas[$i]['COBERTURA_FINAL']; ?>" class="img-fluid" alt="Cobertura Final">
								</td>
								<td style="text-align:center">
									<i class="parametrizarProductoEd fa fa-pencil-square-o" aria-hidden="true" style="cursor:pointer;" codPlanPrograma="<?php echo $lineas[$i]['COD_PLAN_PROGRAMA']; ?>"></i>
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
<script src="<?php echo site_url() ?>asset/public/user/js/lineas.js"></script>