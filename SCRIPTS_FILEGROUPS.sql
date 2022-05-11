--getQuery
use [colocar o nome da BD        ]
GO
SELECT
DB_NAME() [Database], sf.groupname, COUNT(0) [Total Number of Datafiles]
FROM         sys.sysfiles AS a with (nolock)
inner join sysfilegroups sf with (nolock) on a.groupid = sf.groupid
--WHERE groupname = 'PRIMARY'
--groupname IN (SELECT NAME FROM sys.filegroups)
GROUP BY sf.groupname
GO
SELECT
sf.groupname as Filegroup,
COUNT(0) [Total Number of Datafiles],
SUM(CONVERT(Decimal(15,2),ROUND(a.Size/128.000,2))) [Currently Allocated Space (MB)],
SUM(CONVERT(Decimal(15,2),ROUND(FILEPROPERTY(a.Name,'SpaceUsed')/128.000,2))) AS [Space Used (MB)],
SUM(CONVERT(Decimal(15,2),ROUND((a.Size-FILEPROPERTY(a.Name,'SpaceUsed'))/128.000,2))) AS [Available Space (MB)]
FROM         sys.sysfiles AS a with (nolock)
inner join sysfilegroups sf with (nolock) on a.groupid = sf.groupid
WHERE groupname = 'PRIMARY'
--groupname IN (SELECT NAME FROM sys.filegroups)
GROUP BY sf.groupname

SELECT
sf.groupname as Filegroup,
a.name ,
cast(maxsize*8 /1024 as bigint) as MaxSize ,
CONVERT(Decimal(15,2),ROUND(a.Size/128.000,2)) [Currently Allocated Space (MB)],
CONVERT(Decimal(15,2),ROUND(FILEPROPERTY(a.Name,'SpaceUsed')/128.000,2)) AS [Space Used (MB)],
CONVERT(Decimal(15,2),ROUND((a.Size-FILEPROPERTY(a.Name,'SpaceUsed'))/128.000,2)) AS [Available Space (MB)],
--(cast(maxsize*8 /1024 as bigint) - (CONVERT(Decimal(15,2),ROUND(a.Size128.000,2)) - CONVERT(Decimal(15,2),ROUND((a.Size-FILEPROPERTY(a.Name,'SpaceUsed'))/128.000,2)))) AS MaxSpaceDisp,
LEFT(a.filename, CHARINDEX('\', a.filename,4)) AS Disk
, growth *8 /1024  as [Crescimento (MB)]
FROM         sys.sysfiles AS a with (nolock)
inner join sysfilegroups sf with (nolock) on a.groupid = sf.groupid
WHERE 
groupname LIKE 'PRIMARY%'
order by 2--groupname,
--order by 7, 1, 2--groupname,

--ALTER DATABASE [PTCenterLog] ADD FILE ( NAME = N'PTCenterLog_dat79', FILENAME = N'H:\SQL_DATA_PST38-06\SQL_DATA\PTCenterLog_dat79.ndf' , SIZE = 512MB , MAXSIZE = 31457280KB , FILEGROWTH = 524288KB ) 
--TO FILEGROUP [PRIMARY]
--GO

--ALTER DATABASE DOCONE MODIFY FILE (NAME='PRIMARY08',SIZE=10240MB, MAXSIZE=10241MB, FILEGROWTH = 524288KB)
--GO
--ALTER DATABASE SManagerDB MODIFY FILE (NAME='SManagerDB15',SIZE=15360MB, MAXSIZE=15361MB, FILEGROWTH = 524288KB)
--GO

--USE master;
--GO
--ALTER DATABASE AdventureWorks2012
--REMOVE FILE test1dat4;
--GO