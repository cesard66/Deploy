**FREE
ctl-opt dftactgrp(*no) actgrp(*caller);

// Mismo DS que en Programa A
dcl-ds ClienteDS qualified;
    ID int(10);
    Nombre varchar(50);
    Ciudad varchar(50);
end-ds;

dcl-ds ClientesArray dim(1000) likeDS(ClienteDS);
dcl-s Total int(10);
dcl-s i int(10);

// Declarar prototipo del propio programa
dcl-pi *n;
    pClientes likeDS(ClienteDS) dim(1000);
    pTotal int(10);
end-pi;

ClientesArray = pClientes;
Total = pTotal;

// Procesar array
for i = 1 to Total;
    dsply ('ID: ' + %char(ClientesArray(i).ID));
    dsply (ClientesArray(i).Nombre);
    dsply (ClientesArray(i).Ciudad);
endfor;

*inlr = *on;
return;
