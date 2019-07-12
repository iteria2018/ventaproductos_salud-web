    <?php 
        
        $arregloDatos = array();
        $tokenUrl = array();
        $url = ""; 
        $codigoDecript = 0;  
        $aux_senal = 0;    

        if (isset($_GET['senal'])) {
           
           $key = '1a2b3c4d5e6f7g8hijklmno8';              
           $url = $_SERVER['REQUEST_URI'];             
           $tokenUrl = explode('?senal=',$url);
           $arregloDatos = explode('~',$tokenUrl[1]); 

           if(count($arregloDatos) == 2){
             $codigoDecript = $this->Utilidades_model->decrypt($arregloDatos[1],$key);             
             $aux_senal = $arregloDatos[0];             
           }  

        }                    

 ?>
<script type="text/javascript">
    const  g_listaTipoIdentificacion =  <?php echo  json_encode($tipoIdentificacion)?>;
    const g_listaSexo =  <?php echo  json_encode($sexo)?>; 
    var global_codigo_verificacion = <?php echo $codigoDecript?>; 
    var global_senal = <?php echo  $aux_senal?>;

</script>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8"/>
        <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0, shrink-to-fit=no" name="viewport"/>
        <meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible"/>
        <title>
            Login
        </title>
        <link href="<?php echo base_url()?>asset/public/images/apple-icon.png" rel="apple-touch-icon" sizes="76x76"/>
        <link href="<?php echo base_url()?>asset/public/images/favicon.png" rel="icon" type="image/png"/>
        <!--     Fonts and icons     -->
        <link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Roboto+Slab:400,700|Material+Icons" rel="stylesheet" type="text/css"/>
        <link href="<?php echo base_url()?>asset/public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
        <link href="<?php echo base_url()?>asset/public/css/material-kit.css?v=2.0.4" rel="stylesheet" type="text/css"/>
        <link href="<?php echo base_url()?>asset/public/css/alertify.min.css" rel="stylesheet" type="text/css"/>

        <!-- input file --> 
        <link rel="stylesheet" type="text/css" href="<?php echo base_url()?>asset/public/css/fileinput.css" rel="stylesheet" type="text/css">  
 
        <!-- selector multiple --> 
        <link rel="stylesheet" type="text/css" href="<?php echo base_url()?>asset/public/css/multipleselect/multiple-select.css" rel="stylesheet" type="text/css"> 
   
        <!-- boostrap select --> 
        <link rel="stylesheet" type="text/css" href="<?php echo base_url()?>asset/public/css/bootstrap-select.min.css" rel="stylesheet" type="text/css">   
   
        <!-- dateTimePicker -->         
        <link href="<?php echo base_url()?>asset/public/css/gijgo.min.css" rel="stylesheet" type="text/css"/>
        <!--<link href="<?php echo base_url()?>asset/public/css/core.css" rel="stylesheet" type="text/css"/> -->
    
        <!-- CSS Just for demo purpose, don't include it in your project -->
        <link href="<?php echo base_url()?>asset/public/css/demo.css" rel="stylesheet" type="text/css"/>
        <link href="<?php echo base_url()?>asset/public/user/css/styles_general.css" rel="stylesheet" type="text/css"/>
        <link href="<?php echo base_url()?>asset/public/css/jquerysctipttop.css" rel="stylesheet" type="text/css"/>
    </head>
    <!--<body class="login-page sidebar-collapse" oncontextmenu="return false" ondragstart="return false" onselectstart="return false"> -->
    <body class="login-page sidebar-collapse">
        <div class="page-header header-filter" style="background-image: url('<?php echo base_url()?>asset/public/images/inicio_login.jpg'); background-size: cover; background-position: top center;">
            <div class="container">
                <div class="row">
                    <div class="col-lg-4 ml-auto mr-auto my-auto">
                        <img src="<?php echo base_url()?>asset/public/images/logo_coomeva_mp.png" style="width:26%; position:fixed">
                        <div style="margin-bottom: 140px;"></div>
                    </div>
                    <div class="col-lg-8 col-md-12 ml-auto mr-auto my-auto">                        
                        <div class="card card-login">
                           <div class="row">
                            <div class="col-lg-6 col-md-6 col-sm-12">
                            <form autocomplete="off" class="form" id="form_login" name="form_login">
                                <div class="text-center">
                                    <h4 class="card-title font-weight-bold" style="font-size: 25px;">
                                     Iniciar sesi&oacute;n
                                    </h4>
                                    <div class="social-line">
                                    </div>
                                </div>
                                <p class="description text-center">
                                </p>
                                <div class="card-body">
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text">
                                                <i class="material-icons">
                                                    face
                                                </i>
                                            </span>
                                        </div>
                                        <input class="form-control style_input" id="usuario" name="usuario" placeholder="Login" type="text"/>
                                    </div>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text">
                                                <i class="material-icons">
                                                    lock_outline
                                                </i>
                                            </span>
                                        </div>
                                        <input class="form-control style_input" id="clave" name="clave" placeholder="Clave" type="password"/>
                                    </div>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text">
                                                <i class="material-icons">
                                                    mail
                                                </i>
                                            </span>
                                        </div>
                                        <a href="#"  id="btn-registrar" name="btn-registrar">
                                            Registrarme
                                        </a>                                        
                                    </div>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text">
                                                <i class="material-icons">
                                                    help
                                                </i>
                                            </span>
                                        </div>
                                        <a class="" href="#" id="btn-restablecer">
                                            Olvido su clave?
                                        </a>
                                        
                                                                               
                                    </div>
                                     <br>
                                </div>
                                <br>
                                <div class="footer text-center"> 
                                       <a class="btn btn-primary btn-link btn-wd btn-lg" href="#" id="btn-enviar" name="btn-enviar">
                                            Ingresar
                                       </a>                                                                 
                                </div>
                            </form>
                            </div>
                             <div class="col-lg-6 col-md-6 col-sm-12">
                                <img src="<?php echo base_url()?>asset/public/images/inicio.png" class="img-fluid">
                             </div>   
                            </div>
                        </div>
                    </div>
                    
                </div>
            </div>
           
            <footer class="footer">
                <div class="container">
                    <div class="copyright center">
                    Copyright ©
                    <?php echo date('Y'); ?> COOMEVA MEDICINA PREPAGADA S.A
                    , Todos los derechos reservados.
                    </div>
                </div>                
            </footer>
        </div>
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
        <!-- multiple select -->
        <script src="<?php echo site_url() ?>asset/public/js/multiple-select.js"></script>
        <!-- select boostrap -->    
        <script src="<?php echo site_url() ?>asset/public/js/bootstrap-select.min.js"></script> 
        <!-- file input-->    
        <script src="<?php echo site_url() ?>asset/public/js/fileinput.min.js"></script>    
        <script src="<?php echo site_url() ?>asset/public/js/fileinput_locale_es.js"></script> 
            <script src="<?php echo site_url() ?>asset/public/user/js/login.js">
        </script>
        <script src="<?php echo site_url() ?>asset/public/user/js/funciones_generales.js">
        </script>
        <script src="<?php echo site_url() ?>asset/public/js/PassRequirements.js">
        </script>
        <!-- datetimepicker -->
        <script src="<?php echo site_url() ?>asset/public/js/gijgo.min.js"></script> 
        <script src="<?php echo site_url() ?>asset/public/js/local_datepicker4/messages.es-es.min.js"></script>
        <!--<script src="<?php echo site_url() ?>asset/public/js/core.js"></script> -->
        <script src="<?php echo site_url() ?>asset/public/js/get_ParameterUrl.js"></script>

        <style type="text/css">
            .card-login .form {
                min-height: 355px !important;
            }
            label{
                margin-top: 12px !important;
            }                        
        </style>
    </body>
</html>
