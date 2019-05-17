<?php $this->load->view('header'); ?>  
<!--Consulta estado solicitudes-->
<div class="main main-raised">

	<div class="container">   

        <fieldset> 
            <legend> Estado de solicitudes </legend>
            <br>
            <div class="container">
                <?php $this->load->view('solicitud/formularioConsulta'); ?> 
            </div>
            <div class="container" id="solGestiona">
                <?php $this->load->view('solicitud/tablaConsulta'); ?> 
             </div>

            <br>
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
<script src="<?php echo site_url() ?>asset/public/user/js/solicitud.js"></script>
<script src="<?php echo site_url() ?>asset/public/user/js/encuesta_sarlaf.js"></script>
<script src="<?php echo site_url() ?>asset/public/user/js/encuesta_salud.js"></script>