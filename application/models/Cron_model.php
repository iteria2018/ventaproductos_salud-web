<?php

class Cron_model extends CI_Model{
  	
    public function __construct() {
        parent::__construct(); 
        $this->load->model('Utilidades_model');
    }  

    public function verificarSesion(){

        $codUser = $this->session->userdata('codigo_usuario');  
        $data = 1; 
        if(!$codUser){
           $data = 0;         
        }
        return $data;                
    } 
    
}

?>