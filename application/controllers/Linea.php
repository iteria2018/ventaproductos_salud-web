<?php 

defined('BASEPATH') OR exit('No direct script access allowed');
class Linea extends CI_Controller{

	public function __construct() {
		parent::__construct();		
        $this->load->model('Gestion_compra_model');
        $this->load->model('Utilidades_model');	
		$this->load->model('Linea_model', 'lm', true);	       
	}
	
	/**
	 * Retorna la vista para listar las lineas
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 24/01/2019
	 * 
	 *  
	 * @return html  Vista para listar las lineas
	 */
	public function index() {
		$this->Utilidades_model->validaSession();
		$data = array();
		$data['lineas'] = $this->lm->getLineas();
		$this->load->view('linea/index', $data);
	}

	/**
	 * Retorna la vista para listar las lineas
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 24/01/2019
	 * 
	 *  
	 * @return html  Vista para listar las lineas
	 */
	public function cargarProgramas() {

		$data = array();
		$codProducto        = $this->input->post("codProducto");
		$datos['programas'] = $this->lm->getProgramas($codProducto);

		$vista = $this->load->view('linea/programas', $datos, true);
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
		$datos['productos']        = $this->lm->getProductos();
		$datos['planes']           = $this->lm->getPlanes();
		$datos['estados']          = $this->lm->getEstados(1);
		$tipoAccion                = $this->input->post("tipoAccion");
		$datos['tipoAccion']       = $tipoAccion;
		$datos['arrayExtensiones'] = $this->Utilidades_model->getParametro(18)->RESULTADO;
		$datos['codProgramaHomologa'] = '';

		//Si el tipo de acción es editar
		if ($tipoAccion == 2){
			$codPlanPrograma       = $this->input->post("codPlanPrograma");
			$planPrograma          = $this->lm->getPlanPrograma($codPlanPrograma);
			$datos['planPrograma'] = $planPrograma;
			$datos['programas']    = $this->lm->getProgramas($planPrograma[0]['COD_PRODUCTO']);
			$datos['codProgramaHomologa'] = $planPrograma[0]['COD_PROGRAMA_HOMOLOGA'];
		}
		
		$vista = $this->load->view('linea/formulario', $datos, true);

		$data['vista'] = $vista;
		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	/**
	 * Retorna json con los datos de la transacción
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 25/01/2019
	 * 
	 * @param integer  $codPlan                     Código del plan
     * @param integer  $codPrograma                 Código del programa
     * @param integer  $codEstado                   Código del estado
     * @param array    $_FILES['CoberturaInicial']  Datos del archivo de cobertura inicial
     * @param array    $_FILES['CoberturaFinal']    Datos del archivo de cobertura final
     *   
	 * @return application/json  Indica si la transacción se realizo con exito
	 */
	public function guardarProductos(){
		
		$data          = array();
		$ret           = true;
		$rutaLocal     = $this->Utilidades_model->getParametro(19)->RESULTADO;
		$urlLocal      = $_SERVER['DOCUMENT_ROOT'].$rutaLocal;
        $codPlan       = $this->input->post("cmbPlan");
		$codPrograma   = $this->input->post("cmbPrograma");
		$codEstado     = $this->input->post("cmbEstado");
		$tipoAccion    = $this->input->post("txtTipoAccion");
		$codProgramHmgl = $this->input->post("programaHomologa");

		if ($_FILES['CoberturaInicial']['name'] != ''){
			//Archivo Cobertura inicial
			$nombreCI         = $_FILES['CoberturaInicial']['name'];
			$nombreTemporalCI = $_FILES['CoberturaInicial']['tmp_name'];
			$extensionCI      = pathinfo($nombreCI, PATHINFO_EXTENSION);
			$archivoCI        = file_get_contents($nombreTemporalCI);
			//Nombre del archivo cobertura inicial
			$nombreArchivoCI  = 'coberturaInicial';
			$nombreArchivoCI .= str_pad($codPrograma, 2, "0", STR_PAD_LEFT).'_';
			$nombreArchivoCI .= str_pad($codPlan    , 2, "0", STR_PAD_LEFT).'_';
			$nombreArchivoCI .= '.'.strtolower($extensionCI);
			$rutaCI           = $rutaLocal.$nombreArchivoCI;

			$uploadCoberturaInicial = file_put_contents($urlLocal.$nombreArchivoCI, $archivoCI);

			if ($uploadCoberturaInicial === false){
				$msgRespuesta .= 'Ocurrió un error al subir el archivo: '. $nombreCI .' al servidor \n';
				$ret           = false;   	
			}

	    } else {
            $rutaCI = $this->input->post("txtRutaCoberturaIni");
		}

		if ($_FILES['CoberturaFinal']['name'] != ''){
			//Archivo Cobertura Final
			$nombreCF         = $_FILES['CoberturaFinal']['name'];
			$nombreTemporalCF = $_FILES['CoberturaFinal']['tmp_name'];
			$extensionCF      = pathinfo($nombreCF, PATHINFO_EXTENSION);
			$archivoCF        = file_get_contents($nombreTemporalCF);
			//Nombre del archivo cobertura inicial
			$nombreArchivoCF  = 'coberturaFinal';
			$nombreArchivoCF .= str_pad($codPrograma, 2, "0", STR_PAD_LEFT).'_';
			$nombreArchivoCF .= str_pad($codPlan    , 2, "0", STR_PAD_LEFT).'_';
			$nombreArchivoCF .= '.'.strtolower($extensionCF);
			$rutaCF           = $rutaLocal.$nombreArchivoCF;

			$uploadCoberturaFinal = file_put_contents($urlLocal.$nombreArchivoCF, $archivoCF);

			if ($uploadCoberturaFinal === false){
				$msgRespuesta .= 'Ocurrió un error al subir el archivo: '. $nombreCF .' al servidor \n';
				$ret           = false;   	
			}

		} else {
			$rutaCF = $this->input->post("txtRutaCoberturaFin");
		}

		//Si nada fallo al subir los archivos
		if ($ret == true){
			//Si el tipo de acción es guardar
			if ($tipoAccion == 1){
				//Se guarda la información del programa asociado al plan
				$data = $this->lm->savePlanPrograma($codPlan,$codPrograma,$codEstado,$rutaCI,$rutaCF,$codProgramHmgl);
			//Si el tipo de acción es actualizar	
			} else {
				$codPlanPrograma = $this->input->post("txtCodPlanPrograma");
				//Se guarda la información del programa asociado al plan
				$data = $this->lm->updatePlanPrograma($codPlanPrograma,$codPlan,$codPrograma,$codEstado,$rutaCI,$rutaCF,$codProgramHmgl);
			}
		} else {
			$data['ret']    = $ret;
      		$data['errors'] = $msgRespuesta;
		}
			
    	$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

}