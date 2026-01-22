/* CPP: RUNCMDCLP                                                    */
             CMD        PROMPT('Ejecuta comando via FTP')

             PARM       KWD(USR) TYPE(*CHAR) LEN(10) MIN(1) +
                          CASE(*MIXED) CHOICE('Nombre') +
                          PROMPT('Perfil de usuario')

             PARM       KWD(PWD) TYPE(*CHAR) LEN(10) MIN(1) +
                          CASE(*MIXED) DSPINPUT(*NO) +
                          CHOICE('Nombre, *USRPRF, *NONE') +
                          PROMPT('Contraseña de usuario')

             PARM       KWD(CMD) TYPE(*CHAR) LEN(2000) MIN(1) +
                          PROMPT('Comando a ejecutar')

             PARM       KWD(IP) TYPE(*CHAR) LEN(32) MIN(1) +
                          PROMPT('IP destino')
