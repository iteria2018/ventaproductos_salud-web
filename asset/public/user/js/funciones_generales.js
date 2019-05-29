jQuery(document).ready(function ($) {
    $("body").attr("style","overflow-x: hidden");
	activeMenuItem();
    runLoading(false);
    verAyudaFooter();  
    cambiarClave();    
    removerOpcionesMenu();
    pasarNumberCel();
    
    if(getParam("param") == 0  || getParam("param") == 1 && g_senal == 0){
        var idModal = 'modal_dialog';
        var botonesModal = [{"id":"cancelarMd","label":"Cerrar","class":"btn-primary"}];
        var formulario = $('<form>'+
                            '<div class="row">'+
                                '<div class="col-12">'+
                                  '<h4>El pago no se pudo realizar. Por favor intente nuevamente.</h4>'+                                 
                                '</div>'+                                
                             '</div>'+
                        '</form>');
    
        crearModal(idModal, 'Error', formulario, botonesModal, true, '', '',true);    
    
        $('#cancelarMd').click(function(){
            $('#'+idModal).modal('hide');
        });
    }


});

function activeMenuItem(){
	var patUrl = location.href.toString().split('/');
	var adminControl = ['Usuario_control','AdminFiles_control','Registro_control','Reporte_control'];
	//var selectedItem = localStorage.itemSelect;
	var selectedItem = patUrl[patUrl.length - 1].indexOf('_control') > -1 ? patUrl[patUrl.length - 1] : 'Inicio_control';
	selectedItem = adminControl.indexOf(selectedItem) > -1 ? 'Admin_control' : selectedItem;
	
	$('#bs-example-navbar-collapse-1').find('li').each(function(index, elemento){
		
		if($('#bs-example-navbar-collapse-1').find('li').eq(index).children('a').attr('onclick_') != undefined){
			if($('#bs-example-navbar-collapse-1').find('li').eq(index).children('a').attr('onclick_').indexOf(selectedItem) > -1){
				
				var auxClass = $('#bs-example-navbar-collapse-1').find('li').eq(index).attr('class');
				$('#bs-example-navbar-collapse-1').find('li').eq(index).attr('class', auxClass+' active');
			}			
		}
	});
}

/*Esta funcion valida que solo se ingresen numeros
implementacion dentro de un input:
onkeypress="return validar_solonumeros(event)"*/

function validar_solonumeros(e, valor) {
  
    var tecla = (document.all) ? e.keyCode : e.which;    
    if (tecla == 8 || tecla == 0 || (tecla == 45 && valor != undefined && valor == '')){
        return true;
    }
        
    var patron = /[\d]/; // [A-Za-zñÑ\s solo letras y espacios  \d solo numeros 
    var te = String.fromCharCode(tecla);
      
    return patron.test(te);
}

function validar_solonumeros_mobile(campo) {  
    campo.value = campo.value.replace(/[^0-9]/g,'');
}

/*Esta funcion valida que solo se ingresen letras y espacios
implementacion dentro de un input:
onkeypress="return validar_sololetras_espacios(event)"*/

function validar_sololetras_espacios(e) {
    var tecla = (document.all) ? e.keyCode : e.which;    
    if (tecla == 8 || tecla == 0)
        return true;
    var patron = /[A-Za-zñÑ\s]/; 
    var te = String.fromCharCode(tecla);
    return patron.test(te);
}

/*Esta funcion valida que se ingrese un email correcto
implementacion: retorna -1 si esta malo "*/

function validarEmail(valor) {
    var expReg = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i;
    if (expReg.test(valor.trim())) {
        return 0;
    } else {
        return -1;
    }
}

/*Esta funcion compara dos fechas
implementacion: retorna  0 si la fecha inicial es mayor o igual a la fecha final "*/

function validate_fechaMayorQue(fechaInicial,fechaFinal){
    valuesStart=fechaInicial.split("-");
    valuesEnd=fechaFinal.split("-");

    // Verificamos que la fecha no sea posterior a la actual
    var dateStart=new Date(valuesStart[2],(valuesStart[1]-1),valuesStart[0]);
    var dateEnd=new Date(valuesEnd[2],(valuesEnd[1]-1),valuesEnd[0]);
    if(dateStart>=dateEnd)
    {
        return 0;
    }
    return 1;
} 

/*Esta funcion coloca la primera letra de cada palabra en mayuscula*/

function initcap(str){
    return str.replace(/([^\W_]+[^\s-]*) */g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
}

/*esta funcion utilza un cargando. resive true o false*/
function runLoading(tipo){
    if(tipo){
        var div_load = $('<div id="div_loading_nexos" class="loading_nexos"> </div>');
        $('body').append(div_load);
    }else{
        $('#div_loading_nexos').remove();
    }

}

/*funciones para validar campos requridos
implementacion: validRequired(getObjRequerid("controller_limite", "")), donde controller_limite es el div que contiene los campos y el otro parametro
es opcional donde van los campos separados por copas(id) de los campos qeu no  quiero q me valide */

function validRequired(requeridos){
    var msj = {};
    var ress = true;
    for(z=0; z<requeridos.length; z++){
        var campo = requeridos[z];
        if($('#'+campo['id']).get(0).tagName == 'SELECT'){
            if($('#'+campo['id']).val() == '' || $('#'+campo['id']).val() == ' ' || $('#'+campo['id']).val() == '-1' || $('#'+campo['id']).val() == undefined){
                msj['id'] = campo['id'];
                msj['mensaje'] = 'Por favor seleccionar un valor en el campo <b>'+campo['texto']+'</b>';
                ress = false;
                break;
            }
        }else{            
            if($('#'+campo['id']).get(0).tagName == 'INPUT' || $('#'+campo['id']).get(0).tagName == 'TEXTAREA' || $('#'+campo['id']).get(0).tagName == 'PASSWORD' || $('#'+campo['id']).get(0).tagName == 'NUMBER' || $('#'+campo['id']).get(0).tagName == 'FILE'){
                if($('#'+campo['id']).val() == '' || $('#'+campo['id']).val() == ' '){
                    msj['id'] = campo['id'];
                    msj['mensaje'] = 'Por favor ingresar un valor en el campo <b>'+campo['texto']+'</b>';
                    ress = false;
                    break;
                }else{
                    if($('input[name="'+campo['id']+'"]:checked').val() == undefined && $('#'+campo['id']).attr('type') == 'radio' && $('#'+campo['id']).is(":visible")){
                        msj['id'] = campo['id'];
                        msj['mensaje'] = 'Por favor seleccionar alguna opci&oacute;n del campo <b>'+campo['texto']+'</b>';
                        ress = false;
                        break;
                    }
                }
            }
        }
    }
    
    if(!ress){  
        var posicion = $('#'+msj['id']).offset();
        var divRequired = $('<div id="div_required_nexos" class="required_nexos" style="left:'+posicion['left']+'px;top:'+(posicion['top']-35)+'px;"> </div>');
        $('body').append(divRequired);
        $('#'+msj['id']).focus();
        alertify.notify(msj['mensaje'], 'error', 3, function(){ $('#div_required_nexos').remove(); });
    }    
    
    return ress;
}
    
function getObjRequerid(element, excluir){
    var requeridos = [];
    var excluidos = excluir != '' ? excluir.split(',') : [];
    $('#'+element).find('input[type="text"],input[type="file"],select,textarea,input[type="password"],input[type="number"],input[type="radio"],input[type="checkbox"]').each(function(index, elemento){
        if(excluidos.indexOf(elemento['id']) < 0){
            var objRequeridos = {};
            objRequeridos['id'] = elemento['id'];
            objRequeridos['texto'] = $('#'+elemento['id']).prev('label').text();
            if (objRequeridos['texto'] == '') {
               objRequeridos['texto'] = $('#'+elemento['id']).parent().prev('label').text();
               if (objRequeridos['texto'] == '') {
                    objRequeridos['texto'] = $('#'+elemento['id']).parent().parent().prev('label').text();
                    if (objRequeridos['texto'] == '') {
                        objRequeridos['texto'] = $('#'+elemento['id']).parent().parent().parent().prev('label').text();
                        if (objRequeridos['texto'] == '') {
                            objRequeridos['texto'] = $('#'+elemento['id']).parent().parent().parent().parent().prev('label').text();
                            if (objRequeridos['texto'] == '') {
                                objRequeridos['texto'] = $('#'+elemento['id']).parent().parent().parent().parent().parent().prev('label').text();
                            }
                        }
                    }
               }
            }
            

            if(objRequeridos['id'] != '' && objRequeridos['id'] != undefined){
                requeridos.push(objRequeridos); 
            }
        }
    });
    
    return requeridos;
}


/*funcion para traducir a español el datatable*/

function traducirTabla(nombre_tabla){

    if (nombre_tabla==undefined) {
        nombre_tabla="tabla1";
    }

     $('#'+nombre_tabla).DataTable({
        responsive: true,
        "colReorder": true,
        "ordering": false,
        "language": {
            "processing":     "Procesando...",
            "search":         "B&uacute;squeda General:",
            "lengthMenu": "Mostrar _MENU_ por p&aacute;gina",
            "zeroRecords": "No hay resultados",
            "info": "Mostrando p&aacute;gina _PAGE_ de _PAGES_",
            "infoEmpty": "Sin registros",
            "infoFiltered": "(Filtrar de _MAX_ total registros)",
            "paginate": {
                  "first": "Primero",
                  "previous": "Anterior",
                  "next": "Siguiente",
                  "last": "Ultimo"
              }
        },
        //dom: 'Bfrtip',
        buttons: [  ]
    });

    $('[data-toggle="tooltip"]').tooltip();     
}

/*funcion para validar cualquier caracter especial o lietras o numeos*/

function validarn(e) { 
    tecla = (document.all) ? e.keyCode : e.which; // 2
    if (tecla==8) return true; // 3
    if (tecla==9) return true; // 3
    if (tecla==11) return true; // 3
    patron = /[A-Za-zñÑ'áéíóúÁÉÍÓÚàèìòùÀÈÌÒÙâêîôûÂÊÎÔÛÑñäëïöüÄËÏÖÜ\s\t]/; // 4
 
    te = String.fromCharCode(tecla); // 5
    return patron.test(te); // 6
} 

/*funcion para crera una tabla con el datatable
  IDTABLE
  columnTable RETORNO getColumnTable
  data: DATOS DEL CONTROLADOR EN FORMATO JSON
*/

function createTable(idTabla, columnTable, data){
    var table = $('<table width="100%" class="table table-striped table-bordered table-hover" id="'+idTabla+'" cellspacing="0"> </table>');
    var thead = $('<thead> </thead>');
    var tbody = $('<tbody> </tbody>');
    var trHead = $('<tr></tr>');
    var arrUndefined = [undefined, 'undefined', null, 'null'];
    var datos = data;

    //Llenar cabecera de la tabla
    for(z=0; z<columnTable.length; z++){
        var tdHead = $('<td><b>'+columnTable[z]['label']+'</b></td>');
        trHead.append(tdHead);
    }
    thead.html(trHead);

    //Llenar cuerpo de la tabla
    if(datos.length > 0 &&  typeof datos == 'object'){
        
        //Llenar de datos el cuerpo de la tabla
        for(x=0; x<datos.length; x++){
            var trbody = $('<tr></tr>');	
            for(y=0; y<columnTable.length; y++){
                var labelTd = datos[x][columnTable[y]['column']];
                var labelTd_aux = arrUndefined.indexOf(labelTd) > -1 ? '' : labelTd+'';
                var alingTd = '';
                if(columnTable[y]['format'] != undefined){
                    if(columnTable[y]['format'] == 'numero'){
                        labelTd = labelTd_aux.trim() != '' ? formatMiles(labelTd_aux) : '';
                        alingTd = ' class="class-numero"';
                    }else{
                        if(columnTable[y]['format'] == 'miles'){
                            labelTd = labelTd_aux.trim() != '' ? formatMiles(labelTd_aux) : '';
                            alingTd = ' class="class-pesos"';
                        }
                    }
                }
                var tdbody = $('<td '+alingTd+'>'+labelTd+'</td>');
                trbody.append(tdbody);
            }

            tbody.append(trbody);
        }
    }else{
        tbody.html('');
    }

    table.html(thead);
    table.append(tbody);   
    
    return table;
}

/*funcion que retorna las columnas que va ha tener la tabla donde
colmn es el nombre real del select 
label es el nombre qeu se va ha mirar en la tabla*/
function getColumnTable(tabla){
  columns = {
    "beneficiarios" : [
            {"column":"tipoDocumento_abr", "label":"Tipo documento"},
            {"column":"numeroDocumento", "label":"N&uacute;mero documento"},            
            {"column":"nombre_completo", "label":"Nombre beneficiario"},
            {"column":"fechaNacimiento", "label":"Fecha nacimiento"},
            {"column":"direccion", "label":"Direcci&oacute;n"},
            {"column":"accion", "label":"Acci&oacute;n"}
        ],
    "beneficiarios_prod" : [
            {"column":"aplica", "label":""},
            {"column":"tipoDocumento_abr", "label":"Tipo documento"},
            {"column":"numeroDocumento", "label":"Numero documento"},            
            {"column":"nombre_completo", "label":"Nombre beneficiario"},
            {"column":"fechaNacimiento", "label":"Fecha nacimiento"},
            {"column":"direccion", "label":"Direcci&oacute;n"},
            {"column":"tarifa", "label":"Tarifa mensual", "format":"miles"}
        ],
    "programacion" : [
            {"column":"fechahora", "label":"Fecha y hora"},
            {"column":"comando", "label":"Comando"},
            {"column":"accion", "label":"Acciones"}
        ],
    "1" : [
            {"column":"identificacion", "label":"Identificaci&oacute;n"},
            {"column":"nombre", "label":"Nombre"},            
            {"column":"telefono", "label":"Tel&eacute;fono"},
            {"column":"email", "label":"Correo el&eacute;ctronico"},
            {"column":"direccion", "label":"Direcci&oacute;n"},            
            {"column":"login", "label":"Login"},            
            {"column":"rol", "label":"rol"},
            {"column":"estado", "label":"Estado"},
            {"column":"editar", "label":"Editar"},
            {"column":"activar", "label":"Activar"},
            {"column":"eliminar", "label":"Desactivar"}                    
        ],   
    "2" : [
            {"column":"identificacion", "label":"Nit"},
            {"column":"nombre", "label":"Nombre"},
            {"column":"telefono", "label":"Tel&eacute;fono"},
            {"column":"email", "label":"Correo el&eacute;ctronico"},
            {"column":"direccion", "label":"Direcci&oacute;n"},           
            {"column":"login", "label":"Login"},
            {"column":"rol", "label":"rol"},                   
            {"column":"estado", "label":"Estado"},
            {"column":"editar", "label":"Editar"}, 
            {"column":"activar", "label":"Activar"},
            {"column":"eliminar", "label":"Desactivar"}                
        ],
    "pedido" : [
            {"column":"cancelar", "label":"Accion"},    
            {"column":"codigo", "label":"Codigo"},
            {"column":"nombre", "label":"Nombre"},
            {"column":"valor", "label":"Valor", "format":"miles"},
            {"column":"cantidad", "label":"Cantidad", "format":"numero"},
            {"column":"subtotal", "label":"Subtotal", "format":"miles"},
            {"column":"impuesto", "label":"Impuesto", "format":"miles"},
            {"column":"descuento", "label":"Descuento", "format":"miles"},
            {"column":"promo_nombre", "label":"Promoci&oacute;n"},
            {"column":"promo_descuento", "label":"Descuento promoci&oacute;n", "format":"miles"},
            {"column":"total", "label":"Total", "format":"miles"}
        ],
    "gestion_pedidos" : [
            {"column":"codigo", "label":"Codigo"},
            {"column":"usuario_nombre", "label":"Usuario"},
            {"column":"subtotal", "label":"Subtotal", "format":"miles"},
            {"column":"impuesto", "label":"Impuesto", "format":"miles"},
            {"column":"descuento", "label":"Descuento", "format":"miles"},
            {"column":"promo_descuento", "label":"Promoci&oacute;n", "format":"miles"},
            {"column":"total", "label":"Total", "format":"miles"},
            {"column":"detalle", "label":"Detalle"},
            {"column":"confirmar", "label":"Confirmar"},
            {"column":"cancelar", "label":"Cancelar"}
        ],
    "promo_producto":[
            {"column":"cod_producto", "label":"Codigo"},
            {"column":"nom_producto", "label":"Nombre"},
            {"column":"valor_descuento", "label":"Descuento"},
            {"column":"dia_aplica", "label":"D&iacute;a"},
            {"column":"hora_inicial", "label":"Hora inicio"},
            {"column":"hora_final", "label":"Hora fin"},
            {"column":"descripcion", "label":"Descripcion"}            
        ],
    "factura_venta":[
        {"column":"codigo", "label":"Codigo"},
        {"column":"nombre_usuario", "label":"Nombre Usuario"},
        {"column":"impuesto", "label":"Impuesto", "format":"miles"},
        {"column":"descuento", "label":"Descuento", "format":"miles"},
        {"column":"promocion", "label":"Promocion", "format":"miles"},
        {"column":"subtotal", "label":"Sub total", "format":"miles"},
        {"column":"total", "label":"Total", "format":"miles"},
        {"column":"fecha_creacion", "label":"Fecha creaci&oacute;n"}            
    ],
    "beneficiarios_cotiza" : [        
        {"column":"tipoNroId", "label":"Identificación"},
        {"column":"nombre_completo", "label":"Nombre beneficiario"},
        {"column":"des_parentesco", "label":"Parantesco"},
        {"column":"soporte_eps", "label":"Soporte EPS"},
        {"column":"salud", "label":"Declaración de salud"},
        {"column":"nombreProducto", "label":"Producto"}
    ],
    "realizar_pago" : [
        {"column":"producto", "label":"Producto"},
        {"column":"afiliados", "label":"Afiliados"},            
        {"column":"tarifa", "label":"Tarifa mensual", "format":"miles"}
    ],
    "beneficiarios_contrato" : [
        {"column":"tipoDocumento_abr", "label":"Tipo de identificación"},
        {"column":"numeroDocumento", "label":"Número de identificación"},            
        {"column":"nombre_completo", "label":"Nombre beneficiario"},
        {"column":"telefono", "label":"Teléfono"},
        {"column":"correo", "label":"Correo electrónico"},
        {"column":"tarifaProducto", "label":"Tarifa mensual"}
    ]
  };

  return columns[tabla];
  
}

/*funcion para aplicar el data table*/

function aplicarDataTable(idTabla, columnas, botones){
    var vColumnas = columnas != undefined && columnas != '' ? columnas : null;
    var vBotones = botones != undefined && botones != '' ? botones : [];
   
    setTimeout(function(){
      
        $('#'+idTabla).DataTable({
            "retrieve": true,
            "responsive": true,
            "colReorder": true,
            "ordering": false,
            "aoColumns": vColumnas,
            "language": {
                "processing":     "Procesando...",
                "search":         "Búsqueda General:",
                "lengthMenu": "Mostrar _MENU_ por p&aacute;gina",
                "zeroRecords": "No hay resultados",
                "info": "Mostrando p&aacute;gina _PAGE_ de _PAGES_",
                "infoEmpty": "Sin registros",
                "infoFiltered": "(Filtrar de _MAX_ total registros)",
                "paginate": {
                    "first": "Primero",
                    "previous": "Anterior",
                    "next": "Siguiente",
                    "last": "Ultimo"
                }
            },
            "dom": "Bfrtip",
            "buttons": vBotones
        });
    }, 100);
}

/*funciones para validar q no se peguen otros caracteres de numeros con el raton, recibe dos parametros
 'campos' son los ids de los campos que quiero que me valide y 'menos' es cualquier variable que le pongan, es decir si cuando
 se llama se pone este parametro entonces se esta diciendo que deje pegar solo un signno menos */
function validarCopyNumeric(campos, menos){ 

 var arrayCampos=campos.split(",");
   
   for (var i = 0; i < arrayCampos.length; i++) {
      validando2(arrayCampos[i],menos);
   }
   
}

function validando2(campo,menos){
  $("#"+campo).bind({      
          paste : function(){
              var valorCampo="";
              setTimeout(function (){ 

                if (menos != undefined) {
                    valorCampo=$("#"+campo).val();
                }else{
                    valorCampo=$("#"+campo).val().replace('-','z');
                }               
                 if (isNaN(valorCampo)) {
                   $("#"+campo).val("");                
                 }
                      
              },100);
          }
      });   
}

function formatMiles(p_valor){
    var valor = typeof p_valor == "number" ? (p_valor.toString()).replace('.',',') : p_valor; 
    var valorCampo = valor == null ? '' : valor.replace(/\./g,'').replace(/\$/g,'');
    var arrayMilDecimal = valorCampo.split(',');
    var valCampo = arrayMilDecimal[0];
    var decimales = arrayMilDecimal[1] != undefined ? ','+arrayMilDecimal[1] : '';
    var cadenaMiles = '';
    var contarMiles = 0;
    var cadenaMilesDecimal = '';

    for(v=valCampo.length; v>0; v--){
        //console.log('VAR_V ->',v, ' = ',valCampo[v-1]);        
        if(contarMiles % 3 == 0){
          cadenaMiles = valCampo[v-1] + '.' + cadenaMiles;
        }else{
          cadenaMiles = valCampo[v-1] +''+ cadenaMiles;
        }
        contarMiles++;
    }
    
    cadenaMilesDecimal = cadenaMiles.substr(0, cadenaMiles.length-1) + decimales;
    return cadenaMilesDecimal;
} 

function traducirCalendar(){
       $.datepicker.regional['es'] = {
         closeText: 'Cerrar',
         prevText: '< Ant',
         nextText: 'Sig >',
         currentText: 'Hoy',
         monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
         monthNamesShort: ['Ene','Feb','Mar','Abr', 'May','Jun','Jul','Ago','Sep', 'Oct','Nov','Dic'],
         dayNames: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
         dayNamesShort: ['Dom','Lun','Mar','Mié','Juv','Vie','Sáb'],
         dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','Sá'],
         weekHeader: 'Sm',
         dateFormat: 'yy/mm/dd',
         firstDay: 1,
         isRTL: false,
         showMonthAfterYear: false,
         yearSuffix: ''
         };
         $.datepicker.setDefaults($.datepicker.regional['es']);
   }


   function validarExtensionFile(idArchivo,extensiones){
      var cadena = "";
      var arrayExtensiones = [];
      var cadenaExtensiones = extensiones.toLocaleLowerCase();
      arrayExtensiones = cadenaExtensiones.split(",");

      var archivo = $("#"+idArchivo).val();
      var extension = archivo.substring(archivo.lastIndexOf(".")+1);
      var validExtension = extension.toLocaleLowerCase();     

      if ($.inArray(validExtension,arrayExtensiones) == -1) {
          cadena="El archivo de tipo " + extension + " no es v\u00e1lido";
          $fileupload = $('#'+idArchivo);
          $fileupload.replaceWith($fileupload.clone(true));
          $("#"+idArchivo).val("");
      }else{
          cadena='OK';
      }

       return cadena;
   
   }

   function limpiarFormulario(id_formulario){    
     $("#"+id_formulario)[0].reset();
   }
   
function crearModal(idModal, titleModal, contentModal, butonsModal, closeModal, classModal, attrModal, openModal){	
	var classChidrem = classModal.replace(/bd-example-/g, '');
	var divModal = $('<div id="'+idModal+'" class="modal fade" role="dialog" '+attrModal+'> </div>');
	var divModalChildren = $('<div id="div_mod_dialog" class="modal-dialog '+classChidrem+'"> </div>');
	var divContent = $('<div class="modal-content">');
	var divHader = $('<div id="mdHader_'+idModal+'" class="modal-header">');
	var divBody = $('<div id="mdBody_'+idModal+'" class="modal-body">');
	var divfooter = $('<div id="mdFooter_'+idModal+'" class="modal-footer">');
	var hTitle = $('<h4 class="modal-title">'+titleModal+'</h4>');
	var btClose = $('<button type="button" class="close" data-dismiss="modal">&times;</button>');
	
	divHader.html('');
	divfooter.html('');
	divBody.html(contentModal);
	
	if(closeModal){
		divHader.append(btClose);
	}
	divHader.append(hTitle);
	
	for(b=0; b<butonsModal.length; b++){
		var btn = butonsModal[b];
		var clases = btn['class'] != '' ? btn['class'] : 'btn-default';
		var mdBoton = $('<button type="button" class="btn '+clases+'" id="'+btn['id']+'">'+btn['label']+'</button>');
		
		divfooter.append(mdBoton);
	}
	
	divContent.append(divHader);
	divContent.append(divBody);
	divContent.append(divfooter);
	divModalChildren.html(divContent);
	divModal.html(divModalChildren);
	$('body').append(divModal);
	
	$('#'+idModal).bind('hidden.bs.modal', function () {
	    $('#'+idModal).remove();
        //Validar si existe algun modal abierto en la pantalla
        setTimeout(function(){
            if($('.modal:visible').length > 0){
                $('body').addClass('modal-open');
            }            
        }, 100);
	});
	
	if(openModal == undefined || openModal == true){
		$('#'+idModal).modal({backdrop: "static",show:true});
    }
    
}


function openPage(page){
  var urlConsulta = 'Home/getPageLoad';
  var paramConsulta = {};
  
  paramConsulta['page'] = page;
  
  runLoading(true); 
  $.ajax({    
    url: urlConsulta, 
    type: "POST",  
    dataType: "html",          
    data: paramConsulta,
    encode:true,
    success:function(resp){
      runLoading(false);
      $('#contenedor_page').html(resp);
    },
    error: function(result) {
      runLoading(false);
      console.log('ERROR_AJAX: La operaci\u00f3n no se pudo completar por que ocurrio un error en la base de datos');
    }
  });
  
}

// funccion para aplicarle plugin fiileinput a un campo input file
function aplicInputFile(showPreview,id_input,browseLabel,array_allowedFileExtensions,ruta_imagen,nombre_imagen,msgPlaceholder,type_extension){

    /*
     showPreview = true o false. con este parametro decidimos si queremos que la imagen se previsualice 
     id_input = identificador del campo file del formaulario
     browseLabel = el lebel del campo file    
     array_allowedFileExtensions = array de las extensiones de archivos permitidas para subir
     ruta_imagen = ruta del archivo a previsualzar
     nombre_imagen = nombre del archivo a previsualizar
     msgPlaceholder = nombre del placeholder del campo file
     type_extension = la extension del archivo a subir

    */   

      var filePreview = "";
      var DefaulFilePreview = "";      

      if (type_extension == 'mp4') {
        filePreview = "<video id='imgPrew' controls class='embed-responsive-item'>"+
                            "<source src='"+ruta_imagen+"' type='video/mp4'>"+
                            "<source src='"+ruta_imagen+"' type='video/ogg'>"+
                      "</video>";

        DefaulFilePreview = "<video id='imgPrew2' controls class='embed-responsive-item'>"+
                                "<source src='"+ruta_imagen+"' type='video/mp4'>"+
                                "<source src='"+ruta_imagen+"' type='video/ogg'>"+
                           "</video>";                  

      }else if(type_extension == 'mp3' || type_extension == 'MP3'){
        filePreview =   "<audio id='imgPrew' src='"+ruta_imagen+"' controls>"+
                            "<p>Tu navegador no implementa el elemento audio</p>"+
                        "</audio>";

        DefaulFilePreview = "<audio id='imgPrew2' src='"+ruta_imagen+"' controls>"+
                                "<p>Tu navegador no implementa el elemento audio</p>"+
                            "</audio>";                

      }else{
        filePreview = "<img id='imgPrew' src='"+ruta_imagen+"' class='file-preview-image'>";
        DefaulFilePreview = "<img id='imgPrew2' src='"+ruta_imagen+"' class='file-preview-image'>";
      }

      $("#"+id_input).fileinput({
        language: 'es',    
        previewFileType: "any",
        allowedFileExtensions: array_allowedFileExtensions, 
        showUpload : false,
        showRemove : false,
        showCaption: true,
        showPreview: showPreview,    
        showCancel : false,
        showClose : false,
        initialPreview: [
               filePreview    
             ],
              initialPreviewAsData: true,
              defaultPreviewContent: DefaulFilePreview,
              initialPreviewConfig: [
              {caption: ruta_imagen, size: 930321, width: "100%", height: "100%",frameClass: 'img-rounded'}
             ],           
             browseLabel : browseLabel,
          });         
          $(".kv-file-remove").remove();  
          $("#imgPrew").attr("src",ruta_imagen);
          $("#imgPrew2").attr("src",ruta_imagen);
          $('.file-caption-name').html(nombre_imagen);    
   
}  

// funcion para validar la extencion(s) de un archivo
function validarExtFile(id_file,extensiones_file){

   var respueta = validarExtensionFile(id_file,extensiones_file);
      if (respueta!='OK') {
         var idModal = 'modalConfirmar';
         var botonesModal = [{
                              "id": "cerrarMd",
                              "label": "Aceptar",
                              "class": "btn-primary"
                           }];

         crearModal(idModal, 'Advertencia', respueta, botonesModal, false, '', '',true);                           
         $('#cerrarMd').click(function() {
            $('.modal').modal('hide');
         });                
          return false;
      }  
} 

//funcion para obtener la extension de un archivo
function getFileExtension(filename) {
  return (/[.]/.exec(filename.trim())) ? /[^.]+$/.exec(filename.trim())[0] : undefined;
}

//funcion para traer la fecha actual. recive un parametro para definir el formato su valor es 0 = "dd/mm/yyyy" si no "yyyy/mm/dd"

function getFechaActual(formato){  
  var date = new Date();
  var dia = date.getDate() < 10 ? ("0"+date.getDate()) : date.getDate();
  var mes = (date.getMonth() +1) < 10 ? "0"+(date.getMonth() +1) : (date.getMonth() +1);
  var anio = date.getFullYear();
  var fechaActual = "";
  if (formato == 0) {
     fechaActual = anio + "/" + mes + "/" + dia;
  }else{
     fechaActual = dia + "/" + mes + "/" + anio;
  }  
    
  return fechaActual;
}

function aplicarDatatablePedidos(idTabla){
    $('#'+idTabla).DataTable({
        responsive: true,
        "colReorder": true,
        "ordering": false,
        "language": {
            "processing":     "Procesando...",
            "search":         "B&uacute;squeda General:",
            "lengthMenu": "Mostrar _MENU_ por p&aacute;gina",
            "zeroRecords": "No hay resultados",
            "info": "Mostrando p&aacute;gina _PAGE_ de _PAGES_",
            "infoEmpty": "Sin registros",
            "infoFiltered": "(Filtrar de _MAX_ total registros)",
            "paginate": {
                  "first": "Primero",
                  "previous": "Anterior",
                  "next": "Siguiente",
                  "last": "Ultimo"
              }
        },
        //dom: 'Bfrtip',
        buttons: [  ]
    });

    $('[data-toggle="tooltip"]').tooltip();
}

/*
  funcion para validar un rango de valores.
*/

function validarRango(campo, mayor, menor){
    //console.log('campo -> ',campo.value, ' mayor -> ', mayor);
    var valor = parseInt(campo.value);
    var limite = parseInt(mayor);
    var limiteMenor = menor != undefined ? parseInt(menor) : 0;
    //console.log('campo -> ',typeof parseInt(valor), ' mayor -> ', typeof limite);
    if(valor > limite || valor < limiteMenor){
      //console.log('valor falso, no puede ser mayor');
      var val = valor.toString();
      var valAux = parseInt(val.substring(0, val.length - 1));
      while(valAux > limite || valAux < limiteMenor){
        val = valAux.toString();
        valAux = parseInt(val.substring(0, val.length - 1));
        //console.log('val1 -- ',valAux);
      }

      campo.value = val.substring(0, val.length - 1);
    }
    
    setTimeout(function(){
      if(campo.value == '' || campo.value == undefined){
        //campo.value = 0;
      }
    },1000);

}

function fechaActual(){
    var objFecha = {};
    var fecha = new Date();
    objFecha['anio'] = auxFecha(fecha.getFullYear());
    objFecha['mes'] = auxFecha(fecha.getMonth() + 1);
    objFecha['dia'] = auxFecha(fecha.getDate());
    objFecha['dia_semana'] = auxFecha(fecha.getDay());
    objFecha['hora'] = auxFecha(fecha.getHours());
    objFecha['minuto'] = auxFecha(fecha.getMinutes());
    objFecha['segundo'] = auxFecha(fecha.getSeconds());

    return objFecha;
}

function auxFecha(numero){
    var datoRetorno = String(numero);
    if(numero < 10){
        datoReturn = '0' + String(numero);
    }

    return datoRetorno;
}


function validFieldMiles(campo){
    campo.value = formatMiles(campo.value);
}


function execute_event_state(claveFn, estado, validGlobal){
    var resultExecute = false;
    var auxiGlobal = global_accion_evento;
    var auxTime = validGlobal == false ? 1000 : 0;
    //console.log('ENTRO......_execute_ajax_state : ['+claveFn+']['+estado+'] \nGlobal-->', auxiGlobal );
    
    setTimeout(function(){
        if(global_accion_evento[claveFn] != undefined){
            if(global_accion_evento[claveFn]['estado'] == estado){
                if(global_accion_evento[claveFn]['accion'] != undefined){
                    try{
                        
                        if(typeof global_accion_evento[claveFn]['accion'] == 'function'){
                            global_accion_evento[claveFn]['accion']();
                        }else{
                            eval(global_accion_evento[claveFn]['accion']);
                        }
                        
                        resultExecute = true;
                   
                    }catch(error){
                       
                        resultExecute = false;
                    }
                    
                }
            }
        }

        if(resultExecute == false && auxTime == 0){
            execute_event_state(claveFn, estado, false);
        }else{
            return resultExecute;
        }
        
    }, auxTime);
    
}


function definir_event_state(claveFn, estado, accion, ejecutar){
    global_accion_evento[claveFn] = {};
    global_accion_evento[claveFn]['estado'] = estado;
    global_accion_evento[claveFn]['accion'] = accion;
  
    if(ejecutar != undefined && ejecutar == true){
        execute_event_state(claveFn, estado);
    }
}

function pointToUrl(){
    var cadena = '';
    var cPunto = '../';
    var aux_url=location.href.split("/");
    //console.log(aux_url);
    //console.log((aux_url.length - aux_url.indexOf("nexos-web")) - 2);
    var nPosition = 0;

    if(aux_url[aux_url.length-1] != ''){
      nPosition = (aux_url.length - aux_url.indexOf("ventaproductos_salud-web")) - 2;
      
    }else{
      nPosition = (aux_url.length - aux_url.indexOf("ventaproductos_salud-web")) - 3;  
    }

    for(p=0; p<nPosition; p++){
      cadena += cPunto;
    }

    return cadena;
}

function formatDate(fechaInicio, fechaFin, bloquearDiasPasados){

    var fechaMinima = '';
    if (bloquearDiasPasados != '' && bloquearDiasPasados != undefined){
        fechaMinima = getFechaActual(1);
    } 
    
    $('#'+fechaInicio).datepicker({
        locale: 'es-es',
        format: 'dd/mm/yyyy',
        minDate: fechaMinima, 
        keyboardNavigation: true, 
        startDate: getFechaActual(0),
        modal: false, 
        header: false, 
        footer: false,
        //uiLibrary: 'bootstrap4',
        change: function (e) {
            if(fechaFin != '' && fechaFin != undefined){
                var valFechaIni = aplicarFormatDate($('#'+fechaInicio).val());
                var valFechaFin = aplicarFormatDate($('#'+fechaFin).val());

                if(valFechaIni != '' && valFechaFin != ''){
                    var dateIni = new Date(valFechaIni);
                    var dateFin = new Date(valFechaFin);
                    if(dateIni > dateFin){
                        $('#'+fechaFin).val('');
                    }
                }               
            }
        }
    });

    $('#'+fechaInicio).bind("cut copy paste",function(e) {
        e.preventDefault();
    });
    
    $('#'+fechaInicio).attr({
        "onkeypress":"return false;",
        "autocomplete":"off"
    });
    
    if(fechaFin != '' && fechaFin != undefined){
        $('#'+fechaFin).datepicker({      
            locale: 'es-es',
            format: 'dd/mm/yyyy',  
            keyboardNavigation: true, 
            modal: false, 
            header: false, 
            footer: false,
            //uiLibrary: 'bootstrap4',
            minDate: function () {
                return $('#'+fechaInicio).val();
            }
        });

        $('#'+fechaFin).bind("cut copy paste",function(e) {
             e.preventDefault();
        });

        $('#'+fechaFin).attr({
            "onkeypress":"return false;",
            "autocomplete":"off"
        });
    }        
}

function cambioTabs(numTab,titulo1,titulo2,titulo3){
    $('.main').removeClass('fondo-tab1');
    $('.main').removeClass('fondo-tab2');
    $('.main').removeClass('fondo-tab3');
    $('.main').removeClass('fondo-tab4');
    $('.main').removeClass('fondo-tab5');

    $('.main').addClass('fondo-tab'+numTab);
    $('#pasoTab').html(titulo1);
    $('#tituloMedio').html(titulo2);
    $('#tituloFinal').html(titulo3);
}

function verAyudaFooter(){

    $(document.body).on("click", "#verAyuda", function() {

        var idModal      = 'verMsgAyuda';
        var botonesModal = [{"id":"cerrarMd","label":"Aceptar","class":"btn-primary"}];

        $.ajax({
            url: pointToUrl()+"Home/verAyudaFooter",  
            type: "POST",  
            dataType: "json",
            success: function(resp){
                runLoading(false);
               
                crearModal(idModal, 'Ayuda' , resp.ayuda, botonesModal, false, 'modal-xl', '',true);
                $('#cerrarMd').click(function() {                          
                    $('.modal').modal('hide');
                });
            },
            error: function(result) {
                runLoading(false);
                crearModal(idModal, 'Confirmarci\u00f3n', 'No se pueden visualizar la ayuda', botonesModal, false, '', '');
                $('#cerrarMd').click(function(){
                    $('#'+idModal).modal('hide');
                });
            }
        });       
        
    });

}

function cambiarClave(){

    $(document.body).on("click", "#verCambiarClave", function() {

        var idModal      = 'verFormCambiarClave';
        var botonesModal = [{"id":"guardarMd","label":"Guardar","class":"btn-primary mr-3"},{"id":"cerrarMd","label":"Cancelar","class":"btn-primary"}];
        var paramsObj    = {};

        $.ajax({
            url: "Usuario/verCambiarClave",  
            type: "POST",  
            dataType: "json",
            data: paramsObj,   
            success: function(resp){
                runLoading(false);
            
                crearModal(idModal, 'Cambiar Contrase&ntilde;a', resp.vista, botonesModal, false, 'modal-md', '',true);
                $('#cerrarMd').click(function() {	                  	   
                    $('#'+idModal).modal('hide');
                });
                $('#guardarMd').click(function() {	                  	   
                    guardarClave()
                });
                
                $("#txtContrasenaActual").PassRequirements();
                $("#txtContrasenaNueva").PassRequirements();
                $("#txtConfirmarContrasena").PassRequirements();
            },
            error: function(resp) {
                runLoading(false);
                crearModal(idModal, 'Confirmarci\u00f3n', 'No se pueden visualizar el formulario cambiar clave', botonesModal, false, '', '');
                $('#cerrarMd').click(function(){
                    $('#'+idModal).modal('hide');
                });
            }
        });
    });
}

function guardarClave(){

    var camposRequeridos = [];
    camposRequeridos.push({"id":"txtContrasenaActual",    "texto":"Debe ingresar la contraseña actual"});
    camposRequeridos.push({"id":"txtContrasenaNueva",     "texto":"Debe ingresar la nueva contraseña"});
    camposRequeridos.push({"id":"txtConfirmarContrasena", "texto":"Debe confirmar la nueva contraseña"});
    
    if(validRequired(camposRequeridos)){

        var validaClaveActual    = $("#txtContrasenaActual").attr('validaPassword');
        var validaClaveNueva     = $("#txtContrasenaNueva").attr('validaPassword');
        var validaConfirmarClave = $("#txtConfirmarContrasena").attr('validaPassword');
        var mensaje              = '';
        var posicion             = '';

        if (validaClaveActual == 0){
            $("#txtContrasenaActual").focus();
            return false; 
        } 
        
        if (validaClaveNueva == 0){
            $("#txtContrasenaNueva").focus();
            return false; 
        } 

        if (validaConfirmarClave == 0){
            $("#txtConfirmarContrasena").focus();
            return false; 
        } 

        if ($("#txtContrasenaActual").val() == $("#txtContrasenaNueva").val()) {
            var mensaje   = 'La clave nueva no puede ser igual a la clave actual';
            var posicion  = $("#txtContrasenaNueva").offset();
            $("#txtContrasenaNueva").val(''); 
            $("#txtConfirmarContrasena").val(''); 
            $("#txtContrasenaNueva").focus();           
        }

        if ($("#txtContrasenaNueva").val() != $("#txtConfirmarContrasena").val()) {

            var mensaje   = 'Las claves ingresadas no coinciden';
            var posicion  = $("#txtConfirmarContrasena").offset();
            $("#txtConfirmarContrasena").val(''); 
            $("#txtConfirmarContrasena").focus();         	  	 
        } 
       
        if (mensaje != ''){
            var divRequired = $('<div id="div_required_nexos" class="required_nexos" style="left:'+posicion['left']+'px;top:'+(posicion['top']-35)+'px;"> </div>');
            $('body').append(divRequired);
            alertify.notify(mensaje, 'error', 3, function(){ $('#div_required_nexos').remove(); });
            return false;
        }

        var idModal       = 'verMsgGuardarClave';
        var botonesModal  = [{"id":"cerrarMsgClave","label":"Aceptar","class":"btn-primary"}];
        var formData      = new FormData($("#formCambiarContrasena")[0]);
    
        $.ajax({
            url: "Usuario/guardarClave",  
            type: "POST",  
            dataType: "json",
            data:formData,            
            cache: false,
            contentType: false,
            processData: false,        
            success: function(resp){
                runLoading(false);

                if (resp.ret){
                    mensajeRespuesta =  'Se cambio la clave con &eacute;xito'; 
                } else {
                    mensajeRespuesta = resp.errors;
                }

                crearModal(idModal, 'Confirmarci\u00f3n', mensajeRespuesta, botonesModal, false, '', '');
                $('#cerrarMsgClave').click(function(){
                    $('#'+idModal).modal('hide');
                    if (resp.ret){
                        $('#verFormCambiarClave').modal('hide');
                    }
                });
            },
            error: function(resp) {
                runLoading(false);
                crearModal(idModal, 'Confirmarci\u00f3n', 'No se puede cambiar la clave', botonesModal, false, '', '');
                $('#cerrarMsgClave').click(function(){
                    $('#'+idModal).modal('hide');
                });
            }
        });

    }
}

function removerOpcionesMenu(){
    if(typeof global_paginasNoAplica != 'undefined'){
        if(global_paginasNoAplica != null){
            var opcionesMenu = global_paginasNoAplica;

            for(o=0; o<opcionesMenu.length; o++){
                var opcionMenu = opcionesMenu[o];
                $('.'+opcionMenu).remove();
            }
        }
        
    }    
}

//funcion para invertir el formato de una fecha. 
function convertDateFormat(string) {
        var info = string.split('/').reverse().join('/');
        return info;
}

//Validar edad apartir la fecha de nacimiento 
function validaEdad(fechaNacimiento, formato){
    var fchNacimiento = new Date(aplicarFormatDate(fechaNacimiento, formato));
    var fchActual = new Date();
    var difAnio = fchActual.getFullYear() - fchNacimiento.getFullYear();
    var difMes = fchActual.getMonth() - fchNacimiento.getMonth();
    var difdia = fchActual.getDate() - fchNacimiento.getDate();
    var anios = 0;//difMes < 1 ? (difAnio >= 1 && difdia >= 0 ? difAnio : difAnio - 1 ): difAnio;    
    if(difAnio < 1){
        anios = 0;
        if (difMes<=0) {            
            if (difdia<0) {
                anios = -1;
            } 
        } 
    }else{
        if(difMes < 1){
            if(difMes == 0){
                if(difdia < 0){
                    anios = difAnio - 1;
                }else{
                    anios = difAnio;
                }
            }else{
                anios = difAnio - 1;
            }
        }else{
            anios = difAnio;
        }
    }

	return anios;   
}

function aplicarFormatDate(fecha, formato){
	var formatFecha = formato == undefined ? 'dd-mm-yyyy' : formato;
	var arrFecha = fecha.indexOf('/') > -1 ? fecha.split('/') : fecha.split('-');
	var resFecha = fecha;
	//aplicar formato mm/dd/yyyy
	if(formatFecha == 'dd-mm-yyyy' || formatFecha == 'dd/mm/yyyy'){
		if(arrFecha.length >= 2){
			resFecha = arrFecha[1] + '/' + arrFecha[0] + '/' +  arrFecha[2];
		}		
	}else{
        if(formatFecha == 'yyyy-mm-dd' || formatFecha == 'yyyy/mm/dd'){
            if(arrFecha.length >= 2){
                resFecha = arrFecha[1] + '/' + arrFecha[2] + '/' +  arrFecha[0];
            }
        }
    }
	
	return resFecha;
}


function pasarNumberCel(idCampo){
    var altoPantalla = $(document).height();
    var anchoPantalla = $(document).width();
    
    if(anchoPantalla <= 500){
        if(idCampo != undefined){
            //$('#'+idCampo).attr('type','number');
            $('#'+idCampo).attr({"onkeyup":"validar_solonumeros_mobile(this);","onkeypress":""});

        }else{            
            $('INPUT[onkeypress*="validar_solonumeros"]').each(function(index, elemento){
                var id_elemto = elemento.id;
                //$('#'+id_elemto).attr('type','number'); 
                $('#'+idCampo).attr({"onkeyup":"validar_solonumeros_mobile(this);","onkeypress":""});           
            });
        }        
    }else{
        if(idCampo != undefined){
            $('#'+idCampo).attr('type','text');
        }
    }
}

function validaTipoDoc(idTipoDoc, idNumDoc){
    var valTipoDoc = $('#'+idTipoDoc).val();
    var valNumDoc = $('#'+idNumDoc).val();
    var tipoAlfaNum = ['3','4'];
    
    if(tipoAlfaNum.indexOf(valTipoDoc) > -1){
        $('#'+idNumDoc).attr({'onkeypress':'','onkeyup':''});
        //pasarNumberCel(idNumDoc);
    }else{
        if(typeof valNumDoc != 'number'){
            $('#'+idNumDoc).val('');
        }
        $('#'+idNumDoc).attr('onkeypress','return validar_solonumeros(event);');
        pasarNumberCel(idNumDoc);
    }
}

function carrarModal(idModal){
    $('#'+idModal).modal('hide');
}

//funcion para capturar el valor de un parametro enviado por la url
function getParam(param){
  return new URLSearchParams(window.location.search).get(param);
}
