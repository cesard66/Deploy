/* CPP: CHKRMTPWDC                                                           */
             CMD        PROMPT('Verif.Usuario/password remoto')

             PARM       KWD(USR) TYPE(*CHAR) LEN(10) MIN(1) +
                          CASE(*MIXED) CHOICE('Nombre') +
                          PROMPT('Perfil de usuario remoto')

             PARM       KWD(PWD) TYPE(*CHAR) LEN(10) MIN(1) +
                          CASE(*MIXED) DSPINPUT(*NO) +
                          CHOICE('Nombre, *USRPRF, *NONE') +
                          PROMPT('Contrase¦a de usuario remoto')

             PARM       KWD(IP) TYPE(*CHAR) LEN(32) MIN(1) +
                          PROMPT('IP remoto')

             PARM       KWD(ERROR) TYPE(*CHAR) LEN(1) RTNVAL(*YES) +
                          PROMPT('Error')
