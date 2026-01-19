**free

dcl-pr SendEscMsg extpgm('QMHSNDPM');
    MsgID     char(7)   const;
    MsgFile   char(20)  const;
    MsgDta    char(80)  const;
    MsgDtaLen int(10)   const;
    MsgType   char(10)  const;
    MsgQ      char(10)  const;
    MsgQNbr   int(10)   const;
    MsgKey    char(4);
    ErrorDS   char(16);
end-pr;
 
dcl-ds ErrorDS inz;
    BytesProv    int(10) inz(16);
    BytesAvail   int(10);
    ExceptionID  char(7);
end-ds;

dcl-s MsgDta char(80);
dcl-s MsgKey char(4);

MsgDta = 'Cancelado';

callp SendEscMsg(
    'CPF9898'           : 
    'QCPFMSG   QSYS'    : 
    MsgDta              : 
    %len(MsgDta)        : 
    '*ESCAPE'           : 
    '*CTLBDY'           : 
    2                   : 
    MsgKey              : 
    ErrorDS
);

*inlr = *on;