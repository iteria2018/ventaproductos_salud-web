<?php

class Gc_paso_5_model extends CI_Model{
  	
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
     * Retorna una cadena con la url para la firma de Contrato Adobe Sign
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 04/01/2018
     * 
     * @param string   $url        Url del widget parametrizado en Adobe Sign
     * @param integer  $codPersona Código del Contrante
     * 
     * @return string Cadena de la Url con los datos llenos
     */
    public function saveContratoAdobeSign($codPersona, $codPrograma, $codAfiliacion, $nroContratoAdobe){

        $errors = array();
        $ret    = true;
        //Abrir la transacción db
        $this->db->trans_begin();
            
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_CONTRATO.prGuardarContratoAdobe(:inuCodPersona,:inuCodPrograma,:inuCodAfiliacion,:ivcNroContratoAdobe); END;");
        
        oci_bind_by_name($s, ":inuCodPersona", $codPersona);
        oci_bind_by_name($s, ":inuCodPrograma", $codPrograma);
        oci_bind_by_name($s, ":inuCodAfiliacion", $codAfiliacion);
        oci_bind_by_name($s, ":ivcNroContratoAdobe", $nroContratoAdobe);
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
     * Cambia el estado de la afiliación para enviarla a la bandeja de operaciones
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 21/02/2018
     *  
     * @param integer $codAfiliacion Código de la afiliación
     * 
     * @return array Datos de la respuesta
     */
    public function updateAfiliacion($codAfiliacion){

        $errors = array();
        $ret    = true;
        //Abrir la transacción db
        $this->db->trans_begin();
            
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_CONTRATO.prActualizarAfiliacion(:inuCodAfiliacion); END;");
        
        oci_bind_by_name($s, ":inuCodAfiliacion", $codAfiliacion);
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
     * Indica si la persona ya firmo los contratos
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 23/01/2019
     * 
     * @param integer  $codAfiliacion Código de la afiliación
     * @param integer  $codPersona    Código de la persona contratante / beneficiarios
     * @param integer  $codPrograma   Código del programa que se debe firmar
     *  
     * 
     * @return integer Indica si se firman los documentos 1 = Si / 0 = No
     */
    public function getValidaContratos($codAfiliacion,$codPersona,$codPrograma){

        $query = "SELECT VDIR_PACK_CONSULTA_CONTRATO.fnGetValidaContrato(?,?,?) AS valida_contrato FROM DUAL";
        $consulta = $this->db->query($query,array('param1' =>$codAfiliacion, 'param2' => $codPersona, 'param3' => $codPrograma));        
        return $consulta->row();

    }

    public function getValidaInclusion($codAfiliacion,$codContratante){        

        $query = ":curs_datos :=   VDIR_PACK_CONSULTA_CONTRATO.fnGetValidaInclusion(".$codAfiliacion.",".$codContratante.")";
        $data = $this->Utilidades_model->getDataRefCursor($query);                
        if (count($data) > 0) {
            return $data;
        }else{
            return false;
        }

    }
}

?>