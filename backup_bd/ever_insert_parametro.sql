INSERT INTO vdir_parametro (
    cod_parametro,
    des_parametro,
    valor_parametro,
    cod_estado
) VALUES (
    14,
    'Ruta donde se guardan los archivos en el servidor',
    './asset/public/fileUpload/',
    1
);

COMMIT;