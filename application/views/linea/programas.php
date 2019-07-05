<option value="">Seleccione producto</option>
<?php for ($i = 0; $i < count($programas); $i++): ?>
    <option value="<?php echo $programas[$i]['COD_PROGRAMA']; ?>">
        <?php echo $programas[$i]['DES_PROGRAMA']; ?>
    </option>
<?php endfor;?>	