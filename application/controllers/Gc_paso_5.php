<?php 

defined('BASEPATH') OR exit('No direct script access allowed');
class Gc_paso_5 extends CI_Controller{

	public function __construct() {

		parent::__construct();		
        $this->load->model('Gestion_compra_model');
        $this->load->model('Gc_paso_5_model', 'p5', true); 
		$this->load->model('Utilidades_model'); 
		$this->load->model('FirmaDigital_model', 'fdm', true); 

	}
	
	public function index() {
		$this->Utilidades_model->validaSession();
		$data = array();
		$this->load->view('gestion_compra', $data);
	}
	
    /**
	 * Retorna json con los datos necesarios para firmar el contrato
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 14/01/2019
	 * 
	 *  
	 * @return application/json  Información del contrato para firmar
	 */
	public function getUrlFirmaContrato(){
		
		$data = array();

		$nombrePdf     = $this->input->post("nombrePdf");
		$codPersona    = $this->input->post("codPersona");
		$codPrograma   = $this->input->post("codPrograma");
		$codAfiliacion   = $this->input->post("codAfiliacion");
		$datosContrato = $this->fdm->getContrato($nombrePdf,$codPersona,$codPrograma,$codAfiliacion);

		
		$diaActual     = date('d');
		$corte = strtoupper($this->session->userdata('corte'));
		$cortes = $this->Utilidades_model->getParametro(86)->RESULTADO;
		$arrayCorte = explode(',', $cortes);
		
	
		if (empty($corte)) {
			if($diaActual <= 15){
				$msgInicioServicio = $this->Utilidades_model->getParametro(12)->RESULTADO;
			}else{
				$msgInicioServicio = $this->Utilidades_model->getParametro(13)->RESULTADO;
			}
		} else {
			if ($corte == $arrayCorte[0] || $corte == $arrayCorte[1] || $corte == $arrayCorte[2] || $corte == $arrayCorte[3] || $corte == $arrayCorte[4]) {
				if($diaActual <= 15){
					$msgInicioServicio = $this->Utilidades_model->getParametro(12)->RESULTADO;
				}else{
					$msgInicioServicio = $this->Utilidades_model->getParametro(85)->RESULTADO;
				}
			} else if($corte == $arrayCorte[5] || $corte == $arrayCorte[6]){
				$msgInicioServicio = $this->Utilidades_model->getParametro(13)->RESULTADO;
			}
			
		}

		$msgInicioServicio .= ' '.$this->Utilidades_model->getParametro(38)->RESULTADO;
		$msgFinalizarVenta  = $this->Utilidades_model->getParametro(39)->RESULTADO;

		$data['widgetId']          = $datosContrato->widgetId;
		$data['url']               = $datosContrato->url;
		$data['msgInicioServicio'] = $msgInicioServicio;
		$data['msgFinalizarVenta'] = $msgFinalizarVenta;
		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	/**
	 * Retorna json con los datos de la transacción
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 14/01/2019
	 * 
	 * @param string  $codWidget          Cadena con el Id del Widget en Adobe Sign
     * @param string  $codPrograma        Código del programa
	 * @param string  $codPersona         Código de la persona contratante
     * @param string  $codAfiliacion      Código de la afiliación
	 * @param string  $nroIdenfificacion  Número de identificación del Contratante
     *   
	 * @return application/json  Indica si la transacción se realizo con exito
	 */
	public function guardarContratoAdobeSign(){
		
		$data = array();
        $codWidget         = $this->input->post("codWidget");
		$codPrograma       = $this->input->post("codPrograma");
		$codPersona        = $this->input->post("codPersona");
		$codAfiliacion     = $this->input->post("codAfiliacion");
		$nroIdenfificacion = $this->input->post("nroIdenfificacion");
        $nroContratoAdobe  = $this->fdm->getIdContrato($codWidget);
		
		//Se guarda la información del contrato
		$data = $this->p5->saveContratoAdobeSign($codPersona, $codPrograma, $codAfiliacion, $nroContratoAdobe);

    	$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	/**
	 * Retorna json indicando si se firmo el contrato o no
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 20/02/2019
	 * 
	 *  
	 * @return application/json  Información de la validación del contrato
	 */
	public function getValidaContratos(){
		
		$data = array();

		$codPersona     = $this->input->post("codPersona");
		$codAfiliacion  = $this->input->post("codAfiliacion");
		$codPrograma    = $this->input->post("codPrograma");
		$validaContrato = $this->p5->getValidaContratos($codAfiliacion,$codPersona,$codPrograma)->VALIDA_CONTRATO;
		
	    $data['validaContrato'] = $validaContrato;
	    $result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	/**
	 * Retorna json con los datos de la transacción
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 21/02/2019
	 * 
	 * @param string  $codAfiliacion  Código de la afiliación
     *   
	 * @return application/json  Indica si la transacción se realizo con exito
	 */
	public function actualizarAfiliacion(){
		
		$data          = array();       
		$codAfiliacion = $this->input->post("codAfiliacion");

				
		//Se actualiza el estado de la afiliación
		$data = $this->p5->updateAfiliacion($codAfiliacion);

    	$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	/**
	 * Sirve para identificar, si es inclusion
	 * @param string $cod_afiliado
	 * @param string $cod_contratante
	 * 
	 * @return application/json indicando si no hay inclusion
	 */

	public function getInclusion(){

		$datos = array();

		$cod_afiliado     = $this->input->post("cod_afiliado");
		$cod_contratante  = $this->input->post("cod_contratante");
		
		$datos = $this->p5->getValidaInclusion($cod_afiliado,$cod_contratante);
		$result = json_encode($datos);
		$this->output->set_content_type('application/json')->set_output($result);
	}

}

?>