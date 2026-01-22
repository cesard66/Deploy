             CMD        PROMPT('GRABA LOGS EN UN ARCHIVO')

             PARM       KWD(LOG) TYPE(*CHAR) LEN(100) MIN(1) +
                          EXPR(*YES) CASE(*MIXED) CHOICE('LOG') +
                          PROMPT('LOG A GRABAR')
