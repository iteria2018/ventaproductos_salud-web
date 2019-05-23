<?php 
	
	class WebService extends CI_Controller{
		
		public function __construct() {
			parent::__construct();
			$this->load->model('Utilidades_model', 'utm', true);
			$this->load->model('WebService_model', 'wsm', true); 
        }  

        
        public function callWsEstadoUsuario(){
			$params["tipoIdentificacion"] = $this->session->userdata('tipo_identificacion'); 
            $params["nroIdentificacion"] = $this->session->userdata('identificacion');   
            $params["tipo_identificacion_abr"] = $this->session->userdata('tipo_identificacion_abr');
			//$params = $_REQUEST;  
			$auxSw  = true;         
			
			if (count($params) == 0) {
				$data["RESPUESTA"] = "Faltan parámetros por enviar";
			} else {                 
                
                if (trim($params["tipoIdentificacion"]) == "") {
                    $data["RESPUESTA"]="El tipo de identificación esta vacío"; 
                    $auxSw = false; 
                }

                if (trim($params["nroIdentificacion"]) == "") {
                    $data["RESPUESTA"]="El número de identificación esta vacío"; 
                    $auxSw = false; 
                }

                if (is_numeric(trim($params["nroIdentificacion"])) != 1 AND $auxSw) {
                    $data["RESPUESTA"]="El número de identificación debe ser numérico"; 
                    $auxSw = false; 
                }

				if($auxSw){ 
                    $datos=$this->wsm->getWsEstadoUsuario($params["tipoIdentificacion"],$params["nroIdentificacion"]);
                    
                    if (!$datos) {
                        $data["RESPUESTA"]="No existen datos";
                    } else {
                        $data["DATOS"]=$datos;
                    }           
                }
			}
            
			$this->output->set_content_type('application/json')->set_output(json_encode($data));
		}
		
		public function callWsProgramasUsuario(){
			
			$params = $_REQUEST;  
			$auxSw  = true;         
			
			if (count($params) == 0) {
				$data["RESPUESTA"] = "Faltan parámetros por enviar";
			} else {                 
                
                if (trim($params["tipoIdentificacion"]) == "") {
                    $data["RESPUESTA"]="El tipo de identificación esta vacío"; 
                    $auxSw = false; 
                }

                if (trim($params["nroIdentificacion"]) == "") {
                    $data["RESPUESTA"]="El número de identificación esta vacío"; 
                    $auxSw = false; 
                }

                if (is_numeric(trim($params["nroIdentificacion"])) != 1 AND $auxSw) {
                    $data["RESPUESTA"]="El número de identificación debe ser numérico"; 
                    $auxSw = false; 
                }

				if($auxSw){ 
                    $datos=$this->wsm->getWsProgramasUsuario($params["tipoIdentificacion"],$params["nroIdentificacion"]);
                    
                    if (!$datos) {
                        $data["RESPUESTA"]="No existen datos";
                    } else {
                        $data["DATOS"]=$datos;
                    }           
                }
			}
            
			$this->output->set_content_type('application/json')->set_output(json_encode($data));  
        }
        
        public function callWsSeguroUsuario(){
			
			$params = $_REQUEST;  
			$auxSw  = true;         
			
			if (count($params) == 0) {
				$data["RESPUESTA"] = "Faltan parámetros por enviar";
			} else {                 
                
                if (trim($params["nroIdentificacion"]) == "") {
                    $data["RESPUESTA"]="El número de identificación esta vacío"; 
                    $auxSw = false; 
                }

                if (is_numeric(trim($params["nroIdentificacion"])) != 1 AND $auxSw) {
                    $data["RESPUESTA"]="El número de identificación debe ser numérico"; 
                    $auxSw = false; 
                }

				if($auxSw){ 
                    $paramUrl = array($params["nroIdentificacion"]);
                    $datos = $this->utm->getDataCurlSias('COREMP', 'CORE3302MP', 'SP_VDIR_SEGURO_USUARIO', $paramUrl);
                                 
                    if (!$datos) {
                        $data["RESPUESTA"]="No existen datos";
                    } else {
                        $data["DATOS"]=$datos;
                    }           
                }
			}
            
			$this->output->set_content_type('application/json')->set_output(json_encode($data));  
		}


        //funcionque se ejecuta desde payu cuando se confirme el pago
        public function confirPago(){ 


                $senal_log = $this->utm->getParametro(78)->RESULTADO;

                if ($senal_log == 1) {
                    $datosParametros = json_encode($_REQUEST);
                    $this->utm->insert_log_debug('datosPayuConfirm',$datosParametros);
                }            

                $referenceCode = $_REQUEST['reference_sale'];
                $fechaInicial = "";
                $fechaFinal = "";
                $aux_new_valueArray = array();
                $aux_new_value = "";
                $new_value_count = 0;
                $lastValue = 0;
                $value = 0;

             // se creaa el signature con los datos de respuesta pra despues compararla

                $apikey = $this->utm->getParametro(32)->RESULTADO;
                $sign =   $_REQUEST['sign'];
                $value = (string)$_REQUEST['value'];
                $aux_new_valueArray = explode(".",$value);

                 if(isset($aux_new_valueArray[1])){

                    $aux_new_value = $aux_new_valueArray[1];
                    $new_value_count = strlen($aux_new_value)-1;
                    $lastValue = $aux_new_value[$new_value_count];

                    if ($lastValue == 0) {
                       $new_value = substr($value,0,strlen($value)-1);
                    }else{
                       $new_value = $value;
                    }

                 }else{
                    $new_value = $value.'.0';
                 }               


                $aux_signature = $apikey.'~'.$_REQUEST['merchant_id'].'~'.$referenceCode.'~'.$new_value.'~'.$_REQUEST['currency'].'~'.$_REQUEST['state_pol'];
                $signature = md5($aux_signature);                

                if ($senal_log == 1) {
                    $this->utm->insert_log_debug('apikey',$apikey);
                    $this->utm->insert_log_debug('referenceCode',$referenceCode);
                    $this->utm->insert_log_debug('new_value',$new_value);
                    $this->utm->insert_log_debug('signature',$signature);
                    $this->utm->insert_log_debug('sign',$sign);
                }
        

            if ($_REQUEST['state_pol'] == 4 AND $_REQUEST['response_code_pol'] == 1 AND $signature == $sign) { 
                 $formapago = 2;
                 $metodopayu = $_REQUEST['payment_method_id'];
                 if ($metodopayu == 2) {
                    $formapago = 4;                                                                      
                 } else if($metodopayu == 7){
                    $formapago = 1;
                 }
                 
                 $this->db->set('COD_FORMA_PAGO', $formapago);
                 $this->db->where('COD_RECIBO', $referenceCode);
                 $this->db->update('VDIR_FACTURA');

            }else{                 

                // se elimina setea a null el campo tipo de pago de la factura 
                 $this->db->set('COD_FORMA_PAGO', NULL);
                 $this->db->where('COD_RECIBO', $referenceCode);
                 $this->db->update('VDIR_FACTURA');

                 // se valida el tipo de conexion                 
                 $tipo_conexion = $this->utm->getParametro(53)->RESULTADO;
               

                if ($tipo_conexion == 1) {
                    //SIAS
                   
                    $parameters = array();

                    $parameters[] = 'B';
                    $parameters[] =  $referenceCode;
                    $parameters[] = '0';
                    $parameters[] = 0; 
                    $parameters[] = '0';           
                    $parameters[] = '0000-00-00';
                    $parameters[] = '0000-00-00';
                    $parameters[] = 0;
                    $parameters[] = 0; 
                    $parameters[] = 0;                    
                    $parameters[] = '0';
                    $parameters[] = '0';
                    $parameters[] = '0';  
                    $parameters[] = '0';
                    $parameters[] = '0';    
                    
                    $datos = $this->utm->getDataCurlSias('COREMP', 'CORE3302MP', 'SP_VDIR_GUARDAR_RECIBO', $parameters);
                   
                    
                }else{
                    //pendiente por definir
                }  
                 
            }       
       
      }
        
	}
	
	
?>