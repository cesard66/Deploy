/* CPP:SNDRSTCMDC                                                            */
             CMD        PROMPT('ENVIAR Y RESTAURAR OBJETOS FTP')

             PARM       KWD(USR) TYPE(*CHAR) LEN(10) MIN(1) +
                          CASE(*MIXED) CHOICE('Nombre') +
                          PROMPT('Perfil de usuario')

             PARM       KWD(PWD) TYPE(*CHAR) LEN(10) MIN(1) +
                          CASE(*MIXED) DSPINPUT(*NO) +
                          CHOICE('Nombre, *USRPRF, *NONE') +
                          PROMPT('Contrasena de usuario')

             PARM       KWD(LIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          CHOICE('Nombre, generico*') +
                          PROMPT('Biblioteca')

             PARM       KWD(OBJ) TYPE(*CHAR) LEN(10) MIN(1) +
                          CHOICE('Nombre, generico*, *ALL') +
                          PROMPT('Objeto')

             PARM       KWD(TIP) TYPE(*CHAR) LEN(7) RTNVAL(*NO) +
                          RSTD(*YES) DFT(*ALL) VALUES(*ALL *ALRTBL +
                          *BNDDIR *CHTFMT *CLD *CLS *CMD *CRG *CRQD +
                          *CSI *CSPMAP *CSPTBL *DTAARA *DTAQ *EDTD +
                          *EXITRG *FCT *FILE *FNTRSC *FNTTBL +
                          *FORMDF *FTR *GSS *JOBD *JOBQ *JOBSCD +
                          *JRN *JRNRCV *LOCALE *MEDDFN *MENU +
                          *MGTCOL *MODULE *MSGF *MSGQ *M36 *M36CFG +
                          *NODGRP *NODL *OUTQ *OVL *PAGDFN *PAGSEG +
                          *PDG *PGM *PNLGRP *PRDAVL *PRDDFN *PRDLOD +
                          *PSFCFG *QMFORM *QMQRY *QRYDFN *RCT *SBSD +
                          *SCHIDX *SPADCT *SQLPKG *SQLUDT *SRVPGM +
                          *SSND *SVRSTG *S36 *TBL *USRIDX *USRQ +
                          *USRSPC *VLDL *WSCST) MIN(0) CASE(*MIXED) +
                          DSPINPUT(*YES) PROMPT('Tipo de objetos')

             PARM       KWD(REL) TYPE(*CHAR) LEN(8) RTNVAL(*NO) +
                          RSTD(*YES) DFT(V7R1M0) VALUES(*CURRENT +
                          *PRV V5R1M0 V5R2M0 V5R3M0 V6R1M0 V7R1M0) +
                          MIN(0) CASE(*MIXED) DSPINPUT(*YES) +
                          PROMPT('Release destino')

             PARM       KWD(SAV) TYPE(*CHAR) LEN(8) RTNVAL(*NO) +
                          RSTD(*YES) DFT(*LIB) VALUES(*NO *LIB +
                          *SYNCLIB *SYSDFN) MIN(0) CASE(*MIXED) +
                          DSPINPUT(*YES) PROMPT('Salvar activo')

             PARM       KWD(MBR) TYPE(*CHAR) LEN(6) RTNVAL(*NO) +
                          RSTD(*YES) DFT(*ALL) VALUES(*MATCH *ALL +
                          *NEW *OLD) MIN(0) CHOICE('*MATCH, *ALL, +
                          *NEW, *OLD') PROMPT('Opcion de miembro +
                          base datos')

             PARM       KWD(DIF) TYPE(*CHAR) LEN(5) RTNVAL(*NO) +
                          RSTD(*YES) DFT(*ALL) VALUES(*NONE *ALL) +
                          MIN(0) CHOICE('*NONE, *ALL') +
                          PROMPT('Permitir diferencias objetos')

             PARM       KWD(RST) TYPE(*CHAR) LEN(10) RTNVAL(*NO) +
                          RSTD(*NO) DFT(*SAVLIB) MIN(0) +
                          CHOICE('Nombre, *SAVLIB') +
                          PROMPT('Restaurar en biblioteca')

             PARM       KWD(IP) TYPE(*CHAR) LEN(32) MIN(1) +
                          PROMPT('IP destino')

/*           PARM       KWD(ERROR) TYPE(*CHAR) LEN(1) RTNVAL(*NO) +
                          MIN(0) PROMPT('Error') */
