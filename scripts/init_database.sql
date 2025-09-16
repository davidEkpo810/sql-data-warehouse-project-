/*
===========================================================
Creating Database
===========================================================
Script purpose:
    This script creates a new database named 'Datawarehouse' after cchecking if it already exist.
    If database exists, it is dropped and recreated.

WARNING:
    Running this script will drop the entire 'Datawarehouse' database if it exists.
    All data in database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
*/

-- Drop and recreate the 'Datawarehouse' Database if it already exists
DROP DATABASE IF EXISTS Datawarehouse;
CREATE DATABASE Datawarehouse CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


