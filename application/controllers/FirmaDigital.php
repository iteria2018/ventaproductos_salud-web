<?php 
    
    class FirmaDigital extends CI_Controller{
		
		public function __construct() {
			parent::__construct();
            $this->load->model('Utilidades_model');
            $this->load->model('FirmaDigital_model', 'fdm', true);
	
        }   
        
        /**
         * Retorna una copia del contrato firmado en Adobe Sign en formato PDF 
         * 
         * @author: Katherine Latorre Mejía
         * @date  : 10/01/2019
         * 
         * @param string  $idContrato  Cadena con el Id del Acuerdo Firmado
         * 
         *  
         * @return application/pdf Archivo PDF con la información del Contrato Firmado
         */
        public function getAccessToken(){

            return $this->fdm->getAccessToken();
           
        }

        /**
         * Retorna el id del documento transitorio
         * 
         * @author: Katherine Latorre Mejía
         * @date  : 20/02/2019
         * 
         * @param string  $nombrePdf  Cadena con el nombre del Pdf
         * 
         *  
         * @return string Cadena con el id del documento transitorio
         */
        public function getIdDocumentoTransitorio($nombrePdf){

            return $this->fdm->getIdDocumentoTransitorio($nombrePdf);
           
        }

         /**
         * Retorna los datos del contrato creado
         * 
         * @author: Katherine Latorre Mejía
         * @date  : 20/02/2019
         * 
         * @param string  $nombrePdf   Cadena con el nombre del Pdf
         * @param integer $codPersona  Código del contratante al que se le va a crear el contrato
         * @param integer $codPrograma Código del programa para visualizar el contrato
         * @param integer $codAfiliacion Código de la afiliacion para visualizar el contrato
         * 
         *  
         * @return array Datos del contrato creado
         */
        public function getContrato($nombrePdf,$codPersona,$codPrograma,$codAfiliacion){

            return $this->fdm->getContrato($nombrePdf,$codPersona,$codPrograma,$codAfiliacion);
           
        }

        
        /**
         * Retorna una cadena con el id del contrato firmado 
         * 
         * @author: Katherine Latorre Mejía
         * @date  : 20/02/2019
         * 
         * @param string  $idWidget  Cadena con el Id del widget creado
         * 
         *  
         * @return string Cadena con el ID del contrato firmado
         * 
         */
        public function getIdContrato($idWidget){

            return $this->fdm->getIdContrato($idWidget);
           
        }

        /**
         * Retorna una copia del contrato firmado en Adobe Sign en formato PDF 
         * 
         * @author: Katherine Latorre Mejía
         * @date  : 10/01/2019
         * 
         * @param string  $idContrato  Cadena con el Id del Acuerdo Firmado
         * 
         *  
         * @return application/pdf Archivo PDF con la información del Contrato Firmado
         */
        public function getContratoFirmado($idContrato){

            return $this->fdm->getContratoFirmado($idContrato);
           
        }
     

    }
	
	
?>