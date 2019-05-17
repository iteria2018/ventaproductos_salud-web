<?php 

  defined('BASEPATH') OR exit('No direct script access allowed');

  use PHPMailer\PHPMailer\PHPMailer;
  use PHPMailer\PHPMailer\Exception;

  require FCPATH.'application/PHPMailer/src/Exception.php';
  require FCPATH.'application/PHPMailer/src/PHPMailer.php';
  require FCPATH.'application/PHPMailer/src/SMTP.php'; 
  require FCPATH.'application/html2pdf/vendor/autoload.php';  

  use Spipu\Html2Pdf\Html2Pdf;
  use Spipu\Html2Pdf\Exception\Html2PdfException;
  use Spipu\Html2Pdf\Exception\ExceptionFormatter; 
  
  class Utilidades_model extends CI_Model{
  	
  	public function __construct() {
        parent::__construct();
    }
      
    public function validaSession() {
		$codUser = $this->session->userdata('codigo_usuario');   
		if(!$codUser){
			redirect('Login');
        }
    }
  	 public function encrypt($str, $key){
           $block = mcrypt_get_block_size('rijndael_128', 'ecb');
           $pad = $block - (strlen($str) % $block);
           $str .= str_repeat(chr($pad), $pad);
           return base64_encode(mcrypt_encrypt(MCRYPT_RIJNDAEL_128, $key, $str, MCRYPT_MODE_ECB));
     }

      public function decrypt($str, $key){ 
           $str = base64_decode($str);
           $str = mcrypt_decrypt(MCRYPT_RIJNDAEL_128, $key, $str, MCRYPT_MODE_ECB);
           $block = mcrypt_get_block_size('rijndael_128', 'ecb');
           $pad = ord($str[($len = strlen($str)) - 1]);
           $len = strlen($str);
           $pad = ord($str[$len-1]);
           return substr($str, 0, strlen($str) - $pad);
      }

    public function generarCombo($id, $tabla, $campo1, $campo2, $order, $seleccione, $where, $firtsMayus, $objAttr) {

        $this->db->reconnect(); /*esta linea es muy importante permite ejecutar un procedimiento muchsd vesces en la misma peticion*/
        /*
            Descripción de parametros.
            -----------------------------------------------------------------------------------------------------------
            id : Identificador del selector
            tabla : Tabla de la db donde se consultan los datos
            campo1 : campo identificador (PK_ID), este es el value de la opcion en el selector
            campo2 : campo texto visual (DESCRIPCION), este es el html de la opcion en el selector
            order : campo por el que se va ha ordenar (1=PK_ID, 2=DESCRIPCION)
            seleccione : campo adicional a los items de la lista (''=null, ' '=item vacio, 'Selecione...'= item texto)
            where : condicion sql para filtrar registros consultados
            firtsMayus : formatea texto a, preimera letra en mayusculas y el resto en minusculas (true/false)
            objAttr : objecto con atribitos a añadir a la etiqueta select ("attributo"=>"valor_atributo")
        */

        $atributos = '';
        foreach ($objAttr as $atributo => $value) {
            $atributos .= $atributo."='".$value."' ";
        }
        
        $valorIni = $seleccione;
        $selInicio = "<select name='".$id."' id='".$id."' ".$atributos.">";
        $selFin = "</select>";
        $cadena = "";
        
        try {
            $cadenaQuery = "SELECT DISTINCT $campo1, $campo2 FROM  $tabla";
            if(strpos($where, "pk_id") !== false || strpos($where, "vch_nombre") !== false){
                $cadenaQuery = $cadenaQuery ." WHERE ". $where;
            }

            $cadenaQuery = $cadenaQuery ." ORDER BY ".$order;

            $data=$this->db->query("CALL medisscop_proc_get_coleccion('".$cadenaQuery."')");

            if ($data->num_rows() > 0) {
              
                if($valorIni != ''){
                    $cadena = $cadena . "<option value = -1 selected>" . $valorIni;
                }                

                foreach ($data->result() as  $fila) {
                    if($firtsMayus){
                        $cadena = $cadena . "<option value=" . $fila->pk_id . ">" .mb_convert_case($fila->vch_nombre, MB_CASE_TITLE, "UTF-8"). "</option>";
                    }else{
                        $cadena = $cadena . "<option value=" . $fila->pk_id . ">" . $fila->vch_nombre ."</option>"; 
                    }
                }



                $cadena = $selInicio . $cadena . $selFin;
              
            }

            return $cadena;

        } catch (Exception $exc) {
            echo $exc->getTraceAsString();
        }
    }
	
	public function createTable($idTable, $columnTable, $data){
        $vTable = '<table width="100%" class="table table-striped table-bordered display cell-border" id="'.$idTable.'" cellspacing="0">';
        $vThead = '<thead><tr>';
        $vTbody = '<tbody>';

        for($z=0; $z<count($columnTable); $z++){
            $atributos_head = isset($columnTable[$z]['attribs_head']) ? $columnTable[$z]['attribs_head'] : '';
            $vThead .= '<th '.$atributos_head.'>'.$columnTable[$z]['label'].'</th>';
        }

        $vThead .= '</tr></thead>';

        $aux_contador = 1;             
  
        for($y=0; $y<count($data); $y++){
            $vTbody .= '<tr>';            
            
            for($x=0; $x<count($columnTable); $x++){
                
                $atributos = isset($columnTable[$x]['attribs']) ? $columnTable[$x]['attribs'] : '';
                if(gettype($data[$y]) == 'array'){
                   
                    $vTbody .= '<td tabindex="'.$aux_contador.'" '.$atributos.'>'.$data[$y][$columnTable[$x]['column']].'</td>';
                }else{
                    
                    $vTbody .= '<td tabindex="'.$aux_contador.'" '.$atributos.'>'.$data[$y]->$columnTable[$x]['column'].'</td>';
                }

                $aux_contador = $aux_contador+1;
                
            }
            $vTbody .= '</tr>';
        }

         
        $vTbody .= '</tbody>';
        

        $vTable .= $vThead;
        $vTable .= $vTbody;
        $vTable .= '</table>';

        return $vTable;

    }
      
    //Funcion para declarar las cabeceras(COLUMNAS) de una tabla
    public function columnCbz($cbz){
        $cabecera = array(
						'tipoPersona' => array(
                                    array('column'=>'codigo_parametro', 'label'=>'C&oacute;digo'),
                                    array('column'=>'nombre_parametro', 'label'=>'Nombre'),                                    
                                    array('column'=>'nombre_estado', 'label'=>'Estado'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
                                    array('column'=>'eliminar', 'label'=>'Inactivar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')    
                                ),
						'parametros' => array(
                                    array('column'=>'pk_id', 'label'=>'C&oacute;digo'),
                                    array('column'=>'vch_nombre', 'label'=>'Parametro'),
									array('column'=>'vch_descripcion', 'label'=>'Descripci&oacute;n'),
									array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"')									
                                ),
						'rol' => array(
                                    array('column'=>'pk_id', 'label'=>'C&oacute;digo'),
                                    array('column'=>'vch_nombre', 'label'=>'Rol'),
									array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
									array('column'=>'eliminar', 'label'=>'Eliminar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"'),
                                    array('column'=>'permisos', 'label'=>'Permisos')
                                ),
						'tipoArchivo' =>array(
                                    array('column'=>'codigo_parametro', 'label'=>'C&oacute;digo'),
                                    array('column'=>'nombre_parametro', 'label'=>'Nombre'),
                                    array('column'=>'nombre_estado', 'label'=>'Estado'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
                                    array('column'=>'eliminar', 'label'=>'Inactivar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')    
                                ),
                        'tipoFactura' =>array(
                                    array('column'=>'codigo_parametro', 'label'=>'C&oacute;digo'),
                                    array('column'=>'nombre_parametro', 'label'=>'Nombre'),
                                    array('column'=>'nombre_estado', 'label'=>'Estado'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
                                    array('column'=>'eliminar', 'label'=>'Inactivar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')    
                                ),
                        'estados' => array(
                                    array('column'=>'pk_id', 'label'=>'C&oacute;digo'),
                                    array('column'=>'vch_nombre', 'label'=>'Nombre'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"')
                                ),
                        'tipo_nivel' =>array(
                                    array('column'=>'codigo_parametro', 'label'=>'C&oacute;digo'),
                                    array('column'=>'nombre_parametro', 'label'=>'Nombre'),
                                    array('column'=>'nombre_estado', 'label'=>'Estado'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
                                    array('column'=>'eliminar', 'label'=>'Inactivar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')    
                                ),
                         'tipoIdentificacion' =>array(
                                    array('column'=>'codigo_parametro', 'label'=>'C&oacute;digo'),
                                    array('column'=>'nombre_parametro', 'label'=>'Nombre'),
                                    array('column'=>'nombre_estado', 'label'=>'Estado'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
                                    array('column'=>'eliminar', 'label'=>'Inactivar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')    
                                ),
                         'mesa' =>array(
                                    array('column'=>'codigo_parametro', 'label'=>'C&oacute;digo'),
                                    array('column'=>'nombre_parametro', 'label'=>'Nombre'),
                                    array('column'=>'nombre_estado', 'label'=>'Estado'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
                                    array('column'=>'eliminar', 'label'=>'Inactivar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')    
                                ),
                        'pagina' => array(
                                    //array('column'=>'codigo', 'label'=>'C&oacute;digo'),
                                    array('column'=>'nombre', 'label'=>'Nombre p&aacute;gina'),
                                    array('column'=>'href', 'label'=>'Enlace'),
                                    array('column'=>'orden', 'label'=>'Orden'),
                                    array('column'=>'nivel_nombre', 'label'=>'Nivel'),
                                    array('column'=>'padre_nombre', 'label'=>'P&aacute;gina padre'),
                                    array('column'=>'icono_nombre', 'label'=>'Icono'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
                                    array('column'=>'eliminar', 'label'=>'Eliminar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"'),
                                    array('column'=>'permisos', 'label'=>'Permisos')
                                ),
                        'icono' => array(
                                    array('column'=>'codigo_parametro', 'label'=>'C&oacute;digo'),
                                    array('column'=>'nombre_parametro', 'label'=>'Nombre'),
                                    array('column'=>'descripcion', 'label'=>'Descripci&oacute;n'),
                                    array('column'=>'icono_menu', 'label'=>'Icono'),
                                    array('column'=>'nombre_estado', 'label'=>'Estado'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
                                    array('column'=>'eliminar', 'label'=>'Inactivar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')    
                                ),                        
                        'reporte' => array(
                                    array('column'=>'identificacion', 'label'=>'Identificaci&oacute;n paciente'),
                                    array('column'=>'paciente', 'label'=>'Nombre paciente'),
                                    array('column'=>'empresa', 'label'=>'Empresa'),
                                    array('column'=>'dirEmpresa', 'label'=>'Direcci&oacute;n empresa'),
                                    array('column'=>'telefonoEmpresa', 'label'=>'Tel&eacute;fono empresa'),
                                    array('column'=>'emailEmpresa', 'label'=>'Email empresa'),
                                    array('column'=>'examen', 'label'=>'Tipo de ex&aacute;men'),
                                    array('column'=>'fechaVencimiento', 'label'=>'Fecha vencimiento')
                                ),
                        'empresa' => array(
                                    array('column'=>'nit', 'label'=>'Nit'),
                                    array('column'=>'nombre_empresa', 'label'=>'Empresa'),
                                    array('column'=>'slogan_empresa', 'label'=>'Slogan'),
                                    array('column'=>'email_empresa', 'label'=>'Email'),
                                    array('column'=>'telefonos', 'label'=>'Tel&eacute;fono(s)'),
                                    array('column'=>'celulares', 'label'=>'Celular(s)'),
                                    array('column'=>'direccion_empresa', 'label'=>'Direcci&oacute;n'),
                                    array('column'=>'ruta_logo_empresa', 'label'=>'Logo'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"')
                                ),
                        'proveedor' => array(
                                    array('column'=>'nom_tipo_identificacion', 'label'=>'Tipo identificaci&oacute;n'),
                                    array('column'=>'identificacion', 'label'=>'Identificaci&oacute;n'),
                                    array('column'=>'nombre', 'label'=>'Nombre'),                                    
                                    array('column'=>'email', 'label'=>'Email'),
                                    array('column'=>'telefono', 'label'=>'Tel&eacute;fono'),
                                    array('column'=>'celular', 'label'=>'Celular'),
                                    array('column'=>'direccion', 'label'=>'Direcci&oacute;n'),                                   
                                    array('column'=>'eliminar', 'label'=>'Eliminar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"')
                                ),
                        'cliente' => array(
                                    array('column'=>'nom_tipo_identificacion', 'label'=>'Tipo identificaci&oacute;n'),
                                    array('column'=>'identificacion', 'label'=>'Identificaci&oacute;n'),
                                    array('column'=>'nombre', 'label'=>'Nombre'),                                    
                                    array('column'=>'email', 'label'=>'Email'),
                                    array('column'=>'telefono', 'label'=>'Tel&eacute;fono'),
                                    array('column'=>'celular', 'label'=>'Celular'),
                                    array('column'=>'direccion', 'label'=>'Direcci&oacute;n'),                                    
                                    array('column'=>'eliminar', 'label'=>'Eliminar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"')
                                ),
                        'usuario' => array(
                                    array('column'=>'nom_tipo_identificacion', 'label'=>'Tipo identificaci&oacute;n'),
                                    array('column'=>'identificacion', 'label'=>'Identificaci&oacute;n'),
                                    array('column'=>'nombre_persona', 'label'=>'Nombre'),
                                    array('column'=>'telefono', 'label'=>'Tel&eacute;fono'),
                                    array('column'=>'celular', 'label'=>'Celular'),
                                    array('column'=>'email', 'label'=>'Email'),
                                    array('column'=>'direccion', 'label'=>'Direcci&oacute;n'),
                                    array('column'=>'login', 'label'=>'Login'), 
                                    array('column'=>'ruta_foto', 'label'=>'Foto'),                                                                
                                    array('column'=>'eliminar', 'label'=>'Eliminar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"')                                    
                                ),
                        'documento' => array(
                                    array('column'=>'identificacion', 'label'=>'Identificaci&oacute;n'),
                                    array('column'=>'nombre', 'label'=>'Nombre'),   
                                    array('column'=>'nombre_tipo', 'label'=>'Documento'), 
                                    array('column'=>'tipo_propietario', 'label'=>'Visualizar', 'attribs'=>'class="class_visualizar"', 'attribs_head'=>'class="class_visualizar"'),                                                                   
                                    array('column'=>'ruta_documento', 'label'=>'Descargar', 'attribs'=>'class="class_download"', 'attribs_head'=>'class="class_download"'),       
                                    array('column'=>'eliminar', 'label'=>'Eliminar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"')                                    
                                ),
                        'bitacora' => array(
                                    array('column'=>'tabla', 'label'=>'Tabla'),
                                    array('column'=>'operación', 'label'=>'Operaci&oacute;n'),   
                                    array('column'=>'dato_anterior', 'label'=>'Dato anterior'), 
                                    array('column'=>'dato_nuevo', 'label'=>'Dato nuevo'),                                                                   
                                    array('column'=>'fecha', 'label'=>'Fecha'),       
                                    array('column'=>'usuario', 'label'=>'Usuario'),
                                    array('column'=>'campo', 'label'=>'Campo'),
                                    array('column'=>'ip', 'label'=>'IP'),
                                    array('column'=>'navegador', 'label'=>'Navegador')                                                                        
                                ),
                        'tipoPermiso' => array(
                                    array('column'=>'codigo_parametro', 'label'=>'C&oacute;digo'),
                                    array('column'=>'nombre_parametro', 'label'=>'Nombre'),
                                    array('column'=>'clase', 'label'=>'Clase'),
                                    array('column'=>'nombre_estado', 'label'=>'Estado'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
                                    array('column'=>'eliminar', 'label'=>'Inactivar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')    
                                ),
                        'incidencia' => array(
                                    array('column'=>'codigo_incidencia', 'label'=>'C&oacute;digo'),
                                    array('column'=>'descripcion', 'label'=>'Descripci&oacute;n'),
                                    array('column'=>'fecha', 'label'=>'Fecha'),
                                    array('column'=>'nit_empresa', 'label'=>'Nit'),                                    
                                    array('column'=>'editar', 'label'=>'Resolver', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"')                                        
                                ),
                        'tipoPropietario' =>array(
                                    array('column'=>'codigo_parametro', 'label'=>'C&oacute;digo'),
                                    array('column'=>'nombre_parametro', 'label'=>'Nombre'),
                                    array('column'=>'nombre_estado', 'label'=>'Estado'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
                                    array('column'=>'eliminar', 'label'=>'Inactivar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')    
                                ),
                        'tipoPago' =>array(
                                    array('column'=>'codigo_parametro', 'label'=>'C&oacute;digo'),
                                    array('column'=>'nombre_parametro', 'label'=>'Nombre'),
                                    array('column'=>'nombre_estado', 'label'=>'Estado'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
                                    array('column'=>'eliminar', 'label'=>'Inactivar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')    
                                ),
                        'ubicacion_imagen' => array(
                                    array('column'=>'codigo_parametro', 'label'=>'C&oacute;digo'),
                                    array('column'=>'nombre_parametro', 'label'=>'Nombre'),
                                    array('column'=>'nombre_estado', 'label'=>'Estado'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
                                    array('column'=>'eliminar', 'label'=>'Inactivar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')    
                                ),
                        'tipo_proveedor' => array(
                                    array('column'=>'codigo_parametro', 'label'=>'C&oacute;digo'),
                                    array('column'=>'nombre_parametro', 'label'=>'Nombre'),
                                    array('column'=>'nombre_estado', 'label'=>'Estado'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
                                    array('column'=>'eliminar', 'label'=>'Inactivar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')    
                                ),
                        'logUsuarios' => array(
                                    array('column'=>'usuario', 'label'=>'Usuario'),
                                    array('column'=>'fecha', 'label'=>'Fecha'),
                                    array('column'=>'ip', 'label'=>'IP'),
                                    array('column'=>'navegador', 'label'=>'Navegador')                                   
                                ),
                        'tipoDocumento' => array(
                                    array('column'=>'codigo_parametro', 'label'=>'C&oacute;digo'),
                                    array('column'=>'nombre_parametro', 'label'=>'Nombre'),
                                    array('column'=>'tipo_nombre', 'label'=>'Propietario'),
                                    array('column'=>'nombre_estado', 'label'=>'Estado'),                                    
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
                                    array('column'=>'eliminar', 'label'=>'Eliminar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')    
                                ),
                        'tipoEmpresa' => array(
                                    array('column'=>'codigo_parametro', 'label'=>'C&oacute;digo'),
                                    array('column'=>'nombre_parametro', 'label'=>'Nombre'),
                                    array('column'=>'nombre_estado', 'label'=>'Estado'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),
                                    array('column'=>'eliminar', 'label'=>'Inactivar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')    
                                ),
                        'imagen' => array(                                    
                                    array('column'=>'DES_FILE', 'label'=>'Descripci&oacute;n'),
                                    array('column'=>'ruta_foto', 'label'=>'Imagen'),                                   
                                    array('column'=>'ruta_documento', 'label'=>'Descargar'),                                     
                                    array('column'=>'eliminar', 'label'=>'Eliminar') 
                                ),
                        'producto' => array(
                                    array('column'=>'pk_id', 'label'=>'C&oacute;digo','attribs'=>'onclick="updateColumnGlobal(this)"'),
                                    array('column'=>'vch_porcentaje', 'label'=>'Incremento(%)','attribs'=>'onfocus="fnSetInputTd(this);" datae-maxlength="2" datae-onkeypress="return validar_solonumeros(event)" datae-class="setdata"'),
                                    array('column'=>'vch_descripcion', 'label'=>'Descripci&oacute;n','attribs'=>'onfocus="fnSetInputTd(this);" datae-maxlength="200" datae-class="setdata"'), 
                                    array('column'=>'dec_precio_compra', 'label'=>'Precio compra','attribs'=>'onfocus="fnSetInputTd(this);" datae-onkeypress="return validar_solonumeros(event)" datae-onkeyup="validFieldMiles(this);"  datae-onpaste="notCopyPaste(this)" datae-class="setdata"'),  
                                    array('column'=>'dec_precio_venta', 'label'=>'Precio venta','attribs'=>'onfocus="fnSetInputTd(this);" datae-onkeypress="return validar_solonumeros(event)" datae-onkeyup="validFieldMiles(this);"  datae-onpaste="notCopyPaste(this)" datae-class="setdata"'),                                    
                                    array('column'=>'int_cantidad', 'label'=>'Cantidad','attribs'=>'onfocus="fnSetInputTd(this);" datae-onkeypress="return validar_solonumeros(event)" datae-onkeyup="validFieldMiles(this);"  datae-onpaste="notCopyPaste(this)" datae-class="setdata"'), 
                                    array('column'=>'int_stock', 'label'=>'Stock','attribs'=>'onfocus="fnSetInputTd(this);" datae-onkeypress="return validar_solonumeros(event)" datae-onkeyup="validFieldMiles(this);"  datae-onpaste="notCopyPaste(this)" datae-class="setdata"'),
                                    array('column'=>'vch_cod_lector_barras', 'label'=>'C&oacute;digo barras','attribs'=>'onfocus="fnSetInputTd(this);" datae-maxlength="50" datae-class="setdata"'), 
                                    array('column'=>'fk_tipo_medida', 'label'=>'C&oacute;digo tipo medida'),
                                    array('column'=>'fk_categoria', 'label'=>'C&oacute;digo categor&iacute;a'),
                                    array('column'=>'fk_marca', 'label'=>'C&oacute;digo marca'),
                                    array('column'=>'fk_impuesto', 'label'=>'C&oacute;digo impuesto'),
                                    array('column'=>'bool_inventariable', 'label'=>'Inventariable'),
                                    array('column'=>'editar', 'label'=>'Editar','attribs'=>'class="class_delete" onkeydown="showForm(event,this)"', 'attribs_head'=>'class="class_delete center_th"'),
                                    array('column'=>'eliminar', 'label'=>'Eliminar', 'attribs'=>'class="class_edit" onkeydown="showForm(event,this)"', 'attribs_head'=>'class="class_edit center_th"')                                    
                                ),
                        'producto_descuento' => array(
                                    array('column'=>'id', 'label'=>'Productos'),
                                    array('column'=>'nombre_tipo_descuento', 'label'=>'Tipo descuento'),
                                    array('column'=>'descuento', 'label'=>'Valor descuento'),
                                    //array('column'=>'des', 'label'=>'Descripci&oacute;n'),                                                                     
                                    array('column'=>'nombre_periodo', 'label'=>'Tipo periodo'),  
                                    array('column'=>'codigo_periodo', 'label'=>'Periodo'),                                    
                                    array('column'=>'hora_ini', 'label'=>'Hora inicial'), 
                                    array('column'=>'hora_fin', 'label'=>'Hora final'),
                                    array('column'=>'nombre_forma', 'label'=>'Tipo forma descuento'),
                                    //array('column'=>'des_estado', 'label'=>'Estado'), 
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_delete" onkeydown="showForm(event,this)"', 'attribs_head'=>'class="class_delete center_th"'),
                                    array('column'=>'eliminar', 'label'=>'Eliminar', 'attribs'=>'class="class_edit" onkeydown="showForm(event,this)"', 'attribs_head'=>'class="class_edit center_th"')                                    
                        ),
                        'promociones' => array(
                            array('column'=>'codigo', 'label'=>'C&oacute;digo'), 
                            array('column'=>'nombre', 'label'=>'Nombre'),                                   
                            array('column'=>'formula', 'label'=>'Formula'), 
                            array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),                                    
                            array('column'=>'eliminar', 'label'=>'Eliminar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')
                        ),
                        'factura_entrada' => array(
                                    array('column'=>'codigo_factura', 'label'=>'C&oacute;digo factura'),
                                    array('column'=>'fecha_creacion', 'label'=>'Fecha'),
                                    array('column'=>'identificacion_prestador', 'label'=>'Identificaci&oacute;n proveedor'),
                                    array('column'=>'nombre', 'label'=>'Nombre proveedor'),                                                                                                        
                                    //array('column'=>'observacion', 'label'=>'observaci&oacute;n'),  
                                    array('column'=>'nombre_tipo_pago', 'label'=>'Tipo pago'),                                    
                                    array('column'=>'nombre_estado', 'label'=>'Estado pago'), 
                                    array('column'=>'ruta', 'label'=>'Factura'), 
                                    array('column'=>'abono', 'label'=>'Abonar', 'attribs'=>'class="class_visualizar"', 'attribs_head'=>'class="class_visualizar center_th"'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit center_th"')                                    
                      ),
                        'mensajes' => array(
                                    array('column'=>'mensaje', 'label'=>'Mensaje'), 
                                    array('column'=>'nombre_tipo_anuncio', 'label'=>'Tipa anuncio'),
                                    array('column'=>'nombre_estado', 'label'=>'Estado'),
                                    array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"')
                                   ),
                        'pdf_pedido' => array(
                                    array('column'=>'codigo', 'label'=>'C&oacute;digo'), 
                                    array('column'=>'nombre', 'label'=>'Nombre'),
                                    array('column'=>'valor', 'label'=>'Valor'),
                                    array('column'=>'cantidad', 'label'=>'Cantidad'),                                    
                                    array('column'=>'subtotal', 'label'=>'Subtotal'),
                                    array('column'=>'impuesto', 'label'=>'Impuesto'),
                                    array('column'=>'descuento', 'label'=>'Descuento'),
                                    array('column'=>'promo_descuento', 'label'=>'Descuento promoci&oacute;n'),
                                    array('column'=>'total', 'label'=>'Total')
                        ),
                        'reglasPuntos'  => array(
                            array('column'=>'codigo', 'label'=>'C&oacute;digo'), 
                            array('column'=>'nombre', 'label'=>'Nombre'), 
                            array('column'=>'opredor_des', 'label'=>'Operador'), 
                            array('column'=>'puntos', 'label'=>'N&uacute;mero de puntos'),
                            array('column'=>'periodo_des', 'label'=>'Tipo periodo'), 
                            array('column'=>'hora_inicio', 'label'=>'Hora inicio'),
                            array('column'=>'hora_fin', 'label'=>'Hora fin'), 
                            array('column'=>'estado_des', 'label'=>'Estado'),
                            array('column'=>'dias_aplica_des', 'label'=>'Dias aplica'),
                            array('column'=>'editar', 'label'=>'Editar', 'attribs'=>'class="class_edit"', 'attribs_head'=>'class="class_edit"'),                                    
                            array('column'=>'eliminar', 'label'=>'Eliminar', 'attribs'=>'class="class_delete"', 'attribs_head'=>'class="class_delete"')
                        ),
                        'promoProducto' => array(
                            array('column'=>'codigo_producto', 'label'=>'C&oacute;digo'), 
                            array('column'=>'nombre_producto', 'label'=>'Nombre producto'),
                            array('column'=>'periodo', 'label'=>'D&iacute;a'),
                            array('column'=>'descuento', 'label'=>'Descuento'),
                            array('column'=>'hora_inicial', 'label'=>'Hora inicial'),
                            array('column'=>'hora_final', 'label'=>'Hora final'),
                            array('column'=>'precio_anterior', 'label'=>'Precio normal'),
                            array('column'=>'precio_actual', 'label'=>'Precio con descuento','attribs'=>'style="color:red"')

                        )
                    );
        

        return $cabecera[$cbz];
    }

   /*funcion para enviar correos 1*/

    public function enviarEmail($de,$para,$asunto,$mensaje){
        //configuracion para gmail
          $configGmail = array(
            'protocol' => 'smtp',
            'smtp_host' => 'smtp.gmail.com',
            'smtp_port' => 465,
            'smtp_user' => 'ever.hidalgo22@gmail.com',
            'smtp_pass' => 'gomez34671503',
            'smtp_crypto' => 'ssl',
            'mailtype' => 'html',
            'smtp_timeout' => '4',
            'charset' => 'utf-8',
            'newline' => "\r\n",
            'wordwrap' => TRUE // cambio ever 18-07-2018
          ); 

          //cargamos la configuración para enviar con gmail
          $this->email->initialize($configGmail);

          $this->email->from($de);
          $this->email->to($para);          
          $this->email->subject($asunto);
          $this->email->message("<h2>Reporte de insidencias</h2><hr><br>".$mensaje);
          $envio = $this->email->send();         

          return $envio;


     }

     /*funcion para enviar correos 2*/

   public function enviarEmail2($from,$to,$asunto,$mensaje,$name,$pdf,$name_file){

          //set_time_limit(120);
          
          $mail = new PHPMailer();            

          //$mail->SMTPDebug  = 2; 
          $mail->IsSMTP(); 
          //$mail->Timeout =   60;         
          $mail->Host = "smtp.gmail.com";
          $mail->SMTPAuth = true;
          $mail->Username = "ever.hidalgo22@gmail.com";  // Correo Electrónico
          $mail->Password = "3117419329"; // Contraseña
          $mail->SMTPSecure = 'tls';          
          $mail->Port = 587;           
          
          //configurar email 
          $mail->SMTPOptions = array(
                                    'ssl' => array(
                                        'verify_peer' => false,
                                        'verify_peer_name' => false,
                                        'allow_self_signed' => true
                                    )
                                );        
          $mail->SetFrom($from, $name);
          $mail->AddAddress($to);
          $mail->isHTML(true); 
          $mail->Subject  =  $asunto;
          $mail->CharSet = 'UTF-8';
          $mail->Body = $mensaje; //"Nombre: $name \n<br />".  
          if($pdf != ""){            
              $mail->addStringAttachment($pdf,$name_file);
           }      
          //$mail->WordWrap = 50; 

          if ($mail->Send()){
            $result = "OK";
          }else{
            $result = "NO";
          }

          $mail->SmtpClose(); 

         return $result;


   }  

     /*funcion para subir archivos*/
     public function UploadFile($path,$nameImg, $typeFiles){ 
        $retorno="";        
        $config['upload_path'] = $path;                    
        $config['allowed_types'] = $typeFiles;
        $config['encrypt_name'] = false;
        $config['file_name'] = rand(10,100000) .'_'. $_FILES[$nameImg]["name"];       
        
        $this->load->library('upload', $config);
        
        if ( ! $this->upload->do_upload($nameImg)){
            $error = $this->upload->display_errors();
            $retorno=$error;           
            return false;
        }
        else{
            $file_data = $this->upload->data();
            return $file_data['file_name'];
        }
      }


	public function contarVisitas(){
		$paramObj = array();
		$data = array();
		$ipCliente = trim($_SERVER['REMOTE_ADDR']);
		$fechaActual = date('Y-m-d');
        $result = $this->Inicio_model->getContadorVisitas($paramObj);
		
		$data['cotador'] = 0;
		$data['objIp'] = '';
		
		if(!$result){
			
		}else{
			
			for($x=0; $x<count($result); $x++){
				if($result[$x]->vch_nombre == 'contador_visitante_pagina'){
					$data['cotador'] = $result[$x]->valor;
				}else{
					if($result[$x]->vch_nombre == 'ip_visitas_dia'){
						$data['objIp'] = $result[$x]->valor;
					}else{
						if($result[$x]->vch_nombre == 'fecha_ip_visitas'){
							$data['fecha'] = date($result[$x]->valor);
						}
					}
				}
			}
			
			if($data['fecha'] < $fechaActual){
				$this->Inicio_model->setContadorVisitas('fecha_ip_visitas', $fechaActual);
				$this->Inicio_model->setContadorVisitas('ip_visitas_dia', '');
				$data['objIp'] = '';
			}
			
			if($data['objIp'] != ''){				
				$arrayIp = explode('-',$data['objIp']);
				$position = array_search($ipCliente, $arrayIp);
				
				if(!$position){
					$data['cotador'] = ($data['cotador'] + 1);
					$data['objIp'] = $data['objIp'].'-'.$ipCliente;
					$resultContador = $this->Inicio_model->setContadorVisitas('contador_visitante_pagina', $data['cotador']);
				    $resultIp = $this->Inicio_model->setContadorVisitas('ip_visitas_dia', $data['objIp']);

				}
			}else{
				$data['cotador'] = ($data['cotador'] + 1);
				$data['objIp'] = $data['objIp'].'-'.$ipCliente;
				$resultContador = $this->Inicio_model->setContadorVisitas('contador_visitante_pagina', $data['cotador']);
				$resultIp = $this->Inicio_model->setContadorVisitas('ip_visitas_dia', $data['objIp']);
			}
		}
		
		return $data['cotador']; //.' ? '. $data['objIp'];
		//$resp = json_encode($data);
        //$this->output->set_content_type('application/json')->set_output($resp);
		
	}

   /*esta funcion envia en el parametro where la condicion que quiero que se cumpla*/

    public function generarComboWhere($id, $tabla, $campo1, $campo2, $order, $seleccione, $where, $firtsMayus, $objAttr) {
        /*
            Descripción de parametros.
            -----------------------------------------------------------------------------------------------------------
            id : Identificador del selector
            tabla : Tabla de la db donde se consultan los datos
            campo1 : campo identificador (PK_ID), este es el value de la opcion en el selector
            campo2 : campo texto visual (DESCRIPCION), este es el html de la opcion en el selector
            order : campo por el que se va ha ordenar (1=PK_ID, 2=DESCRIPCION)
            seleccione : campo adicional a los items de la lista (''=null, ' '=item vacio, 'Selecione...'= item texto)
            where : condicion sql para filtrar registros consultados
            firtsMayus : formatea texto a, preimera letra en mayusculas y el resto en minusculas (true/false)
            objAttr : objecto con atribitos a añadir a la etiqueta select ("attributo"=>"valor_atributo")
        */

        $atributos = '';
        $seleccionar = '';
        foreach ($objAttr as $atributo => $value) {
            if($atributo != '_SELECCIONAR_'){
                $atributos .= $atributo.'="'.$value.'" ';
            }else{
                $seleccionar = $value;
            }
            
        }
        
        $valorIni = str_replace('{obl}', '', $seleccione);
        $selInicio = '<select name="'.$id.'" id="'.$id.'" '.$atributos.'>';
        $selFin = "</select>";
        $cadena = "";
        
        if($valorIni != ''){
            if(strpos($seleccione, '{obl}') === 0){
                $cadena = $cadena . '<option value ="-1" selected disabled hidden>' . $valorIni . '</option>';
            }else{
                $cadena = $cadena . '<option value ="-1" selected>' . $valorIni . '</option>';
            }            
        }                

        try {
            $aux_array_coleccion = array('campo1' => $campo1,
                                         'campo2' => $campo2,
                                         'tabla'  => $tabla,
                                          'where'  => $where);

            $cadenaQuery = ":curs_datos := VDIR_PACK_UTILIDADES.VDIR_FN_GETCOLECCION_WHERE('".$campo1."','".$campo2."','".$tabla."','".$where."','".$order."')";
          
            $data = $this->Utilidades_model->getDataRefCursor($cadenaQuery);

            if (count($data) > 0) {

                for ($i=0; $i < count($data) ; $i++) {
                       $fila = $data[$i];
                       $selected = $seleccionar == $fila["CODIGO"] ? 'selected' : '';

                        if($firtsMayus){
                            $cadena = $cadena . '<option value="' . $fila["CODIGO"] .'" '.$selected.' >' .mb_convert_case($fila["NOMBRE"], MB_CASE_TITLE, 'UTF-8').'</option>';
                        }else{
                            $cadena = $cadena . '<option value="' . $fila["CODIGO"] .'" '.$selected.' >' . $fila["NOMBRE"] .'</option>'; 
                        } 
                }         
              
            }

            if($id != ''){
                $cadena = $selInicio . $cadena . $selFin;
            }

            return $cadena;

        } catch (Exception $exc) {
            echo $exc->getTraceAsString();
        }
    }   

    public function UploadImage($path,$nameImg, $typeFiles){

        $retorno="";        
        $config['upload_path'] = $path;                    
        $config['allowed_types'] = $typeFiles;
        $config['encrypt_name'] = false; 
        $config['max_size'] = '10240000000';
        $config['file_name'] = rand(10,100000).'_'.$this->limpiarCaracteresEspeciales($_FILES[$nameImg]["name"]);   
        
        $this->load->library('upload', $config);
        
        if (!$this->upload->do_upload($nameImg)){
            $error = $this->upload->display_errors();
            $retorno=$error;                                 
            return false;
        }
        else{
            $file_data = $this->upload->data();
            return $file_data['file_name'];
        }
      }


     public function guardarException($codigo,$mensaje,$nit_empresa){
        
        $query=$this->db->query("INSERT INTO multi.multi_insidencia(pk_id,vch_nombre,fk_empresa,fk_estado) VALUES(".$codigo.",'".$mensaje."','".$nit_empresa."',3)");

       require 'ConexionExterna.php';

       $db= New ConexionExterna();
       $sql="INSERT INTO multi_insidencia(pk_id,vch_nombre,fk_empresa,fk_estado) VALUES(".$codigo.",'".$mensaje."','".$nit_empresa."',3)";

       $result=  $db->query($sql);       

        mysqli_close($db);

        return $result; 
     }

     //funcion para traer cualquier columna de una tabla

     public function getOneFileTable($codigo){

        $query=$this->db->query("SELECT * from  multi.fn_get_one_data_table ('vch_nombre','multi.multi_parametro','pk_id=".$codigo."') AS result");
        return $query->row();
     } 

    public function getPageMainData($objParam){
        $query=$this->db->query("SELECT * from  multi.fn_get_paginas_menu (".$objParam['pagina'].",".$objParam['nivel'].",".$objParam['codigo_usuario'].") AS result");
        return $query->result();
    }

    public function getPermisosQuit($objParam){
        $query=$this->db->query("SELECT * from  multi.fn_get_permisos_pagina_x_usuario('".$objParam['pagina']."',".$objParam['usuario'].") AS resultado");
        return $query->result()[0]->resultado;
    } 


    /*Obtener ip*/
    public function getRealIpAddr() {
        
          if (isset($_SERVER["HTTP_CLIENT_IP"]))
            {
                return $_SERVER["HTTP_CLIENT_IP"];
            }
            elseif (isset($_SERVER["HTTP_X_FORWARDED_FOR"]))
            {
                return $_SERVER["HTTP_X_FORWARDED_FOR"];
            }
            elseif (isset($_SERVER["HTTP_X_FORWARDED"]))
            {
                return $_SERVER["HTTP_X_FORWARDED"];
            }
            elseif (isset($_SERVER["HTTP_FORWARDED_FOR"]))
            {
                return $_SERVER["HTTP_FORWARDED_FOR"];
            }
            elseif (isset($_SERVER["HTTP_FORWARDED"]))
            {
                return $_SERVER["HTTP_FORWARDED"];
            }
            else
            {
                return $_SERVER["REMOTE_ADDR"];
            }
    }


    
    public function getBrowser($user_agent){

        if(strpos($user_agent, 'MSIE') !== FALSE)
           return 'Internet explorer';
         elseif(strpos($user_agent, 'Edge') !== FALSE) //Microsoft Edge
           return 'Microsoft Edge';
         elseif(strpos($user_agent, 'Trident') !== FALSE) //IE 11
            return 'Internet explorer';
         elseif(strpos($user_agent, 'Opera Mini') !== FALSE)
           return "Opera Mini";
         elseif(strpos($user_agent, 'Opera') || strpos($user_agent, 'OPR') !== FALSE)
           return "Opera";
         elseif(strpos($user_agent, 'Firefox') !== FALSE)
           return 'Mozilla Firefox';
         elseif(strpos($user_agent, 'Chrome') !== FALSE)
           return 'Google Chrome';
         elseif(strpos($user_agent, 'Safari') !== FALSE)
           return "Safari";
         else
           return 'No hemos podido detectar su navegador';


     }

     public function getDataSesion(){

        $user_agent = $_SERVER['HTTP_USER_AGENT'];
        $user = $this->session->userdata('login_usuario');
        $browser = $this->Utilidades_model->getBrowser($user_agent);
        $ip = $this->Utilidades_model->getRealIpAddr();
        $result = array(
                        "user" => $user,
                        "browser" => $browser,
                        "ip" => $ip
                    );

        $retorno = $result['user'].'='.$result['ip'].'='.$result['browser'];

        return $retorno;

    } 

    /*funcion para darle formato de miles a un valor numerico*/

    function formatMiles($valor){
        $valCampo = str_replace('.','',$valor);
        $cadenaMiles = '';
        $contarMiles = 0;
        for($v=strlen($valCampo); $v>0; $v--){
            //console.log('VAR_V ->',v, ' = ',valCampo[v-1]);
            
            if($contarMiles % 3 == 0){
              $cadenaMiles = $valCampo[$v-1] . '.' .$cadenaMiles;
            }else{
              $cadenaMiles = $valCampo[$v-1] .''. $cadenaMiles;
            }
            $contarMiles++;
        }
        
        return substr($cadenaMiles, 0, strlen($cadenaMiles)-1);
    } 

    /*funcion para subir y recorrer archivos excel*/
    public function uploadFile_to_db($id_field_file, $ruta_upload){
        //Cargar libreria para leer excel (PHPExcel)
        $this->load->library('excel');
        
        $ruta = $ruta_upload;//'./asset/public/fileUpload_prueba/';
        $idFile = $id_field_file; 
        $typeFile = 'xls|xlsx';
        $ress_upload = $this->Utilidades_model->UploadImage($ruta, $idFile, $typeFile);
        $array_data_sheets = array();
        $aux_ruta_delete = $ruta_upload.$ress_upload;         

        if($ress_upload != false && $ress_upload != ''){
            $inputFileName = $ruta . $ress_upload ;
            $objPHPExcel = PHPExcel_IOFactory::load($inputFileName);
            $sheets_file = $objPHPExcel->getSheetNames();
            
            for($s=0; $s<count($sheets_file); $s++){
                $name_sheet = $sheets_file[$s];
                $sheet = $objPHPExcel->getSheet($s);
                $data_sheet = $sheet->getCellCollection();

                $array_sheet['name'] = $name_sheet;
                $array_sheet['data'] = array();

                foreach ($data_sheet as $cell) {
                    $column = $sheet->getCell($cell)->getColumn();
                    $row = $sheet->getCell($cell)->getRow();
                    $data_value = $sheet->getCell($cell)->getValue();
                    
                    $array_sheet['data'][$row][$column] = $data_value;
                    /*
                    //header will/should be in row 1 only. of course this can be modified to suit your need.
                    if ($row == 1) {
                        $header[$row][$column] = $data_value;
                    } else {
                        $arr_data[$row][$column] = $data_value;
                    }
                    */
                }

                $array_data_sheets[$s] = $array_sheet;
            }
        }

        // se elimina el excel q se subio al servidor       
         $validRuta=strpos($ruta_upload,'images');
         if (file_exists($aux_ruta_delete) AND !$validRuta) {
            @unlink($aux_ruta_delete);
         }

        return $array_data_sheets;
        
    } 

    /*funcion para cargar y recorrer un archivo excel*/

    public function cargarArchivoXls($file_id,$ruta_file){
        $archivo = $file_id;
        $result = $this->uploadFile_to_db($file_id, $ruta_file);
        $new_data = array();       

        for($h=0; $h<count($result); $h++){
            $hoja = $result[$h]['data'];            
            $new_hoja = array();
            $contador = 0;
            $new_hoja['nombre'] = $result[$h]['name'];
            $new_hoja['id'] = $this->replaceCharSpec(str_replace(' ','_',$result[$h]['name']));
            $new_hoja['columnasLetra'] = array();

            
            foreach($hoja as $datos){
                $dato = $datos;
                $cbz_hoja = array();
                $datos_hoja = array();
                if($contador == 0){
                    foreach($dato as $key => $dt){
                        if($dt != null){
                            $cbz['label'] = $dt.'';
                            $cbz['column'] = $this->replaceCharSpec(str_replace(' ','_',$dt));
                            $cbz['letra'] = $key;
                            $new_hoja['columnasLetra'][] = $key;
                            $cbz_hoja[] = $cbz;
                        }           
                    }
                    $new_hoja['cbz'] = $cbz_hoja;
                }else{
                    $contaData = 0;                    
                    /*foreach($dato as $dt){
                        //if($dt != null){
                            $datos_hoja[$new_hoja['cbz'][$contaData]['column']] = $dt;
                            $contaData++;
                        //}           
                    }*/
                    for($c=0; $c<count($new_hoja['columnasLetra']); $c++){
                        $letra = $new_hoja['columnasLetra'][$c];
                        $datoCelda = isset($dato[$letra]) ? $dato[$letra] : '';
                        $datos_hoja[$new_hoja['cbz'][$contaData]['column']] =  $datoCelda;
                        $contaData++;
                    }
                    $new_hoja['datos'][] = $datos_hoja;
                }

                $contador++;
            }

            //$aux_newData['cabecera']
            $new_data[] = $new_hoja;
        }

        $data['data_file'] = $result;
        $data['data'] = $new_data;
        $data['file'] = $archivo;       

        return $data;        
        
    }

    public function replaceCharSpec($str){ 

        $resReplace = str_replace('á','a',$str);
        $resReplace = str_replace('é','e',$resReplace);
        $resReplace = str_replace('í','i',$resReplace);
        $resReplace = str_replace('ó','o',$resReplace);
        $resReplace = str_replace('ú','u',$resReplace);
        $resReplace = str_replace('ñ','n',$resReplace);
        $resReplace = str_replace('Á','A',$resReplace);
        $resReplace = str_replace('É','E',$resReplace);
        $resReplace = str_replace('Í','I',$resReplace);
        $resReplace = str_replace('Ó','O',$resReplace);
        $resReplace = str_replace('Ú','U',$resReplace);
        $resReplace = str_replace('Ñ','N',$resReplace);
        $resReplace = str_replace('/','_',$resReplace);
        $resReplace = strtoupper($resReplace);
      
        return $resReplace;
    } 

   public function getIconosPantallas(){

         $imagenDerecha= "";
         $imagenIzquierda= "";;

         $sql = "SELECT 
                  ubfile.fk_ubicacion_imagen as codigo,
                  file.vch_ruta as ruta
                 FROM
                  multi.multi_file file
                  
                  INNER JOIN multi.multi_ubicacion_file ubfile
                   ON ubfile.fk_file=file.pk_id
                   
                 WHERE  
                   ubfile.fk_ubicacion_imagen IN (4,5)";

        $result = $this->db->query($sql);

        if ($result->num_rows() > 0) {
            foreach ($result->result() as $value) {
               if($value->codigo == 4){
                   $imagenIzquierda = $value->ruta;
               }else{
                   $imagenIzquierda = $this->getParametro(12)->result;
               }

               if ($value->codigo == 5) {
                   $imagenDerecha = $value->ruta;
               }else{
                   $imagenDerecha = $this->getParametro(12)->result; 
               }               
            }
           $datosResult = array('imagenIzquierda' => $imagenIzquierda,
                                'imagenDerecha' => $imagenDerecha);

           return $datosResult;
        }else{
            $datosResult = array('imagenIzquierda' => $this->getParametro(12)->result,
                                'imagenDerecha' => $this->getParametro(12)->result); 
           return $datosResult;
    }

   }

   /*funcion para validar los errores de la operacion*/

   public function  validResult($objResult){      
        if (strtoupper($objResult['respuesta']) != 'OK') {
            $this->guardarException($objResult['codigo'],$objResult['respuesta'],$objResult['nit_empresa']);

            $correosDestino=$this->getOneFileTable(5);
            $correRemitente=$this->getOneFileTable(7);

            $auxArrayEmail = explode(",",$correosDestino->nombre);  
            for ($i=0; $i < count($auxArrayEmail); $i++) { 
             $this->enviarEmail($correRemitente->nombre,$auxArrayEmail[$i],'Reporte insidencias',$objResult['respuesta']);  
            }                     
        }
    }

   /*funcion para limpiar todos los caracterres especiales de una cadena*/
   public function limpiarCaracteresEspeciales($string ){
     $string = htmlentities($string);
     $string = preg_replace('/\&(.)[^;]*;/', '\1', $string);
     return $string;
   } 

   /**
     * Retorna un PDF dependiendo de una vista html que se envie
     * 
     * @author: Ever Hidalgo
     * @date  : 18/01/2019
     * 
     * @param array   $view        Nombre de la vista html que se debe pasar a PDF
     * @param array   $data        Datos para imprimir en la vista HTML
     * @param string  $nombrePDF   Nombre del PDF con el que se va a generar el PDF
     * @param string  $tipoAccion  Destino donde se puede enviar el documento:
     *                             - I: enviar el archivo en línea al navegador.
     *                             - D: enviar al navegador y forzar una descarga
     *                             - F: guardar en un archivo del servidor local.
     *                             - S: devuelve el documento como una cadena.
     *                             - FI: equivalente a la opción F + I
     *                             - FD: equivalente a la opción F + D
     *                             - E: devolver el documento como archivo adjunto de correo 
     *                                  electrónico de varias partes de mime de base64 (RFC 2045)
	 *   
     * @return application/pdf Archivo PDF con la información del HTML
     */
    public function imprimirPdf($view,$data,$nombrePDF,$tipoAccion){  
      
        try {
            ob_start();            
            $this->load->view($view,$data);
            $content = ob_get_clean();
            $html2pdf = new Html2Pdf('P', 'A3', 'es', true, 'UTF-8');  // despues del utf8  valor de los margenes ejemplo array (5, 5, 5, 8) (opcional)
            $html2pdf->setDefaultFont('Arial');            
            $html2pdf->writeHTML($content);             
            $pdf = $html2pdf->output($nombrePDF,$tipoAccion); 

        } catch (Html2PdfException $e) {
                $html2pdf->clean();
                $formatter = new ExceptionFormatter($e);
                echo $formatter->getHtmlMessage();
        }
        
        return $pdf;
    }

/*funccion que procesa un cursor oracle*/
    public function getDataRefCursor($queryCursor){
        $resultado = array();        

        $query = "BEGIN ".$queryCursor."; END;";        

        $curs = oci_new_cursor($this->db->conn_id);
        $stid = oci_parse($this->db->conn_id, $query);
        oci_bind_by_name($stid, ":curs_datos", $curs, -1, OCI_B_CURSOR);
        oci_execute($stid);
        oci_execute($curs);  // Ejecutar el REF CURSOR como un ide de sentencia normal
        while(($row = oci_fetch_array($curs, OCI_ASSOC+OCI_RETURN_NULLS)) != false){
            $resultado[] = $row;
        }

        oci_free_statement($stid);

        oci_free_statement($curs);
        //oci_close($conn);

        return $resultado;
    }

    // funcion para consumir los servicos web 
     public function getDataCurl($parametros){

            $codigo_parametro = 1;  
            $urlBase = $this->getParametro($codigo_parametro)->RESULTADO;
                 
            $urlBase = $urlBase.'/'.$parametros["tipo_documento"].'/'.$parametros["documento"];
     
            $curl = curl_init();
            curl_setopt($curl, CURLOPT_URL, $urlBase);
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($curl, CURLOPT_HEADER, false);
            $data = curl_exec($curl);
            curl_close($curl);            
        
    
        return $data;

    } 

    //Función para consumir los Servicios de Sias
    public function getDataCurlSias($sistema, $token, $nombre, $parametros){ 

        $url =$this->getParametro(57); 

        $urlBase = $url->RESULTADO;
        $urlBase = $urlBase.'/'.$sistema.'/'.$token.'/'.$nombre;

        for($i=0; $i<15; $i++){
            if($i < count($parametros)){
                $urlBase = $urlBase.'/'.$parametros[$i];
            }else{
                $urlBase = $urlBase.'/param'.($i+1);
            }
        }            

        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, $urlBase);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HEADER, false);
        $data = curl_exec($curl);
        curl_close($curl); 

        return $data;

    } 

    //funcion para traer un valor de la tabla de parametros 
    public function getParametro($codigo){

        $query = "SELECT VDIR_PACK_UTILIDADES.VDIR_FN_GET_PARAMETRO(?) AS RESULTADO FROM DUAL";
        $consulta = $this->db->query($query,array('param1' =>$codigo));        
        return $consulta->row();

    }  

    // funcion para consumir un servicos web
    public function getDataCurlServ($codUrlBase, $objParametros, $separador){
        $urlBase = $this->getParametro($codUrlBase)->RESULTADO;
		
        if($separador == '&'){
            $urlBase = $urlBase . '?';
        }
        
        for($u=0; $u<count($objParametros); $u++){
            $param = str_replace(" ", "%20", $objParametros[$u]);
            $urlBase = $urlBase.$separador.$param;
        }
        
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, $urlBase);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HEADER, false);
        $data = curl_exec($curl);
        curl_close($curl);
		
        return json_decode($data, true);
    }

    public function getDataTableCamp($campo1, $campo2, $tabla, $where, $order){
        $cadenaQuery = ":curs_datos := VDIR_PACK_UTILIDADES.VDIR_FN_GETCOLECCION_WHERE('".$campo1."','".$campo2."','".$tabla."','".$where."','".$order."')";
        $data = $this->Utilidades_model->getDataRefCursor($cadenaQuery);
        
        if(count($data) < 1){
            $data = array();
        }

        return $data;
    }

    public function getMaxIndexParam(){
        $sentencia = "SELECT MAX(COD_PARAMETRO) AS IDX FROM VDIR_PARAMETRO";
        $query = $this->db->query($sentencia);
        $ress = -1;
        
        if($query){
            $ress = $query->row()->IDX;
        }
        
        return $ress;
    }

    public function insert_log_debug($pllave, $pvalor){
        $ejecutarInsert = $this->getParametro(78)->RESULTADO;
        $ress = false;
        if($ejecutarInsert == '1'){
            $strIdx = $this->getMaxIndexParam();
            $idxParam = intval($strIdx) + 1;
            $llave = substr($pllave, 0, 3999);
            $valor = substr($pvalor, 0, 3999);
            $sentencia = "INSERT INTO VDIR_PARAMETRO(COD_PARAMETRO, DES_PARAMETRO, VALOR_PARAMETRO, COD_ESTADO) VALUES (".$idxParam.",'".$llave."','".$valor."',1)";
            $query = $this->db->query($sentencia);
        
            if($query){
                $ress = true;
            }
        }
        
        return $ress;
    }


 }


?>