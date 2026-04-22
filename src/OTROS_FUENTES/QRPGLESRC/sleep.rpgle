
Ctl-Opt DftActGrp(*No) ActGrp(*New);

  // Simular procesamiento (puedes quitar esto)
  // Delay de 10ms para simular trabajo
  CallP Sleep(10);
*InLr = *On;
Return;

//------------------------------------------------------------------------------
// Sleep (pausa en milisegundos)
//------------------------------------------------------------------------------
Dcl-Proc Sleep;
  Dcl-Pi *N;
    pMilliseconds Int(10) Const;
  End-Pi;
  
  Dcl-Pr sleep ExtProc('sleep');
    seconds Uns(10) Value;
  End-Pr;
  
  Dcl-Pr usleep ExtProc('usleep');
    microseconds Uns(10) Value;
  End-Pr;
  
  // Convertir milisegundos a microsegundos
  If pMilliseconds > 0;
    usleep(pMilliseconds * 1000);
  EndIf;
  
End-Proc;