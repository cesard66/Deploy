**free
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-s v1 char(10) inz('Hello');
dcl-s v2 char(10) inz('World');
dcl-s v3 char(20);
dcl-s v4 char(20) inz('Hello World');
dcl-s dummy char(1);

dsply 'Initial values:';
dsply v1;
dsply v2;
dsply v4;

v3 = %trim(v1) + ' ' + %trim(v2);  // Concatenate v1 and v2
dsply 'After concatenation:';
dsply ('V3: ' + v3);  // Display the concatenated result
pause();  // Pause to view the output
dsply ('Length of v3: ' + %char(%len(%trim(v3))));  // Display the length of v3
dsply ('Length of v4: ' + %char(%len(%trim(v4))));
dsply ('Length of v1: ' + %char(%len(%trim(v1))));
dsply ('Length of v2: ' + %char(%len(%trim(v2))));

dsply 'End of program';
*inlr = *on;  // Set the last record indicator to end the program
return;

dcl-proc Pause ;
  dcl-pr sleep extproc('sleep') ;
    second uns(10) value ;
  end-pr ;

  sleep(2);  // Pause for 2 seconds
end-proc ;