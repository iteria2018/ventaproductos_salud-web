<?php
	$this->load->view('header');     
?> 

  <script type="text/javascript">
      var global_datos_contratante = <?php echo $datosContratante; ?>;
      var global_op_parentesco = <?php echo json_encode($opParentesco); ?>;
      var global_productos = <?php echo $productos; ?>;
      var global_base_url = '<?php echo base_url(); ?>';
			var global_op_tipo_pago = <?php echo json_encode($opTipoPago); ?>;
			var global_benefis_pend = <?php echo json_encode($beneficiariosPend); ?>; 
			var urlOrigenWidget = '<?php echo $urlOrigenWidget; ?>';
			var global_benefis_programs_pend = <?php echo json_encode($benefisProgramas); ?>; 
			var msgFinalizarVenta = '<?php echo $msgFinalizarVenta; ?>'; 
			const g_senal = <?php echo json_encode($senal); ?>;
			const global_habeasDataCem = <?php echo json_encode($habeasDataCem); ?>;
			const global_msj_noAplicaTarifa = <?php echo json_encode($msj_noAplicaTarifa); ?>;
  </script>

<div class="main main-raised fondo-tab1">

<div class="container" id="container_titulo">
	<div class="row justify-content-end">
		<div class="col-10">
			<h1 id="pasoTab" class="text-muted"   style="margin-bottom: -2.3rem !important;"><b>Paso 1</b></h1>
			<h2 id="tituloMedio" class="text-primary" style="margin-bottom: -2.3rem !important;">Solicitar</h2>
			<h1 id="tituloFinal" class="text-primary" style="margin-bottom: -2.3rem !important;"><b>Compra</b></h1>
		</div>		
	</div>
</div>


    <div class="profile-content">
		<div class="container">
			<div class="row">
				<div class="col-md-12 ml-auto mr-auto">
					<div class="profile-tabs tabs-inicial">
						<ul id="tabs_compra" class="nav nav-pills nav-pills-icons justify-content-center" role="tablist">
							<li class="nav-item">
								<a class="nav-link active" href="#paso_1" role="tab" data-toggle="tab">
									<span class="fontmenu-vd">  Paso 1  </span><br>
									<span class="fontdesc-vd"> Registro datos b&aacute;sicos </span><br>
									<img class="imgmenu-vd" src="<?php echo base_url()?>asset/public/images/vd/carrito_compra.png">
									<!--<i class="material-icons">camera</i> > -->
								</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" href="#paso_2" role="tab" data-toggle="tab">
									<span class="fontmenu-vd">  Paso 2  </span><br>
									<span class="fontdesc-vd"> Agregar productos </span><br>
									<img class="imgmenu-vd" src="<?php echo base_url()?>asset/public/images/vd/bolsa_compra.png">
									<!--<i class="material-icons">palette</i>-->
								</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" href="#paso_3" role="tab" data-toggle="tab">
									<span class="fontmenu-vd">  Paso 3  </span><br>
									<span class="fontdesc-vd"> Cotizaci&oacute;n </span><br>
									<img class="imgmenu-vd" src="<?php echo base_url()?>asset/public/images/vd/factura.png">
									<!--<i class="material-icons">favorite</i>-->
								</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" href="#paso_4" role="tab" data-toggle="tab">
									<span class="fontmenu-vd">  Paso 4  </span><br>          
									<span class="fontdesc-vd"> Registrar pago </span><br>
									<img class="imgmenu-vd" src="<?php echo base_url()?>asset/public/images/vd/tarjeta.png">
									<!--<i class="material-icons">camera</i>-->
								</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" href="#paso_5" role="tab" data-toggle="tab">
									<span class="fontmenu-vd">  Paso 5  </span><br>          
									<span class="fontdesc-vd"> Generar contrato </span><br>
									<img class="imgmenu-vd" src="<?php echo base_url()?>asset/public/images/vd/editar.png">
									<!--<i class="material-icons">favorite</i>-->
								</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<div class="tab-content tab-space">
				<!-- TABS PASO 1 -->
				<div class="tab-pane active text-center gallery" id="paso_1">
					<?php
						$this->load->view('paso_1');
					?>
				</div>
				<!-- TABS PASO 2 -->
				<div class="tab-pane text-center gallery" id="paso_2"> 
					<?php
						$this->load->view('paso_2');
					?>
				</div>
				<!-- TABS PASO 3 -->
				<div class="tab-pane text-center gallery" id="paso_3">
					<?php
						$this->load->view('paso_3');
					?>
				</div>
				<!-- TABS PASO 4 -->
				<div class="tab-pane text-center gallery" id="paso_4"> 
					<?php
						$this->load->view('paso_4');
					?>
				</div>
				<!-- TABS PASO 5 -->
				<div class="tab-pane text-center gallery" id="paso_5">
					<?php
						$this->load->view('paso_5');
					?>
				</div>
			</div>
		</div>
	</div>
</div>

<?php
	$this->load->view('footer');
?>
<script src="<?php echo site_url() ?>asset/public/user/js/gestion_compra.js"></script>
<script src="<?php echo site_url() ?>asset/public/user/js/encuesta_sarlaf.js"></script>
<script src="<?php echo site_url() ?>asset/public/user/js/encuesta_salud.js"></script>
<script src="<?php echo site_url() ?>asset/public/user/js/paso_4.js"></script>



