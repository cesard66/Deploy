        ctl-opt dftactgrp(*no);

        dcl-pr Main extpgm('VALIDANUM') ;
          @monto    char(10);
        end-pr ;

        dcl-pi Main ;
          @monto    char(10);
        end-pi ;

        dcl-s  @monton   zoned(10:0);

        monitor;
        @monton = %DEC(@monto:10:0);
        on-error;
           @monton = 0;
        endmon;
        dsply ('recibido' + @monto);
        dsply ('convertido' + %char(@monton));
        dsply ('fin');
        *inlr=*on;
