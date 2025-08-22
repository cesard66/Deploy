/*                                                                  */
/*  CREACION DE SALDOS A PARTIR DE LAS BAJAS                        */
/*                                                                  */
             PGM

             DCL        VAR(&TEST) TYPE(*CHAR) LEN(001)
             DCL        VAR(&TRUE) TYPE(*CHAR) LEN(001) VALUE('1')

             CHGCURLIB  EXP.LIBR
             CALL       PGM(REX80A)
/*                                                                  */
/*  INVENTARIO DE REMESA DE COBRANZAS  EXPORTACION                  */
/*                                                                  */
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(REX.@@@) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) DLTF FILE(REX.@@@)
             CPYF       FROMFILE(REX.ALT) TOFILE(QS36F/(REX.@@@)) +
                          CRTFILE(*YES) INCCHAR(*RCD 0326 *NE +
                          '000000000000000') COMPRESS(*NO)
             SNDPGMMSG  MSG('Clasificacion de archivo') +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
             CLRPFM     FILE(QTEMP/ADDROUT)
             MONMSG     MSGID(CPF3142) EXEC(CRTPF +
                          FILE(QTEMP/ADDROUT) RCDLEN(4) +
                          SIZE(*NOMAX))
             FMTDTA     INFILE((*LIBL/REX.@@@)) +
                          OUTFILE(QTEMP/ADDROUT) +
                          SRCFILE(CONVQS36F/SORTSRC) +
                          SRCMBR(SORT000116) OPTION(*NOPRT)
/* *IFF DATAF1-REX.AXZ BLDINDEX REX.AXZ,27,7,REX.ALT,,DUPKEY,,11,4, */
/* 6,5                                                              */
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(REX.BXZ) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (*NOT (&TEST *EQ &TRUE)) DO

/* NO DDS FOR BLDIND   EX PROCEDURE */
/* // IFF DATAF1-REX.BXZ BLDINDEX REX.BXZ,4,11,REX.BAJ,,DUPKEY */

             ENDDO
             CALL       PGM(EXP.LIBR/PARAM) PARM(REX80)
             SNDPGMMSG  MSG('REX80- INVENTARIO DE REMESA COBRANZAS +
                          (REX)') TOPGMQ(*EXT) MSGTYPE(*COMP)
             OVRDBF     FILE(REXALT) TOFILE(REX.@@@)
             OVRDBF     FILE(ADDROUT) TOFILE(ADDROUT)
             OVRDBF     FILE(REXBAJ) TOFILE(REX.BXZ)
             OVRDBF     FILE(PRCATAST) TOFILE(PRCATAST)
             OVRDBF     FILE(MONEDA) TOFILE(MONEDA)
             OVRPRTF    FILE(LREX801) PAGESIZE(66) FORMTYPE(RE66) +
                          OUTPTY(9) HOLD(*YES)
             CALL       (EXP.LIBR/REX80)
             DLTOVR     FILE(*ALL)
             DLTF       FILE(REX.@@@)
             DLTF       FILE(REX.BXZ)

             ENDPGM
