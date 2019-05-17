<style>

#encabezado {padding:5px 0; border-bottom: 1px solid; width:100%;margin:auto;}
#encabezado .fila #col_1 #col_3 {width: 15%; text-align: left;}
#encabezado .fila #col_2 {text-align:left; width: 65%}

#encabezado .fila #col_2 #span1{font-size: 15px;}
#encabezado .fila #col_2 #span2{font-size: 15px; color: #ccc;}

#footer {padding-bottom:5px 0;border-top: 1px solid; width:100%; margin:auto;}
#footer .fila td {text-align:center; width:100%;}
#footer .fila td span {font-size: 10px; color: #000;}

#central, #central_datos, #tablaBody, #tablaCompania {width:100%; margin: 20px 0px 0px 0px;} 

#central tr|{
	border: 10; 
}

#central td|{
	border: 0; 
}

.styleLable{
	font-size: 30px;
}

#table_container_1{
  margin-top:200px; width:100%;
  margin-left: -40px;

}
.style_td{
	text-align: right;
}

td, th{
  padding: 3px;
}

</style>

<page backtop="45mm" backbottom="10mm" backleft="0mm" backright="5mm">

	<page_header>
	    <table id="encabezado">
            <tr class="fila">
                <td id="col_2" style="width:90%;height:auto;">
                    <table id="tablaCompania">
			            <tr style="height:10px">	     		
				     		<td style="width:50%;height:auto;"><?php echo $dataEmpresa[0]->nombre_empresa; ?></td>	     		
				     	</tr>
				     	<tr style="height:10px">	     		
				     		<td style="width:50%;height:auto;">NIT: <?php echo $dataEmpresa[0]->nit; ?> </td>	     		
				     	</tr>
				     	<tr style="height:10px">	     		
				     		<td style="width:50%;height:auto;"><?php echo $dataEmpresa[0]->slogan_empresa; ?></td>	     		
				     	</tr>
				     	 <tr style="height:10px">	     		
				     		<td style="width:50%;height:auto;"><?php echo $dataEmpresa[0]->direccion_empresa; ?></td>
				     	</tr>
				     	 <tr style="height:10px">	     		
				     		<td style="width:50%;height:auto;"><?php echo $dataEmpresa[0]->telefonos.' --- '.$dataEmpresa[0]->celulares; ?></td>
				     	</tr>
				     	<tr style="height:10px">	     		
				     		<td style="width:50%;height:auto;"><?php echo $dataEmpresa[0]->email_empresa; ?></td>
				     	</tr>	     	          
			            <tr style="height:5px">	     		
				     		<td style="height: 5px;"></td>
				     	</tr>
			        </table>                 
                </td>
                <td id="col_1" style="width:10%;height:auto; vertical-align: super;">                	
                    <img src="./asset/public/images/favicon.png" width="80" height="80">
                </td>
            </tr>
         </table>	   
	</page_header>

	<div id="table_container">
    	<?php echo $dataPedido; ?>
    </div> 

	<page_footer>	    
	    <table id="footer">
	        <tr class="fila">
	            <td>
	                <span>Orden de compra</span>
	            </td>
	        </tr>
	    </table>	   
	</page_footer>
    
</page>

