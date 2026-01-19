**free
ctl-opt dftactgrp(*no) actgrp(*caller);

/**********************************************************
 * Prototipos de pthread
 **********************************************************/
dcl-pr pthread_create int(10) extproc('pthread_create');
  threadptr    pointer;               // (pthread_t *)
  attr         pointer value options(*omit);
  startRoutine pointer value;         // (void *(*)(void *))
  arg          pointer value;         // (void *)
end-pr;

dcl-pr pthread_join int(10) extproc('pthread_join');
  threadptr    pointer value;
  retval       pointer;
end-pr;

/**********************************************************
 * Estructura para pasar parámetros
 **********************************************************/
dcl-ds ThreadArg qualified template;
  id 10i 0;
end-ds;

/**********************************************************
 * Procedimiento del thread
 **********************************************************/
dcl-pr myThreadProc pointer export;
  arg pointer value;
end-pr;

dcl-proc myThreadProc export;
  dcl-pi *n pointer;
    arg pointer value;
  end-pi;

  dcl-ds parm likeds(ThreadArg) based(arg);

  if arg <> *null;
     dsply ('Hola desde el thread #' + %char(parm.id));
  else;
     dsply ('Thread sin argumentos');
  endif;

  return *null;
end-proc;

/**********************************************************
 * Programa principal
 **********************************************************/
dcl-s thread pointer dim(3);
dcl-s args likeds(ThreadArg) dim(3);
dcl-s rc 10i 0;

for i = 1 to 3;
   args(i).id = i;
   rc = pthread_create(%addr(thread(i)) :
                       *omit :
                       %paddr(myThreadProc) :
                       %addr(args(i)));
   if rc <> 0;
      dsply ('Error creando thread ' + %char(i));
   endif;
endfor;

// Esperar a que terminen
for i = 1 to 3;
   rc = pthread_join(thread(i) : *null);
endfor;

dsply ('Todos los threads finalizaron.');
*inlr = *on;