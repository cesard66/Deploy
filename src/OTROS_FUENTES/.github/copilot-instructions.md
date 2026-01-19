# AI Coding Agent Instructions for IBM iSeries Development

## Project Overview
This is an IBM iSeries (AS/400) application suite focused on journal auditing, data utilities, and system administration tools. The codebase consists of RPGLE programs, embedded SQL, CL commands, DDS files, and SQL scripts.

## Architecture & Components
- **Journal Auditing System**: Core functionality for displaying and analyzing database journal entries
  - `dspjrnle.sqlrpgle`: Main journal display program using subfiles
  - `CREATE_DISPLAY_JOURNAL_TABLE_VIEW.sql`: Stored procedure to create views from journal data
  - Uses `DISPLAY_JOURNAL()` table function to read binary journal entries
- **Data Processing**: Programs for handling client data and file operations
  - `programaa.sqlrpgle`/`programab.sqlrpgle`: Fetch and process client records
- **System Utilities**: Tools for retrieving DDS source and file management
  - `rtvddssrc.cmd`/`rtvddssrcc.clp`/`rtvddssrcr.rpgle`: Retrieve DDS from compiled objects
- **IFS Operations**: SQL-based file I/O for Integrated File System
  - `SQT02001.sqlrpgle`: Read text files from IFS
  - `SQT03001.sqlrpgle`: Write data to IFS files
- **Validation & Testing**: Utility programs for data validation
  - `validanum.rpgle`: Numeric string validation with error handling

## Source Code Organization
- `QRPGLESRC/`: RPGLE and SQLRPGLE source programs
- `QDDSSRC/`: DDS physical/logical file definitions
- `QSQLSRC/`: SQL scripts and stored procedures

## Coding Conventions
### RPGLE Patterns
- Use `**FREE` format for all new code
- Standard control options: `ctl-opt dftactgrp(*no) actgrp(*new);`
- Embedded SQL setup:
  ```rpg
  exec sql set option naming = *sys, commit = *none, usrprf = *user, dynusrprf = *user, datfmt = *iso, closqlcsr = *endmod;
  ```
- Data structure declarations: `dcl-ds` with `qualified` and `likeds()`
- Subfile processing: Initialize with `WRITE PSF01`, load with `recno` counter
- Error handling: `monitor`/`on-error` blocks for data validation

### SQL Patterns
- Use `QSYS2` library functions for system information
- Journal queries use `DISPLAY_JOURNAL()` with specific receiver chains
- IFS operations use `qsys2.ifs_read()` and `qsys2.ifs_write()`
- Stored procedures return command strings for dynamic execution

### DDS Patterns
- Display files use subfiles with `SFL`/`SFLCTL` records
- Function keys: `CA03(03 'finalizar')`, `CA04(04 'Seleccion de valores')`
- Field positioning with row/column coordinates

## Build & Deployment
- **No centralized build system** - compile individual objects
- RPGLE: `CRTBNDRPG PGM(lib/program) SRCFILE(lib/QRPGLESRC)`
- SQLRPGLE: Same as RPGLE, SQL precompiled
- CLP: `CRTCLPGM PGM(lib/program) SRCFILE(lib/QCLSRC)`
- DDS: `CRTPF/CRTLF FILE(lib/file) SRCFILE(lib/QDDSSRC)`
- Commands: `CRTCMD CMD(lib/command) PGM(lib/program) SRCFILE(lib/QCMDSRC)`

## Common Workflows
1. **Journal Analysis**: Create view with stored procedure, then display with RPG program
2. **Data Export**: Query tables, write to IFS using SQL table functions
3. **Source Retrieval**: Use RTVDDSSRC tools to extract DDS from existing objects
4. **Validation**: Test numeric inputs with monitor blocks

## Key Integration Points
- Journal receivers accessed via `*CURAVLCHN` (current available chain)
- IFS paths use `/home/user/` convention
- System catalogs: `SYSCOLUMNS`, `SYSTABLES`, `DISPLAY_JOURNAL`
- CCSID handling: `CHGJOB CCSID(284)` for UTF-8 compatibility

## Debugging Tips
- Use `dsply` statements for quick debugging output
- Journal entries show program/library/user context for each operation
- SQLCODE checking after embedded SQL operations
- PSDS fields for current program/user information

## Performance Considerations
- Use `COMMIT = *NONE` for read-only operations
- Close SQL cursors with `CLOSQLCSR = *ENDMOD`
- Subfile pagination with `SFLPAG(15)` for large datasets
- Avoid full table scans in journal queries - use date ranges