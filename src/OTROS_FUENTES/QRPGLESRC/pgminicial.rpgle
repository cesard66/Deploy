        ctl-opt dftactgrp(*no);

        dcl-ds datos qualified;
           precio packed(7:2);
           cantidad zoned(5:0);
           descripcion char(20);
        end-ds;

        datos.precio     = 999.99;
        datos.cantidad   = 50;
        datos.descripcion= 'Producto A';

        dsply ('inicializar de a uno');
        dsply (datos.precio);
        dsply (datos.cantidad);
        dsply (datos.descripcion);
        clear datos;
        dsply ('inicializar todos');
        dsply (datos.precio);
        dsply (datos.cantidad);
        dsply (datos.descripcion);

        *inlr=*on;
