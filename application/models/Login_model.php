<?php 

  class Login_model extends CI_Model{
  	
  	 public function __construct() {
        parent::__construct(); 
  	 }    

     public function guardarUsuario($data){

      $response = ''; 
      $s = oci_parse($this->db->conn_id, "begin VDIR_PACK_INICIO_SESSION.VDIR_SP_GUARDAR_USUARIO(:bind1,:bind2,:bind3,:bind4,:bind5,:bind6,TO_DATE(:bind7,'dd/mm/yyyy'),:bind8,:bind9,:bind10,:bind11,:bind12,:bind13,:bind14,:bind15,:bind16,:bind17); end;"); 
      oci_bind_by_name($s, ":bind1", $data['tipo_identificacion']); 
      oci_bind_by_name($s, ":bind2", $data['identificacion']); 
      oci_bind_by_name($s, ":bind3", $data['nombre1'],300); 
      oci_bind_by_name($s, ":bind4", $data['nombre2'],300);
      oci_bind_by_name($s, ":bind5", $data['apellido1'],300); 
      oci_bind_by_name($s, ":bind6", $data['apellido2'],300); 
      oci_bind_by_name($s, ":bind7", $data['fecha_nacimiento']); 
      oci_bind_by_name($s, ":bind8", $data['lit_sexo']);
      oci_bind_by_name($s, ":bind9", $data['telefono'],300); 
      oci_bind_by_name($s, ":bind10", $data['celular'],300); 
      oci_bind_by_name($s, ":bind11", $data['email'],300); 
      oci_bind_by_name($s, ":bind12", $data['usuario'],300);
      oci_bind_by_name($s, ":bind13", $data['clave'],300); 
      oci_bind_by_name($s, ":bind14", $data['codigo_tipo_persona']); 
      oci_bind_by_name($s, ":bind15", $data['codigo_plan']);
      oci_bind_by_name($s, ":bind16", $data['estado']);      
      oci_bind_by_name($s, ":bind17", $response,300); 
      oci_execute($s, OCI_DEFAULT);       

      return $response; 
      
     } 

     public function existeUsuario($login,$codigo_usuario){

         if ($codigo_usuario == 0) {

             $query = $this->db->where('TRIM(LOWER(LOGIN))',trim(strtolower($login)))->get('VDIR_USUARIO');

             if ($query->num_rows() > 0) {
                 return 'SI';
             }else{
                 return 'NO';
             }
           
         }else{
            return 'NO';
         }        

     }

     public function existePersonaUsuario($codigo_usuario,$identificacion,$tipo_identificacion){

         $arrayDatos = array('identificacion' => $identificacion,
                             'tipo_identificacion' => $tipo_identificacion,
                             'estado' => 1);

         if ($codigo_usuario == 0) {

             $sql = "   SELECT
                            persona.cod_persona        
                        FROM
                            vdir_persona persona

                            INNER JOIN vdir_usuario usu
                             ON usu.cod_persona = persona.cod_persona

                            LEFT JOIN VDIR_SEXO sexo
                             ON sexo.cod_sexo = persona.cod_sexo

                            INNER JOIN  VDIR_TIPO_IDENTIFICACION ti
                             ON ti.COD_TIPO_IDENTIFICACION = persona.COD_TIPO_IDENTIFICACION

                        WHERE
                           persona.numero_identificacion = ?
                           AND persona.COD_TIPO_IDENTIFICACION = ?
                           AND usu.COD_ESTADO = ?";

             $query = $this->db->query($sql,$arrayDatos);

             //$query = $this->db->where('TRIM(NUMERO_IDENTIFICACION)',trim($identificacion))->where('COD_TIPO_IDENTIFICACION',$tipo_identificacion)->get('VDIR_PERSONA');             
             if ($query->num_rows() > 0) {
                 return 'SI';
             }else{
                 return 'NO';
             }
           
         }else{
            return 'NO';
         }        

     }

      public function validarUsuario($data){           

          $query = ":curs_datos :=  VDIR_PACK_INICIO_SESSION.VDIR_FN_GET_DATOS_USUARIO('".$data['login']."','".$data['clave']."')";
         
         $data = $this->Utilidades_model->getDataRefCursor($query); 

          if (count($data) > 0) {
              return $data;
          }else{
              return false;
          }             
     }

     public function getDatosPersona($identificacion){         

         $query = ":curs_datos :=  VDIR_PACK_UTILIDADES.VDIR_FN_GET_DATOS_PERSONA(".$identificacion.")";
         
         $data = $this->Utilidades_model->getDataRefCursor($query); 

          if (count($data) > 0) {
              return $data;
          }else{
              return false;
          }
     }    

     public function cambiarContrasena($identificacion,$codigoEnviado,$clave){       

      $response = ''; 
      $s = oci_parse($this->db->conn_id, "begin VDIR_PACK_INICIO_SESSION.VDIR_SP_CAMBIAR_CLAVE(:bind1,:bind2,:bind3,:bind4); end;"); 
      
      oci_bind_by_name($s, ":bind1", $identificacion);
      oci_bind_by_name($s, ":bind2", $codigoEnviado,300);
      oci_bind_by_name($s, ":bind3", $clave,300);      
      oci_bind_by_name($s, ":bind4", $response,300); 
      oci_execute($s, OCI_DEFAULT);       

      return $response; 
     }

     public function getTipoIdentificacion(){

        $query = ":curs_datos := VDIR_PACK_INICIO_SESSION.VDIR_FN_GET_TIPO_DOCUMENTO";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
          return $data;
        }else{
          return false;
        } 
        
     } 

     public function getSexo(){

        $query = ":curs_datos := VDIR_PACK_INICIO_SESSION.VDIR_FN_GET_SEXO";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
          return $data;
        }else{
          return false;
        } 
        
     } 

     public function guardarLogUsuariosSistemas($datos){

      $s = oci_parse($this->db->conn_id, "begin VDIR_PACK_INICIO_SESSION.VDIR_SP_INSERT_LOG_USER(:bind1,:bind2,:bind3); end;"); 
      
      oci_bind_by_name($s, ":bind1", $datos["login"],300);
      oci_bind_by_name($s, ":bind2", $datos["ip"],300);
      oci_bind_by_name($s, ":bind3", $datos["navegador"],300); 
      oci_execute($s, OCI_DEFAULT);       

      return $s;

     }

     public function updateCodigoSeg($identificacion){

      $response = ''; 
      $s = oci_parse($this->db->conn_id, "begin VDIR_PACK_INICIO_SESSION.VDIR_SP_ACTUALIZAR_COD_SEG(:bind1,:bind2); end;"); 
      
      oci_bind_by_name($s, ":bind1", $identificacion);      
      oci_bind_by_name($s, ":bind2", $response,300); 
      oci_execute($s, OCI_DEFAULT);       

      return $response; 
      
     } 

     public function sendEnviarEmail($parameters){

        $sql = "SELECT VDIR_PACK_INICIO_SESSION.VDIR_FN_SEND_EMAIL(?,?,?,?) AS RESPUESTA FROM DUAL";          
        $query  = $this->db->query($sql,$parameters); 

        return $query->row();        
     }

     public function getInfoPersona_data($objParam){
        $query = ":curs_datos := VDIR_PACK_REGISTRO_DATOS.fn_get_info_persona('".$objParam['documento']."',".$objParam['tipo_documento'].")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return false;
        }        
     } 
     

    public function validarUsuarioInactivo_data($objParam){
        $this->db->select('*');
        $this->db->from('VDIR_USUARIO');
        $this->db->where('LOGIN', $objParam['login']);
        $this->db->where('CLAVE', $objParam['clave']);
        $this->db->where('COD_ESTADO', 2);
        $query = $this->db->get();        
        $ress = $query->num_rows();

        return $ress;
    }
  	
  }
 ?>