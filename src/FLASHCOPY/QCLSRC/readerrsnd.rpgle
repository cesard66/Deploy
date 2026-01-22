      * PROGGRAMA: de Lectura de errores de envio via FTP
      * Programador: Edgar C. Elizeche (ECE) 22/07/05
      * Files
      *
     H DATEDIT(*YMD)
     FFTPENV    IF A F   92        DISK
     FQPRINT    O    F  132        PRINTER
      * Record en texto
     D SRCDS           DS                  INZ
     D  SRCSEQ                 1      6  0
     D  SRCDAT                 7     12  0
     D  SRCDTA                13     92
      * Parametros de entradas
     C     *ENTRY        PLIST
     C                   PARM                    ERROR             1
     C     *INLR         DOWEQ     *OFF
     C                   READ      FTPENV        SRCDS                    LR
     C                   MOVEL     SRCDTA        CERR              4
     C                   MOVE      CERR          BLANCO            1
     C                   MOVEL     CERR          CERR3             3
     C                   MOVEL     SRCDTA        DTA             132
     C                   TESTN                   CERR3                21
     C     *IN21         IFEQ      *ON
     C     BLANCO        ANDEQ     ' '
     C                   MOVEL     CERR3         ERR               3 0
     C     ERR           IFGT      400
     C                   MOVE      '1'           ERROR
     C                   EXCEPT    SALIDA
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     OQPRINT    E            SALIDA
     O                       DTA                132
