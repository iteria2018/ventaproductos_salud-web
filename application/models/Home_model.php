<?php

class Home_model extends CI_Model{
  	
    public function __construct() {
        parent::__construct(); 
    }

    public function getDataImgPromo($codigo_plan){

        $codPlan = $codigo_plan == null ? 0 : $codigo_plan;

        $query = ":curs_datos := VDIR_PACK_INICIO_SESSION.VDIR_FN_GET_DATOS_IMG_PROMO(".$codPlan.")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return false;
        }    
             
    }  

    
}

?>