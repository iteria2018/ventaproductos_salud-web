<?php 

defined('BASEPATH') OR exit('No direct script access allowed');
class Solicitud extends CI_Controller{

	public function __construct() {
		parent::__construct();		
        $this->load->model('Gestion_compra_model');
        $this->load->model('Utilidades_model');	
        $this->load->model('Solicitud_model', 'sm', true);	 
		$this->load->model('Linea_model', 'lm', true);         
	}
	
	/**
	 * Retorna la vista para listar las Solicitudes pendientes y por gestionar
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 28/01/2019
	 * 
	 *  
	 * @return html  Vista para listar las Solicitudes
	 */
	public function index() {
		$this->Utilidades_model->validaSession();
		$data = array();
		$codUsuario                       = $this->session->userdata('codigo_usuario'); //ID USER SESSION
		$data['estados']                  = $this->lm->getEstados(2);
		$data['solicitudesPendientes']    = $this->sm->getSolicitudesPendientes($codUsuario);
		$data['solicitudesGestionar']     = $this->sm->getSolicitudesGestionar(); 
		$data['validaSolicitudEnGestion'] = $this->sm->getSolicitudGestion($codUsuario)->COD_SOLICITUD;
		$this->load->view('solicitud/index', $data);
	}

	/**
	 * Retorna la vista para listar las solicitudes
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 28/01/2019
	 * 
	 *  
	 * @return html  Vista para listar las lineas
	 */
	public function buscarSolicitudes() {

		$data = array();
		$arrayParam['codEstado']        = $this->input->post("cmbEstado");
		$arrayParam['codAfiliacion']    = $this->input->post("txtNumeroSolicitud");
		$arrayParam['fechaInicia']      = $this->input->post("txtFechaInicial");
		$arrayParam['fechaFinal']       = $this->input->post("txtFechaFinal");
		$datos['solicitudesGestionar']  = $this->sm->getSolicitudesGestionar($arrayParam); 
	

		$vista = $this->load->view('solicitud/tablaGestionar', $datos, true);
		$data['vista'] = $vista;

		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	/**
	 * Retorna la validación para tomar la solicitud de la bandeja de operaciones
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 14/02/2019
	 * 
	 *  
	 *  @return application/json  Información de la validación de la afiliación en cola
	 */
	public function tomarSolicitud() {

		$data = array();

		$codUsuario     = $this->session->userdata('codigo_usuario'); //ID USER SESSION
		$codAfiliacion  = $this->input->post("codSolicitud");	
		$validaCola     = $this->sm->getValidaExisteCola($codUsuario,$codAfiliacion)->VALIDA_COLA;

		//Si la solicitud la tiene otro usuario
        if ($validaCola == 2){
            $data['nombreUsuario'] = $this->sm->getNombreUsuarioCola($codAfiliacion)->NOMBRE_COMPLETO;
		}
		$data['validaCola'] = $validaCola;
	    $result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	/**
	 * Retorna la vista para ver la información de la solicitud
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 13/02/2019
	 * 
	 *  
	 * @return html  Vista para gestionar la solicitud
	 */
	public function formularioGestionSolicitud() {
		$datos                  = array();
		$data                   = array();
		$codAfiliacion          = $this->input->post("codSolicitud");
		$tipoAccion             = $this->input->post("tipoAccion");
		
		$arrayParam['codAfiliacion']  = $codAfiliacion;
        $arrayParam['codUsuario']     = $this->session->userdata('codigo_usuario'); //ID USER SESSION
		
		//Aun no existe el registro en la cola
		if ($tipoAccion == 1) {

			//Se guarda en la cola por primera vez
			$this->sm->saveColaSolicitud($arrayParam);

		//El usuario va a retomar la solicitud de la cola	
		} elseif ($tipoAccion == 2) {

			$arrayParam['tipoGestion']  = 2;
			//Se retoma la solicitud
			$this->sm->managementColaSolicitud($arrayParam);

		//El usuario va a tomar la solicitud de otra persona	
		} elseif ($tipoAccion == 3){

			//Se va reasginar la solicitud
			$this->sm->updateColaSolicitud($arrayParam);

		}
		
		$datos['contratante']   = $this->sm->getDatosContratante($codAfiliacion);
		$arrayProgramas = $this->sm->getDatosProgramas($codAfiliacion);
		foreach ($arrayProgramas as $key => $value) {										
			$bene = $this->sm->getBenexPrograma($codAfiliacion, $value['COD_PROGRAMA']);
			$arrayProgramas[$key]['BENEFICIARIOS'] = $bene;						
		}
		$datos['beneficiarios']  = $arrayProgramas;
		$datos['bitacora']      = $this->sm->getBitacoraSolicitud($codAfiliacion);	

		$vista = $this->load->view('solicitud/formularioGestionSolicitud', $datos, true);
		$data['vista'] = $vista;
		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	/**
	 * Retorna json con los datos de la transacción
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 14/02/2019
	 * 
	 * @param integer  $codUsuario    Código del usuario en session
     * @param integer  $codAfiliacion Código del la afiliación a realizar gestión
     * 
     *   
	 * @return application/json  Indica si la transacción se realizo con exito
	 */
	public function dejarPendienteSolicitud(){
		
		$data                         = array();		
		$codAfiliacion                = $this->input->post("codSolicitud");
		$arrayParam['codAfiliacion']  = $codAfiliacion;
        $arrayParam['codUsuario']     = $this->session->userdata('codigo_usuario'); //ID USER SESSION
		$arrayParam['tipoGestion']    = 1;
					
		//Se deja pendiente la solicitud
		$data = $this->sm->managementColaSolicitud($arrayParam);		
			
    	$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	/**
	 * Retorna json con los datos de la transacción
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 14/02/2019
	 * 
	 * @param integer  $codUsuario    Código del usuario en session
     * @param integer  $codAfiliacion Código del la afiliación a realizar gestión
     * 
     *   
	 * @return application/json  Indica si la transacción se realizo con exito
	 */
	public function validarSolicitud(){
		
		$data                         = array();		
		$codAfiliacion                = $this->input->post("codSolicitud");
		$arrayParam['codAfiliacion']  = $codAfiliacion;
        $arrayParam['codUsuario']     = $this->session->userdata('codigo_usuario'); //ID USER SESSION
						
		//Se valida la solicitud
		$data = $this->sm->deleteColaSolicitud($arrayParam);		

		if ($data["ret"]) {
		   $this->kitBienvenida($codAfiliacion);
		}		
			
    	$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	/**
	 * Retorna el nombre de usuario que tiene la solicitud en gestión
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 14/02/2019
	 * 
	 *  
	 *  @return application/json  Nombre del usuario que tiene la solicitud en gestión
	 */
	public function solicitudEnGestion() {

		$data = array();
		$codAfiliacion         = $this->input->post("codSolicitud");
        $data['nombreUsuario'] = $this->sm->getNombreUsuarioCola($codAfiliacion)->NOMBRE_COMPLETO;		
	    $result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	public function kitBienvenida($codigo_afiliacion){
     $result = $this->sm->getDatosKitBienvenido($codigo_afiliacion)[0];		
		 $datos_programas = $result["PROGRAMAS"];
		 $nombreContrante = $result["NOMBRE_COMPLETO"]; //$this->session->userdata('nombre1')." ".$this->session->userdata('nombre2')." ".$this->session->userdata('apellido1')." ".$this->session->userdata('apellido2'); 
     $email =  $result["CORREO"];
		 $mensaje = '<div style="font-family: arial; background: #f2f2f2">
			            <div style="">                        
			              <img src="'.$result["PARAM65"].'">             
			            </div>
			                <br>
			            <div style="background: #0073bd;border-radius: 10px;width: 713px;margin-left: 20px; color:#ffffff !important;">
			               <br>                          
			                <p style="padding-left: 10px;font-weight: bold;font-size:20px;">!'.$nombreContrante.'!</p>
			                
			                <p style="padding-left: 10px;">Has adquirido el programa(s)  '.$datos_programas.'</p>
			                <p style="padding-left: 10px;">Estamos muy felices que nos hayas elegido para acompa&ntilde;arte en cada momento de tu vida.</p>
			                
			                <p style="padding-left: 10px;font-weight: bold;">!Cuenta con nosotros para lo que necesites!</p>
			                <br>
			                <table>
			                  <tbody>
			                    <tr>
			                      <td><a href="'.$result["PARAM67"].'"><img src="'.$result["PARAM59"].'"></a></td>
			                      <td><a href="'.$result["PARAM68"].'"><img src="'.$result["PARAM60"].'"></a></td>
			                    </tr>
			                    <tr>
			                      <td><a href="'.$result["PARAM69"].'"><img src="'.$result["PARAM61"].'"></a></td>
			                      <td><a href="'.$result["PARAM70"].'"><img src="'.$result["PARAM62"].'"></a></td>
			                    </tr>
			                    <tr>
			                      <td><a href="'.$result["PARAM74"].'"><img src="'.$result["PARAM63"].'"></a></td>
			                      <td><a href="'.$result["PARAM71"].'"><img style="width: 310px;" src="'.$result["PARAM64"].'"></a><a href="'.$result["PARAM72"].'"><img style="width: 310px;" src="'.$result["PARAM75"].'"></a></td>			                      
								</tr>
                 			 </tbody>
			                </table>';			          
			   $mensaje2 = '<p style="padding-left: 10px;">
			                  Linea de atenci&oacute;n al cliente: 018000931666 <span style="font-weight: bold;">Cali:</span> (2)4890075, <span style="font-weight: bold;">Bogota:</span> (1)7435485 <span style="font-weight: bold;">Pereira:</span>  (6)3402635,
			                  <span style="font-weight: bold;">Barranquilla:</span> (5)3853165, <span style="font-weight: bold;">Medellin:</span> (4)6044507, <span style="font-weight: bold;">Bucaramanga:</span> (7)6973350, <span style="font-weight: bold;">Cartagena:</span> (5)6939853,
			                  <span style="font-weight: bold;">Tulu&aacute;:</span> (2)2359483, <span style="font-weight: bold;">Valledupar:</span> (5)5885699.  
			                </p>
			                <br>
			            </div>                                
			            <div style="text-align: center;">
			               <img src="'.$result["PARAM66"].'" style="width: 700px;">
			            </div>
			        </div>';	          

	    $asunto = "Kit de bienvenida";
        $aux_email =  $email;//$this->session->userdata('email');        
	    $aux_array_datos = array('to' => $aux_email,
                                 'asunto' => $asunto,
                                 'mensaje' => $mensaje,
                                 'mensaje2' => $mensaje2 );
	    

       if ($aux_email != "" and $aux_email != null and $datos_programas != "") {       
          $result = $this->sm->sendEnviarEmail($aux_array_datos);
       }    

	}

	public function infoPago(){
		$codigo_afiliacion = $this->input->post("codAfiliacion");
		$data = $this->Utilidades_model->getInformacionPago($codigo_afiliacion)[0];		
		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);	
	}
}