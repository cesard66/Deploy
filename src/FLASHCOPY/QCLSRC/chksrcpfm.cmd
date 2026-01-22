/* CPP:CHKSRCPFMC                                                           */

             CMD        PROMPT('Verifica exist.miembro remoto ')

             PARM       KWD(USR) TYPE(*CHAR) LEN(10) MIN(1) +
                          CASE(*MIXED) CHOICE('Nombre') +
                          PROMPT('Perfil de usuario')

             PARM       KWD(PWD) TYPE(*CHAR) LEN(10) MIN(1) +
                          CASE(*MIXED) DSPINPUT(*NO) +
                          PROMPT('Contrase¦a de usuario')

             PARM       KWD(LIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Biblioteca remota')

             PARM       KWD(FILEO) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Archivo fuente remoto')

             PARM       KWD(MBR) TYPE(*CHAR) LEN(10) RTNVAL(*NO) +
                          MIN(1) PROMPT('Miembro fuente remoto')

             PARM       KWD(IP) TYPE(*CHAR) LEN(32) MIN(1) +
                          PROMPT('IP remoto')

             PARM       KWD(ERROR) TYPE(*CHAR) LEN(1) RTNVAL(*YES) +
                          MIN(1) PROMPT('Error')
