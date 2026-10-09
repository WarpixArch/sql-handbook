
/*
=========================================================
SQL SERVER HANDBOOK
TOPIC 01: DATABASE OPERATIONS
=========================================================

Topics covered:
1. CREATE DATABASE
2. USE
3. ALTER DATABASE
4. BACKUP DATABASE
5. RESTORE DATABASE
6. RESTORE FILELISTONLY
7. RESTORE WITH MOVE
8. RESTORE WITH REPLACE
9. RECOVERY and NORECOVERY
10. DROP DATABASE
11. GO - Batch Separator
*/


/*
=========================================================
1. CREATE DATABASE
=========================================================

WHAT:
Creates a new database.

WHEN TO USE:
When you need a new database to store tables and data.
*/

CREATE DATABASE EmployeeDB;
GO


/*
=========================================================
2. USE DATABASE
=========================================================

WHAT:
Selects the database context for subsequent statements.

WHEN TO USE:
When you want to execute queries against a specific database.
*/

USE EmployeeDB;
GO

-- Check the current database.
SELECT DB_NAME() AS CurrentDatabase;
GO


/*
=========================================================
3. ALTER DATABASE
=========================================================

WHAT:
Changes the settings or properties of a database.

Example A: Set the database to READ_ONLY.
WARNING: Requires appropriate permissions and may require
exclusive access to the database.
*/

ALTER DATABASE EmployeeDB
SET READ_ONLY;
GO

-- Example B: Set the database back to READ_WRITE.

ALTER DATABASE EmployeeDB
SET READ_WRITE;
GO

-- Example C: Set the recovery model to FULL.
-- WHEN TO USE: When you need full recovery-model capabilities.
-- NOTE: A full database backup is needed to establish
-- the log backup chain after switching to FULL.

ALTER DATABASE EmployeeDB
SET RECOVERY FULL;
GO


/*
=========================================================
4. BACKUP DATABASE
=========================================================

WHAT:
Creates a backup of a database.

WHEN TO USE:
Before maintenance, migration, or recovery planning.

IMPORTANT:
The backup folder must exist, and the SQL Server service
account must have permission to write to it.
*/

-- Example A: Full database backup.

BACKUP DATABASE EmployeeDB
TO DISK = 'C:\SQLBackups\EmployeeDB.bak'
WITH
    INIT,
    NAME = 'EmployeeDB-Full-Backup';
GO


-- Example B: Differential backup.
-- WHEN TO USE:
-- To back up changes made since the most recent full backup.

BACKUP DATABASE EmployeeDB
TO DISK = 'C:\SQLBackups\EmployeeDB_Differential.bak'
WITH DIFFERENTIAL, INIT;
GO


-- Example C: Transaction log backup.
-- PREREQUISITE:
-- The database must use FULL or BULK_LOGGED recovery,
-- and a valid log backup chain must exist.

BACKUP LOG EmployeeDB
TO DISK = 'C:\SQLBackups\EmployeeDB_Log.trn'
WITH INIT;
GO


/*
=========================================================
5. RESTORE FILELISTONLY
=========================================================

WHAT:
Lists the logical and physical files contained in a backup.

WHEN TO USE:
Before restoring with MOVE, to identify logical file names.

NOTE:
The backup file must exist at the specified path.
*/

RESTORE FILELISTONLY
FROM DISK = 'C:\SQLBackups\EmployeeDB.bak';
GO


/*
=========================================================
6. RESTORE DATABASE - BASIC
=========================================================

WHAT:
Restores a database from a backup.

WHEN TO USE:
When recovering a database from a backup file.

NOTE:
The destination must be available, and the restore must
be compatible with the existing database and file locations.
*/

RESTORE DATABASE EmployeeDB
FROM DISK = 'C:\SQLBackups\EmployeeDB.bak'
WITH RECOVERY;
GO


/*
=========================================================
7. RESTORE DATABASE - USING MOVE
=========================================================

WHAT:
Restores database files to specified physical locations.

WHEN TO USE:
When the original file paths are unavailable, or when
restoring a separate copy of an existing database.

IMPORTANT:
Replace the logical file names below with the names
returned by RESTORE FILELISTONLY.
The destination folder must exist and be writable by SQL Server.
*/

RESTORE DATABASE EmployeeDB_Copy
FROM DISK = 'C:\SQLBackups\EmployeeDB.bak'
WITH
    MOVE 'EmployeeDB'
        TO 'E:\RestoredDB\EmployeeDB_Copy.mdf',
    MOVE 'EmployeeDB_log'
        TO 'E:\RestoredDB\EmployeeDB_Copy_log.ldf',
    RECOVERY;
GO


/*
=========================================================
8. RESTORE DATABASE - WITH REPLACE
=========================================================

WHAT:
Allows a restore to overwrite an existing database with
the same target name, subject to SQL Server's checks.

WHEN TO USE:
Only when intentionally replacing an existing database.

WARNING:
This can overwrite the target database's data.
Verify the backup, target database, and file paths first.
*/

-- Example only. Do not run unless replacement is intended.

-- RESTORE DATABASE EmployeeDB
-- FROM DISK = 'C:\SQLBackups\EmployeeDB.bak'
-- WITH REPLACE, RECOVERY;
-- GO


/*
=========================================================
9. RECOVERY AND NORECOVERY
=========================================================

RECOVERY:
Finishes the restore sequence and makes the database usable.

NORECOVERY:
Leaves the database in a restoring state so more backups
can be applied.

WHEN TO USE NORECOVERY:
When applying a full backup followed by a differential
backup or transaction log backups.
*/

-- Example: Restore a full backup and leave the database
-- ready for additional backup restores.

-- RESTORE DATABASE EmployeeDB
-- FROM DISK = 'C:\SQLBackups\EmployeeDB_Full.bak'
-- WITH NORECOVERY;
-- GO

-- Example: Apply a transaction log backup, then finish recovery.

-- RESTORE LOG EmployeeDB
-- FROM DISK = 'C:\SQLBackups\EmployeeDB_Log.trn'
-- WITH RECOVERY;
-- GO


/*
=========================================================
10. DROP DATABASE
=========================================================

WHAT:
Removes a database and its data from SQL Server.

WHEN TO USE:
When a database is no longer needed.

WARNING:
This is destructive. Confirm the database name and ensure
you have a backup if the data may be needed.
*/

-- Example only. Keep commented until deletion is intended.

-- USE master;
-- GO
-- DROP DATABASE EmployeeDB;
-- GO


/*
=========================================================
11. GO - BATCH SEPARATOR
=========================================================

WHAT:
GO is recognized by tools such as SSMS and sqlcmd.
It separates SQL batches; it is not a T-SQL command
executed directly by the SQL Server Database Engine.

WHEN TO USE:
To separate batches in SQL scripts.
*/

SELECT DB_NAME() AS CurrentDatabase;
GO

SELECT GETDATE() AS CurrentDateTime;
GO


/*
=========================================================
IMPORTANT NOTES
=========================================================

1. CREATE DATABASE creates a database.
2. USE selects the current database context.
3. ALTER DATABASE modifies database settings.
4. BACKUP DATABASE creates a full or differential backup.
5. BACKUP LOG backs up transaction log records.
6. RESTORE FILELISTONLY identifies files inside a backup.
7. RESTORE DATABASE restores a database.
8. MOVE specifies new physical file locations.
9. REPLACE permits intentional replacement of a target.
10. NORECOVERY allows additional backups to be applied.
11. RECOVERY completes the restore sequence.
12. DROP DATABASE removes a database.
13. GO separates batches in SSMS and sqlcmd.

SAFETY:
- Paths in this handbook are examples; adjust them to your
  SQL Server environment.
- Do not run every section sequentially.
- Do not use WITH REPLACE unless you understand the impact.
- A differential backup depends on its base full backup.
- Log backups require an appropriate recovery model and
  an intact backup chain.
*/
