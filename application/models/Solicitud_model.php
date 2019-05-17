<?php

class Solicitud_model extends CI_Model{
  	
    public function __construct() {
        parent::__construct(); 
    }

     /**
     * Retorna todas las solicitudes por gestionar
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 08/02/2019
     * 
     * @param integer  $nroSolicitud  Número de la solicitud o código de la afiliación
     * @param integer  $codEstado     Código del estado de la afiliación
     * @param string   $fechaInicial  Fecha Inicial de radicación
     * @param string   $fechaFinal    Fecha Final de radicación
     *  
     * 
     *@return array Datos de la consulta
     */
    public function getSolicitudesGestionar($arrayParam = null){


        $codEstado     = $arrayParam['codEstado']     == null ? '7' :    $arrayParam['codEstado'];
        $codAfiliacion = $arrayParam['codAfiliacion'] == null ? 'null' : $arrayParam['codAfiliacion'];
        $fechaInicia   = $arrayParam['fechaInicia']   == null ? 'null' : '\''.$arrayParam['fechaInicia'].'\'';
        $fechaFinal    = $arrayParam['fechaFinal']    == null ? 'null' : '\''.$arrayParam['fechaFinal'].'\'';

        $query = ":curs_datos := VDIR_PACK_CONSULTA_SOLICITUD.fnGetSolicitudesGestionar(".$codEstado.",".$codAfiliacion.",".$fechaInicia.",".$fechaFinal.")";          
       
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }

    }

    /**
     * Retorna todas las solicitudes
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 08/02/2019
     * 
     * @param integer  $nroSolicitud     Número de la solicitud o código de la afiliación
     * @param integer  $codEstado        Código del estado de la afiliación
     * @param string   $fechaRadicaIni   Fecha Inicial de radicación
     * @param string   $fechaRadicaFin   Fecha Final de radicación
     * @param string   $fechaGestionIni  Fecha Inicial de gestión
     * @param string   $fechaGestionFin  Fecha Final de gestión
     *  
     * 
     *@return array Datos de la consulta
     */
    public function getSolicitudes($arrayParam = null){


        $codEstado       = $arrayParam['codEstado']       == null ? 'null' : $arrayParam['codEstado'];
        $codAfiliacion   = $arrayParam['codAfiliacion']   == null ? 'null' : $arrayParam['codAfiliacion'];
        $fechaRadicaIni  = $arrayParam['fechaRadicaIni']  == null ? 'null' : '\''.$arrayParam['fechaRadicaIni'].'\'';
        $fechaRadicaFin  = $arrayParam['fechaRadicaFin']  == null ? 'null' : '\''.$arrayParam['fechaRadicaFin'].'\'';
        $fechaGestionIni = $arrayParam['fechaGestionIni'] == null ? 'null' : '\''.$arrayParam['fechaGestionIni'].'\'';
        $fechaGestionFin = $arrayParam['fechaGestionFin'] == null ? 'null' : '\''.$arrayParam['fechaGestionFin'].'\'';

        $query = ":curs_datos := VDIR_PACK_CONSULTA_SOLICITUD.fnGetSolicitudes(".$codEstado.",".$codAfiliacion.",".$fechaRadicaIni.",".$fechaRadicaFin.",".$fechaGestionIni.",".$fechaGestionFin.")";          
       
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }

    }

    /**
     * Retorna los datos de las socitudes pendientes
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 13/02/2019
     * 
     * @param integer  $codUsuario Código del usuario
     *   
     * @return array Datos de la consulta
     */
    public function getSolicitudesPendientes($codUsuario){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_SOLICITUD.fnGetSolicitudesPendientes(".$codUsuario.")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }


    /**
     * Retorna los datos del contratante
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 13/02/2019
     * 
     * @param integer  $codAfiliacion Código de la afiliación
     *   
     * @return array Datos de la consulta
     */
    public function getDatosContratante($codAfiliacion){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_SOLICITUD.fnGetDatosContratante(".$codAfiliacion.")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

    /**
     * Retorna los datos de los beneficiarios
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 13/02/2019
     * 
     * @param integer  $codAfiliacion Código de la afiliación
     *   
     * @return array Datos de la consulta
     */
    public function getDatosBeneficiarios($codAfiliacion){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_SOLICITUD.fnGetDatosBeneficiarios(".$codAfiliacion.")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

    /**
     * Retorna los datos de la bitacora por afiliación
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 14/02/2019
     * 
     * @param integer  $codAfiliacion Código de la afiliación
     *   
     * @return array Datos de la consulta
     */
    public function getBitacoraSolicitud($codAfiliacion){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_SOLICITUD.fnGetDatosBitacora(".$codAfiliacion.")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

     /**
     * Indica si la solicitud ya existe en la cola
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 14/02/2019
     * 
     * @param integer  $codUsuario    Código del usuario que esta en la session actual
     * @param integer  $codAfiliacion Código de la afiliación
     * 
     * 
     * @return integer Indica si se existe en la cola  1 = Mismo usuario / 2 = Diferente usuario / 0 = No existe
     */
    public function getValidaExisteCola($codUsuario,$codAfiliacion){

        $query = "SELECT VDIR_PACK_CONSULTA_SOLICITUD.fnGetValidaExisteCola(?,?) AS valida_cola FROM DUAL";
        $consulta = $this->db->query($query,array('param1' =>$codAfiliacion, 'param2' => $codUsuario));        
        return $consulta->row();

    }
    
     /**
     * Retorna el nombre del usuario que tiene la solicitud en la cola
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 14/02/2019
     * 
     * @param integer  $codAfiliacion Código de la afiliación
     * 
     * 
     * @return string Retorna el nombre del usuario que tiene la afiliación en la cola
     */
    public function getNombreUsuarioCola($codAfiliacion){

        $query = "SELECT VDIR_PACK_CONSULTA_SOLICITUD.fnGetNombreUsuarioCola(?) AS nombre_completo FROM DUAL";
        $consulta = $this->db->query($query,array('param1' => $codAfiliacion));        
        return $consulta->row();

    }

     /**
     * Indica si el usuario actualmente tiene una solicitud en gestión
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 14/02/2019
     * 
     * @param integer  $codUsuario    Código del usuario que esta en la session actual
     * 
     * @return integer Código de la solicitud que el usuario tiene en gestión
     */
    public function getSolicitudGestion($codUsuario){

        $query = "SELECT VDIR_PACK_CONSULTA_SOLICITUD.fnGetValidaSolicitudEnGestion(?) AS cod_solicitud FROM DUAL";
        $consulta = $this->db->query($query,array('param1' => $codUsuario));        
        return $consulta->row();

    }
    
    /**
     * Guarda la afiliación en la cola
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 14/04/2019
     * 
     * @param integer  $codUsuario    Código del usuario en session
     * @param integer  $codAfiliacion Código del la afiliación a realizar gestión
     * 
     * @return array  Retorna array indicando si se guarda exitosamente o si hubieron errores
     */
    public function saveColaSolicitud($arrayParam){

        $errors = array();
        $ret    = true;
        //Abrir la transacción db
        $this->db->trans_begin();
            
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_BANDEJA_OPERACIONES.prGuardarColaSolicitud(:inu_codUsuario,:inu_codAfiliacion); END;");
        
        oci_bind_by_name($s, ":inu_codUsuario",    $arrayParam['codUsuario']);
        oci_bind_by_name($s, ":inu_codAfiliacion", $arrayParam['codAfiliacion']);
        
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
     * Actualiza el usuario y el estado en la afiliación
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 14/04/2019
     * 
     * @param integer  $codUsuario    Código del usuario en session
     * @param integer  $codAfiliacion Código del la afiliación a realizar gestión
     * 
     * @return array  Retorna array indicando si se guarda exitosamente o si hubieron errores
     */
    public function updateColaSolicitud($arrayParam){

        $errors = array();
        $ret    = true;
        //Abrir la transacción db
        $this->db->trans_begin();
            
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_BANDEJA_OPERACIONES.prActualizaColaSolicitud(:inu_codUsuario,:inu_codAfiliacion); END;");
        
        oci_bind_by_name($s, ":inu_codUsuario",    $arrayParam['codUsuario']);
        oci_bind_by_name($s, ":inu_codAfiliacion", $arrayParam['codAfiliacion']);
        
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
     * Elimina la afiliación de la cola
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 14/04/2019
     * 
     * @param integer  $codUsuario    Código del usuario en session
     * @param integer  $codAfiliacion Código del la afiliación a realizar gestión
     * 
     * @return array  Retorna array indicando si se guarda exitosamente o si hubieron errores
     */
    public function deleteColaSolicitud($arrayParam){

        $errors = array();
        $ret    = true;
        //Abrir la transacción db
        $this->db->trans_begin();
            
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_BANDEJA_OPERACIONES.prEliminaColaSolicitud(:inu_codUsuario,:inu_codAfiliacion); END;");
        
        oci_bind_by_name($s, ":inu_codUsuario",    $arrayParam['codUsuario']);
        oci_bind_by_name($s, ":inu_codAfiliacion", $arrayParam['codAfiliacion']);
        
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
     * Gestión de la afiliación en la cola
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 14/04/2019
     * 
     * @param integer  $codUsuario    Código del usuario en session
     * @param integer  $codAfiliacion Código del la afiliación a realizar gestión
     * 
     * @return array  Retorna array indicando si se guarda exitosamente o si hubieron errores
     */
    public function managementColaSolicitud($arrayParam){

        $errors = array();
        $ret    = true;
        //Abrir la transacción db
        $this->db->trans_begin();
            
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_BANDEJA_OPERACIONES.prGestionSolicitud(:inu_codUsuario,:inu_codAfiliacion,:inu_tipoGestion); END;");
        
        oci_bind_by_name($s, ":inu_codUsuario",    $arrayParam['codUsuario']);
        oci_bind_by_name($s, ":inu_codAfiliacion", $arrayParam['codAfiliacion']);
        oci_bind_by_name($s, ":inu_tipoGestion",   $arrayParam['tipoGestion']);
                
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

    public function getDatosKitBienvenido($codigo_afiliacion){      

         $query = ":curs_datos :=  VDIR_PACK_UTILIDADES.VDIR_FN_GET_DATOS_KIT_BIENV(".$codigo_afiliacion.")";
         
         $data = $this->Utilidades_model->getDataRefCursor($query); 

          if (count($data) > 0) {
              return $data;
          }else{
              return false;
          }
    }

    public function sendEnviarEmail($parameters){

        $sql = "SELECT VDIR_PACK_INICIO_SESSION.VDIR_FN_SEND_EMAIL(?,?,?,?) AS RESPUESTA FROM DUAL";          
        $query  = $this->db->query($sql,$parameters); 

        return $query->row();        
    } 

}

?>