             CMD        PROMPT('RECUPERA CONFIGURACIÓN')

             /* CONTEXTO CONFIGURACION */
             PARM       KWD(CONTEXT) TYPE(*CHAR) LEN(20) +
                          PROMPT('CONTEXTO')

             /* CLAVE CONFIGURACION */
             PARM       KWD(KEY) TYPE(*CHAR) LEN(50) PROMPT('KEY')

             /* VALOR CONFIGURACION */
             PARM       KWD(VALUE) TYPE(*CHAR) LEN(200) PROMPT('VALOR')
