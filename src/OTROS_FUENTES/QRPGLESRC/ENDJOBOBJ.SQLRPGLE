**FREE
///
// Program: ENDJOBOBJ
// Description: End all jobs using a specific object
// Author: Bob
// Date: 2026-04-13
//
// This program finds all jobs that have locks on a specified object
// and ends them using the specified end option.
//
// Parameters:
//   pObjName  - Object name
//   pObjLib   - Object library
//   pObjType  - Object type (*FILE, *PGM, *DTAARA, etc.)
//   pEndOpt   - End option (*IMMED, *CNTRLD, *FRCFAIL)
//   pDelay    - Delay time in seconds for *CNTRLD
///

Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIO);

// Parameters
Dcl-Pi ENDJOBOBJ;
  pObjName  Char(10) Const;
  pObjLib   Char(10) Const;
  pObjType  Char(10) Const;
  pEndOpt   Char(10) Const Options(*NoPass);
  pDelay    Packed(5:0) Const Options(*NoPass);
End-Pi;

// Local variables
Dcl-S wEndOpt     Char(10);
Dcl-S wDelay      Packed(5:0);
Dcl-S wJobName    Char(28);
Dcl-S wJobNumber  Char(6);
Dcl-S wJobUser    Char(10);
Dcl-S wJobSimple  Char(10);
Dcl-S wFullJob    Char(26);
Dcl-S wEndCnt     Int(10) Inz(0);
Dcl-S wErrCnt     Int(10) Inz(0);
Dcl-S wSkipCnt    Int(10) Inz(0);
Dcl-S wCmd        Varchar(512);
Dcl-S wMsg        Varchar(256);
Dcl-S wCurrentJob Char(28);

// Data structure for job information
Dcl-Ds JobInfo Qualified;
  JobName       Char(28);
  JobNumber     Char(6);
  JobUser       Char(10);
  JobNameOnly   Char(10);
  LockState     Char(10);
  LockScope     Char(10);
  LockStatus    Char(10);
End-Ds;

// SQL cursor declaration

// Get current job name to avoid ending ourselves
Exec SQL SET :wCurrentJob = CURRENT_SERVER;

// Set default values for optional parameters
If %Parms() >= 4;
  wEndOpt = pEndOpt;
Else;
  wEndOpt = '*CNTRLD';
EndIf;

If %Parms() >= 5;
  wDelay = pDelay;
Else;
  wDelay = 30;
EndIf;

// Validate parameters
If pObjName = *Blanks;
  wMsg = 'Object name is required';
  SendEscapeMsg(wMsg);
EndIf;

If pObjLib = *Blanks;
  wMsg = 'Object library is required';
  SendEscapeMsg(wMsg);
EndIf;

// Send initial message
wMsg = 'Searching for jobs using object ' + %Trim(pObjName) +
       '/' + %Trim(pObjLib) + ' type ' + %Trim(pObjType);
SendInfoMsg(wMsg);

// Declare cursor to find jobs with locks on the object
Exec SQL DECLARE JobCursor CURSOR FOR
  SELECT
    JOB_NAME,
    SUBSTR(JOB_NAME, 21, 6) AS JOB_NUMBER,
    SUBSTR(JOB_NAME, 11, 10) AS JOB_USER,
    SUBSTR(JOB_NAME, 1, 10) AS JOB_NAME_ONLY,
    LOCK_STATE,
    LOCK_SCOPE,
    LOCK_STATUS
  FROM QSYS2.OBJECT_LOCK_INFO
  WHERE SYSTEM_OBJECT_NAME = :pObjName
    AND SYSTEM_OBJECT_SCHEMA = :pObjLib
    AND OBJECT_TYPE = :pObjType
  ORDER BY JOB_NAME;

// Open cursor
Exec SQL OPEN JobCursor;

If SqlCode < 0;
  wMsg = 'Error opening cursor. SQLCODE: ' + %Char(SqlCode);
  SendEscapeMsg(wMsg);
EndIf;

// Process each job
Dow SqlCode = 0;

  // Fetch next job
  Exec SQL FETCH NEXT FROM JobCursor INTO
    :JobInfo.JobName,
    :JobInfo.JobNumber,
    :JobInfo.JobUser,
    :JobInfo.JobNameOnly,
    :JobInfo.LockState,
    :JobInfo.LockScope,
    :JobInfo.LockStatus;

  If SqlCode = 0;

    // Build full job name (number/user/name)
    wFullJob = %Trim(JobInfo.JobName);

    // Skip if it's the current job
    If %Trim(JobInfo.JobName) = %Trim(wCurrentJob);
      wMsg = 'Skipping current job: ' + wFullJob;
      SendInfoMsg(wMsg);
      wSkipCnt += 1;
      Iter;
    EndIf;

    // Display job information
    wMsg = 'Found job: ' + wFullJob + ' - Lock: ' +
           %Trim(JobInfo.LockState);
    SendInfoMsg(wMsg);

    // Build ENDJOB command
    If wEndOpt = '*CNTRLD';
      wCmd = 'ENDJOB JOB(' + %Trim(wFullJob) + ') ' +
             'OPTION(*CNTRLD) DELAY(' + %Char(wDelay) + ')';
    Else;
      wCmd = 'ENDJOB JOB(' + %Trim(wFullJob) + ') ' +
             'OPTION(' + %Trim(wEndOpt) + ')';
    EndIf;

    // Execute ENDJOB command
    Monitor;
      ExecuteCommand(wCmd);
      wEndCnt += 1;
      wMsg = 'Job ended: ' + wFullJob;
      SendInfoMsg(wMsg);
    On-Error;
      wErrCnt += 1;
      wMsg = 'Error ending job: ' + wFullJob;
      SendDiagMsg(wMsg);
    EndMon;

  EndIf;

EndDo;

// Close cursor
Exec SQL CLOSE JobCursor;

// Send completion message
If wEndCnt = 0 And wSkipCnt = 0;
  wMsg = 'No jobs found using the object';
Else;
  wMsg = 'Jobs ended: ' + %Char(wEndCnt) +
         ', Skipped: ' + %Char(wSkipCnt) +
         ', Errors: ' + %Char(wErrCnt);
EndIf;

SendCompMsg(wMsg);

*InLr = *On;
Return;

//=====================================================================
// ExecuteCommand - Execute a CL command
//=====================================================================
Dcl-Proc ExecuteCommand;
  Dcl-Pi *N;
    pCmd Varchar(512) Const;
  End-Pi;

  Dcl-Pr QCMDEXC ExtPgm('QCMDEXC');
    *N Char(512) Options(*VarSize);
    *N Packed(15:5) Const;
  End-Pr;

  Dcl-S wCmdLen Packed(15:5);
  Dcl-S wCmdStr Char(512);

  wCmdStr = pCmd;
  wCmdLen = %Len(%Trim(pCmd));

  QCMDEXC(wCmdStr: wCmdLen);

End-Proc;

//=====================================================================
// SendInfoMsg - Send informational message
//=====================================================================
Dcl-Proc SendInfoMsg;
  Dcl-Pi *N;
    pMsg Varchar(256) Const;
  End-Pi;

  Dcl-Pr QMHSNDPM ExtPgm('QMHSNDPM');
    *N Char(7) Const;                    // Message ID
    *N Char(20) Const;                   // Message file
    *N Char(256) Const Options(*VarSize);// Message data
    *N Int(10) Const;                    // Message data length
    *N Char(10) Const;                   // Message type
    *N Char(10) Const;                   // Call stack entry
    *N Int(10) Const;                    // Call stack counter
    *N Char(4) Const;                    // Message key
    *N Char(256);                        // Error code
  End-Pr;

  Dcl-S wMsgKey Char(4);
  Dcl-S wErrCode Char(256) Inz(*AllX'00');

  QMHSNDPM('CPF9897': 'QCPFMSG   *LIBL':
           pMsg: %Len(pMsg): '*INFO':
           '*CTLBDY': 1: wMsgKey: wErrCode);

End-Proc;

//=====================================================================
// SendDiagMsg - Send diagnostic message
//=====================================================================
Dcl-Proc SendDiagMsg;
  Dcl-Pi *N;
    pMsg Varchar(256) Const;
  End-Pi;

  Dcl-Pr QMHSNDPM ExtPgm('QMHSNDPM');
    *N Char(7) Const;
    *N Char(20) Const;
    *N Char(256) Const Options(*VarSize);
    *N Int(10) Const;
    *N Char(10) Const;
    *N Char(10) Const;
    *N Int(10) Const;
    *N Char(4) Const;
    *N Char(256);
  End-Pr;

  Dcl-S wMsgKey Char(4);
  Dcl-S wErrCode Char(256) Inz(*AllX'00');

  QMHSNDPM('CPF9897': 'QCPFMSG   *LIBL':
           pMsg: %Len(pMsg): '*DIAG':
           '*CTLBDY': 1: wMsgKey: wErrCode);

End-Proc;

//=====================================================================
// SendCompMsg - Send completion message
//=====================================================================
Dcl-Proc SendCompMsg;
  Dcl-Pi *N;
    pMsg Varchar(256) Const;
  End-Pi;

  Dcl-Pr QMHSNDPM ExtPgm('QMHSNDPM');
    *N Char(7) Const;
    *N Char(20) Const;
    *N Char(256) Const Options(*VarSize);
    *N Int(10) Const;
    *N Char(10) Const;
    *N Char(10) Const;
    *N Int(10) Const;
    *N Char(4) Const;
    *N Char(256);
  End-Pr;

  Dcl-S wMsgKey Char(4);
  Dcl-S wErrCode Char(256) Inz(*AllX'00');

  QMHSNDPM('CPF9897': 'QCPFMSG   *LIBL':
           pMsg: %Len(pMsg): '*COMP':
           '*CTLBDY': 1: wMsgKey: wErrCode);

End-Proc;

//=====================================================================
// SendEscapeMsg - Send escape message
//=====================================================================
Dcl-Proc SendEscapeMsg;
  Dcl-Pi *N;
    pMsg Varchar(256) Const;
  End-Pi;

  Dcl-Pr QMHSNDPM ExtPgm('QMHSNDPM');
    *N Char(7) Const;
    *N Char(20) Const;
    *N Char(256) Const Options(*VarSize);
    *N Int(10) Const;
    *N Char(10) Const;
    *N Char(10) Const;
    *N Int(10) Const;
    *N Char(4) Const;
    *N Char(256);
  End-Pr;

  Dcl-S wMsgKey Char(4);
  Dcl-S wErrCode Char(256) Inz(*AllX'00');

  QMHSNDPM('CPF9898': 'QCPFMSG   *LIBL':
           pMsg: %Len(pMsg): '*ESCAPE':
           '*CTLBDY': 1: wMsgKey: wErrCode);

End-Proc;
