<?php

class Gc_paso_4_model extends CI_Model{
  	
    public function __construct() {
        parent::__construct(); 
    }

    public function getTipoIdentificacion_data(){
        $query = ":curs_datos := VDIR_PACK_INICIO_SESSION.VDIR_FN_GET_TIPO_DOCUMENTO";          
        $data = $this->Utilidades_model->getDataRefCursor($query);

        if(count($data) > 0){
            return $data;
        }else{
            return array();
        }
    }

     public function getDatosPago($cod_afiliacion){         

         $query = ":curs_datos :=  VDIR_PACK_UTILIDADES.VDIR_FN_GET_DATOS_PAGO(".$cod_afiliacion.")";
         
         $data = $this->Utilidades_model->getDataRefCursor($query); 

          if (count($data) > 0) {
              return $data;
          }else{
              return false;
          }
     }    
}

?>