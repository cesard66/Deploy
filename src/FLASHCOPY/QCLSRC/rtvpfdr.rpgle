      *****************************************************************
      * Programa: RTVPFDR
      * Funcion : Compara dos DSPFD si long de reg.son iguales
      * Hecho   : Ino
      *****************************************************************
     FQAFDPHY   IP   E             DISK

     D PHMXRLA         S                   Like(PHMXRL)
     D PHMXRLB         S                   Like(PHMXRL)
     D FstTime         S               N   Inz('1')
     D SndTime         S               N

     DMain             PR                  Extpgm('RTVPFDR')
     D Error                          1A
     DMain             PI
     D Error                          1A

      /Free
         If FstTime;
            PHMXRLA=PHMXRL;
            FstTime='0';
            SndTime='0';
         Endif;

         If SndTime;
            PHMXRLB=PHMXRL;

            Error='0';
            If PHMXRLA<>PHMXRLB;
               Error='1';
            Endif;
            *InLR='1';
         Endif;

         SndTime='1';

      /End-free
