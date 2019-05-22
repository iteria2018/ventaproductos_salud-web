<?php 

defined('BASEPATH') OR exit('No direct script access allowed');
class Gc_paso_4 extends CI_Controller{

	public function __construct() {
		parent::__construct();		
        $this->load->model('Gestion_compra_model');
        $this->load->model('Gc_paso_4_model');  
       	$this->load->model('Utilidades_model');		       
	}
	
	public function index() {
        $this->Utilidades_model->validaSession();
		$data = array();
		
		$this->load->view('gestion_compra', $data);
    }

    public function getFormularioPago(){

        $cod_afiliacion = $this->input->post('cod_afiliacion');            

        $result = $this->Gc_paso_4_model->getDatosPago($cod_afiliacion);
        $datos = $result[0];          
        
        $server = $this->Utilidades_model->getParametro(3)->RESULTADO;
        $path = $this->Utilidades_model->getParametro(83)->RESULTADO;        		
		$baseUrl = $server.$_SERVER["HTTP_HOST"].$path;	

        $referenceCode = $this->generarCodigoSias($datos); 

        $responseUrl = $baseUrl."Pago/responseUrl";
        $confirmationUrl = $baseUrl."WebService/confirPago";
        $aux_signature = $datos["APIKEY"].'~'.$datos["MERCHANTID"].'~'.$referenceCode.'~'.$datos["AMOUNT"].'~'.$datos["CURRENCY"];
        $signature = md5($aux_signature);
        $url_ejecucion =  $datos["URL_EJECUCION"];           

        $formulario = '<form method="post" id="form_payu" action="'.$url_ejecucion.'">
						<input name="merchantId"    type="hidden"  value="'.$datos["MERCHANTID"].'">                       
                        <input name="referenceCode" type="hidden"  value="'.$referenceCode.'" >
                        <input name="accountId"     type="hidden"  value="'.$datos["ACCOUNTID"].'" >
						<input name="description"   type="hidden"  value="'.$datos["DESCRIPTION"].'"  >
						<input name="amount"  		type="hidden"  value="'.$datos["AMOUNT"].'">
						<input name="tax"           type="hidden"  value="0"  >
						<input name="taxReturnBase" type="hidden"  value="0" >
						<input name="currency"      type="hidden"  value="'.$datos["CURRENCY"].'" >
						<input name="signature"     type="hidden"  value="'.$signature.'"  >
						<input name="test"          type="hidden"  value="'.$datos["TESTT"].'" >
						<input name="buyerEmail"    type="hidden"  value="'.$datos["EMAIL"].'" >
						<input name="buyerFullName" type="hidden"  value="'.$datos["NOMBRE_COMPLETO"].'">        
						<input name="responseUrl"   type="hidden"  value="'.$responseUrl.'" >
						<input name="confirmationUrl"    type="hidden"  value="'. $confirmationUrl.'" >						
				     </form>';
  
    	if ($referenceCode != -1) {  

	    	 $this->db->set('COD_RECIBO',$referenceCode);
			 $this->db->where('COD_FACTURA', $datos["CODIGO_FACTURA"]);
			 $this->db->update('VDIR_FACTURA');
	    }

	   $data = array();
       $data["formulario"] = $formulario;
       $data["codigo_recibo"] = $referenceCode;       
   
       $this->output->set_content_type('application/json')->set_output(json_encode($data));     

    }

    /**
     * Consume trae el numero de recibo de sias 
     * 
     * @author: Ever hidalgo
     * @date  : 27/02/2019
     * 
     * 
     * @return int numro recibo
     */

    function generarCodigoSias($datos){    	

    	$tipo_conexion = $this->Utilidades_model->getParametro(53)->RESULTADO;
    	$numero_recibo = -1;
    	$fechaInicial = ""; 
    	$fechaFinal = "";     	
    	$fechaActual = date('j-m-Y');
    	$dia = intval(date("d"));
    	$mes = intval(date("m"));    			

    	if ($dia <= 15) {
    	    $dia = "15";
			$mes = date("m", strtotime("$fechaActual"));
			$anio = date("Y", strtotime("$fechaActual")); 
			$fechaInicial = $anio."-".$mes."-".$dia;	
    	}else if($dia > 15 && $mes == 12){

	      	$dia = "01";
			$mes = '01';
			$anio = date("Y", strtotime("$fechaActual +1 year")); 
			$fechaInicial = $anio."-".$mes."-".$dia;
    	}else if($dia > 15 && $mes != 12){
            $dia = "01";
            $mes = date("m", strtotime("$fechaActual +1 month"));
            $anio = date("Y");
			$fechaInicial = $anio."-".$mes."-".$dia;
    	}

    	$dia = date("d", strtotime("$fechaInicial"));
		$mes = date("m", strtotime("$fechaInicial"));
	    $anio = date("Y", strtotime("$fechaInicial +1 year"));

        $fechaFinal = $anio."-".$mes."-".$dia;      	

    	if ($tipo_conexion == 1) {
    		//SIAS
    		$parameters = array();

    		$parameters[] = 'I';
            $parameters[] = 0;
    		$parameters[] = 'SL';
    		$parameters[] = intval($datos["NUMERO_IDENTIFICACION"]); 
    		$parameters[] = 'AA';    		
    		$parameters[] = $fechaInicial;
    		$parameters[] = $fechaFinal;
    		$parameters[] = intval($datos["CANTIDAD"]);
    		$parameters[] = intval($datos["AMOUNT"]); 
    		$parameters[] = intval($datos["AMOUNT"]);    		
    		$parameters[] = $datos["TIPO_PLAN"];
    		$parameters[] = $datos["PROGRAMA"];
    		$parameters[] = '4';  
    		$parameters[] = $datos["EMAIL"];
    		$parameters[] = 'VDIR';

            $sistema = $this->Utilidades_model->getParametro(79)->RESULTADO;
            $token = $this->Utilidades_model->getParametro(80)->RESULTADO;
            $nombre = $this->Utilidades_model->getParametro(81)->RESULTADO;
            $datos = $this->Utilidades_model->getDataCurlSias($sistema, $token, $nombre, $parameters);
            
            $respuestaDatos = json_decode($datos,true); 
            $length = count($respuestaDatos["respuesta"]);                          
            
            if ($respuestaDatos["respuesta"] == null) {
                $numero_recibo = -1;
            } else {
            	$length = count($respuestaDatos["respuesta"]);
                $numero_recibo = $respuestaDatos["respuesta"][$length-1]["CONS"];
            }    
    		
    	}else{
    		//pendiente por definir
    	}
       
    	return $numero_recibo;
    }

    /**
     * Consume la url del servicio que se envie
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 20/02/2019
     * 
     * 
     * @return string Cadena con el token de Acceso
     */
    public function consultarPagoPayu($postData,$urlApiEchoSign,$indProxy){

        $header = array('Content-Type: application/json;charset=UTF-8');

        $ch = curl_init($urlApiEchoSign);
        curl_setopt($ch, CURLOPT_HEADER,         false);
        curl_setopt($ch, CURLOPT_HTTPHEADER,     $header);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLINFO_HEADER_OUT,    true);

        if ($postData != null){

            curl_setopt($ch, CURLOPT_POST, 1);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
        }
        
        //Si se envia el proxy
        if (indProxy == 1){
            curl_setopt($ch, CURLOPT_PROXY, proxyCurl);
            curl_setopt($ch, CURLOPT_PROXYUSERPWD, userPwdProxy);            
        }

        $response = curl_exec($ch);
        $status   = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        
        if ($status != 200 && $status != 201) {
            echo "Error al llamar el servicio Web, El estatus es:" . $status. ", ".curl_error($ch);
            exit(-1);
        }

        curl_close($ch);

        return $response;
    }

}

?>