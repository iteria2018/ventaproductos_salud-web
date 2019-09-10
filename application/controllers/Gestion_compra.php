<?php 

defined('BASEPATH') OR exit('No direct script access allowed');
class Gestion_compra extends CI_Controller{

	public function __construct() {
		parent::__construct();		
		$this->load->model('Gestion_compra_model');
		$this->load->model('WebService_model');
       	$this->load->model('Utilidades_model');	       
	}
	
	public function index() {
		$this->Utilidades_model->validaSession();		
		$data = array();
		$data["senal"] = $this->Gestion_compra_model->getTipoPagoFactura($this->session->userdata('codigo_usuario')); //0;
		$atributos = array('class'=>'form-control');
		$paramObj = array('tipo'=>'CEM');
		$data['opTipoId'] = $this->getTipoIdentificacion();
		$data['opSexo'] = $this->getSexo();
		$data['opPais'] = $this->Utilidades_model->generarComboWhere('', 'VDIR_PAIS','COD_PAIS','DES_PAIS', '2', '{obl}Seleccione pais','COD_ESTADO = 1',false, $atributos);
		$data['opTipoVia'] = $this->getSelTipoVia();
		$data['opEstadoCivil'] = $this->Utilidades_model->generarComboWhere('', 'VDIR_ESTADO_CIVIL','COD_ESTADO_CIVIL','DES_ESTADO_CIVIL', '2', '{obl}Seleccione estado civil','COD_ESTADO = 1',false, $atributos);
		$data['opEps'] = $this->Utilidades_model->generarComboWhere('', 'VDIR_EPS','COD_EPS','DES_EPS', '2', '{obl}Seleccione eps','COD_ESTADO = 1',false, $atributos);
		$data['opParentesco'] = $this->Utilidades_model->generarComboWhere('', 'VDIR_PARENTESCO','COD_PARENTESCO','DES_PARENTESCO', '2', '{obl}Seleccione parentesco ','COD_ESTADO = 1',false, $atributos);
		$data['opMunicipio'] = $this->Utilidades_model->generarComboWhere('', 'VDIR_MUNICIPIO','COD_MUNICIPIO','DES_MUNICIPIO', '2', '{obl}Seleccione municipio','COD_ESTADO = 1',false, $atributos);
		$data['datosContratante'] = json_encode($this->getContratante());
		$data['productos'] = json_encode($this->getProducto());
		$data['opTipoPago'] = $this->Utilidades_model->generarComboWhere('', 'VDIR_TIPO_PAGO','COD_TIPO_PAGO','DES_TIPO_PAGO', '2', '{obl}Seleccione un tipo de pago ','COD_ESTADO = 1',false, $atributos);
		$data['urlOrigenWidget'] = $this->Utilidades_model->getParametro(9)->RESULTADO;		
		$data['beneficiariosPend'] = $this->traerBeneficiariosPendientes();
		$data['benefisProgramas'] = array();//$this->getBenefisProgramasPend();		
		$data['msgFinalizarVenta'] = $this->Utilidades_model->getParametro(39)->RESULTADO;
		$data['habeasDataCem'] = $this->Gestion_compra_model->getHabeasData_data($paramObj);		
		$data['msj_noAplicaTarifa'] = $this->Utilidades_model->getParametro(76)->RESULTADO;
		$this->load->view('gestion_compra', $data);
	}

	
	public function traerCategorias(){
        $paramObj = array();
        $ress = array();
        $ress['datos'] = $this->Gestion_compra_model->getGestionCompra($paramObj);

        return $ress;
	}
	
	public function getTipoIdentificacion(){
		$data = $this->Gestion_compra_model->getTipoIdentificacion_data();
		$optCadena = '<option value="-1" disabled selected hidden>Seleccione tipo de identificaci&oacute;n</option>';
		for($p=0; $p<count($data); $p++){
			$dato = $data[$p];
			$optCadena .= '<option value="'.$dato['CODIGO'].'" data-abr="'.$dato['NOMBRE_ABR'].'">'.$dato['NOMBRE'].'</option>';
		}

		return $optCadena;
	}

	public function getSexo(){
		$data = $this->Gestion_compra_model->getSexo_data();
		$optCadena = '<option value="-1" disabled selected hidden>Seleccione Sexo</option>';
		for($p=0; $p<count($data); $p++){
			$dato = $data[$p];
			$optCadena .= '<option value="'.$dato['CODIGO'].'" data-abr="'.$dato['NOMBRE_ABR'].'">'.$dato['NOMBRE'].'</option>';
		}

		return $optCadena;
	}

	public function getContratante(){
		$paramObj = array();		
		$paramObj['cod_usuario'] = $this->session->userdata('codigo_usuario'); //ID USER SESSION
		$data = $this->Gestion_compra_model->getContratante_data($paramObj);
		
		return $data;
	}

	public function getInfoPersona(){
		$paramObj = array();
		$data = array();
		$paramObj['num_identificacion'] = $this->input->post("num_identificacion");
		$paramObj['tipo_identificacion'] = $this->input->post("tipo_identificacion");		
		$paramObj['tipo_identificacion_abr'] = $this->input->post("tipo_identificacion_abr");
		$data['benefi'] = $this->Gestion_compra_model->getInfoPersona_data($paramObj);
		$data['mora'] = $this->validaMora($paramObj);
		$data['benefi_count'] = count($data['benefi']);
		if(count($data['benefi']) == 0){
			$paramService = array($paramObj['tipo_identificacion_abr'], $paramObj['num_identificacion']);
			$dataBenefi = $result = $this->Utilidades_model->getDataCurlServ(1, $paramService, '/');
			if(isset($dataBenefi['cabeceraUsuario'])){
				if($dataBenefi['cabeceraUsuario'] != null){
					$data['benefi'] = $this->omologaBenefiAfilmet($dataBenefi);
				}
			}
		}
		

		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	public function omologaBenefiAfilmet($datosBenefi){
		$data = array();
		
		$data['NUMERO_IDENTIFICACION'] = TRIM($datosBenefi['cabeceraUsuario']['num_identificacion']);
		$data['COD_TIPO_IDENTIFICACION'] = $datosBenefi['cabeceraUsuario']['tipo_identificacion'];
		$data['NOMBRE_1'] = $datosBenefi['cabeceraUsuario']['primer_nombre'];
		$data['NOMBRE_2'] = $datosBenefi['cabeceraUsuario']['segundo_nombre'];
		$data['APELLIDO_1'] = $datosBenefi['cabeceraUsuario']['primer_apellido'];
		$data['APELLIDO_2'] = $datosBenefi['cabeceraUsuario']['segundo_apellido'];
		$data['NOMBRE_COMPLETO'] = $data['NOMBRE_1'].' '.$data['NOMBRE_2'].' '.$data['APELLIDO_1'].' '.$data['APELLIDO_2'];
		$data['CELULAR'] = $datosBenefi['cabeceraUsuario']['telefono_celular'];
		$data['TELEFONO'] = $datosBenefi['cabeceraUsuario']['telefono_fijo'];
		$data['COD_EPS'] = $datosBenefi['cabeceraUsuario']['cod_eps'];
		$data['COD_ESTADO_CIVIL'] = $datosBenefi['cabeceraUsuario']['cod_estado_civil'] == 'S' ? '1' : '0';
		$data['COD_MUNICIPIO'] = $datosBenefi['credencialUsuario'][0]['cod_ciudad'];
		$data['COD_PAIS'] = '36';
		$data['COD_SEXO'] = $datosBenefi['cabeceraUsuario']['genero'] == 'F' ? '2' : '1';		
		$data['DIRECCION'] = $datosBenefi['credencialUsuario'][0]['direccion'];
		/*$data['DIR_COMPLEMENTO'] = $datosBenefi[''][''];
		$data['DIR_NUM_PLACA'] = $datosBenefi[''][''];
		$data['DIR_NUM_VIA'] = $datosBenefi[''][''];
		$data['DIR_TIPO_VIA'] = $datosBenefi[''][''];*/
		$data['EMAIL'] = $datosBenefi['cabeceraUsuario']['email'];
		$data['FECHA_NACIMIENTO'] = $this->transformaFechaAfilmet($datosBenefi['cabeceraUsuario']['fecha_nacimiento']);
		$data['IND_TIENE_MASCOTA'] = '0';

		return $data;
	}

	public function transformaFechaAfilmet($fecha){
		$anio = isset($fecha) && $fecha != null ? substr($fecha,0,4) : '';
		$mes = isset($fecha) && $fecha != null ? substr($fecha,4,2) : '';
		$dia = isset($fecha) && $fecha != null ? substr($fecha,6,2) : '';
		$fechaSalida =  $dia != '' && $mes != '' && $anio != '' ? $dia.'/'.$mes.'/'.$anio : '';

		return $fechaSalida;
	}

	public function validaMora($paramObj){
		$objParametros = array(
							'tipoIdentificacion='.$paramObj['tipo_identificacion_abr'],
							'nroIdentificacion='.$paramObj['num_identificacion']
						);
		$result = $this->Utilidades_model->getDataCurlServ(56, $objParametros, '&');
		$ress = isset($result['DATOS'])? $result['DATOS'][0] : array('fecha_retiro'=>null, 'fecha_mora'=>null);
		
		return $ress;
	}

	public function getProducto(){
		$paramObj = array();
		$paramObj['codigo_producto'] = -1;
		$paramObj['codigo_plan']     = $this->session->userdata('codigo_plan');
		$data = $this->Gestion_compra_model->getProducto_data($paramObj);
		
		for($x=0; $x<count($data); $x++){
			$data[$x]['PROGRAMAS'] = json_decode($data[$x]['PROGRAMAS'], true);
		}
		
		return $data;
	}

	public function validarAplicaBenefi(){
		$paramObj = array();
		$data = array();
		$paramObj['codProducto'] = $this->input->post("codProducto");
		$paramObj['codPrograma'] = $this->input->post("codPrograma");
		$paramObj['objBeneficiario'] = $this->input->post("objBeneficiario");

		$data['disponibleVd'] = $this->Gestion_compra_model->validarAplicaBenefi_data($paramObj);
		$data['disponibleAfilmed'] = $this->validaExisteBenefiProd($paramObj['objBeneficiario'], $paramObj['codProducto']);
		$data['disponibleUbicacion'] = $this->validaUbicaionBenefi($paramObj['objBeneficiario'], $paramObj['codProducto']);

		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	public function validaUbicaionBenefi($benefi, $producto){
		$reusult = -1;
		if($producto == 3){
			$direccion = $benefi['tipoVia_abr'].' '.$benefi['numeroTipoVia'].' '.$benefi['numeroPlaca'];//.' '.$benefi['complemento'];
			$objParametros = array(
									$benefi['nombre_completo'],
									$benefi['numeroDocumento'],
									$benefi['tipoDocumento_abr'],
									$direccion,
									$benefi['municipio']
								);
			
			$reusult_serv = $this->Utilidades_model->getDataCurlServ(4, $objParametros, '/');
			$reusult = $reusult_serv != null && $reusult_serv != '' ? $reusult_serv : array("aprobado"=>"F", "mensaje"=>"Fallo la validaci&oacute;n de la ubicaci&oacute;n." ) ;
		}
		
		return $reusult;
	}

	public function validaExisteBenefiProd($benefi, $producto){
		$reusult = -1;
		$tipoIdentificacion = $benefi['tipoDocumento_abr'];
		$identificacion = $benefi['numeroDocumento'];
		$existeUsuarioProducto = $this->WebService_model->validUsuarioLinea($tipoIdentificacion, $identificacion, $producto);
		$cantidad = isset($existeUsuarioProducto[0]['existe']) ? intval($existeUsuarioProducto[0]['existe']) : -1;
		//var_dump('existeUsuarioProducto-validaExisteBenefiProd:',$existeUsuarioProducto);
		if($cantidad > 0){
			$reusult = 1;
		}
		
		return $reusult;
	}

	public function guardarDatosBasicos(){
		$paramObj = array();
		$data = array();
		$codContratante = $this->input->post("codContratante");
		$codEstado = $this->input->post("codEstado");
		$objBeneficiarios = $this->input->post("objBeneficiarios");
		$incluyente = $this->input->post("incluyente");
		$cod_afiliacion = -1;
		$paramObjQuit['codUsuario'] = $this->session->userdata('codigo_usuario'); //ID USER SESSION
		$paramObjQuit['codEstado'] = 2;
		$paramQuitIncluyente = array();
		$paramQuitIncluyente['cod_persona'] = $codContratante;
		
		//Abrir la transaccion db
		$this->db->trans_begin();		

		//inactivar el estado del registro entre el contratante y los beneficiarios
		$this->Gestion_compra_model->inactivarContraBenefis_data($paramObjQuit);

		//Agregar relacion entre el contratatnte y sus beneficiarios
		foreach($objBeneficiarios as $clave => $valor){
			$paramObj = $valor;
			$paramObj['estado'] = $codEstado;
			$paramObj['codContratante'] = $codContratante;
			$paramObj['codAfiliacion'] = $cod_afiliacion;
			$llaveBenefi = $paramObj['tipoDocumento'].'_'.$paramObj['numeroDocumento'];

			$direccion = $paramObj['tipoVia_abr'].' '.$paramObj['numeroTipoVia'].' '.$paramObj['numeroPlaca'];//.' '.$benefi['complemento'];
			$objParametros = array(
				$paramObj['nombre_completo'],
				$paramObj['numeroDocumento'],
				$paramObj['tipoDocumento_abr'],
				$direccion,
				$paramObj['municipio']
			);

			$reusult_serv = $this->Utilidades_model->getDataCurlServ(4, $objParametros, '/');
			$cod_ubi = "";
			if ($reusult_serv["aprobado"] == "S") {
				$parteMensj = explode(" ", $reusult_serv["mensaje"]);
				$cod_ubi = preg_replace("/[.]/","",$parteMensj[14]);
			}
			$paramObj['codDireccion'] = $cod_ubi;
			$cod_afiliacion = $this->Gestion_compra_model->agregarBeneficiario_data($paramObj);
			if ($cod_afiliacion == -1) {
			   break;	
			}
			$data[$llaveBenefi] = $cod_afiliacion;
		}
		
		//inactivar registro del contrtatante incluido como beneficiario, si este no se incluyo
		if($incluyente == 0 && $cod_afiliacion > 0){
			$paramQuitIncluyente['cod_afiliacion'] = $cod_afiliacion;
			$this->Gestion_compra_model->inactivar_BenefiContra_data($paramQuitIncluyente);
		}		

		//Eliminar registros de relacion entre el contratante y los beneficiarios
		$ressQuit = $this->Gestion_compra_model->quitarContraBenefis_data($paramObjQuit);		

		//Confirmar commit si se el resultado de la transaccion es diferente a false, de lo contrario hacer rellback
		if ($this->db->trans_status() === FALSE){
            $this->db->trans_rollback();
        }else{
            $this->db->trans_commit();
        }
		
		$data['codAfiliacion'] = $cod_afiliacion;
		$data['beneficiarios'] = $this->traerBeneficiariosPendientes();
		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	public function traerBeneficiariosPendientes(){
		$paramObj = array();
		$result = array();
		$paramObj['codUsuario'] = $this->session->userdata('codigo_usuario'); //ID USER SESSION
		$data = $this->Gestion_compra_model->getBenefisPendiente_data($paramObj);
		
		if($data != false){
			$result = $data;
		}		

		return $result;
	}

	public function getSelTipoVia(){
		$data = $this->Utilidades_model->getDataTableCamp("COD_TIPO_VIA||''-''||ABR_TIPO_VIA","DES_TIPO_VIA","VDIR_TIPO_VIA","COD_ESTADO = 1","2");
		$optCadena = '<option value="-1" disabled selected hidden>Seleccione</option>';
		
		for($p=0; $p<count($data); $p++){
			$dato = $data[$p];
			$codigo = explode("-",$dato['CODIGO']);
			$cod = $codigo[0];
			$abr = isset($codigo[1]) ? $codigo[1] : '';
			$optCadena .= '<option value="'.$cod.'" data-abr="'.$abr.'">'.$dato['NOMBRE'].'</option>';
		}

		return $optCadena;
	}

	public function getHabeasData(){
		$paramObj = array();
		$result = array();
		$paramObj['tipo'] = 'COMPRA';
		$data['habeasData'] = $this->Gestion_compra_model->getHabeasData_data($paramObj);
		
		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	public function getOpMunicipio(){
		$paramObj = array();
		$result = array();
		$atributos = array('class'=>'form-control');
		$codPais = $this->input->post("codPais");
		$data['opMunicipio'] = $this->Utilidades_model->generarComboWhere('', 'VDIR_MUNICIPIO mu, VDIR_DEPARTAMENTO dp','mu.COD_MUNICIPIO','mu.DES_MUNICIPIO', '2', '{obl}Seleccione municipio','mu.COD_ESTADO = 1 AND mu.COD_DEPARTAMENTO = dp.COD_DEPARTAMENTO AND dp.COD_PAIS ='.$codPais,false, $atributos);
		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}


	/**
	 * Retorna json con los datos de la vista para mostrar las imagenes
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 17/01/2019
	 * 
	 * @param string  $codPrograma  Código del programa
     *    
	 * @return application/json  Retorna las imagenes de cobertura
	 */
	public function getImgCoberturas(){

		$data                = array();
		$datos               = array();
		$codPrograma         = $this->input->post("codPrograma");
		$codPlan             = $this->input->post("codPlan");
		$tipoCobertura       = $this->input->post("tipoCobertura");
		$coberturas          = $this->Gestion_compra_model->getCoberturas($codPrograma,$codPlan);
		$datos['coberturas']    = $coberturas;
		$datos['tipoCobertura'] = $tipoCobertura;

		$vista = $this->load->view('coberturas', $datos, true);

		$data['vista'] = $vista;
		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
		
	}

	public function setBenefiPrograma(){
		$paramObj = array();
		//$paramObj['codProducto'] = $this->input->post("producto");
		$paramObj['codBeneficiario'] = $this->input->post("beneficiario");
		$paramObj['codPrograma'] = $this->input->post("programa");		
		$paramObj['codAfiliacion'] = $this->input->post("afiliacion");
		$paramObj['codEstado'] = $this->input->post("estado");
		$paramObj['codTipoSolicitud'] = $this->validaUsuarioInclusion($paramObj['codPrograma']);

		$data = $this->Gestion_compra_model->setBenefiPrograma_data($paramObj);	
		$data['tipoSolicitud'] = $paramObj['codTipoSolicitud'];
		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	public function setFactura(){
		$paramObj = array();
		$data = array();
		$paramObj['codUsuario'] = $this->session->userdata('codigo_usuario');	
		$paramObj['codAfiliacion'] = $this->input->post("afiliacion");

		$data['codFactura'] = $this->Gestion_compra_model->setFactura_data($paramObj);
		
		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	public function getBenefisProgramasPend(){
		$paramObj = array();
		$paramObj['codUsuario'] = $this->session->userdata('codigo_usuario');
		//Quitar registros inactivos de vdir_beneficiario_programa
		$this->Gestion_compra_model->quitarBenefiProgram_data($paramObj);
		//Traer registros activos de vdir_beneficiario_programa
		$data = $this->Gestion_compra_model->getBenefisProgramasPend_data($paramObj);

		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}
	
	public function validaUsuarioInclusion($codPrograma){
		$ress = 2; //Default 1=Inclusion, 2=Venta nueva
		$dataUser = $this->session->userdata;
		$tipoIdentificacion = $dataUser['tipo_identificacion_abr']; 
		$identificacion = $dataUser['identificacion'];
		$codPlan = $dataUser['codigo_plan'];
		$paramObj = array(
						"cod_programa" => $codPrograma,
						"cod_plan" => $codPlan
					);
		$codProgramaHomologa = $this->Gestion_compra_model->getCodProgramaHomologa_data($paramObj);
		$existeUsuarioPrograma = $this->WebService_model->validUsuarioPrograma($tipoIdentificacion, $identificacion, $codProgramaHomologa);
		$cantidad = isset($existeUsuarioPrograma[0]['existe']) ? intval($existeUsuarioPrograma[0]['existe']) : -1;
		
		if($cantidad > 0){
			$ress = 1;
		}
		
		return $ress;
	}

	public function actualizarMicarrito(){
		$paramObj = array();
		$data = array();
		$paramObj['codUsuario'] = $this->session->userdata('codigo_usuario'); //ID USER SESSION
		$paramObj['codEstado'] = 1; //Confirmar temporales

		//inactivar el estado del registro entre el contratante y los beneficiarios
		$data['status'] = $this->Gestion_compra_model->confirmarProgramasBenefis_data($paramObj);

		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	public function getParametro(){
		$param = $this->input->post("parametro");
		$data['parametro'] =$this->Utilidades_model->getParametro($param)->RESULTADO;
		$result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}
	
}

?>