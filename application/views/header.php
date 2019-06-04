<!DOCTYPE html>
<html>
<head> 

 <?php    

      require_once(FCPATH.'application/models/Utilidades_model.php'); 

      $nombre = $this->session->userdata('nombre1').' '.$this->session->userdata('apellido1');    
      $codUser = $this->session->userdata('codigo_usuario');
      $str_classPaginasNoAplica = $this->session->userdata('class_paginas_no_aplica');
      $paginasNoAplica_css = $this->session->userdata('paginas_no_aplica_css');
      $paginasNoAplica_url = $this->session->userdata('paginas_no_aplica_url');
      $nameControler = $this->router->fetch_class();

      $codigoPersona = $this->session->userdata('codigoPersona');
      $codRol = $this->session->userdata('roles');
      
     
      //Validar si el usuario tiene session activa, de ser asi, se valida que tambein tenga permisos para la pagina actual
      if(!$codUser){
          redirect('Login');
      }else{
          if(array_search($nameControler, $paginasNoAplica_url)){
              redirect('Gestion_compra');
          }
      }   
 ?>  

  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Venta productos salud-web</title>
 
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"> 

  <link href="<?php echo base_url()?>asset/public/images/apple-icon.png" rel="apple-touch-icon" sizes="76x76"/>
  <link href="<?php echo base_url()?>asset/public/images/favicon.png" rel="icon" type="image/png"/>
  <!--     Fonts and icons     -->
   <!-- Google Fonts -->
  <!--<link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Roboto+Slab:400,700|Material+Icons" rel="stylesheet" type="text/css"/>-->
  <link href="<?php echo base_url()?>asset/public/font-awesome/css/css_icons.css" rel="stylesheet" type="text/css"/>  
  <link href="<?php echo base_url()?>asset/public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>  
  <link href="<?php echo base_url()?>asset/public/css/material-kit.css?v=2.0.4" rel="stylesheet" type="text/css"/>
  

  <!-- jquery ui  -->
  <link rel="stylesheet" type="text/css" href="<?php echo base_url()?>asset/public/css/jquery-ui.css" rel="stylesheet" type="text/css">     
  

  <!-- Libraries CSS Files -->  
  <!--<link href="<?php echo base_url()?>asset/public/lib/animate/animate.min.css" rel="stylesheet">
  <link href="<?php echo base_url()?>asset/public/lib/ionicons/css/ionicons.min.css" rel="stylesheet">
  <link href="<?php echo base_url()?>asset/public/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
  <link href="<?php echo base_url()?>asset/public/lib/lightbox/css/lightbox.min.css" rel="stylesheet"> -->

  <!-- input file --> 
  <link rel="stylesheet" type="text/css" href="<?php echo base_url()?>asset/public/css/fileinput.css" rel="stylesheet" type="text/css">  
   
   <!-- Datatable --> 
  <link rel="stylesheet" type="text/css" href="<?php echo base_url()?>asset/public/css/jquery.dataTables.min.css" rel="stylesheet" type="text/css">
  <link rel="stylesheet" type="text/css" href="<?php echo base_url()?>asset/public/css/jquery.dataTables_themeroller.css" rel="stylesheet" type="text/css">     
  <link rel="stylesheet" type="text/css" href="<?php echo base_url()?>asset/public/css/buttons.dataTables.min.css" rel="stylesheet" type="text/css">
  <link rel="stylesheet" type="text/css" href="<?php echo base_url()?>asset/public/css/colReorder.dataTables.min.css" rel="stylesheet" type="text/css">
 
  <!-- tables responsive --> 
  <link rel="stylesheet" type="text/css" href="<?php echo base_url()?>asset/public/css/responsive.bootstrap.min.css" rel="stylesheet" type="text/css">   


  <link href="<?php echo base_url()?>asset/public/css/alertify.min.css" rel="stylesheet" type="text/css"/>

  <!-- selector multiple --> 
  <link rel="stylesheet" type="text/css" href="<?php echo base_url()?>asset/public/css/multipleselect/multiple-select.css" rel="stylesheet" type="text/css">

   <!-- boostrap select --> 
   <link rel="stylesheet" type="text/css" href="<?php echo base_url()?>asset/public/css/bootstrap-select.min.css" rel="stylesheet" type="text/css">   
 
  <!-- date picker -->
  <link href="<?php echo base_url()?>asset/public/css/gijgo.min.css" rel="stylesheet" type="text/css"/>
  <!--<link href="<?php echo base_url()?>asset/public/css/core.css" rel="stylesheet" type="text/css"/>-->
    
  <!-- CSS Just for demo purpose, don't include it in your project -->
  <link href="<?php echo base_url()?>asset/public/css/demo.css" rel="stylesheet" type="text/css"/>

  <!-- Main Stylesheet File -->
  <!--<link href="<?php echo base_url()?>asset/public/lib/css/style.css" rel="stylesheet"> -->

  <link href="<?php echo base_url()?>asset/public/user/css/styles_general.css" rel="stylesheet" type="text/css"/> 
  
  <!-- se agregan clases para no visualizar en el munu las paginas a las que el usuario no tiene permisos -->
  <style> <?php echo $str_classPaginasNoAplica; ?> </style>
  
  <!-- Definir variable global con las clases de las opciones del menu, a las que no tiene permiso el usuario -->
  <script type="text/javascript">
      const global_paginasNoAplica = <?php echo json_encode($paginasNoAplica_css); ?>;
      const global_codigo_usuario = <?php echo json_encode($codUser); ?>;
      const global_codigo_persona = <?php echo json_encode($codigoPersona); ?>;
      const global_roles = <?php echo json_encode($codRol); ?>;
      const global_tiempoMaxInact = <?php echo  $this->Utilidades_model->getParametro(77)->RESULTADO?>;
  </script>
</head>

<body class="login-page sidebar-collapse">
   <nav class="navbar navbar-transparent navbar-color-on-scroll fixed-top navbar-expand-lg" color-on-scroll="100" id="sectionsNav">
    <div class="container">
      <div class="navbar-translate">
        <img src="<?php echo base_url()?>asset/public/images/logoC.png" class="logo-vd"></a>     
        <button class="navbar-toggler" type="button" data-toggle="collapse" aria-expanded="false" aria-label="Toggle navigation">
          <span class="sr-only">Toggle navigation</span>
          <span class="navbar-toggler-icon"></span>
          <span class="navbar-toggler-icon"></span>
          <span class="navbar-toggler-icon"></span>
        </button>
      </div>
      <div class="collapse navbar-collapse">
        <ul class="navbar-nav ml-auto nav-menu">
            <li class="nav-item">
              <a id="a_admin" class="nav-link menu-home" href="#" onclick="redHome();">
                <i class="material-icons">home</i> Home
              </a>
            </li>   
           <li class="dropdown nav-item">
              <a id="a_admin" href="#" class="dropdown-toggle nav-link menu-administracion" data-toggle="dropdown">
                <i class="material-icons">apps</i> Administraci&oacute;n
              </a>
              <div class="dropdown-menu dropdown-with-icons">
               <a id="a_gestionar_pedido" href="#" onclick="gestionarImgPromo();" class="dropdown-item menu-images">
                 <i class="material-icons">add_to_photos</i> Imagenes 
               </a> 
               <a href="<?php echo base_url(); ?>Linea" class="dropdown-item menu-linea">
                 <i class="material-icons">local_grocery_store</i> Productos 
               </a> 
               <a href="<?php echo base_url(); ?>Tarifa" class="dropdown-item menu-tarifa">
                 <i class="material-icons">attach_money</i> Tarifas y promociones 
               </a>
               <a href="<?php echo base_url(); ?>Usuario" class="dropdown-item menu-usuario">
                 <i class="material-icons">group</i> Administrar Usuarios
               </a> 
              </div>             
           </li> 
           <li class="dropdown nav-item">
              <a id="a_admin" href="#" class="dropdown-toggle nav-link menu-operaciones" data-toggle="dropdown">
                <i class="material-icons">library_books</i> Operaciones
              </a>
              <div class="dropdown-menu dropdown-with-icons">
               <a href="<?php echo base_url(); ?>Solicitud" class="dropdown-item menu-solicitud">
                 <i class="material-icons">swap_horiz</i> Gestión solicitudes
               </a> 
               <a href="<?php echo base_url(); ?>Consulta" class="dropdown-item menu-consulta">
                 <i class="material-icons">pageview</i> Consultar solicitudes
               </a>                           
              </div>
             
           </li> 
                   
           <li class="dropdown nav-item">
              <a id="a_admin" href="#" class="dropdown-toggle nav-link" data-toggle="dropdown">
                <i class="material-icons">person_outline</i> <?php echo $nombre ?>
              </a>
              <div class="dropdown-menu dropdown-with-icons">
                <a id="parametrizarUsuarioEditar" href="#" class="dropdown-item">
                  <i class="material-icons">person_outline</i> Actualizar datos 
                </a>
                <a id="verCambiarClave" href="#" class="dropdown-item">
                  <i class="material-icons">lock</i> Cambiar clave 
                </a>
                <a title ="Cerrar sessión" href="<?php echo base_url('Login/logout')?>" class="dropdown-item">
                  <i class="material-icons">power_settings_new</i> Cerrar sesi&oacute;n 
                </a> 
              </div>
           </li> 
                           
        </ul>
      </div>
    </div>
  </nav>
  <div class="page-header header-vd" data-parallax="true"></div>

  
  




 
   
  

