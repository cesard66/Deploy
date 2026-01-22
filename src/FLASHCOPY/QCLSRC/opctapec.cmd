CMD        PROMPT('ELIGE OPCIÓN DE MENU')

             PARM       KWD(OPC) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          VALUES(1 2) MIN(1) CASE(*MIXED) +
                          CHOICE('1=NATIVO 2=CON BRMS') +
                          KEYPARM(*NO) PROMPT('OPCIÓN DE MENU')
