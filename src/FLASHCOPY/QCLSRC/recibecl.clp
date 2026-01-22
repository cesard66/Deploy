    PGM        PARM(&LIB &OBJ)
          DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
          DCL        VAR(&OBJ) TYPE(*CHAR) LEN(10)
          MONMSG     MSGID(CPF2105 CPF3773)
          RSTOBJ     OBJ(&OBJ) SAVLIB(&LIB) DEV(*SAVF) +
                          SAVF(PPLIB/RECIBEDE)
          CLRSAVF    FILE(PPLIB/RECIBEDE)
          SNDPGMMSG  MSG('BIBLIOTECA RECIBIDA')

    ENDPGM
