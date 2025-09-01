/*                                                                  */
             PGM

             DCL        VAR(&USER) TYPE(*CHAR) LEN(010)

             RTVJOBA    USER(&USER)
             CHGDTAARA  DTAARA(*LDA (1 19)) VALUE(&USER *TCAT '    -
   ')

/* NCS410 - ACTIVE Condition not translatable.                      */
             IF         (* ACTIVE-LISCAJ *) SNDPGMMSG MSG('NO SE +
                          PUEDE SOLICITAR ESTE LISTADO EN DOS +
                          PANTALLAS SIMULTANEAMENTE') TOPGMQ(*EXT) +
                          MSGTYPE(*COMP)

/* NCS410 - ACTIVE Condition not translatable.                      */
             IF         (* ACTIVE-LISCAJ *) SNDUSRMSG MSG('PAUSE - +
                          When ready, enter 0 to continue') +
                          TOMSGQ(*EXT)

/* NCS410 - ACTIVE Condition not translatable.                      */
             IF         (* ACTIVE-LISCAJ *) RETURN
             CHGJOB     SWS(00000000)
             OVRDBF     FILE(MOLO) TOFILE(MOL)
             OVRDBF     FILE(TOL) TOFILE(TOLB)
             OVRPRTF    FILE(AUDICINT) PAGESIZE(66) FORMTYPE(RE66) +
                          COPIES(1) OUTPTY(9) HOLD(*YES)
             CALL       (ONLINEC/LISCAJ)
             DLTOVR     FILE(*ALL)

/* UNEXPECTED ERROR OCCURS ON NEXT LINE, REFER TO MANUAL.           */
// IF SWITCH8-1* ' &USER , USTED NO ESTA AUTORIZADO A UTILIZAR ESTE PROGRAMA'

             IF         (%SWITCH(XXXXXXX1)) SNDUSRMSG MSG('PAUSE - +
                          When ready, enter 0 to continue') +
                          TOMSGQ(*EXT)

             ENDPGM
