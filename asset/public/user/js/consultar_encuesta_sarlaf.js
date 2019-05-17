$(document).on("ready",pintarEncuesta);


function pintarEncuesta(){
	
		$("#form_div").find("input[type='text'],select").each(function(){
			
			   var valor_respuesta = "";			   	  
			   valor_respuesta = $(this).closest(".div_container_respuesta").attr("data-val_respuesta");
			   $(this).val(valor_respuesta);
			   $(this).attr("disabled","disabled");		   			    
		                      		    
		  });
}