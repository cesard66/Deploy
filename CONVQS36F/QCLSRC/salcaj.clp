             PGM        PARM(&PM01 &PM10)

             DCL        VAR(&PM01) TYPE(*CHAR) LEN(032)
             DCL        VAR(&PM10) TYPE(*CHAR) LEN(032)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(010)
             DCL        VAR(&WORK) TYPE(*CHAR) LEN(032)

             RTVJOBA    USER(&USER)
             CALL       VERAGECL PARM(&USER)
/* EVALUATE PARAMETER LENGTH IGNORED */
             CHGVAR     VAR(&PM10) VALUE(((%SST(*LDA 035 002))))
/* EVALUATE PARAMETER LENGTH IGNORED */
             CHGVAR     VAR(&PM01) VALUE(((%SST(*LDA 035 002))))
             CHGJOB     SWS(00000000)
             IF         (&USER *EQ 'SEVERIANO') SNDPGMMSG MSG('POR +
                          FAVOR INGRESE EL CODIGO DE AGENCIA A +
                          VISUALIZAR (DD)') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             SNDUSRMSG  MSG('Enter Required Parameter') +
                          TOMSGQ(*EXT) MSGRPY(&WORK)
             IF         (&USER *EQ 'SEVERIANO') DO
/* EVALUATE PARAMETER LENGTH IGNORED */
             CHGVAR     VAR(&PM01) VALUE((&WORK))
             ENDDO
             IF         (&USER *EQ 'SEVERIANO') CHGJOB SWS(00000100)
             IF         (&USER *EQ 'AGUSTING') SNDPGMMSG MSG('POR +
                          FAVOR INGRESE EL CODIGO DE AGENCIA A VI +
                          SUALIZAR (DD)') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)
             SNDUSRMSG  MSG('Enter Required Parameter') +
                          TOMSGQ(*EXT) MSGRPY(&WORK)
             IF         (&USER *EQ 'AGUSTING') DO
/* EVALUATE PARAMETER LENGTH IGNORED */
             CHGVAR     VAR(&PM01) VALUE((&WORK))
             ENDDO
             IF         (&USER *EQ 'AGUSTING') CHGJOB SWS(00000100)
             CPYF       FROMFILE(QS36F/TOLB) +
                          TOFILE(QS36F/TOLBW&PM10) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF DEPEN *EQ '&PM01'))
             ALCOBJ     OBJ((TOLBW&PM10 *FILE *EXCL))
             OVRDBF     FILE(TOLO) TOFILE(TOLBW *CAT &PM10)
             CALL       PGM(SALCAJ)
             DLTOVR     FILE(*ALL)
             IF         (%SWITCH(X1XXXXXX)) SNDPGMMSG MSG('UD.NO +
                          ESTA AUTORIZADO A USAR ESTE PROGRAMA.. +
                          ') TOPGMQ(*EXT) MSGTYPE(*COMP)
             IF         (%SWITCH(X1XXXXXX)) SNDUSRMSG MSG('PAUSE - +
                          When ready, enter 0 to continue') +
                          TOMSGQ(*EXT)
             DLCOBJ     OBJ((TOLBW&PM10 *FILE *EXCL))
             CHGJOB     SWS(00000000)

             ENDPGM
