USE [epignosis_18112019]
GO
/****** Object:  StoredProcedure [dbo].[EPI_pBulkInsertActiveIngredientAtoZPage]    Script Date: 07/04/2021 05:11:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[EPI_pBulkInsertActiveIngredientAtoZPage]
@path nvarchar(Max)
as
begin
 SET NOCOUNT ON;  
declare @bulk  nvarchar(max)
 IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_NAME = N'EPI_BE_ActiveIngredientAtoZPage')
BEGIN
Print 'exist'
EXEC('
drop table EPI_BE_ActiveIngredientAtoZPage;

    Create table EPI_BE_ActiveIngredientAtoZPage(
   Id int IDENTITY(1,1) primary key not null,
   Page varchar(100) not null,
   Link varchar(255) not null
   );	
	');

IF NOT EXISTS(SELECT 1 FROM sys.views 
		 WHERE Name = 'EPI_vEPI_BE_ActiveIngredientAtoZPage')
		BEGIN
		EXEC('
		create VIEW [dbo].[EPI_vEPI_BE_ActiveIngredientAtoZPage]
		AS
		SELECT 
			[Page],
			[Link]
			FROM EPI_BE_ActiveIngredientAtoZPage WITH (nolock)
		');
		
		END
		ELSE
		BEGIN
		DROP VIEW EPI_vEPI_BE_ActiveIngredientAtoZPage
		EXEC('		
		create VIEW [dbo].[EPI_vEPI_BE_ActiveIngredientAtoZPage]
		AS
		SELECT 
			[Page],
			[Link]
			FROM EPI_BE_ActiveIngredientAtoZPage WITH (nolock)
		');
		
		END

END
else
BEGIN
   Create table EPI_BE_ActiveIngredientAtoZPage(
   Id int IDENTITY(1,1) primary key not null,
   Page nvarchar(100) not null,
   Link nvarchar(255) not null
   );	
	

IF NOT EXISTS(SELECT 1 FROM sys.views 
		 WHERE Name = 'EPI_vEPI_BE_ActiveIngredientAtoZPage')
		BEGIN
		EXEC('
		create VIEW [dbo].[EPI_vEPI_BE_ActiveIngredientAtoZPage]
		AS
		SELECT 
			[Page],
			[Link]
			FROM EPI_BE_ActiveIngredientAtoZPage WITH (nolock)
		');
	
		END
		ELSE
		BEGIN
		DROP VIEW EPI_vEPI_BE_ActiveIngredientAtoZPage
		EXEC('		
		create VIEW [dbo].[EPI_BE_ActiveIngredientAtoZPage]
		AS
		SELECT 
			[Page],
			[Link]
			FROM EPI_BE_ActiveIngredientAtoZPage WITH (nolock)
		');
		
		END
END
set @bulk='BULK
		INSERT [dbo].[EPI_vEPI_BE_ActiveIngredientAtoZPage]
		FROM '''++@path+'''
		WITH
		(
		FIELDTERMINATOR = '+'''~'''+','+'
		ROWTERMINATOR = '+'''0x0a'''+','+
		'FirstRow = 2
		)';
		EXEC sp_executesql @bulk
end



--select * from EPI_vLinks with(nolock) 
--exec EPI_pBulkInsertLinks 'C:\wamp\www\epignosis\protected\uploads\1518784166_ob_products.csv'
