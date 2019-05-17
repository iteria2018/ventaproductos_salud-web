<?php 

defined('BASEPATH') OR exit('No direct script access allowed');
class Consulta extends CI_Controller{

	public function __construct() {
		parent::__construct();		
        $this->load->model('Gestion_compra_model');
        $this->load->model('Utilidades_model');	
        $this->load->model('Solicitud_model', 'sm', true);	 
		$this->load->model('Linea_model', 'lm', true);         
	}
	
	/**
	 * Retorna la vista para listar las Solicitudes
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 15/02/2019
	 * 
	 *  
	 * @return html  Vista para listar las Solicitudes
	 */
	public function index() {
		$this->Utilidades_model->validaSession();
		$data = array();
		$codUsuario                       = $this->session->userdata('codigo_usuario'); //ID USER SESSION
		$data['estados']                  = $this->lm->getEstados(2);	
		$data['solicitudes']              = $this->sm->getSolicitudes();
		$this->load->view('solicitud/indexConsulta', $data);
	}

	/**
	 * Retorna la vista para listar las solicitudes
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 15/02/2019
	 * 
	 *  
	 * @return html  Vista para listar las solicitudes
	 */
	public function consultarSolicitudes() {

		$data = array();
		$arrayParam['codEstado']        = $this->input->post("cmbEstado");
		$arrayParam['codAfiliacion']    = $this->input->post("txtNumeroSolicitud");
		$arrayParam['fechaRadicaIni']   = $this->input->post("txtFecRadicaIni");
		$arrayParam['fechaRadicaFin']   = $this->input->post("txtFecRadicaFin");
		$arrayParam['fechaGestionIni']  = $this->input->post("txtFecGestionIni");
		$arrayParam['fechaGestionFin']  = $this->input->post("txtFecGestionFin");
		$datos['solicitudes']           = $this->sm->getSolicitudes($arrayParam); 
	

		$vista = $this->load->view('solicitud/tablaConsulta', $datos, true);
		$data['vista'] = $vista;

		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}
	
}