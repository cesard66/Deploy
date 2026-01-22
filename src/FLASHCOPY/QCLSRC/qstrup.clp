/********************************************************************/
/*                                                                  */
/* 5770SS1 V7R4M0 190621     Salida RTVCLSRC     31/01/24 07:13:10  */
/*                                                                  */
/* Nombre de programa . . . . . . . . . . . :   QSTRUP            PN*/
/* Nombre de biblioteca . . . . . . . . . . :   QSYS              PL*/
/* Archivo de origen original . . . . . . . :   S000026668        SN*/
/* Nombre de biblioteca . . . . . . . . . . :   $BLDSS1           SL*/
/* Miembro de origen original . . . . . . . :   S000026668        SM*/
/* Cambio de archivo fuente                                         */
/*   fecha/hora . . . . . . . . . . . . . . :   17/02/19 09:42:55 SC*/
/* Opción de parche . . . . . . . . . . . . :   *NOPATCH          PO*/
/* Perfil de usuario  . . . . . . . . . . . :   *USER             UP*/
/* Texto  . . :                                                   TX*/
/* Propietario  . . . . . . . . . . . . . . :   QSYS              OW*/
/* Distintivo de mod de usuario . . . . . . :   *NO               UM*/
/* Recuperar fuente incluido  . . . . . . . :   *YES              RI*/
/*                                                                ED*/
/********************************************************************/
     PGM
     DCL VAR(&STRWTRS) TYPE(*CHAR) LEN(1)
     DCL VAR(&CTLSBSD) TYPE(*CHAR) LEN(20)
     DCL VAR(&CPYR) TYPE(*CHAR) LEN(90) VALUE('5770-SS1 (C) COPYRIGHT-
 IBM CORP 1980, 2018. LICENSED MATERIAL - PROGRAM PROPERTY OF IBM')
     QSYS/STRSBS SBSD(QSERVER)              /*-----*/
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QUSRWRK)
     MONMSG MSGID(CPF0000)
     QSYS/RLSJOBQ JOBQ(QGPL/QS36MRT)
     MONMSG MSGID(CPF0000)
     QSYS/RLSJOBQ JOBQ(QGPL/QS36EVOKE)
     MONMSG MSGID(CPF0000)
     QSYS/STRCLNUP
     MONMSG MSGID(CPF0000)
     QSYS/RTVSYSVAL SYSVAL(QCTLSBSD) RTNVAR(&CTLSBSD)
     IF COND((&CTLSBSD *NE 'QCTL      QSYS      ') *AND (&CTLSBSD *NE-
 'QCTL      QGPL      ')) THEN(GOTO CMDLBL(DONE))
     QSYS/STRSBS SBSD(QINTER)               /*-----*/
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QBATCH)               /*-----*/
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QCMN)
     MONMSG MSGID(CPF0000)
DONE:
     QSYS/STRSBS SBSD(QSPL)           /*-----*/
     MONMSG MSGID(CPF0000)
     QSYS/RTVSYSVAL SYSVAL(QSTRPRTWTR) RTNVAR(&STRWTRS)
     IF COND(&STRWTRS = '0') THEN(GOTO CMDLBL(NOWTRS))
     CALL PGM(QSYS/QWCSWTRS)
     MONMSG MSGID(CPF0000)
NOWTRS:
     RETURN
     CHGVAR VAR(&CPYR) VALUE(&CPYR)
     ENDPGM
