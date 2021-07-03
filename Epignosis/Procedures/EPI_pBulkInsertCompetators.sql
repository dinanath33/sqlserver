USE [epignosis_18112019]
GO
/****** Object:  StoredProcedure [dbo].[EPI_pBulkInsertCompetators]    Script Date: 07/04/2021 05:13:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EPI_pBulkInsertCompetators]	
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
SET NOCOUNT ON;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'EPI_Competators')
BEGIN
--Print 'exist'
EXEC('
drop table EPI_Competators;

    CREATE TABLE [dbo].[EPI_Competators](
	[ID] [int] IDENTITY(1,1) primary key NOT NULL,
	[Market_ANDA_RM] bigint NULL,
	[applicantHolder] [nvarchar](max) NULL,
	[compt_shares] [int] NULL);
	');
END
ELSE
BEGIN
   CREATE TABLE [dbo].[EPI_Competators](
	[ID] [int] IDENTITY(1,1) primary key NOT NULL,
	[Market_ANDA_RM] bigint NULL,
	[applicantHolder] [nvarchar](max) NULL,
	[compt_shares] [int] NULL);
END 	
select vtable.applNo,vtable.Market_ANDA_RM,vtable.Strength,vtable.AG_RM as AG,cast(vtable.LABELERNAME as nvarchar(MAX)) LABELERNAME,vtable.applicantHolder,sum(vtable.ExtUnits_Y01)ExtUnits_Y01,MT.sum_ExtUnits_Y01 INTO #main_table_details  
from EPI_vNDC_IMS_OB_Competators vtable
LEFT JOIN EPI_Market_sale_total MT WITH (nolock) on vtable.Market_ANDA_RM = MT.Market_ANDA_RM
group by vtable.applNo,vtable.applicantHolder,cast(vtable.LABELERNAME as nvarchar(MAX)),vtable.AG_RM,MT.sum_ExtUnits_Y01,vtable.ExtUnits_Y01,vtable.Strength,vtable.Market_ANDA_RM
order by Strength,applNo desc 
select  distinct(applNo),Market_ANDA_RM,applicantHolder,LABELERNAME,AG,round(sum(ExtUnits_Y01),0)ExtUnits_Y01,round(sum_ExtUnits_Y01,0) sum_ExtUnits_Y01  into #sum_temptb 
from #main_table_details 
where applNo is not NULL and Market_ANDA_RM is not NULL
group by applNo,applicantHolder,sum_ExtUnits_Y01,LABELERNAME,AG,Market_ANDA_RM
select  Market_ANDA_RM,(case when(AG='Y') then (LABELERNAME+' '+'('+'AG'+')') else(applicantHolder)end)applicantHolder
,(case when (ISNULL(sum_ExtUnits_Y01,'')='')then sum_ExtUnits_Y01 else 
round(((CAST(ExtUnits_Y01 as float)/CAST(sum_ExtUnits_Y01 as float))*100),0) end) 
as compt_shares 
into #total_Compitators  
from #sum_temptb group by applNo,applicantHolder,sum_ExtUnits_Y01,LABELERNAME,AG,ExtUnits_Y01,Market_ANDA_RM
INSERT INTO EPI_Competators(Market_ANDA_RM,applicantHolder,compt_shares)
select Market_ANDA_RM,dbo.ProperCase(applicantHolder) applicantHolder,(CASE When sum(compt_shares) < 100 Then sum(compt_shares) else 100 end) compt_shares   from #total_Compitators  group by applicantHolder,Market_ANDA_RM
     
     UPDATE EPI_Competators set applicantHolder = REPLACE(REPLACE(applicantHolder,'Pharmaceuticals','Pharma'),'Pharmaceutical','Pharma')
	 UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'Laboratories','Labs')
	 UPDATE EPI_Competators set applicantHolder = REPLACE(REPLACE(applicantHolder,'Technologies','Tech'),'Technology','Tech')
	 UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'Ameal of New York','Amneal')
	 UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,' LP','')
	 UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'INC','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'LTD','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'LLC','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'PRIVATE','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'HEALTHCARE','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'GMBH','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'USA','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'GLOBAL','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'PTE','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'UNIT','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'WHOLLY','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'OWNED','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'SUBIDIARY','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'AN INDIRECT WHOLLY OWNED SUB OF','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'AN WHOLLY-OWNED SUB OF','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'TOTOWA','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'INTERNATIONAL','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'WORLDWIDE','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'COMPANY','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'SPECIALITY','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'SPECIALTY','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'FARMACEUTICA','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'THERAPEUTICS','')
	UPDATE EPI_Competators set applicantHolder = REPLACE(applicantHolder,'(ag)','(AG)')
END
/*
select  distinct(applNo),Market_ANDA_RM,applicantHolder,LABELERNAME,AG,sum(ExtUnits_Y01)ExtUnits_Y01,sum_ExtUnits_Y01  from #main_table_details
where applNo is not NULL and Market_ANDA_RM is not NULL
 group by applNo,applicantHolder,sum_ExtUnits_Y01,LABELERNAME,AG,Market_ANDA_RM
exec EPI_pGet_Competators '003444'
EXEC EPI_pReportD_NDC_OB_IMS_Competators '003444'
exec EPI_pGet_Competators '020489'
EXEC EPI_pReportD_NDC_OB_IMS_Competators '020489'
*/

--EXEC [dbo].[EPI_pBulkInsertCompetators]	
-- Drop table #main_table_details
-- Drop table #sum_temptb
--select * from [dbo].[EPI_Competators] where Market_ANDA_RM='003444' order by compt_shares
-- select * from EPI_Competators
