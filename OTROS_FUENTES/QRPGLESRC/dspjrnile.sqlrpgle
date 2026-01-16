**Free
        //==============================================================*
        //                                                              *
        // FEC. CREACION: 12/11/2025          FEC.ULT.MOD.:   /  /      *
        //==============================================================*
       Ctl-Opt DEBUG DECEDIT(',') DATEDIT(*DMY/);
        //--------------------------------------------------------------*
        //Dcl-F CONJRND WORKSTN SFILE(PSF01:recno);
        //--------------------------------------------------------------*
       Dcl-DS *N  PSDS;
         WUSER          Char(10)   Pos(254);
         WUSUA          Char(8)    Pos(254);
         WPROG          Char(10)   Pos(334);
       //--------------------------------------------------------------*
       End-DS;
       //  Detalle de la linea del subfile donde se delimitan los campos
       Dcl-Ds LinSfl         Len(72);
          COD_LOG           char(21) Pos(01);
          DES_LOG           Char(40) Pos(23);
       End-Ds;

       Dcl-s STRINGPOSITION  INT(10) ;
       Dcl-s REALSTORAGE     INT(10) ;
       Dcl-s COLUMN_NAME     CHAR(128) ;
       Dcl-s COLUMN_HEADING  CHAR(254) ;
       Dcl-s DATA_TYPE       CHAR( 32 ) ;
       Dcl-s DATA_TYPE_LENGTH CHAR( 32 ) ;
       Dcl-s DATA_LENGTH     INT(10) ;
       Dcl-s ORDINAL_POSITION INT(10) ;
       Dcl-s FIELD_LENGTH    INT(10) ;
       Dcl-s NUMERIC_SCALE   INT(10) ;
       Dcl-s STORAGE         INT(10) ;
       Dcl-s FIELD_CCSID     INT(10) ;
       Dcl-s END_TABLE       INT(10) ;
       Dcl-s MYTABLE_NAME    CHAR( 10 ) inz('ALUMNOS');
       Dcl-s MYLIBRARY_NAME  CHAR( 10 ) inz('CESARDLIB');
       dcl-s MYTABLE_LIBRARY CHAR( 10 ) inz('CESARDLIB') ;
       dcl-s MYJOURNAL_LIBRARY CHAR(10) inz('CESARDLIB') ;
       dcl-s MYJOURNAL_NAME CHAR(10) inz('QSQJRN') ;
       Dcl-s MY_SYSTEM_TABLE_NAME  CHAR(128) ;
       Dcl-s MY_SYSTEM_SCHEMA_NAME CHAR(128) ;
       dcl-s MYCMD VARCHAR(32000);

       Exec Sql DECLARE CURSOR1 Scroll Cursor FOR
                SELECT COLUMN_NAME , COLUMN_HEADING , ORDINAL_POSITION
                , DATA_TYPE , LENGTH , COALESCE ( NUMERIC_SCALE , 0 ) NUMERIC_SCALE
                , STORAGE , COALESCE ( CCSID , 65535 ) FIELD_CCSID
                FROM QSYS2 . SYSCOLUMNS A
                WHERE ( SYSTEM_TABLE_NAME = :MYTABLE_NAME OR TABLE_NAME = :MYTABLE_NAME )
                AND ( SYSTEM_TABLE_SCHEMA = :MYTABLE_LIBRARY OR TABLE_SCHEMA = :MYTABLE_LIBRARY )
                ORDER BY ORDINAL_POSITION ;



        MYCMD = '' ;

        // Retrieve SYSTEM TABLE and SCHEMA name (you can call this procedure passing SQL Table Name o
        // System Table Name)

        Exec Sql
            SELECT SYSTEM_TABLE_NAME , SYSTEM_TABLE_SCHEMA
            INTO :MY_SYSTEM_TABLE_NAME , :MY_SYSTEM_SCHEMA_NAME
            FROM QSYS2 . SYSTABLES
            WHERE ( SYSTEM_TABLE_NAME = :MYTABLE_NAME OR TABLE_NAME = :MYTABLE_NAME )
            AND ( SYSTEM_TABLE_SCHEMA = :MYTABLE_LIBRARY OR TABLE_SCHEMA = :MYTABLE_LIBRARY ) ;

            MYCMD = %trim ( MYCMD ) + ' ' +
                    'SELECT ENTRY_TIMESTAMP , ' +
                            'JOURNAL_CODE , ' +
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
                            'SUBSTR(OBJECT,1,10) AS FILE, ' +
                            'SUBSTR(OBJECT,11,10) AS FILELIB, ' +
                            'SUBSTR(OBJECT,21,10) AS FILEMBR, ' +
                            'OBJECT_TYPE, ' +
                            'PROGRAM_NAME , ' +
                            'PROGRAM_LIBRARY ' ;
        //-- Read all table columns from SYSCOLUMS catalog
            STRINGPOSITION = 1 ;

        Exec Sql
            OPEN CURSOR1 ;
        Exec Sql
            FETCH CURSOR1 INTO :COLUMN_NAME , :COLUMN_HEADING , :ORDINAL_POSITION
                    , :DATA_TYPE , :FIELD_LENGTH , :NUMERIC_SCALE , :STORAGE , :FIELD_CCSID ;

        Dow SqlCod = 0;

        // Set the REALSTORAGE length considering case for DATE/TIME/TIMESTAMT different from STORAGE in th
        // in the SYSCOMUMNS (Why??)
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


        // INTERPRET for each data_type (Pay attention, some DATA_TYPE are stored in the journal ENTRY_DATA
        // in a different way:
        // DATA as CHAR(10), TIME as CHAR(8), TIMESTAMP as CHAR(26)
        MYCMD = %trim ( MYCMD ) +
        ' , INTERPRET(SUBSTR(ENTRY_DATA ,' +
        %trim(%char(STRINGPOSITION ) ) +
        ' , ' +
        %trim(%char( REALSTORAGE ) ) +
        ') AS ' +
        %trim( DATA_TYPE_LENGTH ) ;

        Select;
            WHEN DATA_TYPE = 'CHAR' OR
            DATA_TYPE = 'VARCHAR' OR
            DATA_TYPE = 'BINARY';
            MYCMD = %trim( MYCMD ) + ' (' + %trim(%char(FIELD_LENGTH ) ) + ')) ' ;
            WHEN DATA_TYPE = 'DECIMAL' OR
            DATA_TYPE = 'NUMERIC';
            MYCMD = %trim( MYCMD ) + ' (' + %trim(%char( FIELD_LENGTH  ) ) + ' , ' +
                    %trim(%char( NUMERIC_SCALE ) ) + '))' ;
            Other;
            MYCMD = %trim( MYCMD ) + ')' ;
        endsl;

        // FIELD NAME
        MYCMD = %trim( MYCMD ) +
        ' AS ' +
        %trim( COLUMN_NAME ) ;



        STRINGPOSITION = STRINGPOSITION + REALSTORAGE ;

        Exec Sql
            FETCH CURSOR1 INTO :COLUMN_NAME , :COLUMN_HEADING , :ORDINAL_POSITION
                    , :DATA_TYPE , :FIELD_LENGTH , :NUMERIC_SCALE , :STORAGE , :FIELD_CCSID ;


        EndDo  ;

        Exec Sql
        CLOSE CURSOR1 ;

        MYCMD = %trim ( MYCMD ) +
        ' FROM TABLE(DISPLAY_JOURNAL(' +
        ' JOURNAL_LIBRARY  => ''' + MYJOURNAL_LIBRARY + '''' +
        ' ,JOURNAL_NAME    => ''' + MYJOURNAL_NAME + '''' +
        ' ,STARTING_RECEIVER_NAME =>  ''*CURAVLCHN'' ' +
        ' ,JOURNAL_CODES   => ''R'' ' +
        ' ,OBJECT_LIBRARY  => ''' + MY_SYSTEM_SCHEMA_NAME + '''' +
        ' ,OBJECT_NAME     => ''' + MY_SYSTEM_TABLE_NAME + '''' +
        ' ,OBJECT_MEMBER   => ''*ALL'' ' +
        ' ,OBJECT_OBJTYPE  => ''*FILE'' )))' ;

        *InLR = *On;
