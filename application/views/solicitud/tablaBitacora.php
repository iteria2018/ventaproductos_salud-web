<?php if (!empty($bitacora)): ?>
 <table width="100%" class="table table-striped table-bordered table-hover" >
    <thead>
        <tr>
            <th>Fecha</th>
            <th>Nombre de usuario</th>
            <th>Acción</th>
        </tr>
    </thead>	
    <tbody>
        <?php for ($i = 0; $i < count($bitacora); $i++): ?>
            <tr>
                <td><?php echo $bitacora[$i]['FECHA_BITACORA']; ?></td>
                <td><?php echo $bitacora[$i]['NOMBRE_PERSONA']; ?></td>
                <td><?php echo $bitacora[$i]['OBSERVACION']; ?></td>               
            </tr>
        <?php endfor;?>		
    </tbody>
</table>
<?php else: ?>
    <div class="alert alert-dismissible fade show" role="alert" style="color: #004085;background-color: #cce5ff;border-color: #b8daff;">
        No hay trazabilidad registrada de las gestiones realizadas a esta solicitud!     
    </div>
<?php endif; ?>