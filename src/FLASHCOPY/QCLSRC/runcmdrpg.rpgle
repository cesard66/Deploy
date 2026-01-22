      * PROGRAMA: de Ejecucion de comandos via FTP
      * Programador: Edgar Elizeche
      * Files
      *
     H DATEDIT(*YMD)
     FFTPENV    O  A F 2000        DISK
      * Record en texto
     D SRCDS           DS                  INZ
     D  SRCSEQ                 1      6  0
     D  SRCDAT                 7     12  0
     D  SRCDTA                13   2000
      * Nombres de Constantes
     D SENDPAsv        C                   CONST('SENDPAsv 0')
     D QUOTE           C                   CONST('QUOTE RCMD')
     D CIERRA          C                   CONST('CLOSE')
     D SALE            C                   CONST('QUIT')
      * Parametros de entradas
     C     *ENTRY        PLIST
     C                   PARM                    USU              10
     C                   PARM                    SENA             10
     C                   PARM                    CMD            2000
      * Conectarse: usuario y contrasena
     C                   MOVEL     USU           SRCDTA
     C                   CAT       SENA:1        SRCDTA
     C                   EXSR      WRTSRC
      * SndPsv 0
     C                   MOVEL     Sendpasv      SRCDTA
     C                   EXSR      WRTSRC
      * Ejecucion de comando
     C                   MOVEL     QUOTE         SRCDTA
     C                   CAT       CMD:1         SRCDTA
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
     O                       SRCDS             2000
