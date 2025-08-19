**free
// ---------------------------------------------------------------
// Write IFS JSON document with SQL & RPG
// ---------------------------------------------------------------
// *ENTRY PLIST
dcl-pi SQT03002 ;
end-pi;

dcl-s  jsondoc    sqltype(CLOB:50000);
dcl-s  $exit      ind;
dcl-s  pathFile   char(200);
dcl-c  EOF        100;

Exec SQL
  SET OPTION COMMIT = *NONE,
             CLOSQLCSR=*ENDMOD,
             DLYPRP=*YES
  ;

pathFile = '/home/CESARD/Employee.json';

// Write empty file. If existing, it will be deleted first
Exec SQL
CALL qsys2.ifs_write(
PATH_NAME => TRIM(:pathFile),
LINE => '',
OVERWRITE => 'REPLACE',
FILE_CCSID => 284,
END_OF_LINE => 'NONE'
)
;

clear jsondoc;

// Build JSON document from Employee table
Exec SQL
SELECT JSON_OBJECT (
'employees' VALUE JSON_ARRAYAGG(
JSON_OBJECT (
'Emp ID'  VALUE EMPNO ,
'Name' VALUE TRIM(name) ,
'Dept ID' VALUE TRIM(WORKDEPT)  
)))
INTO  :jsondoc
FROM  cesardlib.employee
;

// Write JSON document to IFS file
Exec SQL
CALL qsys2.ifs_write(
PATH_NAME => TRIM(:pathFile),
LINE => :jsondoc,
OVERWRITE => 'APPEND',
FILE_CCSID => 284,
END_OF_LINE => 'CRLF'
)
;

*inLR=*on;
return;