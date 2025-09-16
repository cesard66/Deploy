**FREE
ctl-opt dftactgrp(*no) actgrp(*new) thread(*yes);

/* ==== Prototipos de APIs POSIX ==== */
dcl-pr pthread_create int(10) extproc('pthread_create');
   thread     pointer;
   attr       pointer value options(*nullind);
   start_rtn  pointer value;
   arg        pointer value;
end-pr;

dcl-pr pthread_join int(10) extproc('pthread_join');
   thread     pointer value;
   status     pointer;
end-pr;

dcl-pr pthread_exit extproc('pthread_exit');
   value      pointer value;
end-pr;

/* ==== Variables globales ==== */
dcl-s th1 pointer;
dcl-s th2 pointer;
dcl-s rc int(10);

/* ==== Procedimientos de los hilos ==== */
dcl-proc tarea1 export;
   dcl-pi *n pointer end-pi;

   dsply 'Hilo 1 ejecutando...';
   pthread_exit(*null);
end-proc;

dcl-proc tarea2 export;
   dcl-pi *n pointer end-pi;

   dsply 'Hilo 2 ejecutando...';
   pthread_exit(*null);
end-proc;

/* ==== Programa principal ==== */
dcl-s null ptr inz(*null);

rc = pthread_create(%addr(th1): null: %paddr(tarea1): null);
rc = pthread_create(%addr(th2): null: %paddr(tarea2): null);

rc = pthread_join(th1: null);
rc = pthread_join(th2: null);

dsply 'Programa principal terminado';
*inlr = *on;
return;
