<?php

class FirmaDigital_model extends CI_Model{
       
    public function __construct() {
        parent::__construct();   
        //Datos para probar en desarrollo
        //define('urlAdobeSign',     'https://api.na2.echosign.com');
        //define('idCliente',        'CBJCHBCAABAAXY5dLaq4vX4uRT1n2ahSsZd29owZxD5C');
        //define('idSecretoCliente', 'sKvgZDbalpNsjbXbDYNq6XumexUxrRBj');
        //define('refreshToken',     '3AAABLblqZhCAvZViWeCoLAoalsbdLHb5Q8CMmLvyU1UD0Otij-piv7YkvA4RhY3aKOGQe29falE*'); 
        //define('indProxy',         '0');
        define('urlAdobeSign',     $this->Utilidades_model->getParametro(11)->RESULTADO); //https://api.na2.echosign.com
        define('idCliente',        $this->Utilidades_model->getParametro(6)->RESULTADO);  //'CBJCHBCAABAAXY5dLaq4vX4uRT1n2ahSsZd29owZxD5C'
        define('idSecretoCliente', $this->Utilidades_model->getParametro(7)->RESULTADO); //'sKvgZDbalpNsjbXbDYNq6XumexUxrRBj'
        define('refreshToken',     $this->Utilidades_model->getParametro(8)->RESULTADO); //'3AAABLblqZhCAvZViWeCoLAoalsbdLHb5Q8CMmLvyU1UD0Otij-piv7YkvA4RhY3aKOGQe29falE*'
        define('indProxy',         $this->Utilidades_model->getParametro(35)->RESULTADO);
        define('proxyCurl',        $this->Utilidades_model->getParametro(36)->RESULTADO);
        define('userPwdProxy',     $this->Utilidades_model->getParametro(37)->RESULTADO);     
    }

     /**
     * Consume la url del servicio que se envie
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 20/02/2019
     * 
     * 
     * @return string Cadena con el token de Acceso
     */
    public function curlFirmaDigital($urlApiEchoSign, $showHeader, $header, $postData){

        $ch = curl_init($urlApiEchoSign);
        curl_setopt($ch, CURLOPT_HEADER,         $showHeader);
        curl_setopt($ch, CURLOPT_HTTPHEADER,     $header);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLINFO_HEADER_OUT,    true);

        if ($postData != null){

            curl_setopt($ch, CURLOPT_POST, 1);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
        }
        
        //Si se envia el proxy
        if (indProxy == 1){
            curl_setopt($ch, CURLOPT_PROXY, proxyCurl);
            curl_setopt($ch, CURLOPT_PROXYUSERPWD, userPwdProxy);            
        }

        $response = curl_exec($ch);
        $status   = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        
        if ($status != 200 && $status != 201) {
            echo "Error al llamar el servicio Web, El estatus es:" . $status. ", ".curl_error($ch);
            exit(-1);
        }

        curl_close($ch);

        return $response;
    }


    /**
     * Retorna el token de acceso para consumir los servicios del API Rest Adobe Sign
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 10/01/2019
     * 
     * 
     * @return string Cadena con el token de Acceso
     */
    public function getAccessToken(){
        
        $urlApiEchoSign   = urlAdobeSign.'/oauth/refresh';
        $refreshToken     = refreshToken;
        $idCliente        = idCliente;
        $idSecretoCliente = idSecretoCliente;
        $header           = array('Content-Type: application/x-www-form-urlencoded');
        $postData         = 'refresh_token='.$refreshToken.'&client_id='.$idCliente.'&client_secret='.$idSecretoCliente.'&grant_type=refresh_token';
        $response         = $this->curlFirmaDigital($urlApiEchoSign,false,$header,$postData);
        $token            = json_decode($response);

        return $token->access_token;      
    }

     /**
     * Retorna el id del documento transitorio creado
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 10/01/2019
     * 
     * 
     * @return string Cadena con el id del documento transitorio creado
     */
    public function getIdDocumentoTransitorio($nombrePdf){        
       
        $accessToken    = $this->getAccessToken();     
        $urlApiEchoSign = urlAdobeSign.'/api/rest/v5/transientDocuments';    
        $urlLocal       = './asset/public/uploadPdf/Contrato/';
        $header         = array('Authorization: Bearer '.$accessToken,
                                'Content-Type: multipart/form-data',
                                'Content-Disposition: form-data; name="File"; filename="'.$nombrePdf.'"');

        $filePath  = '@'.file_get_contents(realpath($urlLocal.$nombrePdf));
        $postData  = array('File' => $filePath,'Mime-Type' => 'application/pdf', 'File-Name' => $nombrePdf);
        $response  = $this->curlFirmaDigital($urlApiEchoSign,false,$header,$postData);
        $documento = json_decode($response);
        
        return $documento->transientDocumentId;
    }

    /**
     * Retorna la url del contrato con los datos llenos
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 20/02/2019
     * 
     * 
     * @return string Cadena con la url del contrato para firmar
     */
    public function getContrato($nombrePdf,$codPersona,$codPrograma,$codAfiliacion){

        $accessToken       = $this->getAccessToken();   
        $urlApiEchoSign    = urlAdobeSign.'/api/rest/v5/widgets';
        $header            = array('Authorization: Bearer '.$accessToken,
                                   'Content-Type: application/json;charset=UTF-8');
        $idDocuTransitorio = $this->getIdDocumentoTransitorio($nombrePdf);                    
        $datosFirma        = $this->getDatosFirmaContrato($codPersona,$codPrograma,$codAfiliacion)->DATOS_FIRMA;
      
        $postData = '
        {
            "widgetCreationInfo": {
                "fileInfos": [
                    {
                        "transientDocumentId": "'.$idDocuTransitorio.'"
                    }
                ],
                "name": "'.$nombrePdf.'",
                "signatureFlow": "SENDER_SIGNATURE_NOT_REQUIRED",                                              
                "mergeFieldInfo": ['.$datosFirma.' ]                
            }
        }';

        $response = $this->curlFirmaDigital($urlApiEchoSign,false,$header,$postData);
        $acuerdo  = json_decode($response);               
        return $acuerdo;
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

        $urlAdobeSign   = $this->Utilidades_model->getParametro(11)->RESULTADO;
        $rutaLocal      = $this->Utilidades_model->getParametro(10)->RESULTADO;
        $pdf      = $this->Utilidades_model->getParametro(96)->RESULTADO;
        $accessToken    = $this->getAccessToken();
        $urlLocal       = $_SERVER['DOCUMENT_ROOT'].$rutaLocal;
        $nombreContrato = $idContrato.'.pdf';
        $urlApiEchoSign = $urlAdobeSign.'/api/rest/v5/agreements/'.$idContrato.'/combinedDocument';        
        $header         = array('Authorization: Bearer '.$accessToken,
                                'Content-Type: application/json;charset=UTF-8');

        $ch = curl_init($urlApiEchoSign);
        curl_setopt($ch, CURLOPT_HEADER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER,  $header);
        // curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLINFO_HEADER_OUT, true);
        
        $response = curl_exec($ch);

        if (!curl_errno($ch)) {
            $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        }

        curl_close($ch);        
        
        if ($http_code == 200) {
            file_put_contents($urlLocal.$nombreContrato, $response);    
            header('Content-type: application/pdf');
            header('Content-Disposition: inline; filename="'.$pdf.'"');
            return $response;
        } else {
            return "error";
        }
        
        

    }

    /**
     * Retorna una cadena con el Id del Acuerdo Firmado
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 10/01/2019
     * 
     * @param string  $idWidget           Cadena con el Id del Widget en Adobe Sign
     * 
     * @return string  Cadena con el Id del Acuerdo Firmado en Adobe Sign
     */
    public function getIdContrato($idWidget){
        
        $rutaLocal      = $this->Utilidades_model->getParametro(10)->RESULTADO;
        $accessToken    = $this->getAccessToken();
        $urlLocal       = $_SERVER['DOCUMENT_ROOT'].$rutaLocal;
        $nombreArchivo  = $idWidget.'.csv';
        $urlApiEchoSign = urlAdobeSign.'/api/rest/v5/widgets/'.$idWidget.'/formData';
        $header         = array('Authorization: Bearer '.$accessToken,
                                'Content-Type: application/json;charset=UTF-8');
        $response       = $this->curlFirmaDigital($urlApiEchoSign,false,$header,null);      
       
        //Se crea el archivo Plano en la ruta temporal
        file_put_contents($urlLocal.$nombreArchivo, $response);

        //Se convierte el archivo .csv a un array Multidimensional en php
        $rows      = array_map('str_getcsv', file($urlLocal.$nombreArchivo));    
        $idAcuerdo = $rows[1][7];

        //echo "<pre>";  print_r($rows);die();
     
        return $idAcuerdo;

    }
    
    /**
     * Retorna una cadena con los datos JSON para firmar el contrato
     * 
     * @author: Katherine Latorre Mejía
     * @date  : 04/01/2018
     * 
     * @param string   $url         Url del widget parametrizado en Adobe Sign
     * @param integer  $codPersona  Código del Contrante
     * @param integer  $codPrograma Código del programa
     * 
     * @return string Cadena de la Url con los datos llenos
     */
    public function getDatosFirmaContrato($codPersona,$codPrograma,$codAfiliacion){

        $query = "SELECT VDIR_PACK_CONSULTA_CONTRATO.fnGetDatosContrato(?,?,?) AS datos_firma FROM DUAL";
        $consulta = $this->db->query($query,array('param1' => $codPersona,'param2' => $codPrograma,'param3' => $codAfiliacion));        
        return $consulta->row();

    }

    /**
     * Consume la url del servicio que se envie
     * 
     * @author: ever hidalgo
     * @date  : 27/02/2019
     * 
     * 
     * @return json con los datos de la compra
     */
    public function curlFirmaDigitalPayu($postData,$urlApiEchoSign,$indProxy){

        $header = array('Content-Type: application/json;charset=UTF-8');

        $ch = curl_init($urlApiEchoSign);
        curl_setopt($ch, CURLOPT_HEADER,         false);
        curl_setopt($ch, CURLOPT_HTTPHEADER,     $header);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLINFO_HEADER_OUT,    true);

        if ($postData != null){

            curl_setopt($ch, CURLOPT_POST, 1);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
        }
        
        //Si se envia el proxy
        if (indProxy == 1){
            curl_setopt($ch, CURLOPT_PROXY, proxyCurl);
            curl_setopt($ch, CURLOPT_PROXYUSERPWD, userPwdProxy);            
        }

        $response = curl_exec($ch);
        $status   = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        
        if ($status != 200 && $status != 201) {
            echo "Error al llamar el servicio Web, El estatus es:" . $status. ", ".curl_error($ch);
            exit(-1);
        }

        curl_close($ch);

        return $response;
    }

    /**
     * Retorna una cadena con los datos JSON para firmar el contrato
     * 
     * @author: Jors Castro
     * @date  : 09/10/2019
     * 
     * @param integer  $codAfiliacion  Código de afiliacion
     * @param integer  $codPrograma Código del programa
     * 
     * @return string Ccontrato
     */
    public function getNombreContrato($codPrograma,$codAfiliacion){

        $query = "SELECT VDIR_PACK_CONSULTA_CONTRATO.fnGetContrato(?,?) AS datos_firma FROM DUAL";
        $consulta = $this->db->query($query,array('param1' => $codPrograma,'param2' => $codAfiliacion));        
        return $consulta->row();

    }


}

?>