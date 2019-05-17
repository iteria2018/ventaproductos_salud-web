<?php

class Encuesta_sarlaf_model extends CI_Model{
  	
    public function __construct() {
        parent::__construct(); 
    }

    public function getDataEncuestaSarlaf($codigo_afiliacion,$codigo_contratante){
        $data = "SELECT VDIR_PACK_ENCUESTAS.VDIR_FN_GET_ENCUESTA_SARLAF(".$codigo_afiliacion.",".$codigo_contratante.") AS DATA FROM DUAL";        
        $resultado = '[]';
        
        $query = oci_parse($this->db->conn_id,$data);
        oci_execute($query);  

        while (($row = oci_fetch_array($query, OCI_NUM)) != false) {               
            $resultado = $this->read_clob_consultar($row[0]);             
        } 

        return $resultado;
    }

     function read_clob_consultar($field) {
        return $field->read($field->size());
    }

    function save_encuesta_sarlaf($data){
          
          $response = ''; 
          $s = oci_parse($this->db->conn_id, "begin VDIR_PACK_ENCUESTAS.VDIR_FN_GUARDAR_ENCUESTA(:bind1,:bind2,:bind3,:bind4,:bind5,:bind6,:bind7); end;"); 
          oci_bind_by_name($s, ":bind1", $data['codigo_encuesta']); 
          oci_bind_by_name($s, ":bind2", $data['codigo_pregunta']); 
          oci_bind_by_name($s, ":bind3", $data['codigo_respuesta']); 
          oci_bind_by_name($s, ":bind4", $data['codigo_afiliacion']);
          oci_bind_by_name($s, ":bind5", $data['valor_respuesta'],600);
          oci_bind_by_name($s, ":bind6", $data['codigo_persona']);           
          oci_bind_by_name($s, ":bind7", $response,300); 
          oci_execute($s, OCI_DEFAULT);       

          return $response;

    }

     public function getDataEncuestaSarlafDatos($codigo_afiliacion,$codigo_contratante){

        $sql = "SELECT VDIR_PACK_ENCUESTAS.VDIR_FN_GET_DATOS_ENCT(".$codigo_afiliacion.",".$codigo_contratante.") AS DATA FROM DUAL";
        $resultado = '[]';
        
        $query = oci_parse($this->db->conn_id,$sql);
        oci_execute($query);  

        while (($row = oci_fetch_array($query, OCI_NUM)) != false) {               
            $resultado = $this->read_clob_consultar($row[0]);             
        } 

        return $resultado;
    }


    public function getDataEncuestaSalud($edad,$codigo_sexo,$codigo_afiliacion,$codigo_beneficiario){
        $data = "SELECT VDIR_PACK_ENCUESTAS.VDIR_FN_GET_ENCUESTA_DE_SALUD(".$edad.",".$codigo_sexo.",".$codigo_afiliacion.",".$codigo_beneficiario.") AS DATA FROM DUAL";
       
        $resultado = '[]';
        
        $query = oci_parse($this->db->conn_id,$data);
        oci_execute($query);  

        while (($row = oci_fetch_array($query, OCI_NUM)) != false) {               
            $resultado = $this->read_clob_consultar($row[0]);             
        } 

        return $resultado;
    }

    function save_encuesta_salud($data){

          $response = ''; 
          $s = oci_parse($this->db->conn_id, "begin VDIR_PACK_ENCUESTAS.VDIR_FN_GUARDAR_ENCUESTA(:bind1,:bind2,:bind3,:bind4,:bind5,:bind6,:bind7); end;"); 
          oci_bind_by_name($s, ":bind1", $data['codigo_encuesta']); 
          oci_bind_by_name($s, ":bind2", $data['codigo_pregunta']); 
          oci_bind_by_name($s, ":bind3", $data['codigo_respuesta']); 
          oci_bind_by_name($s, ":bind4", $data['codigo_afiliacion']);
          oci_bind_by_name($s, ":bind5", $data['valor_respuesta'],600);
          oci_bind_by_name($s, ":bind6", $data['codigo_persona']);           
          oci_bind_by_name($s, ":bind7", $response,300); 
          oci_execute($s, OCI_DEFAULT);       

          return $response;

    }

     public function getDataEncuestaSaludDatos($edad,$codigo_sexo,$codigo_afiliacion,$codigo_beneficiario){

        $sql = "SELECT VDIR_PACK_ENCUESTAS.VDIR_FN_GET_DATOS_ENCT_SALUD(".$edad.",".$codigo_sexo.",".$codigo_afiliacion.",".$codigo_beneficiario.") AS DATA FROM DUAL";
        $resultado = '[]';
        
        $query = oci_parse($this->db->conn_id,$sql);
        oci_execute($query);  

        while (($row = oci_fetch_array($query, OCI_NUM)) != false) {               
            $resultado = $this->read_clob_consultar($row[0]);             
        } 

        return $resultado;
    }

    /**
     * Indica si la persona ya diligencio la encuesta correspondiente
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 15/01/2019
     * 
     * @param integer  $codPersona    Código de la persona contratante / beneficiarios
     * @param integer  $codAfiliacion Código de la afiliación
     * @param integer  $codEncuesta   Código de la encuesta
     * 
     * 
     * @return integer Indica si se lleno la encuesta 1 = Si / 0 = No
     */
    public function getValidaEncuesta($codPersona,$codAfiliacion,$codEncuesta){

        $query = "SELECT VDIR_PACK_ENCUESTAS.fnGetValidaEncuesta(?,?,?) AS valida_encuesta FROM DUAL";
        $consulta = $this->db->query($query,array('param1' =>$codAfiliacion, 'param2' => $codPersona, 'param3' => $codEncuesta));        
        return $consulta->row();

    }


     /**
     * Retorna una array con la respuesta
     * 
     * @author: Ever Hidalgo
     * @date  : 18/02/2019
     * 
     * @param object   $db                    Objeto de llamado a la base de datos
     * @param string   $codigo_afiliacion     codigo de la afiliacion     
     
     * @return array Datos de la respuesta
     */

    public function validaEncuestaSalud($codigo_afiliacion){
        $query = ":curs_datos := VDIR_PACK_ENCUESTAS.VDIR_FN_VALIDA_ENCUESTA_SALUD(".$codigo_afiliacion.")";          
        $data = $this->Utilidades_model->getDataRefCursor($query);

        if(count($data) > 0){
            return $data;
        }else{
            return array();
        }
    }

}


    

?>