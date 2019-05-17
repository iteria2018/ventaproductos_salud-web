<?php 

defined('BASEPATH') OR exit('No direct script access allowed');
class Gc_paso_3 extends CI_Controller{

	public function __construct() {
		parent::__construct();		
        $this->load->model('Gestion_compra_model');
        $this->load->model('Gc_paso_3_model', 'p3', true);
       	$this->load->model('Utilidades_model');		       
	}
	
	public function index() {
		$this->Utilidades_model->validaSession();
		$data = array();
		
		$this->load->view('gestion_compra', $data);
	}
	
	/**
     * Retorna un PDF con los datos de la cotización
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 18/01/2019
     * 
	 *   
     * @return application/pdf Archivo PDF con la información de la cotización
     */
	public function verCotizacionPDF(){
	
		$data  = array();
		$paramObj['cod_usuario']     = $this->session->userdata('codigo_usuario'); //ID USER SESSION
		$paramObj['codUsuario']      = $this->session->userdata('codigo_usuario');
		$paramObj['codigo_plan']     = $this->session->userdata('codigo_plan');
		$paramObj['codigo_producto'] = -1;
		$contratante   = $this->Gestion_compra_model->getContratante_data($paramObj);
		$beneficiarios = $this->Gestion_compra_model->getBenefisPendiente_data($paramObj);
		$productos     = $this->Gestion_compra_model->getProducto_data($paramObj);

		$data['datosContratante'] = $contratante;
		$data['beneficiarios']    = $beneficiarios;
		$data['productos']        = $productos;

		$this->Utilidades_model->imprimirPdf('ver_cotizacion',$data, 'verCotizacion'.$paramObj['cod_usuario'].'.pdf', 'I');
	
	}
	
	/**
	 * Retorna la vista para ver/adjuntar documentos
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 22/01/2019
	 * 
	 *  
	 * @return html  Vista para adjuntar archivos
	 */
	public function verAdjuntarArchivos($codPersona,$codAfiliacion){
		
		$data = array();
		$tamanoPermitido = $this->Utilidades_model->getParametro(16)->RESULTADO;
		$datosArchivos              = $this->p3->getAdjuntosBeneficiario($codPersona, $codAfiliacion);
		$data['arrayExtensiones']   = $this->Utilidades_model->getParametro(15)->RESULTADO;
		$data['tamanoAdjunto']      = $tamanoPermitido != '' ? $tamanoPermitido.'MB' : '';
		$data['datosArchivos']      = $datosArchivos;
		
        if (empty($datosArchivos)){
		    $this->load->view('adjuntar_archivos', $data);
		} else {
		    $this->load->view('ver_adjuntos', $data);
		}
        
	}

	/**
	 * Retorna json con los datos de la transacción
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 22/01/2019
	 * 
	 * @param string  $codBeneficiario    Código de la persona beneficiario
     * @param string  $codAfiliacion      Código de la afiliación
	 * @param string  $_FILE              Array de archivos
     *   
	 * @return application/json  Indica si la transacción se realizo con exito
	 */
	public function guardarDocumentos(){
		
		$rutaLocal        = $this->Utilidades_model->getParametro(17)->RESULTADO;
		$urlLocal         = $_SERVER['DOCUMENT_ROOT'].$rutaLocal;
		$codBeneficiario  = $this->input->post("codBeneficiario");
		$codAfiliacion    = $this->input->post("codAfiliacion");
		$msgRespuesta     = '';
		$ret              = true;
		$db               = $this->db;

		$data = array();
		$tamanoPermitido = $this->Utilidades_model->getParametro(16)->RESULTADO;
		$data['arrayExtensiones']   = $this->Utilidades_model->getParametro(15)->RESULTADO;
		$data['tamanoAdjunto']      = $tamanoPermitido != '' ? $tamanoPermitido.'MB' : '';
		//Abrir la transaccion db
		$db->trans_begin();

		//Se recorren el array de archivos
	    for($i = 0; $i < count($_FILES['archivo']['name']); $i++) {
			$nombre         = $_FILES['archivo']['name'][$i];
			$nombreTemporal = $_FILES['archivo']['tmp_name'][$i];
			$error          = $_FILES['archivo']['error'][$i];
			$sizeFile 		= $_FILES["archivo"]["size"][$i]/pow(1024,2);
			$extension      = pathinfo($nombre, PATHINFO_EXTENSION);
			$tipoArchivo    = $_POST['tipoArchivo'][$i];
			$desFile        = $_POST['desArchivo'][$i];
			$archivo        = file_get_contents($nombreTemporal);
			$nombreArchivo  = str_pad($codAfiliacion, 14, "0", STR_PAD_LEFT).'_';
			$nombreArchivo .= str_pad($codBeneficiario, 16, "0", STR_PAD_LEFT).'_';
			$nombreArchivo .= $tipoArchivo.'.'.strtolower($extension);
			$ruta           = $rutaLocal.$nombreArchivo;
			$sizePermitido = $tamanoPermitido != '' ? intval($tamanoPermitido) : $sizeFile;

			if($sizeFile <= $sizePermitido){
				if($tipoArchivo != null && $nombre != null){
					$uploadArchivo = file_put_contents($urlLocal.$nombreArchivo, $archivo);
					
					if ($uploadArchivo === false){
						$msgRespuesta .= 'Ocurrió un error al subir el archivo: '. $nombre .' al servidor <br>';
						$ret           = false;
						break;   	
					}
					
					$guardarAdjunto  = $this->p3->saveDocumento($db, $desFile, '', $ruta, $tipoArchivo);
	
					if ($guardarAdjunto['ret'] == true){
	
						$guardarBeneficiario  = $this->p3->saveDocumentoBeneficiario($db, $codAfiliacion, $guardarAdjunto['codFile'], $codBeneficiario);
	
						if ($guardarBeneficiario['ret'] == false){
							$msgRespuesta .= $guardarBeneficiario['errors'] .'<br>';
							$ret = false;
							break;
						}
	
					} else {
						$msgRespuesta .= $guardarAdjunto['errors'] .'<br>';
						$ret = false;
						break;
					}
				}
			}else{
				$msgRespuesta .= 'El archivo '. $nombre .' supera el tama&ntilde;o permitido por adjunto (<b>'.$data['tamanoAdjunto'].'</b>). Por favor validar que el tama&ntilde;o no exceda el limite permitido. <br>';
				$ret           = false;
				break;
			}			
		}
		
		if ($ret == false){
			$db->trans_rollback();
        } else {
			$db->trans_commit();
			$msgRespuesta = 'Se agregaron correctamente los soportes.';
		}
		
		$success = $ret == true ? '1' : '0';
		
		if($success == '0'){
			$data['errores'] = $msgRespuesta;
			$this->load->view('adjuntar_archivos', $data);
		}

		?>
			<script type="text/javascript">
				//Cerrar modal
				var mensajeAdjuntos =  "<?php echo $msgRespuesta; ?>";
				var successAdjunto =  "<?php echo $success; ?>";
				window.parent.resultSubmitFileBenefi('verAdjuntarArchivos', successAdjunto, mensajeAdjuntos);
			</script>
		<?php
		
				
		
		/*if ($msgRespuesta != ''){
			$datosArchivos         = $this->p3->getAdjuntosBeneficiario($codBeneficiario, $codAfiliacion);
			$data['datosArchivos'] = $datosArchivos;
            $this->load->view('ver_adjuntos', $data);
		} else {
			$data['errores'] = $msgRespuesta;
			$this->load->view('adjuntar_archivos', $data);
		}*/
		
	}

	/**
	 * Retorna json indicando si se adjunto o no el documento
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 23/01/2019
	 * 
	 *  
	 * @return application/json  Información de la validación del archivo
	 */
	public function getValidaAdjuntos(){
		
		$data = array();

		$codPersona      = $this->input->post("codPersona");
		$codAfiliacion   = $this->input->post("codAfiliacion");
		$validaDocumento = $this->p3->getValidaAdjuntos($codPersona,$codAfiliacion)->VALIDA_DOCUMENTOS;
		
	    $data['validaDocumento'] = $validaDocumento;
	    $result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

}

?>