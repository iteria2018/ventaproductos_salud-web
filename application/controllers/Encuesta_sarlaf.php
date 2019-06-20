<?php 

defined('BASEPATH') OR exit('No direct script access allowed');
class Encuesta_sarlaf extends CI_Controller{

	public function __construct() {
		parent::__construct();		
       	$this->load->model('Utilidades_model');	
       	$this->load->model("Encuesta_sarlaf_model");	       
	}
	
	public function index(){
		$this->Utilidades_model->validaSession();
       	$this->load->view('Encuesta_sarlaf');
    }

	public function save_encuesta_sarlaf(){

		   $data = $this->input->post("datos");
		   $retorno = array();
		   $result = "";	

		    //Abrir la transaccion db
		   $this->db->trans_begin(); 	  

		   foreach ($data as $value) {

		   	  $obj = array(  
	                     'codigo_encuesta' =>  $value["codigo_encuesta"],                     
	                     'codigo_pregunta' => $value["codigo_pregunta"],
	                     'codigo_respuesta' => $value["codigo_respuesta"], 
	                     'codigo_afiliacion' => $value["codigo_afiliacion"],
	                     'valor_respuesta' => $value["valor_respuesta"],
	                     'codigo_persona' =>  $this->session->userdata('codigoPersona') //$value["codigo_persona"]                  
                      );
              $result = $this->Encuesta_sarlaf_model->save_encuesta_sarlaf($obj); 

              if ($result == '-1') {
                  break;     	 	
              }           	 
		   	
		   }

		  //Confirmar commit si se el resultado es diferente de -1
		    if ($this->db->trans_status() === FALSE){
            	$this->db->trans_rollback();
	        }else{
	            $this->db->trans_commit();
	        }
           

	        if ($result == '-1') {
	        	$result == "Ocurrio un error en la base de datos";
	        }

            $retorno['respuesta'] = $result; 


            $this->output->set_content_type('application/json')->set_output(json_encode($retorno));           
    }

    public function save_encuesta_salud(){

		   $data = $this->input->post("datos");
		   $retorno = array();
		   $result = "";

		  //Abrir la transaccion db
		   $this->db->trans_begin(); 	  

		   foreach ($data as $value) {

		   	  $obj = array(  
	                     'codigo_encuesta' =>  $value["codigo_encuesta"],                     
	                     'codigo_pregunta' => $value["codigo_pregunta"],
	                     'codigo_respuesta' => $value["codigo_respuesta"], 
	                     'codigo_afiliacion' => $value["codigo_afiliacion"],
	                     'valor_respuesta' => $value["valor_respuesta"],
	                     'codigo_persona' =>  $value["codigo_persona"]                  
                      );
              $result = $this->Encuesta_sarlaf_model->save_encuesta_salud($obj); 

              if ($result == '-1') {
                  break;     	 	
               }         	 
		   	
		   }

		   //Confirmar commit si se el resultado es diferente de -1
		    if ($this->db->trans_status() === FALSE){
            	$this->db->trans_rollback();
	        }else{
	            $this->db->trans_commit();
	        }

	        if ($result == '-1') {
	        	$result == "Ocurrio un error en la base de datos";
	        }

            $retorno['respuesta'] = $result;            

            $this->output->set_content_type('application/json')->set_output(json_encode($retorno));           
    }

	public function getEncuestaSarlaf(){

		 $codigo_afiliacion = $this->input->post("codigo_afiliacion");
	  	 $codigo_contratante = $this->input->post("codigo_contratante");

	 	 $data["encuestaSarlaf"] = $this->Encuesta_sarlaf_model->getDataEncuestaSarlaf($codigo_afiliacion,$codigo_contratante); 
	 	 $this->output->set_content_type('application/json')->set_output(json_encode($data));

	}

	public function getEncuestaSarlafDilig(){

	  	 $codigo_afiliacion = $this->input->post("codigo_afiliacion");
	  	 $codigo_contratante = $this->input->post("codigo_contratante");

	 	 $data["encuestaSarlafDilig"] = $this->Encuesta_sarlaf_model->getDataEncuestaSarlafDatos($codigo_afiliacion,$codigo_contratante); 
	 	 $this->output->set_content_type('application/json')->set_output(json_encode($data));

	}

	public function getEncuestaSalud(){
	 	
	  	 $edad = $this->input->post("edad");
	  	 $codigo_sexo = $this->input->post("codigo_sexo");
	  	 $codigo_afiliacion = $this->input->post("codigo_afiliacion");
	  	 $codigo_beneficiario = $this->input->post("codigo_beneficiario");

	 	 $data["encuestaSalud"] = $this->Encuesta_sarlaf_model->getDataEncuestaSalud($edad,$codigo_sexo,$codigo_afiliacion,$codigo_beneficiario); 
	 	 $this->output->set_content_type('application/json')->set_output(json_encode($data));

	}

	public function getEncuestaSaludDilig(){

	  	 $edad = $this->input->post("edad");
	  	 $codigo_sexo = $this->input->post("codigo_sexo");
	  	 $codigo_afiliacion = $this->input->post("codigo_afiliacion");
	  	 $codigo_beneficiario = $this->input->post("codigo_beneficiario");

	 	 $data["encuestaSaludDilig"] = $this->Encuesta_sarlaf_model->getDataEncuestaSaludDatos($edad,$codigo_sexo,$codigo_afiliacion,$codigo_beneficiario); 
	 	 $this->output->set_content_type('application/json')->set_output(json_encode($data));

	}

	/**
	 * Retorna json indicando si se diligencio o no la encuesta
	 * 
	 * @author: Katherine Latorre Mejía
	 * @date  : 15/01/2019
	 * 
	 *  
	 * @return application/json  Información de la validación de la encuesta
	 */
	public function getValidaEncuesta(){
		
		$data = array();

		$codPersona      = $this->input->post("codPersona");
		$codAfiliacion   = $this->input->post("codAfiliacion");
		$codEncuesta     = $this->input->post("codEncuesta");
		$validaEncuesta  = $this->Encuesta_sarlaf_model->getValidaEncuesta($codPersona,$codAfiliacion,$codEncuesta)->VALIDA_ENCUESTA;
		
	    $data['validaEncuesta'] = $validaEncuesta;
	    $result = json_encode($data);
		$this->output->set_content_type('application/json')->set_output($result);
	}


	/**
	 * Retorna un arrar con los beneficiarios que no pueden comprar un producto
	 * 
	 * @author: Ever Hidalgo
	 * @date  : 18/02/2019
	 * 
	 *  
	 * @return application/json  Información de los beneficiarios que no pueden comprar un producto
	 */

     public function validaEncuestaSaludDatos(){

     	$cod_afiliacion = $this->input->post("codigo_afiliacion");
     	$datos = array();    	
     	$fomularioIni = '<form id="form_valida"><div class="container">
     	                 <div class="row"><div class="col-12 text-justify"><label>Debido a la condición  de salud actual del beneficiario: </label> </div></div>';
     	$fomularioFin = '</div></form>';
     	$cadena = "";
     	$formularioFinal = "";
     	$campoDiv = '<div class="row"><div class="col-12 text-justify">
     	             <label> No se puede continuar con el proceso de compra de determinado producto, En breve un asesor se pondrá en contacto con usted</label>
     	            </div></div>';

     	$datos  = $this->Encuesta_sarlaf_model->validaEncuestaSalud($cod_afiliacion);

       if (count($datos) > 0) {      	
       
	        for ($i=0; $i < count($datos) ; $i++) { 
	        	$cadena .= '<div class="col-12 font-weight-bold"> '.mb_convert_case($datos[$i]["BENEFICIARIO"], MB_CASE_TITLE, "UTF-8").' </div>';        	
	        }
			
	        $formularioFinal = $fomularioIni.'<div class="row">'.$cadena.'</div><br>'.$campoDiv.$fomularioFin;
       }

       $this->output->set_content_type('application/json')->set_output(json_encode($formularioFinal));

  }

	
}
?>