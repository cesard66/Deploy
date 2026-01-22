             CMD        PROMPT('RSTOBJ FTP')

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
                          DSPINPUT(*YES) PROMPT('Tipo de objetos')

             PARM       KWD(MBR) TYPE(*CHAR) LEN(6) RTNVAL(*NO) +
                          RSTD(*YES) DFT(*MATCH) VALUES(*MATCH *ALL +
                          *NEW *OLD) MIN(0) CHOICE('*MATCH, *ALL, +
                          *NEW, *OLD') PROMPT('Opción de miembro +
                          base datos')

             PARM       KWD(DIF) TYPE(*CHAR) LEN(5) RTNVAL(*NO) +
                          RSTD(*YES) DFT(*NONE) VALUES(*NONE *ALL) +
                          MIN(0) CHOICE('*NONE, *ALL') +
                          PROMPT('Permitir diferencias objetos')

             PARM       KWD(RST) TYPE(*CHAR) LEN(10) RTNVAL(*NO) +
                          RSTD(*NO) DFT(*SAVLIB) MIN(0) +
                          CHOICE('Nombre, *SAVLIB') +
                          PROMPT('Restaurar en biblioteca')

