     H DATEDIT(*YMD)
      *---------------------------------------------------------------------
      * Programa: Graba sentencias FTP p/traer un SAVF desde un sist.remoto
      * Autor   : Rufino Caceres Gamarra
      * Modif.  : Edgar Elizeche 06/07/05
      * Modif.  : Ino Gomez      31/10/11
      *           Se agrego la sentencia SENDPAsv 0

      * 1-BIN
      * 2-SENDPAsv 0
      * 3-GET PPLIB003/SAVF PPLIB003/SAVF.SAVF (REPLACE
      * 4-CLOSE
      * 5-QUIT
      *---------------------------------------------------------------------
     FINPUT     O  A F   92        DISK
      *---------------------------------------------------------------------
     D SAVF            S             10A
     D SRCDS           DS                  INZ
     D  SRCSEQ                 1      6  0
     D  SRCDAT                 7     12  0
     D  SRCDTA                13     92

     D BI              C                   CONST('BIN')
     D SENDPAsv        C                   CONST('SENDPAsv 0')
     D ARCH            C                   CONST('GET PPLIB003/')
     D ARCH1           C                   CONST('PPLIB003/')
     D CIERRA          C                   CONST('CLOSE')
     D SALE            C                   CONST('QUIT')
      *---------------------------------------------------------------------
     C     *ENTRY        PLIST
     C                   PARM                    USU              10
     C                   PARM                    SENA             10
     C                   PARM                    PREF              4
     C                   PARM                    JOBNBR            6

      * Conectarse: usuario y contrasena

     C                   MOVEL     USU           SRCDTA
     C                   CAT       SENA:1        SRCDTA
     C                   EXSR      WRTSRC

      * Formato de archivo a envia (BI=Binario)

     C                   MOVEL     BI            SRCDTA
     C                   EXSR      WRTSRC

      * Formato de archivo a envia (SENDPAsv=0)

     C                   MOVEL     SENDPAsv      SRCDTA
     C                   EXSR      WRTSRC

      * archivo a recibir en sistema remoto tipo *savf en qgpl

     C                   Eval      SAVF=PREF+JOBNBR
     C                   Eval      SRCDTA=ARCH+SAVF
     C                   CAT       ARCH1:1       SRCDTA
     c                   Eval      SRCDTA=%TRIM(SRCDTA)+SAVF+'.'+SAVF
     C                   Eval      SRCDTA=%TRIM(SRCDTA)+' (REPLACE'
     C                   EXSR      WRTSRC
     C                   MOVEL     CIERRA        SRCDTA
     C                   EXSR      WRTSRC
     C                   MOVEL     SALE          SRCDTA
     C                   EXSR      WRTSRC

     C                   MOVE      *ON           *INLR
     C                   RETURN
      *---------------------------------------------------------------------
      * WRTSRC   ESCRITURA DE LA FUENTE PARA TCP
      *---------------------------------------------------------------------
     C     WRTSRC        BEGSR

     C                   ADD       1             SRCSEQ
     C                   Z-ADD     0             SRCDAT
     C                   EXCEPT    SRCADD
     C                   MOVE      *BLANKS       SRCDTA

     C                   ENDSR
      *---------------------------------------------------------------------
     OINPUT     EADD         SRCADD
     O                       SRCDS               92
