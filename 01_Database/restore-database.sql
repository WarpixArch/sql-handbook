-- =====================================================
-- RESTORE DATABASE
-- =====================================================

-- WHAT IS IT?
-- RESTORE DATABASE is used to restore a database
-- from a SQL Server backup file (.bak).


-- =====================================================
-- Example: Restore a database from a backup
-- =====================================================

-- WHEN TO USE:
-- Use this when you have a database backup (.bak)
-- and want to restore it in SQL Server.

RESTORE DATABASE EmployeeDB
FROM DISK = 'C:\Backup\EmployeeDB.bak';
