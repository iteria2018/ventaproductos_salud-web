<?php

class Gc_paso_3_model extends CI_Model{
  	
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

    /**
     * Retorna una array con la respuesta
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 23/01/2018
     * 
     * @param object   $db            Objeto de llamado a la base de datos
     * @param string   $desFile       Descripción del archivo
     * @param string   $observacion   Observación del archivo
     * @param string   $ruta          Ruta en la que queda el archivo
     * @param integer  $codTipoFile   Código del tipo de archivo
     * 
     * @return array Datos de la respuesta
     */
    public function saveDocumento($db2, $desFile, $observacion, $ruta, $codTipoFile){
        
        $codFile = 0;
        $errors = array();
        $ret    = true;

        if ($db2 == null){

            $db = $this->db;
            //Abrir la transacción db
            $db->trans_begin();
        } else {
            $db = $db2;
        }

        $s = oci_parse($db->conn_id, "BEGIN VDIR_PACK_REGISTRO_FILE.prGuardarFile(:ivc_desFile,:ivc_observacion,:ivc_ruta,:inu_codTipoFile,:onu_codFile); END;");
        
        oci_bind_by_name($s, ":ivc_desFile", $desFile);
        oci_bind_by_name($s, ":ivc_observacion", $observacion);
        oci_bind_by_name($s, ":ivc_ruta", $ruta);
        oci_bind_by_name($s, ":inu_codTipoFile", $codTipoFile);
        oci_bind_by_name($s, ":onu_codFile", $codFile,14);
        oci_execute($s, OCI_DEFAULT);
            
        if ($db->trans_status() === FALSE){

            $db->trans_rollback();
            $errNo   = $db->_error_number();
            $errMess = $db->_error_message();
            array_push($errors, array($errNo, $errMess));
            $ret = false;

        }else{
            if ($db2 == null){
                $db->trans_commit();
            }
        }

        $data['ret']     = $ret;
        $data['codFile'] = $codFile;
        $data['errors']  = $errors;

        return $data;

    }

     /**
     * Retorna una array con la respuesta
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 23/01/2018
     * 
     * @param object   $db               Objeto de llamado a la base de datos
     * @param string   $codAfiliacion    Código de la afiliación 
     * @param string   $codFile          Código del archivo adjunto
     * @param string   $codBeneficiario  Código del beneficiario
     * 
     *  
     * @return array Datos de la respuesta
     */
    public function saveDocumentoBeneficiario($db, $codAfiliacion, $codFile, $codBeneficiario){

        $errors = array();
        $ret    = true;

        if ($db == null){

            $db = $this->db;
            //Abrir la transacción db
            $db->trans_begin();
        }
       
            
        $s = oci_parse($db->conn_id, "BEGIN VDIR_PACK_REGISTRO_FILE.prGuardarFileBeneficiario(:inu_codAfiliacion,:inu_codFile,:inu_codBeneficiaro); END;");
        
        oci_bind_by_name($s, ":inu_codAfiliacion", $codAfiliacion);
        oci_bind_by_name($s, ":inu_codFile",  $codFile);
        oci_bind_by_name($s, ":inu_codBeneficiaro", $codBeneficiario);
        oci_execute($s, OCI_DEFAULT);
            
        if ($db->trans_status() === FALSE){

            $db->trans_rollback();
            $errNo   = $db->_error_number();
            $errMess = $db->_error_message();
            array_push($errors, array($errNo, $errMess));
            $ret = false;

        }else{
            if ($db == null){
                $db->trans_commit();
            }
        }

        $data['ret']     = $ret;
        $data['errors']  = $errors;

        return $data;

    }


    
    /**
     * Indica si la persona ya adjunto los documentos
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 23/01/2019
     * 
     * @param integer  $codPersona    Código de la persona contratante / beneficiarios
     * @param integer  $codAfiliacion Código de la afiliación
     *  
     * 
     * @return integer Indica si se adjunto los documentos 1 = Si / 0 = No
     */
    public function getValidaAdjuntos($codPersona,$codAfiliacion){

        $query = "SELECT VDIR_PACK_CONSULTA_FILE.fnGetValidaDocumentos(?,?) AS valida_documentos FROM DUAL";
        $consulta = $this->db->query($query,array('param1' =>$codAfiliacion, 'param2' => $codPersona));        
        return $consulta->row();

    }

    /**
     * Retorna una array con los datos de las imagenes por beneficiario
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 23/01/2019
     * 
     * @param integer  $codPersona    Código de la persona contratante / beneficiarios
     * @param integer  $codAfiliacion Código de la afiliación
     *  
     * @return array Datos de las imagenes por beneficiario
     */
    public function getAdjuntosBeneficiario($codPersona,$codAfiliacion){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_FILE.fnGetDocumentosBeneficiario(".$codAfiliacion.",".$codPersona.")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

}

?>