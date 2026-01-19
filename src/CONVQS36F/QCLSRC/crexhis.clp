             PGM        PARM(&PM01 &PM04 &PM05 &PM06)

             DCL        VAR(&PM01) TYPE(*CHAR) LEN(032)
             DCL        VAR(&PM03) TYPE(*CHAR) LEN(032)
             DCL        VAR(&PM04) TYPE(*CHAR) LEN(032)
             DCL        VAR(&PM05) TYPE(*CHAR) LEN(032)
             DCL        VAR(&PM06) TYPE(*DEC) LEN(015)
             DCL        VAR(&TEST) TYPE(*CHAR) LEN(001)
             DCL        VAR(&TRUE) TYPE(*CHAR) LEN(001) VALUE('1')
             DCL        VAR(&WRK01) TYPE(*CHAR) LEN(032)

             CHGDTAARA  DTAARA(*LDA (1 32)) VALUE(&PM01)
/* EVALUATE PARAMETER LENGTH IGNORED */
             CHGVAR     VAR(&PM03) VALUE(((%SST(*LDA 003 004))))
/* EVALUATE PARAMETER LENGTH IGNORED */
             CHGVAR     VAR(&PM04) VALUE(((%SST(*LDA 003 002))))
/* EVALUATE PARAMETER LENGTH IGNORED */
             CHGVAR     VAR(&PM05) VALUE(((%SST(*LDA 005 002))))
/* EVALUATE PARAMETER LENGTH IGNORED */
             CHGVAR     VAR(&PM06) VALUE(&PM05 - 1)
             IF         (&PM06 *EQ '00') DO
/* EVALUATE PARAMETER LENGTH IGNORED */
             CHGVAR     VAR(&PM06) VALUE('12')
             ENDDO
             CPYF       FROMFILE(QS36F/CTESDO&PM04) +
                          TOFILE(EXTRAH/CTESDO&PM04&PM06) +
                          CRTFILE(*YES)
             CPYF       FROMFILE(QS36F/CAHSDO&PM04) +
                          TOFILE(EXTRAH/CAHSDO&PM04&PM06) +
                          CRTFILE(*YES)
             CPYF       FROMFILE(QS36F/HISTR&PM04) +
                          TOFILE(EXTRAH/HCT&PM04&PM06) CRTFILE(*YES)
             CPYF       FROMFILE(QS36F/CCMASL&PM04) +
                          TOFILE(EXTRAH/CCMASL&PM04&PM06) +
                          CRTFILE(*YES)
             CPYF       FROMFILE(QS36F/CCMANU&PM04) +
                          TOFILE(EXTRAH/CCMANU&PM04&PM06 +
                          CRTFILE(*YES)
             CHGVAR     VAR(&WRK01) VALUE(MVTRPF *CAT &PM04)
             CHGVAR     &TEST (&TRUE)
             CHKOBJ     OBJ(&WRK01) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR &TEST ('0'))
             IF         (&TEST *EQ &TRUE) CPYF +
                          FROMFILE(QS36F/MVTRPF&PM04) +
                          TOFILE(EXTRAH/MVTR&PM04&PM06) +
                          CRTFILE(*YES)
IF   (*NOT (&PM04  *GT '06'))   CPYF       +
                          FROMFILE(QS36F/HISTOC06) +
                          TOFILE(EXTRAH/HCA&PM04&PM06) +
                          CRTFILE(*YES) INCCHAR(RCD 11 *EQ '&PM04
             IF         (&PM04 *GT '06') CPYF +
                          FROMFILE(QS36F/HISTOC12) +
                          TOFILE(EXTRAH/HCA&PM04&PM06) +
                          CRTFILE(*YES) INCCHAR(RCD 11 *EQ '&PM04'

/* NCS201 - FILELIB statement not translated.                       */
// FILELIB NAME-EXTRAH,SESSION-NO


/* NO DDS FOR BLDIND   EX PROCEDURE */
/* // BLDINDEX HCT &PM04  &PM06 L,2,5,HCT &PM04  &PM06 ,,DUPKEY */


/* NO DDS FOR BLDIND   EX PROCEDURE */
/* // BLDINDEX HCA &PM04  &PM06 L,2,5,HCA &PM04  &PM06 ,,DUPKEY */


             ENDPGM
