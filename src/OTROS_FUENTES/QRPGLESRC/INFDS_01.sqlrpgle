**FREE

//==============================================================================
// Program: INFDS_EXAMPLE
// Description: Example of INFDS (Information Data Structure) definition
//              in RPG ILE Free Format
// Author: IBM Bob
// Date: 2026-01-16
//==============================================================================

Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIO);

//==============================================================================
// File Information Data Structure (INFDS)
//==============================================================================
// This data structure provides runtime information about the program,
// files, and system status

Dcl-Ds PgmSts Qualified;
  // Program Status Information
  PgmName        Char(10)    Pos(1);      // Program name
  PgmStatus      Zoned(5:0)  Pos(11);     // Program status code
  PrevStatus     Zoned(5:0)  Pos(16);     // Previous status
  SrcLineNum     Char(8)     Pos(21);     // Source line number
  Routine        Char(8)     Pos(29);     // Routine name
  NumParms       Zoned(3:0)  Pos(37);     // Number of parameters
  ExcpType       Char(3)     Pos(40);     // Exception type
  ExcpNum        Zoned(4:0)  Pos(43);     // Exception number
  Reserved1      Char(4)     Pos(47);     // Reserved
  ExcpData       Char(80)    Pos(51);     // Exception data
  ExcpId         Char(4)     Pos(131);    // Exception ID
  Date           Zoned(8:0)  Pos(191);    // Date (YYYYMMDD)
  Year           Zoned(2:0)  Pos(199);    // Year (YY)
  LastFile       Char(8)     Pos(201);    // Last file used
  FileInfo       Char(35)    Pos(209);    // File information
  JobName        Char(10)    Pos(244);    // Job name
  UserName       Char(10)    Pos(254);    // User name
  JobNumber      Zoned(6:0)  Pos(264);    // Job number
  JobDate        Zoned(6:0)  Pos(270);    // Job date (YYMMDD)
  RunDate        Zoned(6:0)  Pos(276);    // Run date (YYMMDD)
  RunTime        Zoned(6:0)  Pos(282);    // Run time (HHMMSS)
  CrtDate        Char(6)     Pos(288);    // Creation date
  CrtTime        Char(6)     Pos(294);    // Creation time
  CplLevel       Char(4)     Pos(300);    // Compiler level
  SrcFile        Char(10)    Pos(304);    // Source file
  SrcLib         Char(10)    Pos(314);    // Source library
  SrcMbr         Char(10)    Pos(324);    // Source member
  PgmLib         Char(10)    Pos(334);    // Program library
  MsgId          Char(7)     Pos(40);     // Message ID (overlay)
  Reserved2      Char(1)     Pos(47);     // Reserved
  MsgData        Char(80)    Pos(48);     // Message data (overlay)
End-Ds;

//==============================================================================
// File Information Data Structure (for file operations)
//==============================================================================
Dcl-Ds FileSts Qualified;
  FileName       Char(8)     Pos(1);      // File name
  OpenInd        Char(1)     Pos(9);      // Open indicator
  EndOfFile      Char(1)     Pos(10);     // End of file indicator
  StatusCode     Zoned(5:0)  Pos(11);     // Status code
  OpCode         Char(6)     Pos(16);     // Operation code
  Routine        Char(8)     Pos(22);     // Routine name
  ListNum        Char(8)     Pos(30);     // List number
  RecFormat      Char(10)    Pos(38);     // Record format
  MsgId          Char(7)     Pos(48);     // Message ID
  Reserved       Char(1)     Pos(55);     // Reserved
  MsgData        Char(80)    Pos(56);     // Message data
  FileLib        Char(10)    Pos(136);    // File library
  FileMbr        Char(10)    Pos(146);    // File member
  RecCount       Int(10)     Pos(156);    // Record count
  KeyPos         Int(5)      Pos(160);    // Key position
  KeyLen         Int(5)      Pos(162);    // Key length
  MbrNum         Int(5)      Pos(164);    // Member number
  RRN            Int(10)     Pos(166);    // Relative record number
  KeyValue       Char(2000)  Pos(170);    // Key value
End-Ds;

//==============================================================================
// Main Program Logic
//==============================================================================

Dcl-S Message Char(52);

// Display program information
Message = 'Program: ' + %Trim(PgmSts.PgmName) +
          ' User: ' + %Trim(PgmSts.UserName) +
          ' Job: ' + %Trim(PgmSts.JobName);
Dsply Message;

// Display date and time information
Message = 'Date: ' + %Char(PgmSts.Date) +
          ' Time: ' + %Char(PgmSts.RunTime);
Dsply Message;

// Display job information
Message = 'Job Number: ' + %Char(PgmSts.JobNumber) +
          ' Library: ' + %Trim(PgmSts.PgmLib);
Dsply Message;

// Example of error handling using INFDS
Monitor;
  // Simulate an operation that might fail
  TestErrorHandling();
On-Error;
  Message = 'Error: ' + %Trim(PgmSts.MsgId) +
            ' Status: ' + %Char(PgmSts.PgmStatus);
  Dsply Message;
EndMon;

*InLr = *On;
Return;

//==============================================================================
// Subprocedures
//==============================================================================

Dcl-Proc TestErrorHandling;
  // This procedure demonstrates error handling with INFDS
  Dcl-S TestVar Char(10);
  
  // Example: This would trigger an error if uncommented
  // TestVar = %Subst('ABC': 1: 10); // String too short
  
  TestVar = 'Test OK';
  Dsply ('Test completed: ' + TestVar);
End-Proc;

//==============================================================================
// Alternative: INFDS associated with a specific file
//==============================================================================
// To use INFDS with a file, declare it like this:
//
// Dcl-F MyFile Disk(*Ext) Usage(*Input) Infds(FileSts);
//
// Then FileSts will be automatically populated with file-specific information
// whenever a file operation occurs.
//==============================================================================

//==============================================================================
// Common INFDS Status Codes:
//==============================================================================
// 00000 - No error
// 01021 - End of file on read
// 01022 - Record not found
// 01023 - Duplicate key on write
// 01024 - Record already locked
// 01031 - Match field sequence error
// 01041 - Array index error
// 01042 - Divide by zero
// 01051 - Called program not found
// 01071 - Decimal data error
// 01211 - I/O operation to closed file
// 01215 - OPEN issued to open file
// 01216 - Error on OPEN
// 01217 - Error on CLOSE
// 01218 - Record already exists (WRITE)
// 01221 - Update/delete not preceded by input
// 01222 - Record in use by another job
// 01331 - Wait time exceeded for READ
//==============================================================================