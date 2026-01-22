/*AAA*/
     CMD        PROMPT('Envia objetos via FTP')

     PARM       KWD(USR) TYPE(*CHAR) LEN(10) MIN(1) +
                          CASE(*MIXED) CHOICE('Nombre') +
                          PROMPT('Perfil de usuario')

     PARM       KWD(PWD) TYPE(*CHAR) LEN(10) MIN(1) +
                          CASE(*MIXED) DSPINPUT(*NO) +
                          CHOICE('Nombre, *USRPRF, *NONE') +
                          PROMPT('Contraseña de usuario')

     PARM       KWD(LIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          CHOICE('Nombre, genérico*') +
                          PROMPT('Biblioteca')
             PARM       KWD(OBJ) TYPE(*CHAR) LEN(10) MIN(1) +
                          CHOICE('Nombre, genérico*, *ALL') +
                          PROMPT('Objeto')
             PARM       KWD(TIP) TYPE(*CHAR) LEN(10) RTNVAL(*NO) +
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
                          DSPINPUT(*YES) PROMPT('Tipo de Objetos')
             PARM       KWD(REL) TYPE(*CHAR) LEN(10) RTNVAL(*NO) +
                          RSTD(*YES) DFT(*CURRENT) VALUES(*CURRENT +
                          *PRV V5R1M0 V5R2M0 V5R3M0 V6R1M0 V7R1M0) +
                          MIN(0) CASE(*MIXED) DSPINPUT(*YES) +
                          PROMPT('Release destino')

             PARM       KWD(SAV) TYPE(*CHAR) LEN(10) RTNVAL(*NO) +
                          RSTD(*YES) DFT(*NO) VALUES(*NO *LIB +
                          *SYNCLIB *SYSDFN) MIN(0) CASE(*MIXED) +
                          DSPINPUT(*YES) PROMPT('Salvar activo')

             PARM       KWD(IP) TYPE(*CHAR) LEN(32) MIN(1) +
                          PROMPT('IP destino')
