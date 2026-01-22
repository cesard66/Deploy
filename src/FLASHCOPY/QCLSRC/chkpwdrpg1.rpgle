      * PROGGRAMA: Verifica el usuario y pwd via FTP
      * Programador: Benjamin Diaz  27/11/2023
      * Files
      *
     H DATEDIT(*YMD)
     FFTPENV    O  A F  300        DISK
      * Record en texto
     D SRCDS           DS                  INZ
     D  SRCSEQ                 1      6  0
     D  SRCDAT                 7     12  0
     D  SRCDTA                13    300
      * Nombres de Constantes
     D BI              C                   CONST('BIN')
     D SENDPAsv        C                   CONST('SENDPAsv 0')
     D ARCH            C                   CONST('PUT INSTFLASAH/')
     D ARCH1           C                   CONST('INSTFLASAH/')
     D CIERRA          C                   CONST('CLOSE')
     D SALE            C                   CONST('QUIT')
     D SAVFE           S             10A
     D SAVFR           S             10A
      *---------------------------------------------------------------
      * Parametros de entradas
     C     *ENTRY        PLIST
     C                   PARM                    USU              10
     C                   PARM                    SENA             10
     C                   PARM                    ENVI              4
     C                   PARM                    RECI              4
     C                   PARM                    JOBNBR            6
      * Conectarse: usuario y contrasena
     C                   MOVEL     USU           SRCDTA
     C                   CAT       SENA:1        SRCDTA
     C                   EXSR      WRTSRC
      * Formato de archivo a envia (SENDPAsv=0)
     C                   MOVEL     BI            SRCDTA
     C                   EXSR      WRTSRC
      * Archivo a recibir en sistema remoto tipo *savf en QGPL
     C                   EVAL      SAVFE=ENVI+JOBNBR
     C                   EVAL      SAVFR=RECI+JOBNBR
     C                   EVAL      SRCDTA=ARCH+SAVFE
     C                   CAT       ARCH1:1       SRCDTA
     C                   EVAL      SRCDTA=%TRIM(SRCDTA)+SAVFR
     C                   EVAL      SRCDTA=%TRIM(SRCDTA)
     C                   EXSR      WRTSRC
      * salir
     C                   MOVEL     CIERRA        SRCDTA
     C                   EXSR      WRTSRC
     C                   MOVEL     SALE          SRCDTA
     C                   EXSR      WRTSRC
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      * WRTSRC   ESCRITURA DE LA FUENTE PARA TCP
     C     WRTSRC        BEGSR
     C                   ADD       1             SRCSEQ
     C                   Z-ADD     0             SRCDAT
     C                   EXCEPT    SRCADD
     C                   MOVE      *BLANKS       SRCDTA
     C                   ENDSR
      * Texto output
     OFTPENV    EADD         SRCADD
     O                       SRCDS              300
