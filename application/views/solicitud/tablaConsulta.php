<?php if (!empty($solicitudes)): ?>
<table width="100%" class="table table-striped table-bordered table-hover" id="solicitudesConsulta" >
    <thead>
        <tr>
            <th>No Solicitud</th>
            <th>Contratante</th>
            <th>Fecha radicaci&oacute;n</th>
            <th>Plan</th>
            <th>Estado</th>
            <th>Fecha gesti&oacute;n</th>
            <th>Realizada por</th>
            <th>Tomada por</th>
            <th>Ver</th>
        </tr>
    </thead>	
    <tbody>
        <?php for ($i = 0; $i < count($solicitudes); $i++): ?>
            <tr>
                <td><?php echo $solicitudes[$i]['COD_AFILIACION']; ?></td>
                <td><?php echo $solicitudes[$i]['NOMBRE_1'].' '.$solicitudes[$i]['APELLIDO_1']; ?></td>
                <td><?php echo $solicitudes[$i]['FECHA_RADICACION']; ?></td>
                <td><?php echo $solicitudes[$i]['DES_PLAN']; ?></td>
                <td><?php echo $solicitudes[$i]['DES_ESTADO']; ?></td>
                <td><?php echo $solicitudes[$i]['FECHA_GESTION']; ?></td>
                <td><?php echo $solicitudes[$i]['USUARIO_GESTION']; ?></td>
                <td><?php echo $solicitudes[$i]['USUARIO_TOMA']; ?></td>
                <td style="text-align:center">
                    <?php if ($solicitudes[$i]['COD_ESTADO'] == 7): ?>
                        <i title="Sin gestión" class="text-danger fa fa-check-circle validado" aria-hidden="true" style="cursor:pointer;" codSolicitud="<?php echo $solicitudes[$i]['COD_AFILIACION']; ?>"></i>
                    <?php elseif ($solicitudes[$i]['COD_ESTADO'] == 4): ?> 
                        <i title="Pendiente por gestión" class="validado text-warning fa fa-check-circle" aria-hidden="true" style="cursor:pointer;" codSolicitud="<?php echo $solicitudes[$i]['COD_AFILIACION']; ?>"></i>
                    <?php elseif ($solicitudes[$i]['COD_ESTADO'] == 5): ?> 
                        <i title="En gestión" class="validado text-primary fa fa-check-circle" aria-hidden="true" style="cursor:pointer;" codSolicitud="<?php echo $solicitudes[$i]['COD_AFILIACION']; ?>"></i>
                    <?php elseif ($solicitudes[$i]['COD_ESTADO'] == 6): ?>  
                        <i title="Validado" class="validado text-success fa fa-check-circle" aria-hidden="true" style="cursor:pointer;" codSolicitud="<?php echo $solicitudes[$i]['COD_AFILIACION']; ?>"></i>
                    <?php endif; ?>
                </td>
            </tr>
        <?php endfor;?>		
    </tbody>
</table>
<?php else: ?> 
    <br><br><br><br>
    <div class="alert alert-dismissible fade show" role="alert" style="color: #856404;background-color: #fff3cd;border-color: #ffeeba;">
        No se encontraron solicitudes. <strong>Intente con un filtro de búsqueda diferente!</strong>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true" style="color: #856404;">&times;</span>
        </button>
    </div>      
<?php endif; ?>