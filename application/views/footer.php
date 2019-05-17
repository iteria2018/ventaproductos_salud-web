
<!-- Footer -->
<footer class="page-footer font-small">

    <!-- Footer Links -->
    <div class="container-fluid text-center text-md-left" style="background:#cccccc !important;">
        <div class="row"  style="display: flex !important;">
            <div class="col-md-6">
                 
                <h5 class="text-uppercase">
                    <strong> <?php  echo $this->session->userdata('titulo1Footer'); ?> </strong>
                </h5>
                <p class="text-secondary"><?php  echo $this->session->userdata('datos1Footer'); ?></p>
            </div>  
            <div class="col-md-3">
                <h5 class="text-uppercase">
                    <strong><?php  echo $this->session->userdata('titulo2Footer'); ?></strong>
                </h5>
                <?php  echo $this->session->userdata('datos2Footer'); ?>               
            </div>  
            <div class="col-md-3 text-center">
                <span id="verAyuda" class="text-secondary" style="cursor:pointer;">
                    <h5 class="text-uppercase">
                        <strong>Ayuda</strong>
                    </h5>
                    <img class="img-fluid" src="<?php echo base_url()?>asset/public/images/ayuda.png" alt="Ayuda" width="100px" >
                </span>
            </div>
        </div>

        <div class="row">
            <div class="col-12 footer-copyright text-center py-3 bg-secondary text-white">
              Copyright ©
                <?php echo date('Y'); ?> COOMEVA MEDICINA PREPAGADA S.A
            , Todos los derechos reservados.
            </div>
        </div>
      
    </div>

</footer>
<!-- Footer -->
    

    <script src="<?php echo site_url() ?>asset/public/js/jquery.min.js">
    </script>
    <script src="<?php echo site_url() ?>asset/public/js/popper.min.js">
    </script>
    <script src="<?php echo site_url() ?>asset/public/js/bootstrap-material-design.min.js">
    </script>
    <script src="<?php echo site_url() ?>asset/public/js/moment.min.js">
    </script>
    <script src="<?php echo site_url() ?>asset/public/js/nouislider.min.js">
    </script>
    <script src="<?php echo site_url() ?>asset/public/js/jquery.sharrre.js">
    </script>
    <script src="<?php echo site_url() ?>asset/public/js/material-kit.js?v=2.0.4">
    </script>
    <script src="<?php echo site_url() ?>asset/public/js/alertify.min.js">
    </script>
     <!-- file input-->    
    <script src="<?php echo site_url() ?>asset/public/js/fileinput.min.js"></script>    
    <script src="<?php echo site_url() ?>asset/public/js/fileinput_locale_es.js"></script> 
    <!-- fin lib otra pagina -->    
    <!-- datatable -->
    <script src="<?php echo site_url() ?>asset/public/js/jquery.dataTables.min.js"></script> 
    <script src="<?php echo site_url() ?>asset/public/js/dataTables.colReorder.min.js"></script>
    <script src="<?php echo site_url() ?>asset/public/js/dataTables.buttons.min.js"></script>
    <!-- fin datatable -->
    
    <!--tabla resonsive-->
    <script src="<?php echo site_url() ?>asset/public/js/dataTables.responsive.min.js"></script> 
    <script src="<?php echo site_url() ?>asset/public/js/responsive.bootstrap.min.js"></script>      
    
    <!-- multiple select -->
    <script src="<?php echo site_url() ?>asset/public/js/multiple-select.js"></script>  

    <!-- select boostrap -->    
    <script src="<?php echo site_url() ?>asset/public/js/bootstrap-select.min.js"></script> 

    <!-- datetimepicker -->
    <script src="<?php echo site_url() ?>asset/public/js/gijgo.min.js"></script> 
    <script src="<?php echo site_url() ?>asset/public/js/local_datepicker4/messages.es-es.min.js"></script>
    <!--<script src="<?php echo site_url() ?>asset/public/js/core.js"></script> -->

    <!-- amchart -->
    <!--<script src="<?php echo site_url() ?>asset/public/js/amcharts/amcharts.js"></script> 
    <script src="<?php echo site_url() ?>asset/public/js/amcharts/serial.js"></script> -->     
        
    <script src="<?php echo site_url() ?>asset/public/user/js/funciones_generales.js">
    </script>
    <script src="<?php echo site_url() ?>asset/public/js/PassRequirements.js">
    </script>

    <script src="<?php echo site_url() ?>asset/public/user/js/header.js"></script>          
    
  </body>
</html>