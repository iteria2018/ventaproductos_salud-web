<?php 

defined('BASEPATH') OR exit('No direct script access allowed');
class Cron extends CI_Controller{

	public function __construct() {
		parent::__construct();
		$this->load->model('Cron_model'); 
       	$this->load->model('Utilidades_model');
    }   

    public function verificarSesion(){

        $respuesta = $this->Cron_model->verificarSesion();
        $this->output->set_content_type('application/json')->set_output($respuesta);          
    }

    public function verificarSesionServer(){

        $respuesta = $this->Cron_model->verificarSesion();  
        if($respuesta == 0){           
           redirect('Login');
        }     
    }    


}

?>