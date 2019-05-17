<?php

class Linea_model extends CI_Model{
  	
    public function __construct() {
        parent::__construct(); 
    }

    /**
     * Retorna una array con los datos de los programas y 
     * productos asociados al plan y las coberturas
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 24/01/2019
     * 
     *   
     * @return array Datos de la consulta
     */
    public function getLineas(){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_LINEAS.fnGetLineas";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }
    
    /**
     * Retorna una array con los datos de los productos
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 24/01/2019
     * 
     *   
     * @return array Datos de la consulta
     */
    public function getProductos(){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_LINEAS.fnGetProductos";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }
    
    /**
     * Retorna una array con los datos de los programas
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 24/01/2019
     * 
     *   
     * @return array Datos de la consulta
     */
    public function getProgramas($codProducto){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_LINEAS.fnGetProgramas(".$codProducto.")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }
    
    /**
     * Retorna una array con los datos de los planes
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 24/01/2019
     * 
     *   
     * @return array Datos de la consulta
     */
    public function getPlanes(){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_LINEAS.fnGetPlanes";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

    /**
     * Retorna una array con los datos de los estados
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 24/01/2019
     * 
     *   
     * @return array Datos de la consulta
     */
    public function getEstados($indTipo){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_LINEAS.fnGetEstados(".$indTipo.")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

     /**
     * Retorna una array con los datos de las lineas por código de linea
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 23/01/2019
     * 
     * @param integer  $codPlanPrograma   Código del plan por programa
     * 
     *   
     * @return array Datos de los planes por programa
     */
    public function getPlanPrograma($codPlanPrograma){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_LINEAS.fnGetPlanPrograma(".$codPlanPrograma.")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

    /**
     * Guarda el programa asociado al plan
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 25/01/2019
     * 
     * @param integer  $codPlan             Código del plan
     * @param integer  $codPrograma         Código del programa
     * @param integer  $codEstado           Código del estado
     * @param string   $coberturaInicial    Ruta de la carpeta donde se guarda la cobertura inicial
     * @param string   $coberturaFinal      Ruta de la carpeta donde se guarda la cobertura final
     * @param string   $codProgramaHomologa Código de hologacion presmed para el programa (Producto)
     * 
     * @return array  Retorna array indicando si se guarda exitosamente o si hubieron errores
     */
    public function savePlanPrograma($codPlan,$codPrograma,$codEstado,$coberturaInicial,$coberturaFinal,$codProgramaHomologa){

        $errors = array();
        $ret    = true;
        //Abrir la transacción db
        $this->db->trans_begin();
            
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_LINEAS.prGuardarPlanPrograma(:inu_codPlan,:inu_codPrograma,:inu_codEstado,:ivc_coberturaInicial,:ivc_coberturaFinal,:ivc_codProgramaHomologa); END;");
        
        oci_bind_by_name($s, ":inu_codPlan", $codPlan);
        oci_bind_by_name($s, ":inu_codPrograma", $codPrograma);
        oci_bind_by_name($s, ":inu_codEstado", $codEstado);
        oci_bind_by_name($s, ":ivc_coberturaInicial", $coberturaInicial);
        oci_bind_by_name($s, ":ivc_coberturaFinal", $coberturaFinal);
        oci_bind_by_name($s, ":ivc_codProgramaHomologa", $codProgramaHomologa);
        oci_execute($s, OCI_DEFAULT);
            
        if ($this->db->trans_status() === FALSE){

            $this->db->trans_rollback();
            $errNo   = $this->db->_error_number();
            $errMess = $this->db->_error_message();
            array_push($errors, array($errNo, $errMess));
            $ret = false;

        }else{
            $this->db->trans_commit();
        }

        $data['ret']    = $ret;
        $data['errors'] = $errors;

        return $data;

    }

     /**
     * Guarda el programa asociado al plan
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 25/01/2019
     * 
     * @param integer  $codPlanPrograma     Código del plan asociado al programa
     * @param integer  $codPlan             Código del plan
     * @param integer  $codPrograma         Código del programa
     * @param integer  $codEstado           Código del estado
     * @param string   $coberturaInicial    Ruta de la carpeta donde se guarda la cobertura inicial
     * @param string   $coberturaFinal      Ruta de la carpeta donde se guarda la cobertura final
     * @param string   $codProgramaHomologa Código de hologacion presmed para el programa (Producto)
     * @return array  Retorna array indicando si se guarda exitosamente o si hubieron errores
     */
    public function updatePlanPrograma($codPlanPrograma,$codPlan,$codPrograma,$codEstado,$coberturaInicial,$coberturaFinal,$codProgramaHomologa){

        $errors = array();
        $ret    = true;
        //Abrir la transacción db
        $this->db->trans_begin();
            
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_LINEAS.prActualizarPlanPrograma(:inu_codPlanPrograma,:inu_codPlan,:inu_codPrograma,:inu_codEstado,:ivc_coberturaInicial,:ivc_coberturaFinal,:ivc_codProgramaHomologa); END;");
        
        oci_bind_by_name($s, ":inu_codPlanPrograma", $codPlanPrograma);
        oci_bind_by_name($s, ":inu_codPlan", $codPlan);
        oci_bind_by_name($s, ":inu_codPrograma", $codPrograma);
        oci_bind_by_name($s, ":inu_codEstado", $codEstado);
        oci_bind_by_name($s, ":ivc_coberturaInicial", $coberturaInicial);
        oci_bind_by_name($s, ":ivc_coberturaFinal", $coberturaFinal);
        oci_bind_by_name($s, ":ivc_codProgramaHomologa", $codProgramaHomologa);
        oci_execute($s, OCI_DEFAULT);
            
        if ($this->db->trans_status() === FALSE){

            $this->db->trans_rollback();
            $errNo   = $this->db->_error_number();
            $errMess = $this->db->_error_message();
            array_push($errors, array($errNo, $errMess));
            $ret = false;

        }else{
            $this->db->trans_commit();
        }

        $data['ret']    = $ret;
        $data['errors'] = $errors;

        return $data;
        
    }

}

?>