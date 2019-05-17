<?php

class Tarifa_model extends CI_Model{
  	
    public function __construct() {
        parent::__construct(); 
    }

    /**
     * Retorna una array con los datos de los programas y 
     * las tarifas asociadas al producto
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 28/01/2019
     * 
     *   
     * @return array Datos de la consulta
     */
    public function getTarifas(){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_TARIFAS.fnGetTarifas";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }
    
    /**
     * Retorna una array con los datos de los tipos de tarifas
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 28/01/2019
     * 
     *   
     * @return array Datos de la consulta
     */
    public function getTiposTarifas(){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_TARIFAS.fnGetTipoTarifas";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

    /**
     * Retorna una array con los datos de los tipos de generos
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 28/01/2019
     * 
     *   
     * @return array Datos de la consulta
     */
    public function getGeneros(){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_TARIFAS.fnGetGeneros";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

    /**
     * Retorna una array con los datos de los tipos de condiciones
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 28/01/2019
     * 
     *   
     * @return array Datos de la consulta
     */
    public function getTipoCondiciones(){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_TARIFAS.fnGetCondicionTarifa";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

    /**
     * Retorna una array con los datos de los números de usuarios por tarifa
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 28/01/2019
     * 
     *   
     * @return array Datos de la consulta
     */
    public function getNumUsuarios(){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_TARIFAS.fnGetNumUsuarios";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

     /**
     * Retorna una array con los datos de los productos por plan
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 28/01/2019
     * 
     * @param integer  $codPlan   Código del plan
     * 
     *   
     * @return array Datos de los programas por plan
     */
    public function getProgramasPlan($codPlan){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_TARIFAS.fnGetProgramasPlan(".$codPlan.")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }


     /**
     * Retorna una array con los datos de las tarifas
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 28/01/2019
     * 
     * @param integer  $codTarifa   Código de la tarifa
     * 
     *   
     * @return array Datos de la tarifa
     */
    public function getTarifa($codTarifa){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_TARIFAS.fnGetTarifa(".$codTarifa.")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

     /**
     * Indica si la tarifa ya existe con el código ingresado
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 31/01/2019
     * 
     * @param string   $codTarifaMP  Código de la tarifa MP
     *  
     * 
     * @return integer Código de la tarifa si existe
     */
    public function getExisteTarifa($codTarifaMP){

        $query = "SELECT VDIR_PACK_CONSULTA_TARIFAS.fnGetExisteTarifa(?) AS cod_tarifa FROM DUAL";
        $consulta = $this->db->query($query,array('param1' =>$codTarifaMP));        
        return $consulta->row();

    }

    /**
     * Guarda el programa asociado al plan
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 28/01/2019
     * 
     * @param integer  $codPlanPrograma  Código del plan asociado al programa
     * @param integer  $codPlan          Código del plan
     * @param integer  $codEstado        Código del estado
     * @param integer  $codTipoTarifa    Código del tipo de tarifa
     * @param integer  $valorTarifa      Valor de la tarifa
     * @param string   $fecVigenciaIni   Fecha inicio de vigencia
     * @param string   $fecVigenciaFin   Fecha fin de vigencia
     * @param integer  $codCondicion     Código de la condición
     * @param integer  $codNumUsuarios   Código del número de usuarios
     * @param integer  $codSexo          Código del genero
     * @param integer  $edadInicial      Edad mínima
     * @param integer  $edadFinal        Edad máxima
     * 
     * @return array  Retorna array indicando si se guarda exitosamente o si hubieron errores
     */
    public function saveTarifa($arrayParam){

        $errors = array();
        $ret    = true;
        //Abrir la transacción db
        $this->db->trans_begin();
            
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_TARIFAS.prGuardarTarifa(:inu_codPlanPrograma,:inu_codPlan,:inu_codEstado,:inu_codTipoTarifa,:inu_valorTarifa,TO_DATE(:idt_fecVigenciaIni,'dd/mm/yyyy'),TO_DATE(:idt_fecVigenciaFin,'dd/mm/yyyy'),:inu_codCondicion,:inu_codNumUsuarios,:inu_codSexo,:inu_edadInicial,:inu_edadFinal,:ivc_codTarifaMP); END;");
        
        oci_bind_by_name($s, ":inu_codPlanPrograma", $arrayParam['codPlanPrograma']);
        oci_bind_by_name($s, ":inu_codPlan",         $arrayParam['codPlan']);
		oci_bind_by_name($s, ":inu_codEstado",       $arrayParam['codEstado']);
		oci_bind_by_name($s, ":inu_codTipoTarifa",   $arrayParam['codTipoTarifa']);
		oci_bind_by_name($s, ":inu_valorTarifa",     $arrayParam['valorTarifa']);
		oci_bind_by_name($s, ":idt_fecVigenciaIni",  $arrayParam['fecVigenciaIni']);
		oci_bind_by_name($s, ":idt_fecVigenciaFin",  $arrayParam['fecVigenciaFin']);
		oci_bind_by_name($s, ":inu_codCondicion",    $arrayParam['codCondicion']);
		oci_bind_by_name($s, ":inu_codNumUsuarios",  $arrayParam['codNumUsuarios']);
		oci_bind_by_name($s, ":inu_codSexo",         $arrayParam['codSexo']);
		oci_bind_by_name($s, ":inu_edadInicial",     $arrayParam['edadInicial']);
        oci_bind_by_name($s, ":inu_edadFinal",       $arrayParam['edadFinal']);
        oci_bind_by_name($s, ":ivc_codTarifaMP",     $arrayParam['codTarifaMP']);
        
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
     * @date  : 28/01/2019
     * 
     * @param integer  $codTarifa        Código de la tarifa
     * @param integer  $codPlanPrograma  Código del plan asociado al programa
     * @param integer  $codPlan          Código del plan
     * @param integer  $codEstado        Código del estado
     * @param integer  $codTipoTarifa    Código del tipo de tarifa
     * @param integer  $valorTarifa      Valor de la tarifa
     * @param string   $fecVigenciaIni   Fecha inicio de vigencia
     * @param string   $fecVigenciaFin   Fecha fin de vigencia
     * @param integer  $codCondicion     Código de la condición
     * @param integer  $codNumUsuarios   Código del número de usuarios
     * @param integer  $codSexo          Código del genero
     * @param integer  $edadInicial      Edad mínima
     * @param integer  $edadFinal        Edad máxima
     * 
     * @return array  Retorna array indicando si se guarda exitosamente o si hubieron errores
     */
    public function updateTarifa($codTarifa,$arrayParam){

        $errors = array();
        $ret    = true;
        //Abrir la transacción db
        $this->db->trans_begin();
            
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_TARIFAS.prActualizarTarifa(:inu_codTarifa,:inu_codPlanPrograma,:inu_codPlan,:inu_codEstado,:inu_codTipoTarifa,:inu_valorTarifa,TO_DATE(:idt_fecVigenciaIni,'dd/mm/yyyy'),TO_DATE(:idt_fecVigenciaFin,'dd/mm/yyyy'),:inu_codCondicion,:inu_codNumUsuarios,:inu_codSexo,:inu_edadInicial,:inu_edadFinal); END;");
        
        oci_bind_by_name($s, ":inu_codTarifa",       $codTarifa);
        oci_bind_by_name($s, ":inu_codPlanPrograma", $arrayParam['codPlanPrograma']);
        oci_bind_by_name($s, ":inu_codPlan",         $arrayParam['codPlan']);
		oci_bind_by_name($s, ":inu_codEstado",       $arrayParam['codEstado']);
		oci_bind_by_name($s, ":inu_codTipoTarifa",   $arrayParam['codTipoTarifa']);
		oci_bind_by_name($s, ":inu_valorTarifa",     $arrayParam['valorTarifa']);
		oci_bind_by_name($s, ":idt_fecVigenciaIni",  $arrayParam['fecVigenciaIni']);
		oci_bind_by_name($s, ":idt_fecVigenciaFin",  $arrayParam['fecVigenciaFin']);
		oci_bind_by_name($s, ":inu_codCondicion",    $arrayParam['codCondicion']);
		oci_bind_by_name($s, ":inu_codNumUsuarios",  $arrayParam['codNumUsuarios']);
		oci_bind_by_name($s, ":inu_codSexo",         $arrayParam['codSexo']);
		oci_bind_by_name($s, ":inu_edadInicial",     $arrayParam['edadInicial']);
		oci_bind_by_name($s, ":inu_edadFinal",       $arrayParam['edadFinal']);
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