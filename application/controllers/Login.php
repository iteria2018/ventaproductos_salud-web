<?php 

  defined('BASEPATH') OR exit('No direct script access allowed');
  class Login extends CI_Controller{
  	
  	 public function __construct() {
      parent::__construct(); 
       $this->load->model('Login_model'); 
       $this->load->model('Utilidades_model'); 
       $this->load->model('WebService_model', 'wsm', true);    
  	 }
	 
	 public function index() {

      $data["tipoIdentificacion"] =  $this->getSelTipoDocumento();
      $data["sexo"] = $this->getSelSexo();
      $this->load->view('login',$data);

    }

    public function getSelTipoDocumento(){
        
        $data = $this->Login_model->getTipoIdentificacion();
        $cadenaLista = '<select id="tipo_identificacion" name="tipo_identificacion" data-width="100%" class="form-control lista-vd"><option value="-1" >Seleccione un tipo de documento</option>';

        if ($data != false) {
          for($p=0; $p<count($data); $p++){
              $dato =  $data[$p];
              $nombre = $dato['NOMBRE'];            
              $cadenaLista .= '<option data_abr ="'.$dato['NOMBRE_ABR'].'"  value="'.$dato['CODIGO'].'" >'.$dato['NOMBRE'].'</option>';
          }
        }  

        $cadenaLista .= '</select>';
        return $cadenaLista;
    }

    public function getSelSexo(){
        
        $data = $this->Login_model->getSexo();
        $cadenaLista = '<select id="lit_sexo" name="lit_sexo" data-width="100%" class="form-control lista-vd"><option value="-1" >Seleccione el sexo</option>';

        if ($data != false) {
          for($p=0; $p<count($data); $p++){
              $dato =  $data[$p];
              $nombre = $dato['NOMBRE'];            
              $cadenaLista .= '<option data_abr ="'.$dato['NOMBRE_ABR'].'"  value="'.$dato['CODIGO'].'" >'.$dato['NOMBRE'].'</option>';
          }
        }  

        $cadenaLista .= '</select>';
        return $cadenaLista;
    }

    
  	 public function loguear(){

      $key = '1a2b3c4d5e6f7g8hijklmno8';          
      $usuario = $this->input->post('usuario');
      $clave = $this->input->post('clave');

      $claveEncript=$this->Utilidades_model->encrypt($clave, $key);
  	 
       $datos = array('login' => $usuario, 
                     'clave' => $claveEncript                   
                    );   

       $data = $this->Login_model->validarUsuario($datos);       
      
      if ($data != false) {            

            for ($i=0; $i < count($data) ; $i++) {
                   $fila = $data[$i];
                   $paginasNoAplica = json_decode($fila["PAGINAS_NO_APLICA"],true);
                   
                   $datosUsuario= array('codigoPersona' => $fila["COD_PERSONA"],
                                        'tipo_identificacion' => $fila["COD_TIPO_IDENTIFICACION"],
                                        'identificacion' => $fila["NUMERO_IDENTIFICACION"],
                                        'nombre1' => mb_convert_case($fila["NOMBRE_1"], MB_CASE_TITLE, "UTF-8"),                                
                                        'nombre2' => mb_convert_case($fila["NOMBRE_2"], MB_CASE_TITLE, "UTF-8"),                                
                                        'apellido1' => mb_convert_case($fila["APELLIDO_1"], MB_CASE_TITLE, "UTF-8"),
                                        'apellido2' => mb_convert_case($fila["APELLIDO_2"], MB_CASE_TITLE, "UTF-8"),
                                        'nom_completo' => mb_convert_case($fila["NOMBRE_COMPLETO"], MB_CASE_TITLE, "UTF-8"),
                                        'fecha_nacimiento' => $fila["FECHA_NACIMIENTO"],
                                        'edad' => $fila["EDAD"],                                        
                                        'telefono' => $fila["TELEFONO"],  
                                        'celular' => $fila["CELULAR"],
                                        'email' => $fila["EMAIL"],  
                                        'direccion' => $fila["DIRECCION"],  
                                        'sexo' => $fila["COD_SEXO"],  
                                        'codigo_usuario' => $fila["COD_USUARIO"], 
                                        'login_usuario' => $fila["LOGIN"],                                                                                
                                        'roles' => $fila["ROLESS"],
                                        'codigo_plan' =>  $fila["CODIGO_PLAN"] == null ? 0 : $fila["CODIGO_PLAN"],
                                        'titulo1Footer' =>  $this->Utilidades_model->getParametro(23)->RESULTADO, 
                                        'datos1Footer' =>  $this->Utilidades_model->getParametro(24)->RESULTADO,  
                                        'titulo2Footer' =>  $this->Utilidades_model->getParametro(25)->RESULTADO,  
                                        'datos2Footer' =>  $this->Utilidades_model->getParametro(26)->RESULTADO,
                                        'tipo_identificacion_abr' => $fila["DES_TIP_IDENT_SMALL"],
                                        'paginas_no_aplica_css' => $paginasNoAplica['css'],
                                        'paginas_no_aplica_url' => $paginasNoAplica['url'],
                                        'class_paginas_no_aplica' => $this->getCalssPageNot($paginasNoAplica['css'])                                        
                                        );

            }  
         
            $this->session->set_userdata($datosUsuario);            

            $user_agent = $_SERVER['HTTP_USER_AGENT'];       
            $browser = $this->Utilidades_model->getBrowser($user_agent);
            $ip = $this->Utilidades_model->getRealIpAddr();

            $datosLogUsuarios = array('login' => $usuario,
                                      'ip' => $ip, 
                                      'navegador' => $browser);
            $this->Login_model->guardarLogUsuariosSistemas($datosLogUsuarios);
            
           $data["respuesta"]='OK';      

      }else{
          $validUserInactivo = $this->Login_model->validarUsuarioInactivo_data($datos);
          if($validUserInactivo){
              $data["respuesta"]='El usuario se encuentra inactivo, por favor comun&iacute;quese con el administrador.';
          }else{
              $data["respuesta"]='NO';
          }
          
      }
       $this->output->set_content_type('application/json')->set_output(json_encode($data));       
      

  	 }   	

    public function guardarUsuario(){

      $usuario = $this->input->post("usu");
      $codigo_usuario = $this->input->post("codigo_usuario"); 
      $aux_tipo_identificacion = $this->input->post("tipo_identificacion");
      $aux_identificacion = $this->input->post("identificacion");    
      $existeUsu = $this->Login_model->existeUsuario($usuario,$codigo_usuario);
      $existe_persona = $this->Login_model->existePersonaUsuario($usuario,$aux_identificacion,$aux_tipo_identificacion); 
      $clave = "";

      if ($existeUsu == "NO") {
        if ($existe_persona == "NO") {

         if ($this->input->post('contrasena') != "") {   
         
            $key = '1a2b3c4d5e6f7g8hijklmno8'; 
            $clave = $this->Utilidades_model->encrypt($this->input->post('contrasena'), $key); 
         }       
            
        $obj = array(  
                     'tipo_identificacion' => $aux_tipo_identificacion,                     
                     'identificacion' => $aux_identificacion,
                     'codigo' => $codigo_usuario, 
                     'nombre1' => $this->input->post("nombre1"),
                     'nombre2' => $this->input->post("nombre2"), 
                     'apellido1' => $this->input->post("apellido1"),
                     'apellido2' => $this->input->post("apellido2"),
                     'fecha_nacimiento' => $this->input->post("fecha_nacimiento"), 
                     'lit_sexo' => $this->input->post("lit_sexo"),                    
                     'telefono' => $this->input->post("telefono"),
                     'celular' => $this->input->post("celular"),
                     'email' => $this->input->post("correo"),                    
                     'usuario' => $this->input->post("usu"),                     
                     'clave' => $clave,
                     'codigo_tipo_persona' =>  $this->input->post("codigo_tipo_persona"),
                     'codigo_plan' =>  $this->input->post("codigo_plan"),
                     'estado'  => 1                  
                     ); 
            
            $result = $this->Login_model->guardarUsuario($obj);
            $retorno['respuesta'] = $result;

            /*$datos = json_decode($result->result);              

            $retorno['exception']=$datos->respuesta;              
            $retorno['respuesta']=$datos->mensaje;*/ 

      }else{
        $retorno["respuesta"] = 'La identificaci&oacute;n ingresada ya existe. Por favor intente nuevamente';
      }                        

      }else{
        $retorno["respuesta"] = 'El usuario ingresado ya existe. Por favor intente nuevamente';
      }       


      $this->output->set_content_type('application/json')->set_output(json_encode($retorno));
    
  }

  public function recordarContrasena(){       

      $identificacion = $this->input->post("identificacion_rest");      
      $resultDatos = $this->Login_model->getDatosPersona($identificacion);  
      $array_data = array();    

      if ($resultDatos == false) {
        $array_data['respuesta'] = 'La identificaci&oacute;n ingresada no existe. Por favor intente nuevamente';
      }else{ 

          $cod_verificacion = $this->Login_model->updateCodigoSeg($identificacion);//rand(1000,9999);
          $key='1a2b3c4d5e6f7g8hijklmno8';
          $cod_verificacionEncript = $this->Utilidades_model->encrypt($cod_verificacion, $key);        

          $correo_ini = "";      
          $correo_fin = "";

          $param1 = 2;
          $param2 = 3;
          $aux_email = $resultDatos[0]["EMAIL"];
          $from = $this->Utilidades_model->getParametro($param1)->RESULTADO;
          $url = $this->Utilidades_model->getParametro($param2)->RESULTADO;
          $to = $aux_email; 
          $name = "Coomeva MP";

          $mensaje = '<div style="font-family: arial; background: #f2f2f2">
                      <div style="text-align: center;">                        
                        <img src="https://drive.google.com/uc?export=view&id=12--oDEi44rsUaQuWl8iCq7hsIFbIx2V6">
                      </div>
                          <br>
                      <div style="background: #ffffff;border-radius: 10px;width: 51%;margin-left: 24%;font-size:20px">
                         <br>                          
                          <p style="padding-left: 10px;">Hemos recibido solicitud para el cambio de contrase&ntilde;a de <b>'.$resultDatos[0]["NOMBRE_COMPLETO"].'</b></p> 
                          <p style="padding-left: 10px;">A continuaci&oacute;n confirmamos tus datos:</p>
                          <div style="padding-left: 10px;"> 
                            <p style="color:#0061a1">
                              Nombre de usuario: <b>'.$resultDatos[0]["LOGIN"].'</b>                           
                            </p>
                            <p style="color:#0061a1">                             
                              C&oacute;digo de seguridad: <b>'.$cod_verificacion.'</b>
                            </p>
                          </div>
                          <br>
                          <div style="text-align: center;">
                            <h3>
                               PARA ACTIVAR UNA NUEVA CONTRASE&Ntilde;A                             
                            </h3>
                            <a class="prueba" href="'.$url.'Login?senal=1~'.$cod_verificacionEncript.'">
                              <img style="cursor: pointer;" src="https://drive.google.com/uc?export=view&id=17I5f8PRrsF61mw1SG-UQwqNhJ01FqUdG">
                            </a>                  
                        </div>
                          <br>
                      </div> 
                      <div style="text-align: center;">
                           <img src="https://drive.google.com/uc?export=view&id=1aIoHN1cWTysLWrn17j8mrR-Qsu68406K">                              
                      </div>                     
                      <div style="text-align: center;">
                          <img src="https://drive.google.com/uc?export=view&id=1H75jbE24KhUhX4zeaFH-biQQgKX_uciN">
                      </div>
                  </div>';

          //$mensaje = "<label style='font-size: 12;'>Estimado usuario</label>, <br><br>  <label style='font-size: 12;'>Hemos recibido la solicitud para cambio de clave de <b>".$resultDatos[0]["NOMBRE_COMPLETO"]."</b>, a continuaci&oacute;n confirmamos sus datos:</label><br><br><br> Nombre de usuario:  <b>".$resultDatos[0]["LOGIN"]."</b><br> C&oacute;digo de seguridad:<b> ".$cod_verificacion."</b><br><br><br>Para cambiar su clave ingrese a este <a href='".$url."/Login?senal=1~".$cod_verificacionEncript."'>Link</a>";
          $asunto = "Olvido de contrasena"; 
          $pos = strpos($aux_email,"@");
          $correo_ini = substr($aux_email,0,3);    
          $correo_fin = substr($aux_email,$pos,strlen($aux_email)); 

          $aux_array_datos = array('to' => $aux_email,
                               'asunto' => $asunto,
                               'mensaje' => $mensaje,
                               'mensaje2' => '');

          $result = $this->Login_model->sendEnviarEmail($aux_array_datos);           
           
          $array_data["respuesta"] = $result->RESPUESTA;
          $array_data["codigo_verificacion"] = $cod_verificacion;
          $array_data["correo"] = $correo_ini."....".$correo_fin;         
      }
     
       $this->output->set_content_type('application/json')->set_output(json_encode($array_data));
  }

   public function cambiarContrasena(){      

          $key = '1a2b3c4d5e6f7g8hijklmno8'; 
          $clave = $this->Utilidades_model->encrypt($this->input->post('clave1_rest'), $key);
          $identificacion = $this->input->post("identificacion_rest"); 
          $codigoEnviado = $this->input->post("codigo_rest");               
              
          $result = $this->Login_model->cambiarContrasena($identificacion,$codigoEnviado,$clave);

          $retorno['respuesta'] = $result;          
       
          $this->output->set_content_type('application/json')->set_output(json_encode($retorno));
    
   }

   public function logout() {
      $this->session->sess_destroy();
      redirect('Login');
   }  

   public function getDataCurl(){

      $identificacion = trim($this->input->post("identificacion")); 
      $tipoIdentificacion = trim($this->input->post("tipo_identificacion"));
      $cod_tipo_ident = trim($this->input->post("cod_tipo_ident"));

      $parametros = array('documento' => $identificacion,
                          'tipo_documento' => $tipoIdentificacion);

      $parametrosPerso = array('documento' => $identificacion,
                          'tipo_documento' => $cod_tipo_ident);

      //$datos = json_decode($this->Utilidades_model->getDataCurl($parametros),true);
      $datos = $this->Login_model->getInfoPersona_data($parametrosPerso);
  
      if ($datos == false) {
        $datos = null;
        $datos = json_decode($this->Utilidades_model->getDataCurl($parametros),true);        
        if ($datos != null) {
          if ($datos["errorBean"]["codigo"] == -1) {
            $datos = null;
            $datos=$this->wsm->validaUsuarioAsociado($parametros["tipo_documento"],$parametros["documento"]);
            if ($datos[0]['existe'] > 0) {
              $retorno["datos"] =  'VACIO';
              $retorno["tipo"] =  3;
            } else {
              $retorno["datos"] =  'VACIO';
              $retorno["tipo"] =  0;
            }
            
          }else{  
            $retorno["datos"] =  $datos;
            $retorno["tipo"] =  1;
          } 
        }else{                    
            $retorno["datos"] = 'VACIO';
            $retorno["tipo"] =  0;             
        }
      }else{
         //$datos = $this->Login_model->getInfoPersona_data($parametrosPerso); 
            $retorno["datos"] =  $datos;
            $retorno["tipo"] =  2;        
      } 

      $this->output->set_content_type('application/json')->set_output(json_encode($retorno));      
   }

   public function sendEmailCodSeg(){

      $cod_verificacion = rand(1000,9999);
      $correo_ini = "";      
      $correo_fin = "";

      $param1 = 2;
      $aux_email = $this->input->post("correo");
      $from = $this->Utilidades_model->getParametro($param1)->RESULTADO;
      $to = $aux_email; 
      $name = "Coomeva MP";
      $mensaje = ' <div style="text-align: center;font-family: arial; background: #f2f2f2">
                      <div>
                        <img src="http://drive.google.com/uc?export=view&id=1dGXuqXaso6abPfdhIfihauu01nFsn-Zu">
                      </div>
                          <br>
                      <div style="background: #ffffff;border-radius: 10px;width: 51%;margin-left: 24%;font-size:20px">
                         <br> 
                          <h1>
                            ¡Bienvenidos!
                          </h1>
                          <p>Gracias por elegir a <b>Coomeva Medicina Prepagada</b></p> 
                          <br>
                          <p>
                             Para acceder a tu cuenta ingresa el siguiente c&oacute;digo de verificaci&oacute;n:   
                          </p>
                          <div style="background: #0371b8; color: white; font-size: 30px;width: 114px; margin-left: 40%">
                             '.$cod_verificacion.'
                          </div>
                          <br>
                      </div>                      
                      <div>
                        <img src="http://drive.google.com/uc?export=view&id=1cf_bqVGz_YVVaPRrsfQjWYy2mzgA4ITy"> 
                      </div>
                     </div>';               
      $asunto = "Codigo de verificacion"; 
      $pos = strpos($aux_email,"@");
      $correo_ini = substr($aux_email,0,3);    
      $correo_fin = substr($aux_email,$pos,strlen($aux_email));

      $aux_array_datos = array('to' => $aux_email,
                               'asunto' => $asunto,
                               'mensaje' => $mensaje,
                               'mensaje2' => '');

      $result = $this->Login_model->sendEnviarEmail($aux_array_datos);      
     
      $array_data = array();
      $array_data["respuesta"] = $result->RESPUESTA; // si o no
      $array_data["codigo_verificacion"] = $cod_verificacion;
      $array_data["correo"] = $correo_ini."....".$correo_fin;

      $this->output->set_content_type('application/json')->set_output(json_encode($array_data));
        
   }
   
    public function getCalssPageNot($paginas){
      $str_class = '';
      $obj_paginas = $paginas;

        for($p=0; $p<count($obj_paginas); $p++){
            $str_class .= '.'.$obj_paginas[$p].'{ display:none; } ';
        }

        return $str_class;
    }


  }   


 ?>