             PGM

             DCL        VAR(&DATE) TYPE(*CHAR) LEN(006)
             DCL        VAR(&TEST) TYPE(*CHAR) LEN(001)
             DCL        VAR(&TRUE) TYPE(*CHAR) LEN(001) VALUE('1')

             SNDPGMMSG  MSG(' **                              **   +
                          ') TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG(' **  Transmision para 14 DE MAYO **   +
                          ') TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG(' **                              **   +
                          ') TOPGMQ(*EXT) MSGTYPE(*COMP)

/* NCS410 - ACTIVE Condition not translatable.                      */
             IF         (* ACTIVE-TRANSO *) SNDPGMMSG MSG('LA +
                          TRANSMISION YA SE EFECTUA EN OTRA +
                          TERMINAL - CANCELO.') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)

/* NCS410 - ACTIVE Condition not translatable.                      */
             IF         (* ACTIVE-TRANSO *) SNDUSRMSG MSG('PAUSE - +
                          When ready, enter 0 to continue') +
                          TOMSGQ(*EXT)

/* NCS410 - ACTIVE Condition not translatable.                      */
             IF         (* ACTIVE-TRANSO *) RETURN
/* * CONTROL                                                        */
             CHGJOB     SWS(00000100)
             CALL       PGM(WHEROLO)
             CHGJOB     SWS(0000X000)
             IF         (%SWITCH(XXXX1XXX)) DO
             ENDDO
/* * TRASMISION      GOTO SOS?L'1,2'?                               */
/* * ELIMINA DEL COLB SI YA EXISTE EN EL COLBZ (CESAR DUARTE        */
/* 9/11/2011)                                                       */
             CALL       ONLINE/ELICOLB
             CPYF       FROMFILE(QS36F/COLBZ) TOFILE(QS36F/COLB) +
                          MBROPT(*ADD) CRTFILE(*NO) FMTOPT(*NOCHK)
             CPYF       FROMFILE(QS36F/SALDOAGY) +
                          TOFILE(QS36F/SALDOAG) CRTFILE(*YES) +
                          MBROPT(*REPLACE)
             SNDPGMMSG  MSG('ADDICIONA CUENTAS CON APERTURA EN +
                          PROCESO DE CIERRE') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             CALL       ONLINE/NCCME061
             SNDPGMMSG  MSG(' RESTO LOS DEPOSITOS EN CHEQUE 48, +
                          72, 96 HORAS') TOPGMQ(*EXT) MSGTYPE(*COMP)
             CALL       NLIBERA2
             SNDPGMMSG  MSG(' RESTO LOS DEPOSITOS EN CHEQUE 72, 96 +
                          HORAS M/E') TOPGMQ(*EXT) MSGTYPE(*COMP)
             CALL       CHEQME01
             SNDPGMMSG  MSG('PREPARA ARCHIVO DE INVENTARIO DE +
                          CUENTAS') TOPGMQ(*EXT) MSGTYPE(*COMP)
             CLRPFM     INVCTA01
             CALL       INVCTA01
             CALL       ACTPROM
             SNDPGMMSG  MSG('ACTIVA TRIGER PARA SAC AL ARCHIVO +
                          COLO Y FIRMAN1') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             CALL       SAC/TRFIRMAN1
             SNDPGMMSG  MSG('ENVIADO FICHERO COLO') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             CALL       PGM(WHEROLO)
 SOS01:
             CHGJOB     SWS(XXXX000X)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(HOLB) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DO
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(HOLBZ) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CLRPFM HOLB
             ENDDO
             ENDDO
             CPYF       FROMFILE(QS36F/HOLBZ) TOFILE(QS36F/HOLB) +
                          CRTFILE(*YES) MBROPT(*ADD)
             SNDPGMMSG  MSG('ENVIADO FICHERO HOLB') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             CALL       PGM(WHEROLO)
 SOS02:
             CHGJOB     SWS(XXXX000X)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(TARJOL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DO
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(TARJOL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CLRPFM TARJOL
             ENDDO
             CPYF       FROMFILE (QS36F/TARJOL) TOFILE +
                          (QS36F/TARJOL) CRTFILE (*YES) MBROPT(*ADD)
             SNDPGMMSG  MSG('ENVIADO FICHERO TARJOL') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             CALL       PGM(WHEROLO)
 SOS03:
             CHGJOB     SWS(XXXX000X)
/* * VERIFICAR QUE NO EXISTA DUPLICACION DE CHEQUES PARA MISMA      */
/* CUENTA                                                           */
/* *                                                                */
             OVRDBF     XEQZ XEQBZ
             CALL       RENXEQ
             DLTOVR     XEQZ
             OVRDBF     FILE(XEQZ) TOFILE(XEQBZ)
             OVRDBF     FILE(XEQ) TOFILE(XEQBC)
             CALL       PGM(SUMXEQ)
             DLTOVR     FILE(*ALL)
             RTVJOBA    DATE(&DATE)
             CPYF       FROMFILE (QS36F/XEQBZ) +
                          TOFILE(WRLIB/XEQ&DATE) MBROPT(*REPLACE) +
                          CRTFILE(YES)
             SNDPGMMSG  MSG('ENVIADO FICHERO XEQO') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
/* * BORRADO                                                        */
             CALL       PGM(WHEROLO)
 SOS04:
             CHGJOB     SWS(XXXX000X)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(COLBW) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DO
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(COLBZ) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DLTF FILE(COLBW)
             ENDDO
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(COLBZ) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) RNMOBJ OBJ(COLBZ) +
                          OBJTYPE(*FILE) NEWOBJ(COLBW)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(HOLBW) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DO
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(HOLBZ) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DLTF FILE(HOLBW)
             ENDDO
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(HOLBZ) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) RNMOBJ OBJ(HOLBZ) +
                          OBJTYPE(*FILE) NEWOBJ(HOLBW)
             CHGJOB     SWS(00000010)
             CALL       PGM(WHEROLO)
 SOS05:
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(MOCOB) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DLTF FILE(MOCOB)
/* * INICIALIZACION                                                 */
             OVRDBF     FILE(MOCO0) TOFILE(MOCOB)
             CALL       PGM(INICON)
             DLTOVR     FILE(*ALL)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(MOL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CLRPFM MOL
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(MOL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) DO
             SNDPGMMSG  MSG('ERROR, NO EXISTE ARCHIVO MOL') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDUSRMSG  MSG('PAUSE - When ready, enter 0 to +
                          continue') TOMSGQ(*EXT)
             ENDDO
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(AUXEQB) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) DO

/* NO DDS FOR BLDIND   EX PROCEDURE */
/* // IFF DATAF1-AUXEQB BLDINDEX AUXEQB,15,9,XEQB,,DUPKEY */

             ENDDO
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(MOLL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) DO

/* NO DDS FOR BLDIND   EX PROCEDURE */
/* // IFF DATAF1-MOLL BLDINDEX MOLL,17,7,MOL,,DUPKEY,,15,2,77,2 */

             ENDDO
             CPYF       FROMFILE(NOPOXB) TOFILE(NOPOSB) +
                          MBROPT(*REPLACE)
             CLRPFM     NOPOXB
/* ** REACTIVA EN FORMA AUTOMATICA CHEQUES CON ANULACIÓN TEMPORAL   */
/* ***                                                              */
             CALL       MODSUS01
             CHGJOB     SWS(00000000)
             SNDPGMMSG  MSG('    +
                          *****************************************+
                          **********************') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             SNDPGMMSG  MSG('             TRANSMISION TOTAL PARA +
                          AGENCIA 14 DE MAYO            *') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('    +
                          *****************************************+
                          **********************') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             SNDPGMMSG  MSG('   ') TOPGMQ(*EXT) MSGTYPE(*COMP)
             DLYJOB     DLY(10)
             SNDPGMMSG  MSG('BORRA ARCHIVOS PARA BANCA +
                          ELECTRONICA') TOPGMQ(*EXT) MSGTYPE(*COMP)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(TMCOLB) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DLTF FILE(TMCOLB)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(TMHOLB) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DLTF FILE(TMHOLB)
             SNDPGMMSG  MSG('    +
                          *****************************************+
                          **********************') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             SNDPGMMSG  MSG('    *     ADDICIONA MOVIMIENTOS DEL +
                          DIA ANTERIOR                  *') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             SNDPGMMSG  MSG('    +
                          *****************************************+
                          **********************') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             CALL       PGM(BTLIBC/BT050CL) PARM('X')
             CALL       ONLINEC/ADDMOLCL
             CLRPFM     QS36F/MOLCOBIN
             OVRDBF     FILE(MAECLCIN) TOFILE(INFONET/MAECLCIN)
             CALL       MOVEMOLI
             CALL       ONLINE/RMOVECB
             CALL       ADDMOLINF
             CALL       ONLINE/CLNCANDE
/* **** Se comenta el PGM ADDMOLIBCL y se lleva al proceso INFFICI  */
/* **** CALL IBANKING/ADDMOLIBCL                                    */
             RTVJOBA    DATE(&DATE)
             CHGDTAARA  DTAARA(QS36F/TRANSD (1 6)) VALUE('&DATE')
             CALL       TALIB/TAMOVDCL
             CALL       BTLIB_02/BTMOVDCL
             CALL       PGM(BORCCTRE)
             CALL       PGM(ONLINE/CREBAJ)
             CALL       ONLINE/CAMACDB
             CALL       ONLINE/ADDMPAB
             CALL       ONLINE/ADDMCNB
             OVRDBF     FILE(MOLPSAC) TOFILE(INFONET/MOLPSAC)
             CALL       ONLINE/ADDMPDSC
/* **** MODULOS PARA MANEJO DE AUMENTO/DISMINUCION DE INTERCHEQUE   */
/* POR PRESTAMO UNICO ****                                          */
             CALL       ONLINE/PSOPG034
             CALL       ITBPGLIB/NCPR072CL
/* **CALL ITBPGLIB/NCPR073CL ** PEDIDO DE OY DE SALDO               */
/* PROTEGIDO_ZPHG_11/2018                                           */
             CALL       ITBPGLIB/NCPR075CL
/* **** FIN/MODULOS PARA MANEJO DE AUMENTO/DISMINUCION DE           */
/* INTERCHEQUE POR PRESTAMO UNICO ****                              */
             SNDPGMMSG  MSG('        +
                          *****************************************+
                          **************************') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)

             ENDPGM
