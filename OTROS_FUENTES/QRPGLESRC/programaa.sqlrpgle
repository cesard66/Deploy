**FREE
ctl-opt dftactgrp(*no) actgrp(*caller) bnddir('QC2LE');

// Incluir SQLCA
exec sql include sqlca;
// Llamar al programa B y pasarle los datos
dcl-pr ProgramaB extpgm('PROGRAMAB');
    pClientes likeDS(ClienteDS) dim(MAX);
    pTotal int(10);
end-pr;

dcl-c MAX 1000;

// Definir DS y array
dcl-ds ClienteDS qualified;
    ID int(10);
    Nombre varchar(50);
    Ciudad varchar(50);
end-ds;

dcl-Ds ClientesArray dim(MAX) likeDS(ClienteDS);
dcl-s Total int(10) inz(0);

// Variables para fetch
dcl-s id int(10);
dcl-s nombre varchar(50);
dcl-s ciudad varchar(50);

// Declarar cursor
exec sql declare c1 cursor for
    select ID_CLIENTE, NOMBRE, CIUDAD
    from CLIENTES
    order by ID_CLIENTE;

exec sql open c1;

dow sqlcode = 0;
    exec sql fetch c1 into :id, :nombre, :ciudad;

    if sqlcode = 0 and Total < MAX;
        Total += 1;
        ClientesArray(Total).ID = id;
        ClientesArray(Total).Nombre = nombre;
        ClientesArray(Total).Ciudad = ciudad;
    endif;
enddo;

exec sql close c1;


ProgramaB(ClientesArray: Total);

*inlr = *on;
return;
