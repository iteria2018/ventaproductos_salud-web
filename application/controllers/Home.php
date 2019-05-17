<?php 

defined('BASEPATH') OR exit('No direct script access allowed');
class Home extends CI_Controller{

	public function __construct() {
		parent::__construct();		
		$this->load->model('Home_model'); 
       	$this->load->model('Utilidades_model');		       
	}
	
	public function index() {
		$this->Utilidades_model->validaSession();
		$data = array();
		$data["slider"] = $this->getImagenesCarrucelInicio();
        $this->load->view('Home', $data);
	}

	public function getImagenesCarrucelInicio(){
		
		$cod_parametro = 3;
		$codigo_plan = $this->session->userdata('codigo_plan');
		
		$datos = $this->Home_model->getDataImgPromo($codigo_plan);		
		$baseUrl = $this->Utilidades_model->getParametro($cod_parametro)->RESULTADO; 		
		
		$htmlImagenes = '';	
		$htmlOl = '';
		$inicio_ol = '<ol class="carousel-indicators">';
		$fin_ol = '</ol>';
		$inicioCarrucel = '<div class="carousel-inner">';
		$finCarrucel = '</div>';
		$imgNextPrev = '<a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
			                  <i class="material-icons">keyboard_arrow_left</i>
			                  <span class="sr-only">Previous</span>
			                </a>

			                <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
			                  <i class="material-icons">keyboard_arrow_right</i>
			                  <span class="sr-only">Next</span>
			                </a>';
        $cadenaRetorno = '';
        
        $htmlCarrucel = ''; 			                

	    if ($datos != null) {

	     	 $contador = 0;
	     	 $active = "";	
	     	 for ($i=0; $i < count($datos) ; $i++) {

		     	 $value = $datos[$i]; 
		     	 $contador = $i;   	          
		    
		     	 if($contador == 0){
                     $active = "active";
		     	 }else{
		     	 	$active = "";
		     	 }

		     	 $htmlOl .= '<li data-target="#carouselExampleIndicators" data-slide-to="'.$contador.'" class="'.$active.'"></li>';

		         $htmlImagenes .= '<div class="carousel-item '.$active.'">		                               
																	<img class="d-block w-100" src="'.$baseUrl . $value["RUTA_FILE"].'" alt="First slide">	
																	<div class="carousel-caption d-none d-md-block">					                      					                    
																			<div class="row text-center">
																					<div class="col-12">
																							<button id="btn_comprar" onclick="validMora();" class="btn btn-primary boton-vd btn-gestion-compra"><span><i class="material-icons">shopping_cart</i></span> &nbsp;&nbsp;Inicia tu compra aqu&iacute;</button>
																					</div>
																			</div>					                      
																	</div>				                    
															</div>'; 			     		                                  
		     }

		    $htmlOl = $inicio_ol.$htmlOl.$fin_ol;
		    $htmlCarrucel = $inicioCarrucel.$htmlImagenes.$finCarrucel;
		    $cadenaRetorno = $htmlOl.$htmlCarrucel.$imgNextPrev;
	    }


    	
	 	return $cadenaRetorno;


	}

	public function verAyudaFooter() {
		$data          = array();
		$data["ayuda"] = $this->Utilidades_model->getParametro(20)->RESULTADO;
		$result        = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}

	
}
?>