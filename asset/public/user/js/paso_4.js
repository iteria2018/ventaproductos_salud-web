
$(document).ready(function(){

	var tabsCompra = $('#tabs_compra').children('li'); 
	
	var telefono = global_datos_contratante.TELEFONO != "" && global_datos_contratante.TELEFONO != null ? global_datos_contratante.TELEFONO : global_datos_contratante.CELULAR; 

	$("#tipoDocumento_pago").val(global_datos_contratante.COD_TIPO_IDENTIFICACION);
	$("#numeroDocumento_pago").val(global_datos_contratante.NUMERO_IDENTIFICACION);	
	$("#nombre1_pago").val(global_datos_contratante.NOMBRE_1);
	$("#nombre2_pago").val(global_datos_contratante.NOMBRE_2);
	$("#apellido1_pago").val(global_datos_contratante.APELLIDO_1);
	$("#apellido2_pago").val(global_datos_contratante.APELLIDO_2);
	$("#correo_pago").val(global_datos_contratante.EMAIL);
	$("#telefono_pago").val(telefono);
	$("#tipoTipoPago").val(1);

	$("#form_pago").find("input[type='text'],select").each(function(){
 		$(this).prop("disabled","disabled");
	});

	//Aplicar evento click a la pesta 2 - Agregar producto
    tabsCompra.eq(3).children('a').click(function(){
        pintarTabla();
    });

    $("#btn_pago").click(function(){
        var idModal = 'modalConfirmarPago';       
        var botonesModal = [{"id": "aceptarPago", "label": "Si","class": "btn-primary mr-2"},
                            {"id": "cerrarPago", "label": "No","class": "btn-primary"}]; 
        
        crearModal(idModal, 'Confirmaci&oacute;n', '¿Desea continuar con el pago de los servicios solicitados?', botonesModal, false, '', '',true);
        
        $('#cerrarPago').click(function() {
            $('#'+idModal).modal('toggle');                             
        });
        
        $('#aceptarPago').click(function() {
            $('#'+idModal).modal('toggle');  
            realizarPago();
        });
                
    });     

});


 function pintarTabla(){
    var productos = global_productos;
    var beneficiarios = global_registro_basico;
    var columnas = getColumnTable('realizar_pago');
    var aux_contador = 0;
    var sum_tar = 0;      
    var objDatos = {}; 
    var aux_array_data = [];
    var nomProducto = "";
    var aux_total_compra = 0;
    
    for(p=0; p<productos.length; p++){
        var producto = productos[p];
        var programas = producto['PROGRAMAS'];        
        for(a=0; a<programas.length; a++){
            var programa = programas[a];  
            sum_tar = 0;
            aux_contador = 0; 
            objDatos = {};
            nomProducto = ""; 
                     
         for(b in beneficiarios){
                var beneficiariox = beneficiarios[b];
                var llaveBenefi = beneficiariox['tipoDocumento']+'_'+beneficiariox['numeroDocumento'];                
               
                if (global_prod_benefi[producto['COD_PRODUCTO']][programa['cod_programa']][llaveBenefi]["marcaAplica"] == 1) {
                    sum_tar = parseInt(sum_tar) + parseInt(global_prod_benefi[producto['COD_PRODUCTO']][programa['cod_programa']][llaveBenefi]["tarifa"]);
                    aux_contador++; 
                    nomProducto = producto['DES_PRODUCTO']+'-'+programa['des_programa'];                                     
                }               
                
          }
         aux_total_compra = aux_total_compra + sum_tar;
         if(aux_contador != 0){
	         objDatos = {"producto":nomProducto,"afiliados":aux_contador,"tarifa":sum_tar};
	         aux_array_data.push(objDatos);
         }         
                   
        }        
    }


    //$("input[name='amount']").val(aux_total_compra);
    
    $("#label_sum").text("$"+formatMiles(aux_total_compra));

    tabla = createTable('tablapago', columnas, aux_array_data);
    $('#contenedor_table_pago').html(tabla);
    aplicarDataTable('tablapago');
 }

 function realizarPago(){

           runLoading(true);

           var idModal = 'modalConfirmar';       
           var botonesModal = [{
                                "id": "cerrarMd",
                                "label": "Aceptar",
                                "class": "btn-primary"
                              }]; 
   
           $.ajax({    
                  url: "Gc_paso_4/getFormularioPago", 
                  type: "POST",  
                  dataType: "json",
                  data:{cod_afiliacion:global_datos_contratante['COD_AFILIACION']},//global_registro_basico[0]["cod_afiliacion"]},                                           
                  success:function(data){
                    runLoading(false);
                    console.log("data ",data);
                    if (data.codigo_recibo != -1) { 
                      $("#container_formulario").html(data.formulario);                   
                      $("#form_payu").submit();                                                          
                    }else{
                      crearModal(idModal,'Advertencia', 'Ocurrio un error al generar el n\u00famero de recibo', botonesModal, false, '', '',true);
                      $('#cerrarMd').click(function() {
                            $('#'+idModal).modal('toggle');                             
                      });
                    }                                                       
                  },                  
                  error: function(result) {
                      runLoading(false);                              
                      crearModal(idModal, 'Confirmarci\u00f3n', 'La operaci\u00f3n no se pudo completar por que ocurri\u00f3 un error en la base de datos', botonesModal, false, '', '');
                      $('#cerrarMd').click(function() {
                            $('#'+idModal).modal('toggle');                             
                      });
                  }

                 });

 }






