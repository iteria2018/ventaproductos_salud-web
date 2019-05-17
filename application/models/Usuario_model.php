<?php

class Usuario_model extends CI_Model{
  	
    public function __construct() {
        parent::__construct(); 
    }

    /**
     * Retorna una array con los datos de los usuarios
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 29/01/2019
     * 
     *   
     * @return array Datos de la consulta
     */
    public function getUsuarios(){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_USUARIOS.fnGetUsuarios";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }
    
    /**
     * Retorna una array con los datos de los tipos de identificación
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 30/01/2019
     * 
     *   
     * @return array Datos de la consulta
     */
    public function getTiposIdentificacion(){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_USUARIOS.fnGetTiposIdentificacion";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

    /**
     * Retorna una array con los datos de los perfiles
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 30/01/2019
     * 
     *   
     * @return array Datos de la consulta
     */
    public function getPerfiles(){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_USUARIOS.fnGetPerfiles";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

    /**
     * Retorna una array con los datos del usuario
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 30/01/2019
     * 
     * @param integer  $codUsuario   Código del usuario
     * @param integer  $codPersona   Código de la persona
     * @param integer  $codPerfil    Código del perfil
     * 
     *   
     * @return array Datos del usuario
     */
    public function getUsuario($codUsuario,$codPersona,$codPerfil){
       
        $query = ":curs_datos := VDIR_PACK_CONSULTA_USUARIOS.fnGetUsuario(".$codUsuario.",".$codPersona.",".$codPerfil.")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

    /**
     * Indica si la persona ya existe con el número de identificación ingresado
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 31/01/2019
     * 
     * @param integer  $codTipoId         Código del tipo de identificación
     * @param integer  $nroId             Número del tipo de identificación
     *  
     * 
     * @return integer Código de la persona si existe
     */
    public function getExistePersona($arrayParam){

        $query = "SELECT VDIR_PACK_CONSULTA_USUARIOS.fnGetExistePersona(?,?) AS cod_persona FROM DUAL";
        $consulta = $this->db->query($query,array('param1' =>$arrayParam['codTipoId'], 'param2' => $arrayParam['nroId']));        
        return $consulta->row();

    }

     /**
     * Indica si el usuario ya existe con el login ingresado
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 31/01/2019
     * 
     * @param string   $login    Login del usuario
     *  
     * 
     * @return integer Código del usuario si existe
     */
    public function getExisteLogin($arrayParam){

        $query = "SELECT VDIR_PACK_CONSULTA_USUARIOS.fnGetExisteLogin(?) AS cod_usuario FROM DUAL";
        $consulta = $this->db->query($query,array('param1' =>$arrayParam['login']));        
        return $consulta->row();

    }

     /**
     * Indica si el usuario existe con la clave ingresada
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 01/02/2019
     * 
     * @param integer $codigoUsuario    Código del usuario en sesión
     * @param string  $claveActual      Clave actual del usuario
     *  
     * 
     * @return integer Código del usuario si existe
     */
    public function getValidaClave($codigoUsuario,$claveActual){

        $query = "SELECT VDIR_PACK_CONSULTA_USUARIOS.fnGetValidaClaveActual(?,?) AS cod_usuario FROM DUAL";
        $consulta = $this->db->query($query,array('param1' =>$codigoUsuario,'param2' =>$claveActual));        
        return $consulta->row();

    }

    /**
     * Guarda los datos del usuario
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 30/01/2019
     * 
     * @param integer  $codTipoId         Código del tipo de identificación
     * @param integer  $nroId             Número del tipo de identificación
     * @param string   $primerNombre      Primer nombre del usuario
     * @param string   $segundoNombre     Segundo nombre del usuario
     * @param string   $primerApellido    Primer apellido del usuario
     * @param string   $segundoApellido   Segundo apellido del usuario
     * @param string   $correoElectronico Correo electrónico del usuario
     * @param string   $telefono          Teléfono del usuario
     * @param string   $login             Login del usuario
     * @param string   $clave             Clave del usuario
     * @param integer  $codPerfil         Código del perfil
     * @param integer  $codEstado         Código del estado
     * 
     * @return array  Retorna array indicando si se guarda exitosamente o si hubieron errores
     */
    public function saveUsuario($arrayParam){

        $errors = array();
        $ret    = true;
        //Abrir la transacción db
        $this->db->trans_begin();
            
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_USUARIOS.prGuardarUsuario(:inu_codTipoId,:inu_nroId,:ivc_primerNombre,:ivc_segundoNombre,:ivc_primerApellido,:ivc_segundoApellido,:ivc_correoElectronico,:ivc_telefono,:ivc_login,:ivc_clave,:inu_codPerfil,:inu_codEstado); END;");
       
        oci_bind_by_name($s, ":inu_codTipoId",         $arrayParam['codTipoId']);
        oci_bind_by_name($s, ":inu_nroId",             $arrayParam['nroId']);
		oci_bind_by_name($s, ":ivc_primerNombre",      $arrayParam['primerNombre']);
		oci_bind_by_name($s, ":ivc_segundoNombre",     $arrayParam['segundoNombre']);
		oci_bind_by_name($s, ":ivc_primerApellido",    $arrayParam['primerApellido']);
		oci_bind_by_name($s, ":ivc_segundoApellido",   $arrayParam['segundoApellido']);
		oci_bind_by_name($s, ":ivc_correoElectronico", $arrayParam['correoElectronico']);
		oci_bind_by_name($s, ":ivc_telefono",          $arrayParam['telefono']);
		oci_bind_by_name($s, ":ivc_login",             $arrayParam['login']);
		oci_bind_by_name($s, ":ivc_clave",             $arrayParam['clave']);
		oci_bind_by_name($s, ":inu_codPerfil",         $arrayParam['codPerfil']);
		oci_bind_by_name($s, ":inu_codEstado",         $arrayParam['codEstado']);
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
     * Actualiza los datos del usuario
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 30/01/2019
     * 
     * @param integer  $codUsuario        Código del usuario
     * @param integer  $codPerfil         Código del perfil
     * @param integer  $codEstado         Código del estado
     * 
     * @return array  Retorna array indicando si se guarda exitosamente o si hubieron errores
     */
    public function updateUsuario($codUsuario,$arrayParam){

        $errors = array();
        $ret    = true;
        //Abrir la transacción db
        $this->db->trans_begin();
            
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_USUARIOS.prActualizarUsuario(:inu_codUsuario,:inu_codPerfil,:inu_codEstado); END;");
        
        oci_bind_by_name($s, ":inu_codUsuario", $codUsuario);
        oci_bind_by_name($s, ":inu_codPerfil",  $arrayParam['codPerfil']);
		oci_bind_by_name($s, ":inu_codEstado",  $arrayParam['codEstado']);
		
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
     * Actualiza la clave del usuario
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 01/02/2019
     * 
     * @param integer $codigoUsuario    Código del usuario en sesión
     * @param string  $claveActual      Clave nueva ingresada por el usuario
     * 
     * @return array  Retorna array indicando si se guarda exitosamente o si hubieron errores
     */
    public function updatePassword($codUsuario,$claveNueva){

        $errors = array();
        $ret    = true;
        //Abrir la transacción db
        $this->db->trans_begin();
            
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_USUARIOS.prActualizarClave(:inu_codUsuario,:ivc_clave); END;");
        
        oci_bind_by_name($s, ":inu_codUsuario", $codUsuario);
        oci_bind_by_name($s, ":ivc_clave",      $claveNueva);
		
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

    public function updateUsuarioHeader($dataUsuario,$dataPersona){

       $this->db->trans_begin();
       $ret    = 1;

       $sql = "UPDATE vdir_persona
                    SET
                      nombre_1 = ?, 
                      nombre_2 = ?,
                      apellido_1 = ?,
                      apellido_2 = ?,
                      telefono = ?,
                      email = ?
                WHERE
                    cod_persona = ?"; 
       $this->db->query($sql,$dataPersona);

       $sql = 'UPDATE vdir_usuario
                      SET
                        login = ?
                     WHERE
                      cod_usuario = ?';

       $this->db->query($sql,$dataUsuario);

       if ($this->db->trans_status() === FALSE){

            $this->db->trans_rollback();
            $errNo   = $this->db->_error_number();
            $errMess = $this->db->_error_message();
            array_push($errors, array($errNo, $errMess));
            $ret = 0;

        }else{
            $this->db->trans_commit();
        } 

        return $ret;

    }
     

}

?>