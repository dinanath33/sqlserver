USE [narne]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[getMSNOandPlotsize]
@project varchar(100)=null,
@sector varchar(100)=null,
@block varchar(100)=null
AS
BEGIN  
IF(@project!='' AND @sector!='' AND @block!='')
BEGIN
SET NOCOUNT ON 
SELECT msno,SUM(Cast(size as integer)) as size FROM tblCustomerPlotAllot t1 
WHERE t1.active=1 AND t1.project=@project AND t1.sector=@sector AND t1.block=@block group by msno,size
END
ELSE IF(@project!='' AND @sector!='')
BEGIN
SET NOCOUNT ON 
SELECT msno,SUM(Cast(size as integer)) as size FROM tblCustomerPlotAllot t1 
WHERE t1.active=1 AND t1.project=@project AND t1.sector=@sector group by msno,size
END
ELSE IF(@project!='')
BEGIN
SET NOCOUNT ON 
SELECT msno,SUM(Cast(size as integer)) as size FROM tblCustomerPlotAllot t1 
WHERE t1.active=1 AND t1.project=@project group by msno,size
END
END