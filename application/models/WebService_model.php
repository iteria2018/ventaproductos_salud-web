<?php 
	
	class WebService_model extends CI_Model{
		
		public function __construct() {
            parent::__construct(); 
            $this->load->model('Utilidades_model'); 
		} 
        
        public function getWsEstadoUsuario($tipoId,$nroId){

            $this->load->library("DatabaseMultiple");

            $params = array("param1" => $tipoId,
                            "param2" => $nroId);
			//Si est.vigen_hasta es mayor a fecha actual, el contrato se encuentra en mora
			$query  = "SELECT 
                            COALESCE(afi.nombre,' ') +' '+ COALESCE(afi.nombre2,' ') +' '+ COALESCE(afi.ape,' ') +' '+ COALESCE(afi.ape2, ' ') AS nombre_completo,
                            CONVERT(varchar, afi.baja_fecha, 103) AS fecha_retiro,
                            RTRIM(LTRIM(est.estado)) AS estado_contrato,
                            MAX(est.vigen_desde) AS vigen_desde,
                            est.inhab_motivo,
                            est.vigen_hasta AS vigen_hasta,     
                            CASE WHEN
                                est.estado = 'I' AND (est.inhab_motivo IS NULL OR (est.inhab_motivo IS NOT NULL AND est.vigen_hasta >= getdate()))
                                THEN (CASE WHEN est.vigen_hasta IS NOT NULL THEN CONVERT(varchar, est.vigen_hasta, 103) ELSE CONVERT(varchar, getdate(), 103) END)
                                ELSE NULL END AS fecha_mora,     
                            est.inhab_motivo AS motivo,
                            RTRIM(LTRIM(est.contra)) AS contra, 
                            est.prepaga
                        FROM afiliados          afi,
                            afi_estados_contra est
                        WHERE afi.contra    = est.contra
                            AND afi.prepaga   = est.prepaga
                            AND afi.docu_tipo = '".$tipoId."'
                            AND afi.docu_nro  = '".$nroId."'
                        GROUP BY afi.baja_fecha, est.estado, afi.nombre, afi.nombre2, afi.ape, afi.ape2, est.vigen_hasta, est.inhab_motivo, est.contra, est.prepaga";
            $result = $this->db2->query($query,$params);  
                
			if ($result->num_rows() > 0) {
				return $result->result_array();     
			} else {
				return false; 
			}    
			
        } 

        public function getWsProgramasUsuario($tipoId,$nroId){

            $this->load->library("DatabaseMultiple");

            $params = array("param1" => $tipoId,
                            "param2" => $nroId);
			
			$query  = "SELECT lin.linea_negocio linea,
                              pln.deno programa
                         FROM afiliados        afi,
                              afi_credenciales cre,
                              linea_negocio    lin,
                              planes           pln
                        WHERE afi.contra          = cre.contra
                          AND afi.prepaga       = cre.prepaga
                          AND afi.inte          = cre.inte
                          AND cre.linea_negocio = lin.cod
                          AND cre.plan_codi     = pln.plan_codi 
                          AND afi.docu_tipo     = ?
                          AND afi.docu_nro      = ?";
            $result = $this->db2->query($query,$params);  
                
			if ($result->num_rows() > 0) {
				return $result->result_array();     
			} else {
				return false; 
			}    
			
        }

        public function validUsuarioPrograma($tipoId, $nroId, $codPrograma){
            $this->load->library("DatabaseMultiple");
            $params = array("param1" => $tipoId,
                            "param2" => $nroId,
                            "param3" => $codPrograma);
			
			$query  = "SELECT 
                              COUNT(*) AS existe
                         FROM afiliados        afi,
                              afi_credenciales cre,
                              linea_negocio    lin,
                              planes           pln
                        WHERE afi.contra          = cre.contra
                          AND afi.prepaga       = cre.prepaga
                          AND afi.inte          = cre.inte
                          AND cre.linea_negocio = lin.cod
                          AND cre.plan_codi     = pln.plan_codi 
                          AND afi.docu_tipo     = ?
                          AND afi.docu_nro      = ?
                          AND pln.plan_codi     = ?";
            $result = $this->db2->query($query,$params);  
                
			if ($result->num_rows() > 0) {
				return $result->result_array();     
			} else {
				return false; 
			}    
			
        }

        public function validUsuarioLinea($tipoId, $nroId, $codLinea){
            $this->load->library("DatabaseMultiple");
            $params = array("param1" => $tipoId,
                            "param2" => $nroId,
                            "param3" => $codLinea);
			
			$query  = "SELECT 
                              COUNT(*) AS existe
                         FROM afiliados        afi,
                              afi_credenciales cre,
                              linea_negocio    lin,
                              planes           pln
                        WHERE afi.contra          = cre.contra
                          AND afi.prepaga       = cre.prepaga
                          AND afi.inte          = cre.inte
                          AND cre.linea_negocio = lin.cod
                          AND cre.plan_codi     = pln.plan_codi 
                          AND afi.docu_tipo     = ?
                          AND afi.docu_nro      = ?
                          AND lin.cod     = ?";
            $result = $this->db2->query($query,$params);  
                
			if ($result->num_rows() > 0) {
				return $result->result_array();     
			} else {
				return false; 
			}    
			
        }

        public function validaUsuarioAsociado($tipoId, $nroId){
            $this->load->library("DatabaseMultiple");
            $params = array("param1" => $tipoId,
                            "param2" => $nroId);

            $query  = "SELECT COUNT(*) AS existe
                       FROM asociados_cooperativa aso
                      WHERE aso.docu_tipo     = ?
                        AND aso.docu_nro      = ?";
                     
          $result = $this->db2->query($query,$params);               
          if ($result->num_rows() > 0) {
              return $result->result_array();     
          } else {
              return false; 
          }    
        }

        public function validarUsuarioCoop($tipoId, $nroId){
            $url = $this->Utilidades_model->getParametro(84)->RESULTADO;
            try{
                $client = new SoapClient($url);
                // $something = $client->__getFunctions();
                $result = $client->consultarAsociadoVida($nroId,$tipoId);
                return $result;
            }catch(Exception $e) {
                return false;
            }
        }

       
    }
?>