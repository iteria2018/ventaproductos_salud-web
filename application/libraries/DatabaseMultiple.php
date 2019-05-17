<?php 
defined('BASEPATH') OR exit('No direct script access allowed');   
    class DatabaseMultiple {
        
        public function __construct() {
            $this->load();
	    }
        
        //Se ignora la conexión del framework para realizar multiples conexiones
        public function load() {
            $CI =& get_instance();
            $CI->db2 = $CI->load->database('sql_server', TRUE);            
	    }
        
    }
	
?>