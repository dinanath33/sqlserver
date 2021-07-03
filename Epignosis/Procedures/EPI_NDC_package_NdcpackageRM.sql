USE [narne]
GO
/****** Object:  StoredProcedure [dbo].[getMSNOandPlotsizeByPlotNo]    Script Date: 07/04/2021 05:05:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[getMSNOandPlotsizeByPlotNo]
@project varchar(100)=null,
@sector varchar(100)=null,
@block varchar(100)=null,
@plot varchar(100)=null
AS
BEGIN  
IF(@project!='' AND @sector!='' AND @block!='' AND @plot!='')
BEGIN
SET NOCOUNT ON 
SELECT msno,SUM(Cast(size as integer)) as size FROM tblCustomerPlotAllot t1 
WHERE t1.active=1 AND t1.project=@project AND t1.sector=@sector AND t1.block=@block AND t1.plot=@plot group by msno,size
END
ELSE IF(@project!='' AND @sector!='' AND @block!='')
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