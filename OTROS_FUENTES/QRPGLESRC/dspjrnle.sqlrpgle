**Free
        //==============================================================*
        // json_table                                                   *
        // FEC. CREACION: 12/11/2025          FEC.ULT.MOD.:   /  /      *
        //==============================================================*
        // For journal code R the possible journal entry types are:
        //
        // BR - Before-image of record updated for rollback
        // DL - Record deleted from physical file member
        // DR - Record deleted for rollback
        // IL - Increment record limit
        // PT - Record added to physical file member
        // PX - Record added directly to physical file member
        // UB - Before-image of record updated in physical file member
        // UP - After-image of record updated in physical file member
        // UR - After-image of record updated for rollback
        Ctl-Opt debug decedit(',') datedit(*DMY/) dftactgrp(*no) actgrp(*new);
        //--------------------------------------------------------------*
        dcl-F DSPJRND WORKSTN SFILE(PSF01:recno)
                SFILE(PSF02:recno2)
                SFILE(PSF03:recno3)
                SFILE(PSF04:recno4)
                SFILE(PSF05:recno5)
                SFILE(PSF06:recno6);
        dcl-f MYPRT printer(133) oflind(*in99);
        //--------------------------------------------------------------*
        dcl-DS *N PSDS;
            WUSER          Char(10)   Pos(254);
            WUSUA          Char(8)    Pos(254);
            WPROG          Char(10)   Pos(334);
       end-DS;
       //  Detalle de la linea del subfile donde se delimitan los campos
       dcl-Ds LinSfl         Len(72);
          JOURNAL_CODE_TYPE_LOG char(2) POS(01);
          Tim_LOG           char(22) Pos(05);
          Des_LOG           Char(40) Pos(28);
       end-Ds;
       dcl-s situar_tsh timestamp;
       dcl-s situar_tsd timestamp;
       dcl-s Journal_Receiver_Library  char(10);
       dcl-s Journal_Receiver_Name     char(10);
       dcl-s First_Sequence_Number     int(10);
       dcl-s Fecha_Hora_Coneccion      char(26);
       dcl-s Fecha_Hora_Desconeccion   char(26);
       dcl-s Estado                    char(10);
       dcl-s separador       CHAR(1) ;
       dcl-s STRINGPOSITION  INT(20) ;
       dcl-s REALSTORAGE     INT(20) ;
       dcl-s COLUMN_NAME     VARCHAR(128) ;
       dcl-s COLUMN_HEADING  VARCHAR(254) ;
       dcl-s DATA_TYPE       VARCHAR( 32 ) ;
       dcl-s DATA_TYPE_LENGTH VARCHAR( 32 ) ;
       dcl-s DATA_LENGTH     INT(20) ;
       dcl-s ORDINAL_POSITION INT(20) ;
       dcl-s FIELD_LENGTH    INT(20) ;
       dcl-s NUMERIC_SCALE   INT(20) ;
       dcl-s STORAGE         INT(20) ;
       dcl-s FIELD_CCSID     INT(20) ;
       dcl-s END_TABLE       INT(20) ;
       dcl-s MYTABLE_NAME    CHAR( 10 );
       dcl-s MYLIBRARY_NAME  CHAR( 10 );
       dcl-s MYTABLE_LIBRARY CHAR( 10 );
       dcl-s MYJOURNAL_LIBRARY CHAR(10);
       dcl-s MYJOURNAL_NAME CHAR(10);
       dcl-s MY_SYSTEM_TABLE_NAME  CHAR(10) ;
       dcl-s MY_SYSTEM_SCHEMA_NAME CHAR(10) ;
       dcl-s ENTRY_TIMESTAMP  timestamp;
       dcl-s JOURNAL_CODE  CHAR(1);
       dcl-s JOURNAL_CODE_TYPE  CHAR(2);
       dcl-s JRNTYPE CHAR(15);
       dcl-s JOB_NAME VARCHAR(10);
       dcl-s JOB_USER VARCHAR(10);
       dcl-s CURRENTUSER VARCHAR(10);
       dcl-s JOB_NUMBER VARCHAR(6);
       dcl-s FILE VARCHAR(10);
       dcl-s FILELIB VARCHAR(10);
       dcl-s FILEMBR VARCHAR(10);
       dcl-s OBJECT_TYPE VARCHAR(10);
       dcl-s PROGRAM_NAME VARCHAR(10);
       dcl-s PROGRAM_LIBRARY VARCHAR(10);
       dcl-s MYCMD  varchar(32672);
       dcl-s stmsql varchar(32672);
       dcl-s DATOS  varchar(32672);// SQLType( CLOB : 2000000 );
       dcl-s linea   char(130);
       dcl-s resto   int(10) inz(0);
       dcl-s offset  int(10) inz(0);
       dcl-s lenline int(10) inz(120);
       dcl-s lenstr  int(10) inz(120);
       dcl-s i       int(10);
       dcl-s len     int(10);
       dcl-s len_datos int(10);
       dcl-s len_datos1 int(10);
       dcl-s len_datos2 int(10);
       dcl-s CICLO   int(10) INZ(0);
       dcl-s Existe   packed(1:0);
       Dcl-ds line len(133) inz qualified;
           fcfc     char(1);
           *n       char(6);        // left margin
           text     Char(126);      // Ad-hoc text
           num      char(6)    overlay(text:*next);
           *n       char(6)    overlay(text:*next);
           ts       char(26)   overlay(text:*next);
       end-ds;
       dcl-ds   head1 likeds(line);
       dcl-ds   head2 likeds(line);
       dcl-ds   head3 likeds(line);
       dcl-ds   deta1 likeds(line);
       dcl-c TOP '1';       // Skip to top of  page
       dcl-c S1  ' ';       // Space 1 line & print
       dcl-c S2  '0';       // Space 2 lines & print t
       dcl-c S3  '-';       // Space 3 lines & Print t
       dcl-c S0  '+';       // Space 0, overprint
       dcl-s attrRed   char(1) inz(x'28');
       dcl-s attrBlue  char(1) inz(x'3A');
       dcl-s attrWhite  char(1) inz(x'22');
       dcl-s attrNormal char(1) inz(x'20');
       *in99 = *on;    // First page is always skip
       exec sql
        set option naming = *sys,
        commit = *none,
        usrprf = *user,
        dynusrprf = *user,
        datfmt = *iso,
        closqlcsr = *endmod;

       exec sql
         SELECT VARCHAR_FORMAT(CURRENT TIMESTAMP, 'YYYYMMDD')
         ,  VARCHAR_FORMAT(CURRENT TIMESTAMP, 'HH24MISS')
         into :FEC_CHARH, :HORA_CHARH
         FROM SYSIBM.SYSDUMMY1;

         FEC_CHARD = '00010101';
         HORA_CHARD = '000000';
       Exec SQL CALL QCMDEXC('CHGJOB CCSID(284)');
       Dow *IN03 = *OFF;
         RINICIO();
         RCARGA();
         RVISUAL();
         If *In03;
           LEAVE;
         Endif;
       ENDDO;
       *InLR = *On;
        //--------------------------------------------------------------*
        //    RUTINA PARA INICIAL SUBFILE                               *
        //--------------------------------------------------------------*
       dcl-proc RINICIO;
         recno = recno + 1;
         WRITE PSF01;
         WRITE PCL01;
         recno = 0;
         *IN50 = *ON;
         WRITE PCL01;
         WRITE PBLAN;
         *IN50 = *OFF;
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA CARGAR EL SUBFILE                             *
       //--------------------------------------------------------------*
       dcl-proc RCARGA;
         if FEC_CHARH = *blank;
             exec sql
               SELECT VARCHAR_FORMAT(CURRENT TIMESTAMP, 'YYYYMMDD')
               ,  VARCHAR_FORMAT(CURRENT TIMESTAMP, 'HHMMSS')
               into :FEC_CHARH, :HORA_CHARH
               FROM SYSIBM.SYSDUMMY1;
         endif;
         SITUAR_TSH = %timestamp(
                                 %subst(FEC_CHARH:1:4) + '-' +
                                 %subst(FEC_CHARH:5:2) + '-' +
                                 %subst(FEC_CHARH:7:2) + '-' +
                                 %subst(HORA_CHARH:1:2) + '.' +
                                 %subst(HORA_CHARH:3:2) + '.' +
                                 %subst(HORA_CHARH:5:2) + '.' +
                                 '000000'
                                 ) ;
         if FEC_CHARD = *blank;
            FEC_CHARD = '00010101';
            HORA_CHARD = '000000';
         endif;
         SITUAR_TSD = %timestamp(
                                 %subst(FEC_CHARD:1:4) + '-' +
                                 %subst(FEC_CHARD:5:2) + '-' +
                                 %subst(FEC_CHARD:7:2) + '-' +
                                 %subst(HORA_CHARD:1:2) + '.' +
                                 %subst(HORA_CHARD:3:2) + '.' +
                                 %subst(HORA_CHARD:5:2) + '.' +
                                 '000000'
                                 ) ;
       MYTABLE_NAME  = PTABLE;
       MYLIBRARY_NAME = PTABLELIB;
       MYTABLE_LIBRARY = PTABLELIB;
       MYJOURNAL_LIBRARY = PJOURNALL;
       MYJOURNAL_NAME = PJOURNAL;
       Exec Sql DECLARE CURSOR1 Scroll Cursor FOR
                SELECT CAST(COLUMN_NAME AS VARCHAR(128)) ,
                       CAST(COLUMN_HEADING AS VARCHAR(254)) ,
                       ORDINAL_POSITION ,
                       CAST(DATA_TYPE AS VARCHAR(32)) ,
                       LENGTH ,
                       COALESCE ( NUMERIC_SCALE , 0 ) ,
                       STORAGE ,
                       COALESCE ( CCSID , 0 )
                FROM QSYS2 . SYSCOLUMNS A
                WHERE ( SYSTEM_TABLE_NAME = :MYTABLE_NAME OR TABLE_NAME = :MYTABLE_NAME )
                AND ( SYSTEM_TABLE_SCHEMA = :MYTABLE_LIBRARY OR TABLE_SCHEMA = :MYTABLE_LIBRARY )
                ORDER BY ORDINAL_POSITION ;



        MYCMD = '' ;


        MY_SYSTEM_TABLE_NAME = *blank;
        Exec Sql
            SELECT SYSTEM_TABLE_NAME , SYSTEM_TABLE_SCHEMA
            INTO :MY_SYSTEM_TABLE_NAME , :MY_SYSTEM_SCHEMA_NAME
            FROM QSYS2 . SYSTABLES
            WHERE ( SYSTEM_TABLE_NAME = :MYTABLE_NAME OR TABLE_NAME = :MYTABLE_NAME )
            AND ( SYSTEM_TABLE_SCHEMA = :MYTABLE_LIBRARY OR TABLE_SCHEMA = :MYTABLE_LIBRARY ) ;

            if  MY_SYSTEM_TABLE_NAME <> *blank;

            MYCMD = %trim ( MYCMD ) + ' ' +
                    'SELECT ENTRY_TIMESTAMP,  ' +
                            'JOURNAL_CODE,  JOURNAL_ENTRY_TYPE,  ' +
                            'CASE WHEN JOURNAL_ENTRY_TYPE = ''PT'' ' +
                                'THEN ''INSERT'' ' +
                                'WHEN JOURNAL_ENTRY_TYPE = ''PX'' ' +
                                'THEN ''INSERT BY RRN'' ' +
                                'WHEN JOURNAL_ENTRY_TYPE = ''UB'' ' +
                                'THEN ''UPDATE BEFORE'' ' +
                                'WHEN JOURNAL_ENTRY_TYPE = ''UP'' ' +
                                'THEN ''UPDATE AFTER'' ' +
                                'WHEN JOURNAL_ENTRY_TYPE = ''DL'' ' +
                                'THEN ''DELETE'' ' +
                                'ELSE JOURNAL_ENTRY_TYPE ' +
                            'END AS JRNTYPE, ' +
                            'JOB_NAME, ' +
                            'JOB_USER, ' +
                            'CURRENT_USER as CURRENTUSER, ' +
                            'JOB_NUMBER , ' +
                            'SUBSTR(OBJECT, 1, 10) AS FILE, ' +
                            'SUBSTR(OBJECT, 11, 10) AS FILELIB, ' +
                            'SUBSTR(OBJECT, 21, 10) AS FILEMBR, ' +
                            'OBJECT_TYPE, ' +
                            'COALESCE(PROGRAM_NAME, '''') PROGRAM_NAME , ' +
                            'COALESCE(PROGRAM_LIBRARY,'''') PROGRAM_LIBRARY, ' +
                            'json_object(' ;
            STRINGPOSITION = 1 ;

        Exec Sql
            OPEN CURSOR1 ;
        Exec Sql
            FETCH CURSOR1 INTO :COLUMN_NAME , :COLUMN_HEADING , :ORDINAL_POSITION
                    , :DATA_TYPE , :FIELD_LENGTH , :NUMERIC_SCALE , :STORAGE , :FIELD_CCSID ;

        Dow SqlCod = 0;

        Select;
            WHEN DATA_TYPE = 'DATE' ;
                REALSTORAGE = 10 ;
            WHEN DATA_TYPE = 'TIME' ;
                REALSTORAGE = 08 ;
            WHEN DATA_TYPE = 'TIMESTMP' ;
                REALSTORAGE = 26 ;
            Other;
                REALSTORAGE = STORAGE ;
        endsl;

        Select;
        WHEN DATA_TYPE = 'DATE' ;
            DATA_TYPE_LENGTH = 'CHAR(10)';
        WHEN DATA_TYPE = 'TIME' ;
            DATA_TYPE_LENGTH = 'CHAR(08)';
        WHEN DATA_TYPE = 'TIMESTMP' ;
            DATA_TYPE_LENGTH = 'CHAR(26)';
        WHEN DATA_TYPE = 'FLOAT' AND FIELD_LENGTH = 16 ;
            DATA_TYPE_LENGTH = 'FLOAT';
        WHEN DATA_TYPE = 'FLOAT' AND FIELD_LENGTH = 8 ;
            DATA_TYPE_LENGTH = 'DOUBLE';
        WHEN DATA_TYPE = 'FLOAT' AND FIELD_LENGTH = 4 ;
            DATA_TYPE_LENGTH = 'REAL';
        Other;
            DATA_TYPE_LENGTH = DATA_TYPE;
        endsl ;


        if ORDINAL_POSITION <> 1;
           separador = ',';
        else;
           separador = '';
        endif;

        // FIELD NAME
        MYCMD = %trim( MYCMD ) +  separador +
        ' ''' +
        %trim( COLUMN_NAME )  +
        ''' VALUE ' ;
        // INTERPRET for each data_type
        // in a different way:
        // DATA as CHAR(10), TIME as CHAR(8), TIMESTAMP as CHAR(26)
        MYCMD = %trim ( MYCMD ) +
        ' INTERPRET(SUBSTR(ENTRY_DATA, ' +
        %trim(%char(STRINGPOSITION ) ) +
        ',  ' +
        %trim(%char( REALSTORAGE ) ) +
        ') AS ' +
        %trim( DATA_TYPE_LENGTH ) ;

        Select;
            WHEN DATA_TYPE = 'CHAR' OR
            DATA_TYPE = 'VARCHAR' OR
            DATA_TYPE = 'BINARY';
            MYCMD = %trim( MYCMD ) + ' (' + %trim(%char(FIELD_LENGTH ) ) + ') ) ' ;
            WHEN DATA_TYPE = 'DECIMAL' OR
            DATA_TYPE = 'NUMERIC';
            MYCMD = %trim( MYCMD ) + ' (' + %trim(%char( FIELD_LENGTH  ) ) + ',  ' +
                    %trim(%char( NUMERIC_SCALE ) ) + '))' ;
            Other;
            MYCMD = %trim( MYCMD ) + ')' ;
        endsl;




        STRINGPOSITION = STRINGPOSITION + REALSTORAGE ;

        Exec Sql
            FETCH CURSOR1 INTO :COLUMN_NAME , :COLUMN_HEADING , :ORDINAL_POSITION
                    , :DATA_TYPE , :FIELD_LENGTH , :NUMERIC_SCALE , :STORAGE , :FIELD_CCSID ;


        EndDo  ;

        Exec Sql
        CLOSE CURSOR1 ;

        MYCMD = %trim ( MYCMD ) +
        ' format JSON RETURNING VARCHAR(20000) ' +
        ') as Datos FROM TABLE(DISPLAY_JOURNAL(' +
        ' JOURNAL_LIBRARY => ''' + %trim(MYJOURNAL_LIBRARY) + '''' +
        ' ,JOURNAL_NAME => ''' + %trim(MYJOURNAL_NAME) + '''' +
        ' ,STARTING_RECEIVER_NAME =>  ''*CURAVLCHN'' ' +
        ' ,JOURNAL_CODES => ''R'' ' +
        ' ,OBJECT_LIBRARY => ''' + %trim(MY_SYSTEM_SCHEMA_NAME) + '''' +
        ' ,OBJECT_NAME => ''' + %trim(MY_SYSTEM_TABLE_NAME) + '''' +
        ' ,OBJECT_MEMBER => ''*ALL'' ' +
        ' ,OBJECT_OBJTYPE => ''*FILE'')) ' +
        ' WHERE Entry_Timestamp between ''' + %char(SITUAR_TSD)  + '''' +
        ' and ''' + %char(SITUAR_TSH)  + '''';
         if PTIPOJRN <> '  ';
             MYCMD = %trim ( MYCMD ) +
                              ' AND JOURNAL_ENTRY_TYPE = ''' +  PTIPOJRN + '''';

         endif;
         MYCMD = %trim ( MYCMD ) + ' ORDER BY Entry_Timestamp DESC';
         stmsql = %trim(MYCMD);
       //Prt_journal_CMD ();
         exec sql
           prepare SELECT2 from :stmsql;

         exec sql
           declare CURSOR2 cursor for SELECT2;

         exec sql open CURSOR2;

           dow 1 = 1;
               exec sql
                 fetch next from CURSOR2
                 into
                 :ENTRY_TIMESTAMP,
                 :JOURNAL_CODE,
                 :JOURNAL_CODE_TYPE,
                 :JRNTYPE,
                 :JOB_NAME,
                 :JOB_USER,
                 :CURRENTUSER,
                 :JOB_NUMBER,
                 :FILE,
                 :FILELIB,
                 :FILEMBR,
                 :OBJECT_TYPE,
                 :PROGRAM_NAME,
                 :PROGRAM_LIBRARY,
                 :DATOS;
               if sqlcode<>0;
                 leave;
                 endif;
               //if *in04 = *on;
               //   Prt_journal();
               //endif;
                 LinSfl =*blanks;
                 JOURNAL_CODE_TYPE_LOG = JOURNAL_CODE_TYPE;
                 Tim_LOG  = %char(Entry_Timestamp);
                 len_datos = %len(%trim(DATOS));
                 if len_datos < 40;
                    len_datos1 = len_datos;
                    else;
                    len_datos1 = 40;
                 endif;
                 if len_datos < 500;
                    len_datos2 = len_datos;
                    else;
                    len_datos2 = 500;
                 endif;
                 Des_LOG  = %subst(%trim(DATOS) : 1 : len_datos1);
                 Oculto   =   %subst(%trim(DATOS) : 1 : len_datos2);
                 Oculto2 =  attrWhite+ 'ENTRY_TIMESTAMP :' +
                            attrNormal +  %char(ENTRY_TIMESTAMP) +
                            attrWhite+ ' JOURNAL_CODE:' +
                            attrNormal + JOURNAL_CODE ;
                 Oculto3 =  attrWhite+ 'JRNTYPE :' +
                            attrNormal +  JOURNAL_CODE_TYPE +
                            attrWhite+ '-' +
                            attrNormal + JRNTYPE ;
                 Oculto4 = attrWhite+  'JOB_NAME : ' +
                           attrNormal + JOB_NAME +
                           attrWhite+ ' JOB_USER : ' +
                           attrNormal + JOB_USER +
                           attrWhite+ 'CURRENTUSER : ' +
                           attrNormal + CURRENTUSER;

                 recno += 1;
                 write PSF01 ;
                 Ctlfld = 0  ;

           enddo;
         exec sql
           close CURSOR2;
         endif;

         IF recno = 0;
           POPC  = '';
           LinSfl ='** sin datos **';
           recno = recno + 1;
           WRITE PSF01;
         ENDIF;
         TECLAS = 'F3=Salir  F4=s/Tipo Entrada  F6=Salida tabla  F7=Receptores  Enter=continuar';
       //TECLAS = 'F3=Salir  F4=Lista valores   F6=Salida tabla                 Enter=continuar';
         WRITE PIEPAG;
         // RGenera_tabla ();  //AQUI
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA VISUALIZAR EL SUBFILE                         *
       //--------------------------------------------------------------*
       dcl-proc RVISUAL;
         *In12 = *Off;
         EXFMT PCL01;
         WRITE PIEPAG;
         pmensa = *blanks;
         ConsultaSeleccion5();
         if *in04 = *on;
           select;
              when ZFIELD = 'PTIPOJRN';
                ConsultaSeleccion3();
            //when ZFIELD = 'PJOURNAL' or ZFIELD = 'PJOURNALL';
            //  ConsultaSeleccion4();
            //when ZFIELD = 'PTABLE' or ZFIELD = 'PTABLELIB';
            //  ConsultaSeleccion5();
              other;
                  // código si no se cumple ninguna condición
           endSL;
         endif;
         if *in06 = *on;
            if PTABLE <> *BLANKS;
              RGenera_tabla();
            else;
              pmensa = 'no ingreso tabla p/salida ';
            endif;
         endif;
         if *in07 = *on and  PTABLE <> *BLANKS;
              RVer_receptores();
         endif;
         RSELECC();
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA SELECCIONAR DATOS DEL SUBFILE                 *
       //--------------------------------------------------------------*
       dcl-proc RSELECC;
         *In98 = *Off;
         DOW *IN98 = *OFF;
           READC PSF01 ;
           *in98 = %eof();
            //---
           If *IN98 = *OFF AND POPC  = 'X' AND *IN12 = *OFF;
             *IN55 = *ON;
             ConsultaSeleccion();
             popc = '' ;
           ENDIF;
         ENDDO;
       end-proc;
       //------------------------------------------------------------**
       // Rutina para Consultar selección de registros
       //------------------------------------------------------------**
     //dcl-proc ConsultaSeleccion;
     //      DSC1= %subst(OCULTO:1:75) ;
       //    DSC2= %subst(OCULTO:76:75) ;
       //    DSC3= %subst(OCULTO:151:75) ;
       //    DSC4= %subst(OCULTO:226:75) ;
       //    DSC5= %subst(OCULTO:300:75) ;
     //      Exfmt CONSUL;
     //end-proc;
       //------------------------------------------------------------**
       // Rutina para Consultar selección de registros
       //------------------------------------------------------------**
       dcl-proc ConsultaSeleccion;
         RINICIO_Subfile2();
         RCARGA_Subfile2();
         RVISUAL_Subfile2();
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA INICIAL SUBFILE                               *
       //--------------------------------------------------------------*
       dcl-proc RINICIO_Subfile2;
         recno2 = recno2+ 1;
         WRITE PSF02;
         WRITE PCL02;
         recno2 = 0;
         *IN51 = *ON;
         WRITE PCL02;
         WRITE PBLAN;
         *IN51 = *OFF;
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA CARGAR EL SUBFILE                             *
       //--------------------------------------------------------------*
       dcl-proc RCARGA_Subfile2;
          LINSF2 =  attrWhite + '                 **** Informacion del Journal ****';
            recno2+= 1;
            write PSF02 ;
          LINSF2 =  OCULTO2;
            recno2+= 1;
            write PSF02 ;
          LINSF2 =  OCULTO3;
            recno2+= 1;
            write PSF02 ;
          LINSF2 =  OCULTO4;
            recno2+= 1;
            write PSF02 ;
          *in90 = *on;
          LINSF2 =  attrWhite + '                         **** datos ****';
            recno2+= 1;
            write PSF02 ;
          *in90 = *off;
         lenline = 72;
         offset = 1;
         CICLO = %int(%len(%trim(OCULTO)) / lenline + 1);
         if %len(%trim(DATOS)) > lenline;
            lenstr = lenline;
         else;
            lenstr = %len(%trim(OCULTO));
         endif ;
         for len = 1 to CICLO;
            line.text = '';
            resto=%len(%trim(OCULTO)) - offset;
            if resto < lenstr;
               lenstr= resto + 1;
            endif;
            if lenstr = 0;
               leave;
            endif;
            LINSF2  = %subst(%trim(OCULTO) : offset : lenstr);
            recno2+= 1;
            write PSF02 ;
            offset += lenline;
         endfor;


         IF recno2= 0;
           LinSf2 ='Sin datos';
           recno2= recno2+ 1;
           WRITE PSF02;
         ENDIF;
         WRITE PIEPAG;
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA VISUALIZAR EL SUBFILE                         *
       //--------------------------------------------------------------*
       dcl-proc RVISUAL_Subfile2;
         *In12 = *Off;
         EXFMT PCL02;
         WRITE PIEPAG;
       end-proc;

       //--------------------------------------------------------------*
       //    RUTINA PARA Imprimir el Journal                           *
       //------------------------------------------------------------**
       dcl-proc Prt_journal;
        if (*in99 = *on);
            *in99 = *off;
            head1.fcfc = TOP;
            head1.text = 'Impresion de Journal File:' + FILE + ' FILELIB:' +
                          FILELIB + ' OBJECT_TYPE : ' +
            OBJECT_TYPE;
            head2.fcfc = S2;
            head2.num = 'Number';
            head2.ts = %char(%TIMESTAMP());
            head3.fcfc = S1;
            head3.num = *all'_';
            head3.ts = *all'_';
            write MYPRT head1;
            write MYPRT head2;
            write MYPRT head3;
        endif;
        deta1.text =
        'ENTRY_TIMESTAMP :' + %char(ENTRY_TIMESTAMP) + ' JOURNAL_CODE:' + JOURNAL_CODE +
        ' JRNTYPE :' + JRNTYPE + ' JOB_NAME : ' + JOB_NAME + ' JOB_USER : ' + JOB_USER +
        'CURRENTUSER : ' + CURRENTUSER;
        deta1.fcfc = S1;
        write MYPRT deta1;
                 lenline = 120;
                 offset = 1;
                 CICLO = %int(%len(%trim(DATOS)) / lenline + 1);
                 if %len(%trim(DATOS)) > lenline;
                    lenstr = lenline;
                 else;
                    lenstr = %len(%trim(DATOS));
                 endif ;
                 for len = 1 to CICLO;
                    line.text = '';
                    resto=%len(%trim(DATOS)) - offset;
                    if resto < lenstr;
                       lenstr= resto + 1;
                    endif;
                    if lenstr = 0;
                       leave;
                    endif;
                    line.text  = %subst(%trim(DATOS) : offset : lenstr);
                    write MYPRT line;
                    offset += lenline;
                 endfor;
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA Imprimir el comando                           *
       //------------------------------------------------------------**
       dcl-proc Prt_journal_CMD;
        if (*in99 = *on);
            *in99 = *off;
            head1.fcfc = TOP;
            head1.text = 'Impresion de Journal File:' + FILE + ' FILELIB:' +
                         FILELIB + ' OBJECT_TYPE : ' +
            OBJECT_TYPE;
            head2.fcfc = S2;
            head2.num = 'Number';
            head2.ts = %char(%TIMESTAMP());
            head3.fcfc = S1;
            head3.num = *all'_';
            head3.ts = *all'_';
            write MYPRT head1;
            write MYPRT head2;
            write MYPRT head3;
        endif;
        deta1.text =
        'ENTRY_TIMESTAMP :' + %char(ENTRY_TIMESTAMP) + ' JOURNAL_CODE:' + JOURNAL_CODE +
        ' JRNTYPE :' + JRNTYPE + ' JOB_NAME : ' + JOB_NAME + ' JOB_USER : ' + JOB_USER +
        'CURRENTUSER : ' + CURRENTUSER;
        deta1.fcfc = S1;
        write MYPRT deta1;
                 lenline = 120;
                 offset = 1;
                 CICLO = %int(%len(%trim(MYCMD)) / lenline + 1);
                 if %len(%trim(MYCMD)) > lenline;
                    lenstr = lenline;
                 else;
                    lenstr = %len(%trim(MYCMD));
                 endif ;
                 for len = 1 to CICLO;
                    line.text = '';
                    resto=%len(%trim(MYCMD)) - offset;
                    if resto < lenstr;
                       lenstr= resto + 1;
                    endif;
                    if lenstr = 0;
                       leave;
                    endif;
                    line.text  = %subst(%trim(MYCMD) : offset : lenstr);
                    write MYPRT line;
                    offset += lenline;
                 endfor;
       end-proc;

       //------------------------------------------------------------**
       // Rutina para Consultar selección de registros
       //------------------------------------------------------------**
       dcl-proc ConsultaSeleccion3;
         RINICIO_Subfile3();
         RCARGA_Subfile3();
         RVISUAL_Subfile3();
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA INICIAL SUBFILE                               *
       //--------------------------------------------------------------*
       dcl-proc RINICIO_Subfile3;
         recno3 = recno3+ 1;
         WRITE PSF03;
         WRITE PCL03;
         recno3 = 0;
         *IN53 = *ON;
         WRITE PCL03;
       //WRITE PBLAN;
         *IN53 = *OFF;
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA CARGAR EL SUBFILE                             *
       //--------------------------------------------------------------*
       dcl-proc RCARGA_Subfile3;
       exec sql
         declare CURSOR3 cursor for
       select
       type_jrn
       , cast(type_jrn_des as char(55)) type_jrn_des
       from
        table
       ( values
       ('  ' , 'todas    '),
       ('BR' , 'Imagen anterior de registro actualizado para retrotracción'),
       ('DL' , 'Registro suprimido de miembro de archivo físico'),
       ('DR' , 'Registro suprimido para retrotracción'),
       ('IL' , 'Incrementar límite de registro'),
       ('PT' , 'Registro añadido a miembro de archivo físico'),
       ('PX' , 'Registro añadido directamente a miembro de archivo físico'),
       ('UB' , 'Imagen anterior de registro actualizado en miembro de archivo físico'),
       ('UP' , 'Imagen posterior de registro actualizado en miembro de archivo físico'),
       ('UR' , 'Imagen posterior de registro actualizado para retrotracción'))
            OPCION (type_jrn, type_jrn_des);
       exec sql
         Open CURSOR3;
        Dow SqlCod = 0;
            Exec Sql
                FETCH  CURSOR3 INTO :ptipo , :ptipds;
            if  SqlCod <>0;
                leave;
            endif;
            recno3+= 1;
            write PSF03 ;
        EndDo  ;

        Exec Sql
        CLOSE CURSOR3 ;


         IF recno3= 0;
           PTiPDS ='Sin datos';
           recno3= recno3+ 1;
           WRITE PSF03;
         ENDIF;
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA VISUALIZAR EL SUBFILE                         *
       //--------------------------------------------------------------*
       dcl-proc RVISUAL_Subfile3;
         *In12 = *Off;
         EXFMT PCL03;
         RSELECC3();
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA SELECCIONAR DATOS DEL SUBFILE                 *
       //--------------------------------------------------------------*
       dcl-proc RSELECC3;
         *In98 = *Off;
         DOW *IN98 = *OFF;
           READC PSF03 ;
         *in98 = %eof();
            //---
           If *IN98 = *OFF AND POPC3 = 'X' AND *IN12 = *OFF;
             popc3= '' ;
             PTipoJrn=  ptipo;
             PTipoDes=  ptipds;
           ENDIF;
         ENDDO;
       end-proc;
       //--------------------------------------------------------------*
       // Rutina para Consultar selección de registros
       //------------------------------------------------------------**
       dcl-proc ConsultaSeleccion4;
         RINICIO_Subfile4();
         RCARGA_Subfile4();
         RVISUAL_Subfile4();
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA INICIAL SUBFILE                               *
       //--------------------------------------------------------------*
       dcl-proc RINICIO_Subfile4;
         recno4 = recno4+ 1;
         WRITE PSF04;
         WRITE PCL04;
         recno4 = 0;
         *IN54 = *ON;
         WRITE PCL04;
       //WRITE PBLAN;
         *IN54 = *OFF;
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA CARGAR EL SUBFILE                             *
       //--------------------------------------------------------------*
       dcl-proc RCARGA_Subfile4;
       exec sql
         declare CURSOR4 cursor for
       SELECT JOURNAL_LIBRARY , JOURNAL_NAME FROM  QSYS2.JOURNALED_OBJECTS
       WHERE OBJECT_TYPE = '*FILE'
       GROUP BY JOURNAL_LIBRARY , JOURNAL_NAME
       ORDER BY JOURNAL_LIBRARY , JOURNAL_NAME;

       exec sql
         Open CURSOR4;
        Dow SqlCod = 0;
            Exec Sql
                FETCH  CURSOR4 INTO :PLIBJ, :PJRN ;
            if  SqlCod <>0;
                leave;
            endif;
            recno4+= 1;
            write PSF04 ;
        EndDo  ;

        Exec Sql
        CLOSE CURSOR4 ;


         IF recno4= 0;
           PJRN ='Sin datos';
           recno4= recno4+ 1;
           WRITE PSF04;
         ENDIF;
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA VISUALIZAR EL SUBFILE                         *
       //--------------------------------------------------------------*
       dcl-proc RVISUAL_Subfile4;
         *In12 = *Off;
         EXFMT PCL04;
         RSELECC4();
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA SELECCIONAR DATOS DEL SUBFILE                 *
       //--------------------------------------------------------------*
       dcl-proc RSELECC4;
         *In98 = *Off;
         DOW *IN98 = *OFF;
           READC PSF04 ;
           *in98 = %eof();
            //---
            If *IN98 = *OFF AND POPC4 = 'X' AND *IN12 = *OFF;
              popc4= '' ;
              PJOURNAL=  PJRN;
              PJOURNALL=  PLIBJ;
              PTABLE=  *blank;
              PTABLELIB=  *blank;
            ENDIF;
          ENDDO;
       end-proc;
       //--------------------------------------------------------------*
       // Rutina para Consultar selección de registros
       //------------------------------------------------------------**
       dcl-proc ConsultaSeleccion5;
       exec sql
         declare CURSOR5 cursor for
       SELECT JOURNAL_LIBRARY, JOURNAL_NAME, FILE_TYPE
       FROM  QSYS2.JOURNALED_OBJECTS
       WHERE OBJECT_TYPE = '*FILE'
       AND  OBJECT_NAME = :PTABLE    AND OBJECT_LIBRARY= :PTABLELIB;
     //AND  JOURNAL_LIBRARY = :PJOURNALL AND JOURNAL_NAME = :PJOURNAL;

       exec sql
         Open CURSOR5;
        Dow SqlCod = 0;
            Exec Sql
                FETCH  CURSOR5 INTO :PJOURNALL , :PJOURNAL, :PTYPE;
            if  SqlCod <>0;
                leave;
            endif;
        EndDo  ;

        Exec Sql
        CLOSE CURSOR5 ;

       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA CREAR UNA TABLA A PARTIR DEL JOURNAL          *
       //--------------------------------------------------------------*
       dcl-proc RGenera_tabla;
         pmens1= *blanks;
         pmensa= *blanks;
         plibou= *blanks;
         pfilou= *blanks;
         ptipou = 'S';
         existe= 1;
         dow 1 = 1;
           exfmt Ppan01;
           if *in12 = *on;
                leave;
           endif;
           exec sql
                SELECT COUNT(*) INTO :EXISTE
                  FROM QSYS2.SYSTABLES
                 WHERE TABLE_SCHEMA = :plibou
                   AND TABLE_NAME   = :pfilou;
           Select;
           WHEN Existe  = 1 ;
                pmens1= 'La tabla ya existe';
           WHEN pfilou = *blanks;
                pmens1= 'Ingrese tabla y libreria';
           other;
         //SITUAR_TS = %timestamp(
         //                        %subst(FECHA_CHAR:1:4) + '-' +
         //                        %subst(FECHA_CHAR:5:2) + '-' +
         //                        %subst(FECHA_CHAR:7:2) + '-' +
         //                        %subst(HORA_CHAR:1:2) + '.' +
         //                        %subst(HORA_CHAR:3:2) + '.' +
         //                        %subst(HORA_CHAR:5:2) + '.' +
         //                        '000000'
         //                        ) ;
           MYTABLE_NAME  = PTABLE;
           MYLIBRARY_NAME = PTABLELIB;
           MYTABLE_LIBRARY = PTABLELIB;
           MYJOURNAL_LIBRARY = PJOURNALL;
           MYJOURNAL_NAME = PJOURNAL;
           Exec Sql DECLARE CURSOR9 Scroll Cursor FOR
               SELECT CAST(COLUMN_NAME AS VARCHAR(128)) ,
                      CAST(COLUMN_HEADING AS VARCHAR(254)) ,
                      ORDINAL_POSITION ,
                      CAST(DATA_TYPE AS VARCHAR(32)) ,
                      LENGTH ,
                      COALESCE ( NUMERIC_SCALE , 0 ) ,
                      STORAGE ,
                      COALESCE ( CCSID , 0 )
               FROM QSYS2 . SYSCOLUMNS A
               WHERE ( SYSTEM_TABLE_NAME = :MYTABLE_NAME OR TABLE_NAME = :MYTABLE_NAME )
               AND ( SYSTEM_TABLE_SCHEMA = :MYTABLE_LIBRARY OR TABLE_SCHEMA = :MYTABLE_LIBRARY )
               ORDER BY ORDINAL_POSITION ;



           MYCMD = '' ;

           MY_SYSTEM_TABLE_NAME= *blank;
           Exec Sql
               SELECT SYSTEM_TABLE_NAME , SYSTEM_TABLE_SCHEMA
               INTO :MY_SYSTEM_TABLE_NAME , :MY_SYSTEM_SCHEMA_NAME
               FROM QSYS2 . SYSTABLES
               WHERE ( SYSTEM_TABLE_NAME = :MYTABLE_NAME OR TABLE_NAME = :MYTABLE_NAME )
               AND ( SYSTEM_TABLE_SCHEMA = :MYTABLE_LIBRARY OR TABLE_SCHEMA = :MYTABLE_LIBRARY ) ;

          if MY_SYSTEM_TABLE_NAME <> *blank;
               MYCMD = %trim ( MYCMD ) +
                       ' CREATE TABLE  ' + %trim(plibou) + '.' + %trim(pfilou) + ' AS (' +
                       'SELECT ';
               if ptipou = 'S';
               MYCMD = %trim ( MYCMD ) +
                              ' ENTRY_TIMESTAMP,  ' +
                               'JOURNAL_CODE,  ' +
                               'CASE WHEN JOURNAL_ENTRY_TYPE = ''PT'' ' +
                                   'THEN ''INSERT'' ' +
                                   'WHEN JOURNAL_ENTRY_TYPE = ''PX'' ' +
                                   'THEN ''INSERT BY RRN'' ' +
                                   'WHEN JOURNAL_ENTRY_TYPE = ''UB'' ' +
                                'THEN ''UPDATE BEFORE'' ' +
                                'WHEN JOURNAL_ENTRY_TYPE = ''UP'' ' +
                                'THEN ''UPDATE AFTER'' ' +
                                'WHEN JOURNAL_ENTRY_TYPE = ''DL'' ' +
                                'THEN ''DELETE'' ' +
                                'ELSE JOURNAL_ENTRY_TYPE ' +
                            'END AS JRNTYPE, ' +
                            'JOB_NAME, ' +
                            'JOB_USER, ' +
                            'CURRENT_USER as CURRENTUSER, ' +
                            'JOB_NUMBER , ' +
                            'SUBSTR(OBJECT, 1, 10) AS FILE, ' +
                            'SUBSTR(OBJECT, 11, 10) AS FILELIB, ' +
                            'SUBSTR(OBJECT, 21, 10) AS FILEMBR, ' +
                            'OBJECT_TYPE, ' +
                            'COALESCE(PROGRAM_NAME, '''') PROGRAM_NAME , ' +
                            'COALESCE(PROGRAM_LIBRARY,'''') PROGRAM_LIBRARY, ' ;
               endif;
           //-- Read all table columns from SYSCOLUMS catalog
               STRINGPOSITION = 1 ;

           Exec Sql
               OPEN CURSOR9 ;
           Exec Sql
               FETCH CURSOR9 INTO :COLUMN_NAME , :COLUMN_HEADING , :ORDINAL_POSITION
                       , :DATA_TYPE , :FIELD_LENGTH , :NUMERIC_SCALE , :STORAGE , :FIELD_CCSID ;

           Dow SqlCod = 0;

           Select;
               WHEN DATA_TYPE = 'DATE' ;
                   REALSTORAGE = 10 ;
               WHEN DATA_TYPE = 'TIME' ;
                   REALSTORAGE = 08 ;
               WHEN DATA_TYPE = 'TIMESTMP' ;
                   REALSTORAGE = 26 ;
               Other;
                REALSTORAGE = STORAGE ;
           endsl;

           Select;
           WHEN DATA_TYPE = 'DATE' ;
               DATA_TYPE_LENGTH = 'CHAR(10)';
           WHEN DATA_TYPE = 'TIME' ;
               DATA_TYPE_LENGTH = 'CHAR(08)';
           WHEN DATA_TYPE = 'TIMESTMP' ;
               DATA_TYPE_LENGTH = 'CHAR(26)';
           WHEN DATA_TYPE = 'FLOAT' AND FIELD_LENGTH = 16 ;
               DATA_TYPE_LENGTH = 'FLOAT';
           WHEN DATA_TYPE = 'FLOAT' AND FIELD_LENGTH = 8 ;
               DATA_TYPE_LENGTH = 'DOUBLE';
           WHEN DATA_TYPE = 'FLOAT' AND FIELD_LENGTH = 4 ;
               DATA_TYPE_LENGTH = 'REAL';
           Other;
               DATA_TYPE_LENGTH = DATA_TYPE;
           endsl ;


           if ORDINAL_POSITION <> 1;
              separador = ',';
           else;
              separador = '';
           endif;

           // FIELD NAME
           MYCMD = %trim( MYCMD ) +  separador ;
           MYCMD = %trim ( MYCMD ) +
           ' INTERPRET(SUBSTR(ENTRY_DATA, ' +
           %trim(%char(STRINGPOSITION ) ) +
           ',  ' +
           %trim(%char( REALSTORAGE ) ) +
           ') AS ' +
           %trim( DATA_TYPE_LENGTH ) ;

           Select;
               WHEN DATA_TYPE = 'CHAR' OR
               DATA_TYPE = 'VARCHAR' OR
               DATA_TYPE = 'BINARY';
           MYCMD = %trim( MYCMD ) + ' (' + %trim(%char(FIELD_LENGTH ) ) + ') ) ' ;
           WHEN DATA_TYPE = 'DECIMAL' OR
           DATA_TYPE = 'NUMERIC';
           MYCMD = %trim( MYCMD ) + ' (' + %trim(%char( FIELD_LENGTH  ) ) + ',  ' +
                   %trim(%char( NUMERIC_SCALE ) ) + '))' ;
           Other;
           MYCMD = %trim( MYCMD ) + ')' ;
           endsl;
           MYCMD = %trim( MYCMD ) +
           ' AS ' +
           %trim( COLUMN_NAME )  ;

           STRINGPOSITION = STRINGPOSITION + REALSTORAGE ;

           Exec Sql
               FETCH CURSOR9 INTO :COLUMN_NAME , :COLUMN_HEADING , :ORDINAL_POSITION
                    , :DATA_TYPE , :FIELD_LENGTH , :NUMERIC_SCALE , :STORAGE , :FIELD_CCSID ;


           EndDo  ;

           Exec Sql
           CLOSE CURSOR9 ;

           // ENCODING UTF8
           MYCMD = %trim ( MYCMD ) +
           ' FROM TABLE(DISPLAY_JOURNAL(' +
           ' JOURNAL_LIBRARY => ''' + %trim(MYJOURNAL_LIBRARY) + '''' +
           ' ,JOURNAL_NAME => ''' + %trim(MYJOURNAL_NAME) + '''' +
           ' ,STARTING_RECEIVER_NAME =>  ''*CURAVLCHN'' ' +
           ' ,JOURNAL_CODES => ''R'' ' +
           ' ,OBJECT_LIBRARY => ''' + %trim(MY_SYSTEM_SCHEMA_NAME) + '''' +
           ' ,OBJECT_NAME => ''' + %trim(MY_SYSTEM_TABLE_NAME) + '''' +
           ' ,OBJECT_MEMBER => ''*ALL'' ' +
           ' ,OBJECT_OBJTYPE => ''*FILE'')) ' +
           ' WHERE Entry_Timestamp between ''' + %char(SITUAR_TSD)  + '''' +
           ' and ''' + %char(SITUAR_TSH)  + '''';
           if PTIPOJRN <> '  ';
              MYCMD = %trim ( MYCMD ) +
                               ' AND JOURNAL_ENTRY_TYPE = ''' +  PTIPOJRN + '''';

           endif;
           MYCMD = %trim ( MYCMD ) + ' ) WITH DATA ';

           stmsql = %trim(MYCMD);
           exec sql execute immediate :stmsql;
               if sqlcode=-601;
                  Existe = 1;
                  pmens1= 'La tabla ya existe';
                  iter;
               endif;
             pmensa = 'Se ha creado la tabla ' +
                       %trim(pfilou) + ' en la libreria ' + %trim(plibou) ;
             else;
             pmensa = 'tabla no existe';
             endif;
            leave;
            endsl;
         enddo;

       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA CREAR UNA TABLA A PARTIR DEL JOURNAL          *
       //--------------------------------------------------------------*
       dcl-proc RVer_receptores;
         RINICIO_Subfile6();
         RCARGA_Subfile6();
         RVISUAL_Subfile6();
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA INICIAL SUBFILE                               *
       //--------------------------------------------------------------*
       dcl-proc RINICIO_Subfile6;
         recno6 = recno6+ 1;
         WRITE PSF06;
         WRITE PCL06;
         recno6 = 0;
         *IN56 = *ON;
         WRITE PCL06;
         *IN56 = *OFF;
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA CARGAR EL SUBFILE                             *
       //--------------------------------------------------------------*
       dcl-proc RCARGA_Subfile6;
       exec sql
         declare CURSOR6 cursor for
         Select Journal_Receiver_Library,
                Journal_Receiver_Name,
                First_Sequence_Number,
                varchar(Attach_Timestamp) As Fecha_Hora_Coneccion,
                coalesce(varchar(Detach_Timestamp) , '0000-00-00-00.00.00.000000')
                                                   As Fecha_Hora_Desconeccion,
                Case Status
                    When 'ATTACHED' Then 'CONECTADO'
                    When 'ONLINE' Then 'EN LINEA'
                    When 'SAVED' Then 'SALVADO'
                    When 'FREED' Then 'LIBERADO'
                    When 'PARTIAL' Then 'PARCIAL'
                End As Estado
             From Qsys2.Journal_Receiver_Info
             Where Journal_Library =  :PJOURNALL
                   And Journal_Name = :PJOURNAL;
       exec sql
         Open CURSOR6;
        Dow SqlCod = 0;
            Exec Sql
                FETCH  CURSOR6 INTO
                :Journal_Receiver_Library,
                :Journal_Receiver_Name,
                :First_Sequence_Number,
                :Fecha_Hora_Coneccion,
                :Fecha_Hora_Desconeccion,
                :Estado;
            if  SqlCod <>0;
                leave;
            endif;
            PLIBJRN = %trim(Journal_Receiver_Library) + '/' +
                      %trim(Journal_Receiver_Name);
            PSECUE  = First_Sequence_Number;
            PHORDES = %char(Fecha_Hora_Coneccion);
            PHORHAS = %char(Fecha_Hora_Desconeccion);
            PESTADO = Estado;
            recno6+= 1;
            write PSF06 ;
        EndDo  ;

        Exec Sql
        CLOSE CURSOR6 ;


         IF recno6= 0;
           recno6= recno6+ 1;
           WRITE PSF06;
         ENDIF;
       end-proc;
       //--------------------------------------------------------------*
       //    RUTINA PARA VISUALIZAR EL SUBFILE                         *
       //--------------------------------------------------------------*
       dcl-proc RVISUAL_Subfile6;
         *In12 = *Off;
         EXFMT PCL06;
       end-proc;