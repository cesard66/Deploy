     **-----------------------------------------------------------------------**
     **
     **  Program . . : LOGTABLER
     **  Description : Registra logs de proceso flashcopy
     **  Author  . . :
     **
     **
     **  Parameters:
     **    LOG    . . :  INPUT: - Descripcion del paso realizado
     **                         - variable de tipo char longitud 100        ed
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt: *NoDebugIo )
     **-- File specifications:  ----------------------------------------------**
     FLOGTABLE  O    E             Disk    Block(*NO) RENAME(LOGTABLE:LOGREC)
     **-- Journal exit program interface:  ------------)----------------------**
     DLOG              s            100a
     DMaxSeq           s             10  0
     DRec2             s              2
     **
     D
     D
     **-- Parameters:  -------------------------------------------------------**
     **
     C     *Entry        Plist
     C                   Parm                    LOG
     **
     **-- Mainline:  ---------------------------------------------------------**

     C*                  ExSr      SetSeqTbl
     C                   ExSr      InzLogRcd

     C                   Return

     **-- Set Sequence for the table ---------------------------------------
     C*    SetSeqTbl     BegSr
     C*    *HIVAL        SETGT     REC2                               64
     C*                  Read      LOGREC
     C*                  EVAL      MaxSeq = %DEC(LOGCOD:10:0) + 1
     C*                  IF        %EOF(LOGREC)
     C*                  EndIf
     C*                  EndSr
     **-- Initialize log record:  --------------------------------------------**
     C     InzLogRcd     BegSr

     C*                  Eval      LOGCOD     = %CHAR(MaxSeq)
     C                   Eval      LOGDESC    = %trim(LOG)
     C                   Eval      LOGDATE    = %TIMESTAMP()
     C
     C                   Write     LOGREC
     C
     C                   EndSr
