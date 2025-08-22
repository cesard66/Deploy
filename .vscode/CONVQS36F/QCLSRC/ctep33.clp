/* ***********************************************************      */
/* **PROYECTO AJUSTES AL CORE                                       */
/* **Se comenta la linea 487 don se llama al SEPACTL                */
/* **Analista: Zulmira Peralta Fcha: nov/2021                       */
/* ** ********************************************************      */
/* ** DISCONTINUADOS - FEB/23                                       */
/* **    CONTROLA MONTOS MAYORES A US$ 1.000.000 ******             */
/* **      CALL CONTCCME                                            */
/* **    CONTROL DE REGISTROS IDENTICOS EN PROCESO DE CTACTE        */
/* **      CALL INTERB01/CTESRDU                                    */
/* **      CALL INTERB01/CTESRDL                                    */
/* **    NOTAS DE DEBITOS DE SOBREGIROS                             */
/* **       // LOAD CTES33                                          */
/* ***********************************************************      */
             PGM

             DCL        VAR(&DATE) TYPE(*CHAR) LEN(006)
             DCL        VAR(&RCDNBR) TYPE(*DEC) LEN(008)
             DCL        VAR(&TEST) TYPE(*CHAR) LEN(001)
             DCL        VAR(&TRUE) TYPE(*CHAR) LEN(001) VALUE('1')

             SNDPGMMSG  MSG('**************************************+
                          *************************************') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('***                                   -
                                  ***') TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('***     P R O C E S O     M E N S U A +
                          L     E N C A D E N A D  O        ***') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('***                                   -
                                  ***') TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('**************************************+
                          *************************************') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('***                 PRIMER  --- +
                          RE-PROCESO DE LA CONSISTENCIA           +
                          ***') TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('**************************************+
                          *************************************') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             CPYF       FROMFILE(QS36F/CTESDO) +
                          TOFILE(QS36F/CTESDOAN) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(MCTONL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) SNDPGMMSG +
                          MSG('AUN NO SE PROCESO CONVAGE. +
                          CANCELARE') TOPGMQ(*EXT) MSGTYPE(*COMP)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(MCTONL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) SNDUSRMSG +
                          MSG('PAUSE - When ready, enter 0 to +
                          continue') TOMSGQ(*EXT)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(MCTONL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) RETURN
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(ROBOTCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) SNDPGMMSG +
                          MSG('AUN NO SE PROCESO TRASF.AUTOMATICA. +
                          CANCELARE') TOPGMQ(*EXT) MSGTYPE(*COMP)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(ROBOTCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) SNDUSRMSG +
                          MSG('PAUSE - When ready, enter 0 to +
                          continue') TOMSGQ(*EXT)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(ROBOTCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) RETURN
             SNDPGMMSG  MSG(' PREPARACION DE ARCHIVOS PARA PROCESO +
                          BATCH') TOPGMQ(*EXT) MSGTYPE(*COMP)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(AUTOPF) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) CRTPF +
                          FILE(QS36F/AUTOPF) RCDLEN(80)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(CTACTE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) CRTPF +
                          FILE(QS36F/CTACTE) RCDLEN(80)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(LUNCHCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) CRTPF +
                          FILE(QS36F/LUNCHCC) RCDLEN(80)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(CTCT) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) DO
             CALL       PGM(SUEL) PARM(BLDFILE)
/* CTCTSUEL,S,BLOCKS,1,80,,T,,,NDFILE                               */
             ENDDO
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(MOVIM) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DLTF FILE(MOVIM)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(CTESD01) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DLTF FILE(CTESD01)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(AUTOMATO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DLTF FILE(AUTOMATO)
             CHGJOB     SWS(00000000)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(SUELCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(1XXXXXXX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(MCTONL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(X1XXXXXX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(DBPCT) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(XX1XXXXX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(PRMOVCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(XXX1XXXX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(ROBOTCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(XXXX1XXX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(CHMOVCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(XXXXX1XX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(CCSEISA) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) CRTPF +
                          FILE(QS36F/CCSEISA) RCDLEN(80)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(CCSUEL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) CRTPF +
                          FILE(QS36F/CCSUEL) RCDLEN(80)
/* * ACTUALIZACION SIMULADA DE SALDOS A FIN DE TENER LOS            */
/* SOBREGIROS D/DIA                                                 */
/* * A FIN DE APLICARLE LOS DEBITOS POR COMISION A LAS CUENTAS CON  */
/* * INTERCHEQUE Y QUE SOBREUTILIZARON SU LINEA.                    */
             CALL       PGM(CTEP32X)
             CHGJOB     SWS(00000000)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(SUELCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(1XXXXXXX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(MCTONL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(X1XXXXXX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(DBPCT) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(XX1XXXXX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(PRMOVCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(XXX1XXXX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(ROBOTCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(XXXX1XXX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(CHMOVCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(XXXXX1XX)
/* *                                                                */
/* **// PAUSE 'VERIFIQUE QUE NO EXISTA ARCHIVO DBPCT'               */
             IF         (%SWITCH(1XXXXXXX)) DO
             ENDDO
             IF         (%SWITCH(X1XXXXXX)) DO
             ENDDO
             IF         (%SWITCH(XX1XXXXX)) DO
             ENDDO
             IF         (%SWITCH(XXX1XXXX)) DO
             ENDDO
             IF         (%SWITCH(XXXX1XXX)) DO
             ENDDO
             IF         (%SWITCH(XXXXX1XX)) DO
             ENDDO
             IF         (%SWITCH(XXXXXXX1)) DO
             ENDDO
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(MOVINCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DO
             ENDDO
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(ICHMOVCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DO
             ENDDO
             OVRPRTF    FILE(CONTABIL) FORMTYPE(BORR) OUTPTY(9) +
                          HOLD(*YES)
             OVRPRTF    FILE(CONTABIT) FORMTYPE(BORR) OUTPTY(9) +
                          HOLD(*YES)
             CALL       PGM(CTES29)
             CALL       PGM(RTVFRN) PARM(ICHMOVCC &RCDNBR)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(ICHMOVCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         ((&TEST *EQ &TRUE) *AND (&RCDNBR *GT 0)) +
                          CPYF FROMFILE(QS36F/ICHMOVCC) +
                          TOFILE(QS36F/ICHMOVCC.K) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             ENDDO
             ENDDO
             ENDDO
             ENDDO
             ENDDO
             ENDDO
             ENDDO
             ENDDO
             ENDDO
             CALL       PGM(RTVFRN) PARM(CTEF 17 &RCDNBR)
             SNDPGMMSG  MSG('SE PROCESARAN ' *CAT &RCDNBR *TCAT ' +
                          REGISTROS PARA CUENTA CORRIENTE') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
/* **PAUSE 'SI SON MENOS DE 2000 REGISTROS, PROBABLE ERROR'         */
             CHGJOB     SWS(00000000)
             CLRPFM     FILE(QS36F/CTEF26)
             MONMSG     MSGID(CPF3142) EXEC(CRTPF +
                          FILE(QS36F/CTEF26) RCDLEN(80) +
                          SIZE(*NOMAX))
             FMTDTA     INFILE((*LIBL/CTEF17)) +
                          OUTFILE(QS36F/CTEF26) +
                          SRCFILE(CONVQS36F/SORTSRC) +
                          SRCMBR(SORT000068) OPTION(*NOPRT)
             DLTF       FILE(*LIBL/CTEF17)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(CTEF261) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DLTF FILE(CTEF261)
             OVRPRTF    FILE(CONSISCC) FORMTYPE(BORR) OUTPTY(9) +
                          HOLD(*YES)
             OVRPRTF    FILE(RESUMECC) FORMTYPE(BORR) OUTPTY(9) +
                          HOLD(*YES)
             CALL       PGM(CTES02)
             DLTF       FILE(CTEF26)
             SNDPGMMSG  MSG('   Actualizacion de los saldos en +
                          base a los movimientos del dia.') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('   Clasificacion de las +
                          transacciones.') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             CLRPFM     FILE(QS36F/MOVIM)
             MONMSG     MSGID(CPF3142) EXEC(CRTPF +
                          FILE(QS36F/MOVIM) RCDLEN(80) SIZE(*NOMAX))
             FMTDTA     INFILE((*LIBL/CTEF27)) +
                          OUTFILE(QS36F/MOVIM) +
                          SRCFILE(CONVQS36F/SORTSRC) +
                          SRCMBR(SORT000069) OPTION(*NOPRT)
             DLTF       FILE(*LIBL/CTEF27)
             CPYF       FROMFILE(QS36F/CCMASL) +
                          TOFILE(QS36F/CCMASL1) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
/* * ELIMINAR BLOQUEOS.                                             */
CALL       PGM(GLOBAL/PRENDJOB) PARM('QS36F 'CTESDO')
/* ** MARCA DEP. CH. COB PARA QUE SE CONFIRMEN D+0 (FIN DE A#0)     */
             CALL       INTERB01/CONFICTCL
             OVRDBF     FILE(CCMASL) TOFILE(CCMASL1)
             OVRPRTF    FILE(ANORMACC) FORMTYPE(BORR) OUTPTY(9) +
                          HOLD(*YES)
             CALL       PGM(CTES03)
             DLTOVR     FILE(*ALL)
/* ** SE AGREGA LA EJECUCION DEL SUMADEPC EN PROCESO DE FIN DE A O  */
/* ***                                                              */
/* ** ============================================================  */
/* ***                                                              */
/* **Se modifican estas líneas por el llamado a CTEP33ACL           */
/* **IF ?DATE?/'301214' CALL SUMADEPC                               */
/* **IF ?DATE?/'301214 CALL SUMADEPC1                               */
/* **CALL ONLINE/CTEP33ACL                                          */
             RTVJOBA    DATE(&DATE)
             IF         (&DATE *EQ '301215') DO
             SNDPGMMSG  MSG('CONTROL PROCESO FIN AÑO +
                          SUMADEPC/PC1') TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDUSRMSG  MSG('PAUSE - When ready, enter 0 to +
                          continue') TOMSGQ(*EXT)
             ENDDO
/* *CALL CHEQME06C                                                  */
/* * A PARTIR DEL 22/02/2000 LOS SALDOS BLOQUEADOS YA NO SE RESTAN  */
/* DEL                                                              */
/* * CTESDO PORQUE CREA PROBLEMA EN EL NUMERAL LO MISMO QUE EN      */
/* ENCAJE                                                           */
/* * ENTONCES SE RESTA SOLO EN COLB                                 */
/* // LOAD BLOKCC,INTERBIC                                          */
/* // FILE NAME-BLOQUEO,LABEL-BLOQUEOX                              */
/* // FILE NAME-CTESDO, LABEL-CTESD01, DISP-SHR                     */
/* // RUN                                                           */
 PULOA:
             CHGJOB     SWS(00000000)
             SNDPGMMSG  MSG('*-------------------------------------+
                          -----------------------*') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             SNDPGMMSG  MSG('* ACTUALIZACION DE CABECERAS DE +
                          AGENCIA DEL ARCHIVO CTESD01* *') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('*-------------------------------------+
                          -----------------------*') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             CALL       PGM(CTES04)
             SNDPGMMSG  MSG('     FIN DE LA PRIMERA CONSISTENCIA') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
/*                                                                  */
             SNDPGMMSG  MSG('**************************************+
                          *************************************') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('***          PRIMERA PARTE  ---   +
                          DEBITOS POR SOBREGIROS EFECTUADOS     +
                          ***') TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('***                         ---   +
                          DEBITOS POR PROMEDIOS INFERIORES      +
                          ***') TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('**************************************+
                          *************************************') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(HISTORY4) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) CRTPF +
                          FILE(QS36F/HISTORY4) RCDLEN(24) +
                          SIZE(*NOMAX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(HISTORY4) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CLRPFM QS36F/HISTORY4
             OVRDBF     FILE(CTESDO) TOFILE(CTESDO1)
             OVRDBF     FILE(HISTORY2) TOFILE(HISTORY4)
             CALL       PGM(CTES32)
             DLTOVR     FILE(*ALL)
/* *** DESDE ACA CIERTOS PROCESOS SE LLEVARON A CTEP32T, QUE CORRE  */
/* EN AHORRO ***                                                    */
             CHGJOB     SWS(10000000)
/* *CPYF FROMFILE(QS36F/HISTORY1) +                                 */
/* *     TOFILE(QS36F/HISTOR70) MBROPT(*REPLACE) +                  */
/* *     INCCHAR(RCD 7 *EQ '70') FMTOPT(*NOCHK)                     */
/* *OVRDBF HISTORY1 HISTORY4                                        */
/* *CLRPFM HISTORPF                                                 */
/* *CALL CHISTORPF                                                  */
/* *DLTOVR     FILE(HISTORY1)                                       */
/* *CPYF       FROMFILE(QS36F/HISTORPF) +                           */
/* *         TOFILE(QS36F/HISTORPO) MBROPT(*REPLACE) +              */
/* *         FMTOPT(*NOCHK)                                         */
/* *CPYF FROMFILE(QS36F/SOBRESEP) +                                 */
/* *     TOFILE(QS36F/SOBRESEH) MBROPT(*ADD) +                      */
/* *     CRTFILE(*YES)                                              */
/* *CPYF FROMFILE(QS36F/DETSOSEP) +                                 */
/* *     TOFILE(QS36F/DETSOSEH) MBROPT(*ADD) +                      */
/* *     CRTFILE(*YES)                                              */
/* *CLRPFM SDIFESAL                                                 */
/* *CLRPFM SNUMENEG                                                 */
/* *CLRPFM SOBREN                                                   */
/* *CLRPFM DET SOBN                                                 */
/* *CLRPFM SOBRESEP                                                 */
/* *CLRPFM DETSOSEP                                                 */
/* *BLDINDEX HISTOR4X,2,5, HISTORPO,,DUPKEY                         */
/* *BLDINDEX HISTOR5X,2,5, HISTORPO,,DUPKEY                         */
/* *OVRDBF UCGMACL7 ITBDBLIB/UCGMACL7                               */
/* *OVRDBF CCMASL QS36F/CCMASL1                                     */
/* *CALL CTES39NN                                                   */
/* *DLTOVR CCMASL                                                   */
/* *// IFF DATAF1-POSCCCME BLDFILE POSCCCME,S,BLOCKS,50,80,,T,,,DFI */
/* LE,,25                                                           */
/* *CLRPFM POSCCCME                                                 */
/* *OVRDBF INTF04 POSCCCME                                          */
/* *CALL CTES39NNE                                                  */
/* **************************************************************** */
/* ************                                                     */
/*  SOBREGIROS CTASCTES EURO                                        */
/*            *                                                     */
/* **************************************************************** */
/* ************                                                     */
/* *CALL CTES39NNEU                                                 */
/* *CALL CSOBREGI                                                   */
/* *RUNQRY QRY(SDIFESAL) QRYFILE(CQS36F/SDIFESAL))                  */
/* *RUNQRY QRY(SNUMENEG) QRYFILE((QS36F/SNUMENEG))                  */
/* *// IFF ?F'A, SDIFESAL ?/0 * 'ERROR GRAVE HAY SALDOS CON         */
/* PROBLEMA AL CALCULAR SOBREGIRO'                                  */
/* *// IFF ?F'A, SDIFESAL'?/0 * 'EL PROCESO NO PUEDE CONTINUAR      */
/* COMUNIQUESE CON EL ANALISTA DE GUARDIA'                          */
/* *// IFF ?F'A, SDIFESAL ?/0 PAUSE                                 */
/* **************************************************************** */
/* *************                                                    */
/* ** SEPARA SOBREGIROS QUE PASAN LA TASA MAXIMA O SON MENORES AL   */
/* MONTO MINIMO *                                                   */
/* **************************************************************** */
/* *************                                                    */
/* *CALL SBSEPARA                                                   */
/* *RUNQRY SOBRESEP                                                 */
/* *// PAUSE 'SI EL RESULTADO DEL QUERY DIÓ UN MONTO MUY ALTO, NO   */
/* SE PUEDE CONTINUAR                                               */
/* **************************************                           */
/*  MODULO PARA REINTENTAR A MENOR TASA *                           */
/* **************************************                           */
/* * CTEP33RE                                                       */
/* **************************************************************** */
/* ******                                                           */
/*  DEJA ARCHIVOS EN EL FORMATO ANTERIOR PARA EL RESTO DEL SISTEMA  */
/*      *                                                           */
/* **************************************************************** */
/* ******                                                           */
/* *// IFF DATAF1-SOBRE CRTPF FILE(QS36F/SOBRE)                     */
/* SRCFILE(QS36F/QDDSSRC) SIZE(*NOMAX)                              */
/* *CLRPFM SOBRE                                                    */
/* *CLRPFM DET SOB                                                  */
/* *CPYF FROMFILE(QS36F/SOBREN) TOFILE(QS36F/SOBRE)                 */
/* MBROPT(*REPLACE) FMTOPT(*NOCHK)                                  */
/* *CPYF FROMFILE(QS36F/DETSOBN) TOFILE(QS36F/DETSOB)               */
/* MBROPT(*REPLACE) FMTOPT(*NOCHK)                                  */
/* **************************************************************** */
/* *****                                                            */
/* CREA HISTORICO DE SOBREGIROS (DETSOBNH)                          */
/*     *                                                            */
/* **************************************************************** */
/* *****                                                            */
/* *CALL ONLINE/NDETSOBNH                                           */
/* **************************************************************** */
/* *****                                                            */
/* ** DIFIERE APLICACION DE SOBREGIROS A CUENTAS CON CLAS. 'C' 'D'  */
/* 'E' *                                                            */
/* **************************************************************** */
/* *****                                                            */
/* CALL SBVENCID                                                    */
/* *DELETE HISTOR4X,F1                                              */
/* *DELETE HISTOR5X,F1                                              */
/* * AQUI GENERA POSICION DE CAMBIOS, DESPUES DE EXTORNAR           */
/* SOBREGIROS CLASIFICADOS                                          */
/* *CPYF FROMFILE(QS36F/POSCCCME) +                                 */
/* *     TOFILE(QS36F/POSCC.B) MBROPT(*REPLACE) +                   */
/* *     CRTFILE(*YES)                                              */
/* *CLRPFM POSCCCME                                                 */
/* *CALL GENEPOSC                                                   */
/* * Lleva sobregiro ML a FAMAFA                                    */
/* ***CALL FAMASOBL      SE LLEVO A CTEP22 DESPUES DE EXTRACTOS     */
/* * Lleva sobregiro ME a FAMAFA                                    */
/* ***CALL FAMASOBE      SE LLEVO A CTEP22 DESPUES DE EXTRACTOS     */
/* ** CONFECCIONA PLANILLA Y GENERA REGISTROS DE TRANSACCIONES      */
/* P/ACTUALIZ.C/GTOS                                                */
/*                                                                  */
             SNDPGMMSG  MSG('Impresion de los gastos de +
                          Sobregiros') TOPGMQ(*EXT) MSGTYPE(*COMP)
/* *// LOAD CTES40       CONFEC. PLANILLA DE GASTOS P/SOBREGIRO     */
/* *// PRINTER NAME-CTES40,COPIES-1                                 */
/* *// FILE NAME-SOBRE                                              */
/* *// FILE NAME-SOBREGIR,RECORDS-500,EXTEND-100                    */
/* *// RUN                                                          */
/* *// LOAD CTES40E     CONFEC. PLANILLA DE GASTOS P/SOBREGIRO      */
/* *// PRINTER NAME-CTES40,COPIES-1                                 */
/* *// FILE NAME-SOBRE                                              */
/* *// FILE NAME-SOBREGIR                                           */
/* *// RUN                                                          */
/*                                                                  */
/* *// * 'Impresion de Cuentas Exentas de Debitos por Promedio      */
/* Inferior a Gs.400.000'                                           */
/* *// LOAD CTES41                                                  */
/* *// FILE NAME-CTESDO                                             */
/* *// FILE NAME-TARIFA, DISP-SHR                                   */
/* *// RUN                                                          */
/* *// * 'Impresion de Cuentas Exentas de Debitos por Promedio      */
/* Inferior a US$                                                   */
/* *// LOAD CTES41E                                                 */
/* *// FILE NAME-CTESDO                                             */
/* *// FILE NAME-TARIFA, DISP-SHR                                   */
/* *// RUN                                                          */
/*                                                                  */
/* * * '*********************************************************** */
/* ****************'   ESTA ES LA PARTE MOD                         */
/* * * '***                SEGUNDO  ---  RE-PROCESO DE LA           */
/* CONSISTENCIA          ***'   A. 03/08/87                         */
/* * * '*********************************************************** */
/* ****************'   B. 01/09/87                                  */
/* * * ' '                                                          */
/* *// IF DATAF1-SOBREGIR * 'Van a ingresar hoy los Débitos por     */
/* Sobregiros? '                                                    */
/* *// IF DATAF1-SOBREGIR * '   Teclee ... SI  ;  otra entrada      */
/* asumo ... NO'                                                    */
/* *// IF DATAF1-SOBREGIR * ' -- Ultimo proceso del a o, debera     */
/* ser SI -- '                                                      */
/* *// IF DATAF1-SOBREGIR IF ?2R?/SI RENAME SOBREGIR,SGIRO          */
/* *// IFF DATAF1-SGIRO GOTO RRR                                    */
/* **************************************************************** */
/* **************                                                   */
 CT28:
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(AUTOMATO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DLTF FILE(AUTOMATO)
/*                                                                  */
/* / LOAD CTES28     **** WORKSTN  - CORRECCION BORRADO             */
/* / FILE NAME-SOBRE                                                */
/* / PRINTER NAME-CTES28,LINES-72                                   */
/* / RUN                                                            */
/* * COPIA PARA NUEVO PLAN DE CUENTAS                               */
             CPYF       FROMFILE(QS36F/SOBRE) +
                          TOFILE(SOFTSHOP/SOBRE) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             SNDPGMMSG  MSG(' TRANSFIERE CUARTA PARTE DE +
                          OPERACIONES (SOBREGIRO) DE CTA CTE') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             CALL       INGEN/TR04CCTC3
             CLRPFM     FILE(QS36F/CTEF16)
             MONMSG     MSGID(CPF3142) EXEC(CRTPF +
                          FILE(QS36F/CTEF16) RCDLEN(160) +
                          SIZE(*NOMAX))
             FMTDTA     INFILE((*LIBL/SOBRE)) +
                          OUTFILE(QS36F/CTEF16) +
                          SRCFILE(CONVQS36F/SORTSRC) +
                          SRCMBR(SORT000070) OPTION(*NOPRT)
             DLTF       FILE(*LIBL/SOBRE)
             DLTF       FILE(SGIRO)
             RNMOBJ     OBJ(CTEF16) OBJTYPE(*FILE) NEWOBJ(SOBRE)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(SOBREL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) DO

/* NO DDS FOR BLDIND   EX PROCEDURE */
/* // IFF DATAF1-SOBREL BLDINDEX SOBREL,1,9,SOBRE,,NODUPKEY */

             ENDDO
             SNDPGMMSG  MSG('   Impresion de los gastos de +
                          Sobregiros') TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('   Genera el archivo SGIRO para +
                          ingresar en transacciones diarias.') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             OVRPRTF    FILE(CTES30) FORMTYPE(RE66) COPIES(1) +
                          OUTPTY(9) HOLD(*YES)
             CALL       PGM(CTES30)
             CLRPFM     POSCCCME
             OVRDBF     FILE(COLB) TOFILE(COLBY)
             OVRPRTF    FILE(CTES30) FORMTYPE(RE66) COPIES(1) +
                          OUTPTY(9) HOLD(*YES)
             CALL       PGM(CTES30E)
             DLTOVR     FILE(*ALL)
/*                                                                  */
/* / * '   Tiene usted ?USER?, la opcion de realizar las            */
/* correcciones a los'                                              */
/* / * '   Debitos por Sobregiros antes de imprimirlos.'            */
/* / * '     En caso de que todo este correcto, el proceso sigue    */
/* normalmente.'                                                    */
/* / * '   Teclee LISTO para continuar ; INTRO para volver a        */
/* Corregir'                                                        */
/* / IFF ?R?/LISTO GOTO CT28                                        */
             RTVJOBA    DATE(&DATE)
             IF         (&DATE *EQ '291010') DO
             SNDPGMMSG  MSG('VERIFICAR CALCULOS DE INTERESES DE +
                          SOBREGIRO') TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDUSRMSG  MSG('PAUSE - When ready, enter 0 to +
                          continue') TOMSGQ(*EXT)
             ENDDO
/* **************************************************************** */
/* ***************                                                  */
 RRR:
             SNDPGMMSG  MSG('GENERA ARCHIVO DE LAS EXCEPCIONES') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
/* *CALL EXONPI01CL                                                 */
             CLRPFM     PENDEB
             SNDPGMMSG  MSG('   Genera los Débitos por Promedios +
                          Inferiores.') TOPGMQ(*EXT) MSGTYPE(*COMP)
/* // LOAD CTES06                                                   */
/* // FILE NAME-CTESDO,LABEL-CTESDO1                                */
/* // FILE NAME-TABIVA,LABEL-TABIVA,DISP-SHR                        */
/* // FILE NAME-TARIFA,DISP-SHR                                     */
/* // FILE NAME-SALIVA,DISP-SHR                                     */
/* // FILE NAME-TARIFANW,DISP-SHR                                   */
/* // FILE NAME-EXONPIO1,DISP-SHR                                   */
/* // FILE NAME-DBPCT,RECORDS-300,EXTEND-100                        */
/* // FILE NAME-AUTOMATO,EXTEND-50                                  */
/* // FILE NAME-PENDXX,LABEL-PENDEB,DISP-SHR                        */
/* // FILE NAME-SOBREL,DISP-SHR                                     */
/* // PRINTER NAME-CTES06,COPIES-1,FORMSNO-RE66,PRIORITY-0          */
/* // PRINTER NAME-CTESO6N,COPIES-3,FORMSNO-RE66,PRIORITY-0         */
/* // PRINTER NAME-MODI 348,LINES-24,FORMSNO-1348,PRIORITY-0,COPIES */
/* -1                                                               */
/* // RUN                                                           */
/* **CPYF FROMFILE(QS36F/DBPCT) +                                   */
/* *   TOFILE(QS36F/DBPCT_1000) CRTFILE(YES)                        */
/* *DELETE DBPCT,F1                                                 */
/* // * 'Genera los Débitos por Promedios Inferiores U$S'           */
/* // LOAD CTES06E                                                  */
/* // FILE NAME-CTESDO,LABEL-CTESDO1                                */
/* // FILE NAME-TABIVA,LABEL-TABIVA, DISP-SHR                       */
/* // FILE NAME-TARIFA,DISP-SHR                                     */
/* // FILE NAME-INTF04,LABEL-POSCCCME                               */
/* // FILE NAME-SALIVA,DISP-SHR                                     */
/* // FILE NAME-TARIFANW,DISP-SHR                                   */
/* // FILE NAME-PRESTAL1,DISP-SHR                                   */
/* // FILE NAME-DBPCT, EXTEND-100                                   */
/* // FILE NAME-PENDXX,LABEL-PENDEB,DISP-SHR                        */
/* // FILE NAME-TASAS,DISP-SHR                                      */
/* // FILE NAME-SOBREL,DISP-SHR                                     */
/* // PRINTER NAME-CTES06,COPIES-1,FORMSNO-RE66,PRIORITY-0          */
/* // PRINTER NAME-CTES06N,COPIES-3,FORMSNO-RE66,PRIORITY-0         */
/* // PRINTER NAME-MODI 348,LINES-24,FORMSNO-1348,PRIORITY-0,COPIES */
/* -1                                                               */
/* // RUN                                                           */
/* **** NUEVAS COMISIONES ******                                    */
/* ***// IF DATAF1-HISTOCC1 DELETE HISTOCC1, F1                     */
/* ***// BLDINDEX HISTOCC1,2,5, HISTORY4,,DUPKEY                    */
/* ***CALL NOIMPRCLC                                                */
/* ***CALL CTECOMCL (SE LLEVÓ A AHOP33: REINGENIERIA DE PROCESO DE  */
/* CIERRE)                                                          */
/* ***DLTF HISTOCC1                                                 */
/* ***DLTF HISTORY4                                                 */
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(SOBREL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DLTF FILE(SOBREL)
/* * * '=========================================================== */
/* * * '  YA PUEDE INICIAR SEGUNDO PROCESO DE COMEX. HA FINALIZADO  */
/* * * '  PROCESOS QUE GENERA OPERACIONES PARA POSICION DE CAMBIOS  */
/* * * '  PROGRAMAS CTES39E Y CTES06E.               SUERTE]]]]]]]  */
/* * * '=========================================================== */
             CALL       GLOBAL/PRCOMUPD
             RTVJOBA    DATE(&DATE)
             SBMJOB     CMD(STRS36PRC PRC(PRCOMEX) CURLIB(GLOBAL)) +
                          JOB(PRCOMEX) DATE(&DATE)
             SNDPGMMSG  MSG('PREPARACION DE ARCHIVOS PARA PROCESO +
                          BATCH') TOPGMQ(*EXT) MSGTYPE(*COMP)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(MOVIM) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DLTF FILE(MOVIM)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(CTESD01) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DLTF FILE(CTESDO1)
             CHGJOB     SWS(00000000)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(SUELCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(1XXXXXXX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(MCTONL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(X1XXXXXX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(DBPCT) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(XX1XXXXX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(PRMOVCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(XXX1XXXX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(ROBOTCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(XXXX1XXX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(CHMOVCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(XXXXX1XX)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(SGIRO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CHGJOB SWS(XXXXXXX1)
             IF         (%SWITCH(1XXXXXXX)) DO
             ENDDO
             IF         (%SWITCH(X1XXXXXX)) DO
             ENDDO
             IF         (%SWITCH(XX1XXXXX)) DO
             ENDDO
             IF         (%SWITCH(XXX1XXXX)) DO
             ENDDO
             IF         (%SWITCH(XXXX1XXX)) DO
             ENDDO
             IF         (%SWITCH(XXXXX1XX)) DO
             ENDDO
             IF         (%SWITCH(XXXXXXX1)) DO
             ENDDO
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(MOVINCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DO
             ENDDO
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(ICHMOVCC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DO
             ENDDO
/* DISP-SHR                                                         */
             OVRPRTF    FILE(CONTABIL) FORMTYPE(RE66) OUTPTY(9) +
                          HOLD(*YES)
             OVRPRTF    FILE(CONTABIT) FORMTYPE(RE66) OUTPTY(9) +
                          HOLD(*YES)
             CALL       PGM(CTES29)
             DLTF       FILE(MOVIM10)
             CHGJOB     SWS(00000000)
             CLRPFM     FILE(QS36F/CTEF26)
             MONMSG     MSGID(CPF3142) EXEC(CRTPF +
                          FILE(QS36F/CTEF26) RCDLEN(80) +
                          SIZE(*NOMAX))
             FMTDTA     INFILE((*LIBL/CTEF17)) +
                          OUTFILE(QS36F/CTEF26) +
                          SRCFILE(CONVQS36F/SORTSRC) +
                          SRCMBR(SORT000071) OPTION(*NOPRT)
             DLTF       FILE(*LIBL/CTEF17)
/*  SEPARA LOS MOV. EN CUENTAS CORRIENTES DE CLIENTES CON PROBLEMA  */
/* DE RUC                                                           */
/* * BLDINDEX CTEF261,1,80, CTEF26,,DUPKEY                          */
/* * CALL SEPACTCL                                                  */
/* * IF DATAF1-CTEF261 DELETE CTEF261,F1                            */
             OVRPRTF    FILE(CONSISCC) FORMTYPE(GOAL) OUTPTY(9) +
                          HOLD(*YES)
             OVRPRTF    FILE(RESUMECC) FORMTYPE(GOAL) OUTPTY(9) +
                          HOLD(*YES)
             CALL       PGM(CTES02)
             DLTF       FILE(CTEF26)
             SNDPGMMSG  MSG('   Actualizacion de los saldos en +
                          base a los movimientos del dia.') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('   Clasificacion de las +
                          transacciones.') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             CLRPFM     FILE(QS36F/MOVIM)
             MONMSG     MSGID(CPF3142) EXEC(CRTPF +
                          FILE(QS36F/MOVIM) RCDLEN(80) SIZE(*NOMAX))
             FMTDTA     INFILE((*LIBL/CTEF27)) +
                          OUTFILE(QS36F/MOVIM) +
                          SRCFILE(CONVQS36F/SORTSRC) +
                          SRCMBR(SORT000072) OPTION(*NOPRT)
             DLTF       FILE(*LIBL/CTEF27)
/* * ELMININAR BLOQUEOS                                             */
CALL       PGM(GLOBAL/PRENDJOB) PARM('QS36F 'CTESDO')
/* *                                                                */
/* ** MARCA DEP. CH. COB PARA QUE SE CONFIRMEN D+0 (FIN DE A#0)     */
             CALL       INTERB01/CONFICTCL
             OVRPRTF    FILE(ANORMACC) FORMTYPE(BORR) OUTPTY(9) +
                          HOLD(*YES)
             CALL       PGM(CTES03)
             OVRPRTF    FILE(ANORMALI) COPIES(1)
             CALL       PGM(CTES03X)
             CPYSPLF    FILE(ANORMALI) TOFILE(QS36F/PANORMAC) +
                          SPLNBR(*LAST)
             OVRDBF     FILE(TCMAECOM) TOFILE(TARJETA/TCMAECOM)
             CLRPFM     WLISTADO
             CALL       WLISTADO
             RUNQRY     WLISTADO
             CLRPFM     WLISTADO
             CALL       WLISTAD1
             RUNQRY     WLISTAD1
             DLTOVR     TCMAECOM
/* * VERIFCAR CAMBIO DE ESTADOS   ---  MAY0/11 -- ZPHG              */
             CALL       NCPRO53CT
/* * SUMA AL SALDO DISPONIBLE LOS RECHAZOS DE CH. VIA ATM, POR QUE  */
/* EN EL                                                            */
/* * PROGRAMA ANTERIOR (AHOSO3) LO RESTO.                           */
/* ** LA EJECUCION DEL PROGRAMA CTES90 SE OMITE A FIN DE AÑO ***    */
/* ** ====================================================== ***    */
/* **Se modifican esta línea por el 11amado a CTEP33BCL             */
/* **IFF ?DATE?/'301214' CALL CTES90                                */
/* **CALL ONLINE/CTEP33BCL                                          */
/* **CALL CHEQME06C                                                 */
/* ** ============================================================  */
/* ***                                                              */
/* ** SE AGREGA LA EJECUCION DEL SUMADEPC EN PROCESO DE FIN DE A o  */
/* ***                                                              */
/* ** ============================================================  */
/* ***                                                              */
/* **Se modifican estas líneas por el 11amado a CTEP33ACL           */
/* **IF ?DATE?/'301214' CALL SUMADEPC                               */
/* **IF ?DATE?/'301214' CALL SUMADEPC1                              */
             OVRDBF     FILE(CCMASL1) TOFILE(QS36F/CCMASL)
/* **CALL ONLINE/CTEP33ACL                                          */
             RTVJOBA    DATE(&DATE)
             IF         (&DATE *EQ '301215') DO
             SNDPGMMSG  MSG('CONTROL PROCESO FIN AÑO +
                          SUMADEPC/PC1') TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDUSRMSG  MSG('PAUSE - When ready, enter 0 to +
                          continue') TOMSGQ(*EXT)
             ENDDO
             ENDDO
             ENDDO
             ENDDO
             ENDDO
             ENDDO
             ENDDO
             ENDDO
             ENDDO
             ENDDO
             DLTOVR     CCMASL1
/* * A PARTIR DEL 22/02/2000 LOS SALDOS BLOQUEADOS YA NO SE RESTAN  */
/* DEL                                                              */
/* * CTESDO PORQUE CREA PROBLEMA EN EL NUMERAL LO MISMO QUE EN      */
/* ENCAJE                                                           */
/* * ENTONCES SE RESTA SOLO EN COLB                                 */
/* // LOAD BLOKCC,INTERB1C                                          */
/* // FILE NAME-BLOQUEO,LABEL-BLOQUEOX                              */
/* // FILE NAME-CTESDO,LABEL-CTESD01,DISP-SHR                       */
/* // RUN                                                           */
 PULOB:
             CHGJOB     SWS(00000000)
             SNDPGMMSG  MSG('*-------------------------------------+
                          -----------------------*') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             SNDPGMMSG  MSG('* ACTUALIZACION DE CABECERAS DE +
                          AGENCIA DEL ARCHIVO CTESDO1* *') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('*-------------------------------------+
                          -----------------------*') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             CALL       PGM(CTES04)
             SNDPGMMSG  MSG('LISTADO DE SOBREGIROS') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             OVRPRTF    FILE(CTES31) FORMTYPE(BORR) COPIES(9) +
                          OUTPTY(9) HOLD(*YES)
             OVRPRTF    FILE(CTES31C) FORMTYPE(BORR) COPIES(1) +
                          OUTPTY(9) HOLD(*YES)
             CALL       PGM(CTES31)
             CLRPFM     MOVINCC
             CALL       PGM(RTVFRN) PARM(NCOMISIC &RCDNBR)
             IF         DATAF1-NCOMISIC IF &RCDNBR >0 CPYF +
                          FROMFILE(QS36F/NCOMISIC) +
                          TOFILE(QS36F/NCOMISIC.M) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CLRPFM     FILE(QS36F/NCOMISIC)
             CLRPFM     CTESDOBD
             CALL       PGM(CTES31BR)
/* CALL PGM(CTES31B) PARM('G')                                      */
/* CALL PGM(CTES31B) PARM('D')                                      */
/* CALL PGM(CTES63) PARM('G')                                       */
/* CALL PGM(CTES63) PARM('D')                                       */
/* CALL PGM(CTES67)                                                 */
/* ** Ley 805                                                       */
             CPYF       FROMFILE(QS36F/RECHAFIV) +
                          TOFILE(QS36F/RECHAFIH) MBROPT(*ADD)
/* * GENERA REGISTROS DE CHEQUES RECHAZADOS EN VENTANILLA           */
             CALL       PGM(NL8BU004)
/* * GENERA MULTA **                                                */
             OVRDBF     COLB COLBY
             CALL       PGM(NL8BU005)
             DLTOVR     COLB
             CLRPFM     FILE(RECHAFIV)
             DLTF       QS36F/CONTROC$
/* ** GENERA TASAS DE SOBREGIRO PARA CUENTAS DE INTERVALE PARA      */
/* MOSTRAR EN EL TICKET DEL ATM                                     */
             OVRDBF     IVTASAFM INFONET/IVTASAFM
             CALL       IV029P
             CALL       IV028P
/* * GENERAR INFORME SIN CLEAN UP **                                */
             CALL       PGM(NCPR027CL)
/* * GENERAR INFORME DE CAMBIO DE ESTADOS **                        */
             CALL       PGM(NCCMR040CL)
             SNDPGMMSG  MSG('CONTROL DE FCHA ULTIMO MOVIM EN +
                          CTESDO1') TOPGMQ(*EXT) MSGTYPE(*COMP)
             CALL       ONLINE/CLNCCM09CC
/* * HACE BACKUP Y LIMPIA LOG DE DEP.CH. COB CONFIRMADOS (FIN DE    */
/* A#0)                                                             */
             CALL       INTERB01/CONFIBKCL

             ENDPGM
