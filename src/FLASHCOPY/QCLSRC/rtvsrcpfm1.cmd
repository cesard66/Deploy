/* CPP:RTVSRCPFMD                                                             */
             CMD        PROMPT('Trae Miemb.Fuente de maq.remot')

             PARM       KWD(USR) TYPE(*CHAR) LEN(10) MIN(1) +
                          CASE(*MIXED) CHOICE('Nombre') +
                          PROMPT('Perfil de usuario')

             PARM       KWD(PWD) TYPE(*CHAR) LEN(10) MIN(1) +
                          CASE(*MIXED) DSPINPUT(*NO) +
                          PROMPT('Contrase¦a de usuario')

             PARM       KWD(LIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Biblioteca')

             PARM       KWD(FILEO) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Archivo fuente origen')

             PARM       KWD(MBR) TYPE(*CHAR) LEN(10) RTNVAL(*NO) +
                          MIN(1) PROMPT('Miembro fuente origen')

             PARM       KWD(REL) TYPE(*CHAR) LEN(8) RTNVAL(*NO) +
                          RSTD(*YES) DFT(V7R1M0) VALUES(*CURRENT +
                          *PRV V5R4M0 V6R1M0 V7R1M0) MIN(0) +
                          CASE(*MIXED) DSPINPUT(*YES) +
                          PROMPT('Release destino')

             PARM       KWD(SAV) TYPE(*CHAR) LEN(8) RTNVAL(*NO) +
                          RSTD(*YES) DFT(*LIB) VALUES(*NO *LIB) +
                          MIN(0) CASE(*MIXED)                +
                          PROMPT('Salvar activo')

             PARM       KWD(DIF) TYPE(*CHAR) LEN(5) RTNVAL(*NO) +
                          RSTD(*YES) DFT(*ALL) VALUES(*NONE *ALL) +
                          MIN(0) CHOICE('*NONE, *ALL') +
                          PROMPT('Permitir diferencias objetos')

             PARM       KWD(LIBD) TYPE(*CHAR) LEN(10) RTNVAL(*NO) +
                          RSTD(*NO) DFT(*LIBO) MIN(0) +
                          CHOICE('Nombre, *LIBO') +
                          PROMPT('Libreria destino')

             PARM       KWD(FILED) TYPE(*CHAR) LEN(10) +
                          DFT(*FILEO) MIN(0) CHOICE('Nombre, *FILEO') +
                          PROMPT('Archivo fuente destino')

             PARM       KWD(IP) TYPE(*CHAR) LEN(32) MIN(1) +
                          PROMPT('IP remoto')

             PARM       KWD(ERROR) TYPE(*CHAR) LEN(1) RTNVAL(*NO) +
                          MIN(1) PROMPT('Error')
