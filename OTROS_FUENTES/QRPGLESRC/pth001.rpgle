**free
ctl-opt dftactgrp(*no) actgrp(*caller);

dcl-pr pthread_create int(10) extproc('pthread_create');
  threadptr    pointer;
  attr         pointer;
  startRoutine pointer;
  arg          pointer;
end-pr;

dcl-pr pthread_join int(10) extproc('pthread_join');
  threadptr    pointer;
  retval       pointer;
end-pr;

dcl-pr myThreadProc pointer export;
  arg pointer value;
end-pr;

dcl-proc myThreadProc export;
  dcl-pi *n pointer;
    arg pointer value;
  end-pi;

  dsply ('Hola desde el thread!');
  return *null;
end-proc;

dcl-s thread pointer;
dcl-s rc int(10);

rc = pthread_create(%addr(thread): *null: %paddr(myThreadProc): *null);

if rc = 0;
   dsply ('Thread creado, esperando...');
   rc = pthread_join(thread: *null);
endif;

*inlr = *on;