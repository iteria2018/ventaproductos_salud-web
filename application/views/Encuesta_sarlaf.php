
<?php
   $this->load->view('header');     
?> 
 
 
  <div class="main main-raised">
     <div class="container">
        <input type="button" name="btn_consultar" id="btn_consultar" value="Consultar" class="btn btn-primary">
        <input type="button" name="btn_encuesta" id="btn_encuesta" value="Encuesta" class="btn btn-primary">
     </div>
  </div>    

<?php
  $this->load->view('footer');
?>
<script src="<?php echo site_url() ?>asset/public/user/js/encuesta_sarlaf.js"></script>