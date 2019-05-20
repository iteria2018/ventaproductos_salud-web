<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
  <ol class="carousel-indicators">  
      <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>   
  </ol>
  <div class="carousel-inner">
    <?php if($tipoCobertura == 1): ?>
      <div class="carousel-item active">
        <img class="d-block w-100" src="<?php echo $coberturas[0]['COBERTURA_INICIAL']; ?>" alt="<?php echo $coberturas[0]['DES_PROGRAMA']; ?>" style="height:400px;!important">
      </div>
    <?php else: ?>  
      <div class="carousel-item active">
        <img class="d-block w-100" src="<?php echo $coberturas[0]['COBERTURA_FINAL']; ?>" alt="<?php echo $coberturas[0]['DES_PROGRAMA']; ?>" style="height:400px;!important">
      </div>
    <?php endif; ?>
  </div>
  <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
    <span class="carousel-control-next-icon" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>