<?php
    $this->load->view('header');
		$tipoIdentificacion = $this->session->userdata('tipo_identificacion'); 
		$Identificacion = $this->session->userdata('identificacion');    
		$tipo_identificacion_abr = $this->session->userdata('tipo_identificacion_abr');
?> 

<script type="text/javascript">

   global_tipoIdentificacion = <?php echo $tipoIdentificacion; ?>;
	 global_Identificacion = "<?php echo $Identificacion; ?>";
	 global_tipo_identificacion_abr = "<?php echo $tipo_identificacion_abr; ?>";
  
</script>

  <div class="main main-raised">    
     	<!--<div class="row">
     		<div class="col-12 text-center">
     			<h2 class="display-3">Solicitud de compra</h2>     			
     		</div>     		
     	</div> -->
     	 <!--         carousel  -->
	    <div id="carousel" class="row">
	      
	          <div class="col-12 mr-auto ml-auto">
	            <!-- Carousel Card -->
	            <div class="card card-raised card-carousel">
	              <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel" data-interval="20000">
	                 <?php echo $slider ?>
	              </div>
	            </div>
	            <!-- End Carousel Card -->
	          </div>	        
	    </div>    <!--         end carousel --> 
  </div>

<?php
  $this->load->view('footer');
?>
<style type="text/css">
  .main-raised{
    	padding-top: 0px !important;
  } 
  #carousel {
    	display: block !important;
	}
	/*--- Aplicar estilos sin scroll --*/
	/*.carousel-inner{
			height: 500px;
	}*/
	.header-vd {
    	height: 120px !important;
    	background: #eee !important;
	}
	.page-footer{
			display: none;
	}
	.carousel-caption {
			bottom: 20px;
			display: block !important;
	}
</style>
<script src="<?php echo site_url() ?>asset/public/user/js/home.js"></script>
