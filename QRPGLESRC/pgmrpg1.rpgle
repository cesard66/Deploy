**free
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-s v1 char(10) inz('Hello');
dcl-s v2 char(10) inz('World');
dcl-s v3 char(20);
dcl-s v4 char(20) inz('Hello World');

dsply 'Initial values:';
dsply v1;
dsply v2;
dsply v4;

v3 = v1 + v2;  // Concatenate v1 and v2

dsply 'After concatenation:';
dsply v3;  // Display the concatenated result

dsply ('Length of v3: ' + %char(%len(v3)));  // Display the length of v3
dsply ('Length of v4: ' + %char(%len(v4)));
dsply ('Length of v1: ' + %char(%len(v1)));
dsply ('Length of v2: ' + %char(%len(v2)));

dsply 'End of program';
*inlr = *on;  // Set the last record indicator to end the program
return;




















