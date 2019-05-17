<?php 

defined('BASEPATH') OR exit('No direct script access allowed');
class Tarifa extends CI_Controller{

	public function __construct() {
		parent::__construct();		
        $this->load->model('Gestion_compra_model');
        $this->load->model('Utilidades_model');	
        $this->load->model('Tarifa_model', 'tm', true);	
        $this->load->model('Linea_model', 'lm', true);	         
	}
	
	/**
	 * Retorna la vista para listar las tarifas
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 28/01/2019
	 * 
	 *  
	 * @return html  Vista para listar las tarifas
	 */
	public function index() {
		$this->Utilidades_model->validaSession();
		$data = array();
		$data['tarifas'] = $this->tm->getTarifas();
		$this->load->view('tarifa/index', $data);
	}

	/**
	 * Retorna la vista para listar las productos
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 28/01/2019
	 * 
	 *  
	 * @return html  Vista para listar las lineas
	 */
	public function cargarProgramasPlan() {

		$data = array();
		$codPlan                = $this->input->post("codPlan");
		$datos['programasPlan'] = $this->tm->getProgramasPlan($codPlan);

		$vista = $this->load->view('tarifa/productos', $datos, true);
		$data['vista'] = $vista;

		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
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
		$datos                     = array();
		$data                      = array();
		$datos['tiposTarifas']     = $this->tm->getTiposTarifas();
        $datos['planes']           = $this->lm->getPlanes();
        $datos['generos']          = $this->tm->getGeneros();
        $datos['estados']          = $this->lm->getEstados(1);
        $datos['tipoCondiciones']  = $this->tm->getTipoCondiciones();
        $datos['numUsuarios']      = $this->tm->getNumUsuarios();
        $tipoAccion                = $this->input->post("tipoAccion");
		$datos['tipoAccion']       = $tipoAccion;
		
		//Si el tipo de acción es editar
		if ($tipoAccion == 2){
			$codTarifa              = $this->input->post("codTarifa");
			$tarifa                 = $this->tm->getTarifa($codTarifa);
			$datos['tarifa']        = $tarifa;
			$datos['programasPlan'] = $this->tm->getProgramasPlan($tarifa[0]['COD_PLAN']);
		}
		
		$vista = $this->load->view('tarifa/formulario', $datos, true);

		$data['vista'] = $vista;
		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	/**
	 * Retorna json con los datos de la transacción
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 28/01/2019
	 * 
	 * @param integer  $codPlanPrograma  Código del plan asociado al programa
     * @param integer  $codPlan          Código del plan
     * @param integer  $codEstado        Código del estado
     * @param integer  $codTipoTarifa    Código del tipo de tarifa
     * @param integer  $valorTarifa      Valor de la tarifa
     * @param string   $fecVigenciaIni   Fecha inicio de vigencia
     * @param string   $fecVigenciaFin   Fecha fin de vigencia
     * @param integer  $codCondicion     Código de la condición
     * @param integer  $codNumUsuarios   Código del número de usuarios
     * @param integer  $codSexo          Código del genero
     * @param integer  $edadInicial      Edad mínima
     * @param integer  $edadFinal        Edad máxima
     * 
     *   
	 * @return application/json  Indica si la transacción se realizo con exito
	 */
	public function guardarTarifas(){
		
		$data          = array();
				
		$arrayParam['codTarifaMP']      = $this->input->post("txtCodTarifaMP");
        $arrayParam['codPlanPrograma']  = $this->input->post("cmbProductos");
		$arrayParam['codPlan']          = $this->input->post("cmbPlan");
        $arrayParam['codEstado']        = $this->input->post("cmbEstado");
        $arrayParam['codTipoTarifa']    = $this->input->post("cmbTipoTarifa");
		$arrayParam['valorTarifa']      = $this->input->post("txtValorTarifa");
        $arrayParam['fecVigenciaIni']   = $this->input->post("txtVigenciaInicial");
        $arrayParam['fecVigenciaFin']   = $this->input->post("txtVigenciaFinal");
		$arrayParam['codCondicion']     = $this->input->post("cmbTipoCondicion");
        $arrayParam['codNumUsuarios']   = $this->input->post("cmbNumUsuarios");
        $arrayParam['codSexo']          = $this->input->post("cmbGenero");
		$arrayParam['edadInicial']      = $this->input->post("txtEdadMinima");
        $arrayParam['edadFinal']        = $this->input->post("txtEdadMaxima");
		$tipoAccion                     = $this->input->post("txtTipoAccion");
		
	
		//Se valida si la tarifa ya existe
		$codTarifaMP =  $this->tm->getExisteTarifa($arrayParam['codTarifaMP'])->COD_TARIFA;
		
        //Si el tipo de acción es guardar
        if ($tipoAccion == 1){
		
			//Se valida si la tarifa existe y si el estado es activo
			if ($codTarifaMP != null && $arrayParam['codEstado'] == 1){

				$data['ret']    = false;
                $data['errors'] = 'Ya existe una tarifa activa con el código ingresado';

			} else {
				//Se guarda la información de la tarifa
				$data = $this->tm->saveTarifa($arrayParam);
			}       
					
        //Si el tipo de acción es actualizar	
        } else {

			$codTarifa = $this->input->post("txtCodTarifa");
		
			//Se valida si la tarifa ya existe con estado activo
			if ($codTarifaMP != null && $codTarifa != $codTarifaMP  && $arrayParam['codEstado'] == 1){

				$data['ret']    = false;
                $data['errors'] = 'Ya existe una tarifa activa con el código ingresado';

			} else {
				
				//Se guarda la información de la tarifa
				$data = $this->tm->updateTarifa($codTarifa,$arrayParam);
			}
        }
	
			
    	$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

}