<?php

class Gestion_compra_model extends CI_Model{
  	
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

    public function getSexo_data(){
        $query = ":curs_datos := VDIR_PACK_INICIO_SESSION.VDIR_FN_GET_SEXO";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
          return $data;
        }else{
          return false;
        }        
    }

    public function getContratante_data($objParam){        
        $query = ":curs_datos := VDIR_PACK_REGISTRO_DATOS.fn_get_contratante(".$objParam['cod_usuario'].")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
          return $data[0];
        }else{
          return false;
        }
    }

    public function getInfoPersona_data($objParam){
        $query = ":curs_datos := VDIR_PACK_REGISTRO_DATOS.fn_get_info_persona('".$objParam['num_identificacion']."',".$objParam['tipo_identificacion'].")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data[0];
        }else{
            return array();
        }        
    }

    public function getProducto_data($objParam){
        $query = ":curs_datos := VDIR_PACK_REGISTRO_PRODUCTOS.fn_get_producto(".$objParam['codigo_producto'].",".$objParam['codigo_plan'].")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }       
    }

    public function validarAplicaBenefi_data($objParam){
        $ress = -1;        
        $this->db->select('*');
        $this->db->from('VDIR_BENEFICIARIO_PROGRAMA');
        $this->db->where('COD_PROGRAMA', $objParam['codPrograma']);
        $this->db->where('COD_BENEFICIARIO', $objParam['objBeneficiario']['cod_persona']);
        $this->db->where('COD_ESTADO', 1);
        $query = $this->db->get();
        
        if($query->num_rows()){
            $ress = $query->num_rows();
        }

        return $ress;
    }

    
    public function agregarBeneficiario_data($objParam){
        $response = '';

        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_DATOS.sp_set_beneficiario(:bind1,:bind2,:bind24,:bind3,:bind4,:bind5,:bind6,TO_DATE(:bind7,'dd/mm/yyyy'),:bind8,:bind9,:bind10,:bind11,:bind12,:bind13,:bind14,:bind15,:bind16,:bind17,:bind18,:bind19,:bind20,:bind21,:bind22,:bind23,:bind25); END;");
      
        oci_bind_by_name($s, ":bind1", $objParam['codContratante'], 300);
        oci_bind_by_name($s, ":bind2", $objParam['tipoDocumento'], 300);
        oci_bind_by_name($s, ":bind24",$objParam['numeroDocumento'], 300);
        oci_bind_by_name($s, ":bind3", $objParam['nombre1'], 300);
        oci_bind_by_name($s, ":bind4", $objParam['nombre2'], 300);
        oci_bind_by_name($s, ":bind5", $objParam['apellido1'], 300);
        oci_bind_by_name($s, ":bind6", $objParam['apellido2'], 300);
        oci_bind_by_name($s, ":bind7", $objParam['fechaNacimiento']);
        oci_bind_by_name($s, ":bind8", $objParam['telefono'], 300);
        oci_bind_by_name($s, ":bind9", $objParam['correo'], 300);
        oci_bind_by_name($s, ":bind10", $objParam['tipoSexo'], 300);
        oci_bind_by_name($s, ":bind11", $objParam['municipio'], 300);
        oci_bind_by_name($s, ":bind12", $objParam['celular'], 300);
        oci_bind_by_name($s, ":bind13", $objParam['eps'], 300);
        oci_bind_by_name($s, ":bind14", $objParam['estado_civil'], 300);
        oci_bind_by_name($s, ":bind15", $objParam['mascota'], 300);
        oci_bind_by_name($s, ":bind16", $objParam['tipoVia'], 300);
        oci_bind_by_name($s, ":bind17", $objParam['numeroTipoVia'], 300);
        oci_bind_by_name($s, ":bind18", $objParam['numeroPlaca'], 300);
        oci_bind_by_name($s, ":bind19", $objParam['complemento'], 300);
        oci_bind_by_name($s, ":bind20", $objParam['parentesco'], 300);
        oci_bind_by_name($s, ":bind21", $objParam['estado'], 300);
        oci_bind_by_name($s, ":bind22", $objParam['codAfiliacion'], 300);
        oci_bind_by_name($s, ":bind23", $objParam['codDireccion'], 300);
        oci_bind_by_name($s, ":bind25", $response, 300); 
        oci_execute($s, OCI_DEFAULT);

        return $response; 
    }

    public function getBenefisPendiente_data($objParam){
        $query = ":curs_datos := VDIR_PACK_REGISTRO_DATOS.fn_get_benficiarios_contra(".$objParam['codUsuario'].")";          
        $data = $this->Utilidades_model->getDataRefCursor($query);

        if(count($data) > 0){
            return $data;
        }else{
            return false;
        }
    }   

    public function quitarContraBenefis_data($objParam){
        $response = '';
        
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_DATOS.sp_quitar_contra_benefi(:bind1, :bind2); END;");
      
        oci_bind_by_name($s, ":bind1", $objParam['codUsuario'], 300);
        oci_bind_by_name($s, ":bind2", $response, 300); 
        oci_execute($s, OCI_DEFAULT);

        return $response; 
    }

    public function inactivarContraBenefis_data($objParam){
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_DATOS.sp_set_estado_contra_benefi(:bind1, :bind2); END;");
      
        oci_bind_by_name($s, ":bind1", $objParam['codUsuario'], 300);
        oci_bind_by_name($s, ":bind2", $objParam['codEstado'], 300); 
        oci_execute($s, OCI_DEFAULT);
    }

    public function getHabeasData_data($objParam){
        $query = oci_parse($this->db->conn_id, "BEGIN :resultado := VDIR_PACK_REGISTRO_DATOS.fn_get_habeasData('".$objParam['tipo']."'); END;");          
        $result = ''; 
        
        oci_bind_by_name($query, ":resultado", $result, 32767); 
        oci_execute($query, OCI_DEFAULT);
        
        return $result;
    }

    /**
     * Retorna una array con los datos de las imagenes por programa
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 17/01/2019
     * 
     * @param integer  $codPrograma    Código del programa
     *  
     * @return array Datos de las imagenes por programas
     */
    public function getCoberturas($codPrograma, $codPlan){
        $query = ":curs_datos := VDIR_PACK_CONSULTA_LINEAS.fnGetCoberturas(".$codPrograma.",".$codPlan.")";          
        $data = $this->Utilidades_model->getDataRefCursor($query); 

        if (count($data) > 0) {
            return $data;
        }else{
            return array();
        }    
    }

    public function setBenefiPrograma_data($objParam){
        $response = array();
        $valor_tarifa = '0';       
        $replica_tarifa = '0';
        //Abrir la transaccion db
        $this->db->trans_begin();        
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_PRODUCTOS.sp_registra_benefi_programa(:bind1,:bind2,:bind3,:bind4,:bind5,:bind6,:bind7); END;");
      
        oci_bind_by_name($s, ":bind1", $objParam['codBeneficiario'], 300);
        oci_bind_by_name($s, ":bind2", $objParam['codPrograma'], 300);
        oci_bind_by_name($s, ":bind3", $objParam['codAfiliacion'], 300);
        oci_bind_by_name($s, ":bind4", $objParam['codEstado'], 300);
        oci_bind_by_name($s, ":bind5", $objParam['codTipoSolicitud'], 300);
        oci_bind_by_name($s, ":bind6", $valor_tarifa, 300); 
        oci_bind_by_name($s, ":bind7", $replica_tarifa, 300); 
        oci_execute($s, OCI_DEFAULT);

        //Confirmar commit si se el resultado de la transaccion es diferente a false, de lo contrario hacer rollback
		if ($this->db->trans_status() === FALSE){
            $this->db->trans_rollback();
        }else{
            $this->db->trans_commit();
        }
        
        $response['valorTarifa'] = intval($valor_tarifa);
        $response['replicaTarifa'] = intval($replica_tarifa);

        return $response; 
    }
    
    public function quitarBenefiProgram_data($objParam){
        //Abrir la transaccion db
        $this->db->trans_begin();
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_PRODUCTOS.sp_quitar_benefi_programa(:bind1); END;");
      
        oci_bind_by_name($s, ":bind1", $objParam['codUsuario'], 300);
        oci_execute($s, OCI_DEFAULT);

        //Confirmar commit si se el resultado de la transaccion es diferente a false, de lo contrario hacer rollback
		if ($this->db->trans_status() === FALSE){
            $this->db->trans_rollback();
        }else{
            $this->db->trans_commit();
        }
    }

    public function setFactura_data($objParam){
        $response = '';        
        //Abrir la transaccion db
        $this->db->trans_begin();
        
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_PRODUCTOS.sp_registra_factura(:bind1,:bind2,:bind3); END;");
      
        oci_bind_by_name($s, ":bind1", $objParam['codUsuario'], 300);
        oci_bind_by_name($s, ":bind2", $objParam['codAfiliacion'], 300);
        oci_bind_by_name($s, ":bind3", $response, 300); 
        oci_execute($s, OCI_DEFAULT);

        //Confirmar commit si se el resultado de la transaccion es diferente a false, de lo contrario hacer rollback
		if ($this->db->trans_status() === FALSE){
            $this->db->trans_rollback();
        }else{
            $this->db->trans_commit();
        }
        
        return $response; 
    }

    public function getBenefisProgramasPend_data($objParam){
        $query = ":curs_datos := VDIR_PACK_REGISTRO_PRODUCTOS.fn_get_benficiarios_programas(".$objParam['codUsuario'].")";          
        $data = $this->Utilidades_model->getDataRefCursor($query);
        $result = array();
        
        if(count($data) > 0){
            $result = $data;
        }

        return $result;
    }

    public function getCodProgramaHomologa_data($objParam){
        $query = oci_parse($this->db->conn_id, "BEGIN :resultado := VDIR_PACK_REGISTRO_PRODUCTOS.fn_get_codPrograma_homologa(:param1, :param2); END;");          
        $result = '-1';
        
        oci_bind_by_name($query, ":param1", $objParam['cod_programa']); 
        oci_bind_by_name($query, ":param2", $objParam['cod_plan']); 
        oci_bind_by_name($query, ":resultado", $result, 100); 
        oci_execute($query, OCI_DEFAULT);
        
        return $result;
    }

    public function confirmarProgramasBenefis_data($objParam){
        $response = '-1';
        //Abrir la transaccion db
        $this->db->trans_begin();
        $s = oci_parse($this->db->conn_id, "BEGIN VDIR_PACK_REGISTRO_PRODUCTOS.sp_set_estado_benefi_program(:bind1, :bind2); END;");
      
        oci_bind_by_name($s, ":bind1", $objParam['codUsuario'], 300);
        oci_bind_by_name($s, ":bind2", $objParam['codEstado'], 300); 
        oci_execute($s, OCI_DEFAULT);

        //Confirmar commit si se el resultado de la transaccion es diferente a false, de lo contrario hacer rollback
		if ($this->db->trans_status() === FALSE){
            $this->db->trans_rollback();
        }else{
            $this->db->trans_commit();
            $response = '1';
        }

        return $response;
    }

    public function getTipoPagoFactura($codigo_usuario){

      $codigo_estado = 3;  
   
      $sql = "SELECT fac.COD_FORMA_PAGO FROM VDIR_FACTURA fac INNER JOIN VDIR_AFILIACION af ON fac.cod_afiliacion = af.cod_afiliacion WHERE af.cod_estado = ? AND  COD_USUARIO = ? AND COD_FORMA_PAGO IS NOT NULL";

      $result = $this->db->query($sql,array('param1' => $codigo_estado,
                                            'param2' => $codigo_usuario));

      if ($result->num_rows() > 0) {
            return 1;
        }else{
            return 0;
        }
    }

    public function inactivar_BenefiContra_data($objParam){
        $sentencia = "UPDATE VDIR_CONTRATANTE_BENEFICIARIO SET COD_ESTADO = 2 WHERE COD_CONTRATANTE = ".$objParam['cod_persona']." AND COD_BENEFICIARIO = ".$objParam['cod_persona']." AND COD_AFILIACION = ".$objParam['cod_afiliacion'];
        $query = $this->db->query($sentencia);
        $ress = false;
        
        if($query){
            $ress = true;
        }
        
        return $ress;
    }

}

?>