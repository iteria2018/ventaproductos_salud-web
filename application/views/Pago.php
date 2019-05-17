
<?php
   $this->load->view('header');     
?> 
 
 
  <div class="main main-raised">
     <div class="container">
     	 <label>Total</label>
         <input type="text" name="" class="form-control" value="60.720">

		 <form method="post" id="form_payu" action="https://sandbox.checkout.payulatam.com/ppp-web-gateway-payu/">
		  <input name="merchantId"    type="hidden"  value="508029"   >
		  <input name="accountId"     type="hidden"  value="512321" >
		  <input name="description"   type="hidden"  value="Prueba pago"  >
		  <input name="referenceCode" type="hidden"  value="prueba001" >
		  <input name="amount"        type="hidden"  value="60720"   >
		  <input name="tax"           type="hidden"  value="0"  >
		  <input name="taxReturnBase" type="hidden"  value="0" >
		  <input name="currency"      type="hidden"  value="COP" >
		  <input name="signature"     type="hidden"  value="827cd920973e6bfbd42cfa96f5faf806"  >
		  <input name="test"          type="hidden"  value="1" >
		  <input name="buyerEmail"    type="hidden"  value="hidalgoever@live.com" >
		  <input name="buyerFullName" type="hidden"  value="Ever Hidalgo">		  
		  <input name="responseUrl"    type="hidden"  value="http://localhost/ventaproductos_salud-web/Pago/responseUrl" >
		  <input name="confirmationUrl"    type="hidden"  value="http://localhost/ventaproductos_salud-web/Pago/confirPago" >		  
		</form>
     </div>
  </div>    

<?php
  $this->load->view('footer');
?>
<script src="<?php echo site_url() ?>asset/public/user/js/encuesta_sarlaf.js"></script>