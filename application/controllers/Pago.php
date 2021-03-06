<?php 

defined('BASEPATH') OR exit('No direct script access allowed');
//require_once APPPATH.'controllers/Gestion_compra.php';
class Pago extends CI_Controller{
	
	public function __construct() {
		parent::__construct();		
       	$this->load->model('Utilidades_model');	       
	}
	
	public function index() { 
		$this->Utilidades_model->validaSession();       
	}	

	public function responseUrl(){ 

		if ($_REQUEST['transactionState'] == 4) {
			  $valida = $this->Utilidades_model->getParametro(82)->RESULTADO;
			  if($valida == 0){
				$referenceCode = $_REQUEST['referenceCode'];
				$formapago = 2;
				$metodopayu = $_REQUEST['polPaymentMethodType'];
				if ($metodopayu == 2) {
					$formapago = 4;                                                                      
				} else if($metodopayu == 7){
					$formapago = 1;
				}
				$this->db->set('FECHA_PAGO', "to_date('".$_REQUEST['processingDate']."','yyyy-mm-dd')",false);
                $this->db->set('FRANQUICIA_PAGO', $_REQUEST['lapPaymentMethod']);
				$this->db->set('COD_FORMA_PAGO', $formapago);
				$this->db->where('COD_RECIBO', $referenceCode);
				$this->db->update('VDIR_FACTURA');
			  }
			 
			 //$this->index();	
			 redirect("Gestion_compra?param=1");			
	    }else{

	    	 $url = "Gestion_compra?param=0";
	    	 redirect($url);
	    	    
	    }	    
       
    }
	
}
?>