**FREE
CTL-OPT DFTACTGRP(*NO) ACTGRP(*NEW);

 // --- Interfaz de parámetros ---
DCL-PI GetCfgVal;
   Context   CHAR(20) CONST;
   Key       CHAR(50) CONST;
   Value     CHAR(200);
END-PI;

 // --- Variable para SQLSTATE ---
DCL-S WSqlState CHAR(5);

 // --- Consulta SQL ---
EXEC SQL
   SELECT CFGVALUE
     INTO :Value
     FROM FLASHLIB.FLASHCFG
    WHERE trim(CFGCONTEXT) = trim(:Context)
      AND trim(CFGKEY)     = trim(:Key);

 // --- Manejo de "no encontrado" ---
WSqlState = SQLSTATE;
IF SqlState = '02000';  // Not found
   Value = '*NOTFOUND';
ENDIF;

*INLR = *ON;
RETURN;
// --- Fin del programa ---