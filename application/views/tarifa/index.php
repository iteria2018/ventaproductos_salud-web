<?php $this->load->view('header'); ?>  
 
<div class="main main-raised">

	<div class="container">
		<fieldset> 
			<legend> Parametrizar tarifas y promociones </legend>
			<br>
			<div class="container">
				<div class="row">
					<div class="col-md-12">
						<button id="parametrizarTarifaAg" class="btn btn-primary boton-vd" type="button">
							<i class="fa fa-plus-circle" aria-hidden="true"></i> &nbsp; Agregar
						</button>
					</div>
				</div>
			</div>
			<br>
			<div class="container" >

				<table width="100%" class="table table-striped table-bordered table-hover" id="tablaParametrizaciontarifas">
					<thead>
						<tr>
							<th>Producto</th>
							<th>Plan</th>
							<th>Tipo tarifa</th>
							<th>Tipo</th>
							<th>Sexo</th>
							<th>Vigencia</th>
							<th>Modificar</th>
						</tr>
					</thead>	
					<tbody>
					    <?php for ($i = 0; $i < count($tarifas); $i++): ?>
							<tr>
								<td><?php echo $tarifas[$i]['DES_PRODUCTO'].' - '.$tarifas[$i]['DES_PROGRAMA']; ?></td>
								<td><?php echo $tarifas[$i]['DES_PLAN']; ?></td>
								<td><?php echo $tarifas[$i]['DES_TIPO_TARIFA']; ?></td>							
								<td><?php echo $tarifas[$i]['DES_CONDICION_TARIFA']; ?></td>
								<td><?php echo $tarifas[$i]['DES_SEXO']; ?></td>
								<td><?php echo $tarifas[$i]['FECHA_VIGE_INICIAL'].' - '.$tarifas[$i]['FECHA_VIGE_FIN']; ?></td>
								<td style="text-align:center">
									<i class="parametrizarTarifaEd fa fa-pencil-square-o" aria-hidden="true" style="cursor:pointer;" codTarifa="<?php echo $tarifas[$i]['COD_TARIFA']; ?>"></i>
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
<script src="<?php echo site_url() ?>asset/public/user/js/tarifa.js"></script>