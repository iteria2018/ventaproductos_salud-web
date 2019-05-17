<?php 

  class PromocionesImg extends CI_Controller{
  	
  	public function __construct() {
        parent::__construct();          
        $this->load->model('Utilidades_model');
        $this->load->model('PromocionesImg_model');        
  	}

    public function index(){       
         $this->Utilidades_model->validaSession();  
         $data['tablaImagen'] = $this->crearTablaImagen(); 
         $this->load->view('PromocionesImg',$data); 
    }

    public function crearTablaImagen(){

      $columnas = $this->Utilidades_model->columnCbz('imagen');
      $data = $this->PromocionesImg_model->getDataImagen();                
      if (count($data) > 0) {   

          for ($i=0; $i < count($data) ; $i++) {         
         
              $codigo_file = $data[$i]["CODIGO_FILE"];             
              $ruta_file  = $data[$i]["RUTA_FILE"];    

              $data[$i]["ruta_foto"] = '<div title="'.$ruta_file.'"><center><img src="'.$ruta_file.'" class="btn_image"></center></div>';
              $data[$i]["ruta_documento"] = '<div onclick="descargarDocumento(\''.$ruta_file.'\')" class="descaragarDoc" title="Descargar imagen"></div>';          
              $data[$i]["eliminar"] = '<div onclick="javascript:eliminarReigistro(\''.$codigo_file.'\',\''.$ruta_file.'\');"><center><img src="./asset/public/images/delete.png" class="btn_image"></center></div>';
           }

      }          
    
    $tabla = $this->Utilidades_model->createTable('tabla_imagen', $columnas, $data);

    return $tabla;
  } 

  public function guardarImagen(){ 
      $desArchivo = $this->input->post("desArchivo");
      $file_element_name = 'archivo';
      $typeFile = '*'; 
      $param1 = 14;         
      $rutaParametro =  $this->Utilidades_model->getParametro($param1)->RESULTADO;
      $nameImg = $_FILES["archivo"]["name"];
      $nombreEncrypImg = "";
      $aux_url = "";
       
      if ($nameImg != "") {
         $nombreEncrypImg = $this->Utilidades_model->UploadImage($rutaParametro,$file_element_name,$typeFile);   
      } 
      
      if ($nombreEncrypImg != false OR  $nameImg == "") {
            $datosJson = array(                                      
                              'file_name' => $desArchivo, 
                              'file_name_encript' => $nombreEncrypImg, 
                              'ruta_file' => $rutaParametro.$nombreEncrypImg
                              //'dataSesion' => $this->Utilidades_model->getDataSesion()                                    
            );

            $result = $this->PromocionesImg_model->guardarImagen($datosJson);
            $aux_url = base_url().$rutaParametro.$nombreEncrypImg; 

            $retorno['respuesta'] = $result;
      }else{
         $retorno['respuesta']='Error al subir la foto al servidor.';
      }
         
        
     $retorno['tablaImagen'] = $this->crearTablaImagen();
     $retorno['url_imagen'] = $aux_url;
     $this->output->set_content_type('application/json')->set_output(json_encode($retorno));

  }

  public function eliminarImagen(){
        
        $codigo = $this->input->post("codigo_file");
        $result = $this->PromocionesImg_model->eliminarImagen($codigo);

        $rutaAnterior = $this->input->post("ruta_file_ant");
        $validRuta = strpos($rutaAnterior,'images');

        if ($result == 'OK') {
           if (file_exists($rutaAnterior) AND !$validRuta) {
              @unlink($rutaAnterior);
           }
           $retorno['respuesta'] = "Operaci&oacute;n realizada correctamente";

        }else{
          $retorno['respuesta'] = $result;
        }
       
        //$retorno['url_imagen'] = base_url().json_decode($this->Utilidades_model->getParametro(12)->result)->mensaje;

        $retorno['tablaImagen'] = $this->crearTablaImagen();
        $this->output->set_content_type('application/json')->set_output(json_encode($retorno));
 } 

}


 ?>