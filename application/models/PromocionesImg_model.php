<?php 

  class PromocionesImg_model extends CI_Model{
  	
  	 public function __construct() {
        parent::__construct(); 
  	 } 

  	 public function getDataImagen(){        

        $query = ":curs_datos := VDIR_PACK_TARIFAS.VDIR_FN_GET_DATOS_PROMO_IMG";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        $result = array();

        if (count($data) > 0) {
            $result = $data;
        }

        return $result;
        
  	 }

     public function guardarImagen($parameters){       

      $response = ''; 
      $s = oci_parse($this->db->conn_id, "begin VDIR_PACK_TARIFAS.VDIR_SP_SAVE_PROMO_IMG(:bind1,:bind2,:bind3,:bind4); end;"); 
      
      oci_bind_by_name($s, ":bind1", $parameters["file_name"],300);
      oci_bind_by_name($s, ":bind2", $parameters["file_name_encript"],300);
      oci_bind_by_name($s, ":bind3", $parameters["ruta_file"],300);
      oci_bind_by_name($s, ":bind4", $response,300); 
      oci_execute($s, OCI_DEFAULT);       

      return $response; 
     }
     

     public function eliminarImagen($codigo){         
        $response = ''; 
        $s = oci_parse($this->db->conn_id, "begin VDIR_PACK_TARIFAS.VDIR_SP_DELETE_PROMO_IMG(:bind1,:bind2); end;"); 
        
        oci_bind_by_name($s, ":bind1", $codigo);              
        oci_bind_by_name($s, ":bind2", $response,300); 
        oci_execute($s, OCI_DEFAULT);       

        return $response; 
     }	
     
  }
 ?>