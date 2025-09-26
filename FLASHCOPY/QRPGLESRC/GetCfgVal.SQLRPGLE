**FREE
CTL-OPT DFTACTGRP(*NO) ACTGRP(*NEW);

 // --- Interfaz de parámetros ---
DCL-PI GetCfgVal;
   Context   VARCHAR(20) CONST;
   Key       VARCHAR(50) CONST;
   Value     VARCHAR(200);
END-PI;

 // --- Variable para SQLSTATE ---
DCL-S SqlState CHAR(5);

 // --- Consulta SQL ---
EXEC SQL
   SELECT CFGVALUE
     INTO :Value
     FROM FLASHLIB.FLASHCFG
    WHERE CFGCONTEXT = :Context
      AND CFGKEY     = :Key;

 // --- Manejo de "no encontrado" ---
SqlState = SQLSTATE;
IF SqlState = '02000';  // Not found
   Value = '*NOTFOUND';
ENDIF;

*INLR = *ON;
RETURN;
// --- Fin del programa ---