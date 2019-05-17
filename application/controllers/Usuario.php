<?php 

defined('BASEPATH') OR exit('No direct script access allowed');
class Usuario extends CI_Controller{

	public function __construct() {
		parent::__construct();		
        $this->load->model('Gestion_compra_model');
		$this->load->model('Utilidades_model');	
		$this->load->model('Login_model');
        $this->load->model('Usuario_model', 'um', true);
        $this->load->model('Linea_model', 'lm', true);	 	         
	}
	
	/**
	 * Retorna la vista para listar los usuarios
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 28/01/2019
	 * 
	 *  
	 * @return html  Vista para listar los usuarios
	 */
	public function index() {
		$this->Utilidades_model->validaSession();
		$data = array();
		$data['usuarios'] = $this->um->getUsuarios();
		$this->load->view('usuario/index', $data);
	}

	/**
	 * Retorna la vista para agregar/editar las lineas
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 24/01/2019
	 * 
	 *  
	 * @return html  Vista para agregar/editar las lineas
	 */
	public function formulario() {
		$datos                        = array();
		$data                         = array();
		$datos['tiposidentificacion'] = $this->um->getTiposIdentificacion();
        $datos['perfiles']            = $this->um->getPerfiles();
        $datos['estados']             = $this->lm->getEstados(1);
        $tipoAccion                   = $this->input->post("tipoAccion");
		$datos['tipoAccion']          = $tipoAccion;
		
		//Si el tipo de acción es editar
		if ($tipoAccion == 2){
            $codUsuario       = $this->input->post("codUsuario");
            $codPersona       = $this->input->post("codPersona");
            $codPerfil        = $this->input->post("codPerfil");
			$datos['usuario'] = $this->um->getusuario($codUsuario,$codPersona,$codPerfil);
		}
		
		$vista = $this->load->view('usuario/formulario', $datos, true);

		$data['vista'] = $vista;
		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	/**
	 * Retorna json con los datos de la transacción
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 30/01/2019
	 * 
	 * @param integer  $codTipoId         Código del tipo de identificación
     * @param integer  $nroId             Número del tipo de identificación
     * @param string   $primerNombre      Primer nombre del usuario
     * @param string   $segundoNombre     Segundo nombre del usuario
     * @param string   $primerApellido    Primer apellido del usuario
     * @param string   $segundoApellido   Segundo apellido del usuario
     * @param string   $correoElectronico Correo electrónico del usuario
     * @param string   $telefono          Teléfono del usuario
     * @param string   $login             Login del usuario
     * @param string   $clave             Clave del usuario
     * @param integer  $codPerfil         Código del perfil
     * @param integer  $codEstado         Código del estado
	 * 
	 *   
	 * @return application/json  Indica si la transacción se realizo con exito
	 */
	public function guardarusuarios(){
		
		$data  = array();
		$key   = '1a2b3c4d5e6f7g8hijklmno8'; 
		$clave = $this->Utilidades_model->encrypt($this->input->post("txtContrasena"), $key);
				
        $arrayParam['codTipoId']         = $this->input->post("cmbTipoIdentificacion");
		$arrayParam['nroId']             = $this->input->post("txtNroIdentificacion");
        $arrayParam['primerNombre']      = $this->input->post("txtPrimerNombre");
        $arrayParam['segundoNombre']     = $this->input->post("txtSegundoNombre");
		$arrayParam['primerApellido']    = $this->input->post("txtPrimerApellido");
        $arrayParam['segundoApellido']   = $this->input->post("txtSegundoApellido");
        $arrayParam['correoElectronico'] = $this->input->post("txtCorreoElectronico");
		$arrayParam['telefono']          = $this->input->post("txtTelefono");
        $arrayParam['login']             = $this->input->post("txtUsuario");
        $arrayParam['clave']             = $clave;
		$arrayParam['codPerfil']         = $this->input->post("cmbPerfil");
        $arrayParam['codEstado']         = $this->input->post("cmbEstado");
		$tipoAccion                      = $this->input->post("txtTipoAccion");
				
        //Si el tipo de acción es guardar
        if ($tipoAccion == 1){

			//Se valida si el usuario existe
			$codPersona =  $this->um->getExistePersona($arrayParam)->COD_PERSONA;
			
			if ($codPersona != null){

				$data['ret']    = false;
                $data['errors'] = 'Ya existe un usuario con el tipo y número de identificación ingresados';

			} else {

				//Se valida el login
				$codUsuario =  $this->um->getExisteLogin($arrayParam)->COD_USUARIO;
				
				if ($codUsuario != null){

					$data['ret']    = false;
             		$data['errors'] = 'Ya existe un usuario con el login ingresado';

				} else {

					$nombreCompleto = $arrayParam['primerNombre'].' '.$arrayParam['segundoNombre'].' '.$arrayParam['primerApellido'].' '.$arrayParam['segundoApellido'];
					$nombrePerfil   = $this->input->post("txtNombrePerfil");
					$contrasena     = $this->input->post("txtContrasena");
					$login          = $this->input->post("txtUsuario");
					$asunto         = $this->Utilidades_model->getParametro(22)->RESULTADO;
					$mensaje        = $this->Utilidades_model->getParametro(21)->RESULTADO;
					$varMensaje     = array("$1", "$2", "$3","$4");
					$varReemplaza   = array($nombreCompleto, $login, $contrasena,$nombrePerfil);
					$mensajeCorreo  = str_replace($varMensaje, $varReemplaza, $mensaje);

					$arrayCorreo    = array('to'      => $this->input->post("txtCorreoElectronico"),
                                            'asunto'  => $asunto,
							                'mensaje' => $mensajeCorreo,
							                'mensaje2' => '');
							   
					//Se guarda la información de la usuario
					$data = $this->um->saveUsuario($arrayParam);
					//Se envia el email
					$this->Login_model->sendEnviarEmail($arrayCorreo);    
				}

			}

        //Si el tipo de acción es actualizar	
        } else {
            $codusuario = $this->input->post("txtCodusuario");
            //Se guarda la información de la usuario          
            $data = $this->um->updateUsuario($codusuario,$arrayParam);
        }	
			
    	$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	/**
	 * Retorna la vista para cambiar la clave
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 30/01/2019
	 * 
	 *  
	 * @return html  Vista para ver el formulario de cambiar la contreña
	 */
	public function verCambiarClave() {

		$data   = array();
		$vista  = $this->load->view('usuario/cambiarClave', '', true);
		$data['vista'] = $vista;
		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);

	}


	/**
	 * Retorna json con los datos de la transacción
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 01/02/2019
	 * 
	 * @param string  $claveActual      Clave actual del usuario
     * @param string  $claveNueva       Clave nueva del usuario
     * @param string  $claveConfirmada  Confirmación de la clave nueva del usuario
	 * 
	 *   
	 * @return application/json  Indica si la transacción se realizo con exito
	 */
	public function guardarClave(){
		
		$data            = array();
		$codigoUsuario   =  $this->session->userdata('codigo_usuario'); 
		$key             = '1a2b3c4d5e6f7g8hijklmno8'; 
		$claveActual     = $this->Utilidades_model->encrypt($this->input->post("txtContrasenaActual"), $key);
		$claveNueva      = $this->Utilidades_model->encrypt($this->input->post("txtContrasenaNueva"), $key);
	
        
		$codUsuario =  $this->um->getValidaClave($codigoUsuario,$claveActual)->COD_USUARIO;
		
		if ($codUsuario == null){

			$data['ret']    = false;
			$data['errors'] = 'La clave actual ingresada no corresponde a la almacenada en la base de datos';

		} else {

			//Se guarda la información de la usuario
			$data = $this->um->updatePassword($codigoUsuario,$claveNueva);
		}

        $result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}


	/**
	 * Retorna json con los datos de la transacción
	 * 
	 * @author: Ever Hidalgo
	 * @date  : 30/01/2019
	 * 
	 
     * @param string   $primerNombre      Primer nombre del usuario
     * @param string   $segundoNombre     Segundo nombre del usuario
     * @param string   $primerApellido    Primer apellido del usuario
     * @param string   $segundoApellido   Segundo apellido del usuario     
     * @param string   $telefono          Teléfono del usuario
     * @param string   $login             Login del usuario    
	 * 
	 *   
	 * @return application/json  Indica si la transacción se realizo con exito
	 */
	public function guardarusuariosHeader(){


		$arrayPersona = array('primerNombre' => $this->input->post("txtPrimerNombre"), 
	                          'segundoNombre' => $this->input->post("txtSegundoNombre"),
	                          'primerApellido' => $this->input->post("txtPrimerApellido"),
	                          'segundoApellido' => $this->input->post("txtSegundoApellido"),
	                          'telefono' => $this->input->post("txtTelefono"),
	                          'correoElectronico' => $this->input->post("txtCorreoElectronico"),
	                          'codigoPersona' => $this->input->post("txtCodPersona")    
	                         );

		$arrayUsuario = array('login' => $this->input->post("txtUsuario"), 
	                          'codigo_usuario' => $this->input->post("txtCodusuario")
	                         );
          	
      
        //Se guarda la información de la usuario          
        $data = $this->um->updateUsuarioHeader($arrayUsuario,$arrayPersona);


        			
    	$result["ret"] = $data;
		$this->output->set_content_type('application/json')->set_output(json_encode($result));
	}


}