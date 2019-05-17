<?php $this->load->view('header'); ?>  
 
<input type="hidden" id="txtcodSolicitudGestion" class="form-control campo-vd-sm" value="<?php if (isset($validaSolicitudEnGestion)): echo $validaSolicitudEnGestion; endif;?>" readonly>

<div class="main main-raised">

	<div class="container">
        <fieldset> 
            <legend> Solicitudes Pendientes </legend>
            <br>
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        
                        <?php $this->load->view('solicitud/tablaPendientes'); ?> 
                        
                    </div>
                </div>
            </div>
            <br>
            <hr/>	
        </fieldset>  

        <fieldset> 
            <legend> Solicitudes a gestionar </legend>
            <br>
            <div class="container">
                <?php $this->load->view('solicitud/formularioBuscar'); ?> 
            </div>
            <div class="container" id="solGestiona">
                <?php $this->load->view('solicitud/tablaGestionar'); ?> 
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