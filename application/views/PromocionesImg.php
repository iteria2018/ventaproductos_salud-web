
<?php
   $this->load->view('header');     
?>  
 
  <div class="main main-raised">
      <div class="container">
          <div class="container">
              <fieldset> 
              <legend> Parametrizar Imagenes </legend>
                  <br>
                  <div class="container">
                    <div class="row">
                      <div class="col-md-12">
                        <button id="agregar" name="agregar" class="btn btn-primary boton-vd" type="button">
                            <i class="fa fa-cart-plus" aria-hidden="true"></i> &nbsp; Agregar
                        </button>
                      </div>
                    </div>
                  </div>
                  <br>
                  <div id="contenedor_table">
                      <?php echo $tablaImagen;?>
                  </div>
                  <hr/>
              </fieldset>
          </div>
      </div>
  </div>    

<?php
  $this->load->view('footer');
?>
<script src="<?php echo site_url() ?>asset/public/user/js/promocionesImg.js"></script>