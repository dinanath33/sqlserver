USE [epignosis_18112019]
GO
/****** Object:  StoredProcedure [dbo].[EPI_pAdd_IMS_Sales]    Script Date: 07/04/2021 05:10:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EPI_pAdd_IMS_Sales]
@tableName nvarchar(Max),
@item1 nvarchar(max),
@item2 nvarchar(max),
@item3 nvarchar(max),
@item4 nvarchar(max),
@replacecolumn nvarchar(Max)
AS
BEGIN
declare @query nvarchar(Max)
declare @temp nvarchar(MAX)
SET NOCOUNT ON;
--set @temp=@temp+(1+2+3+4)
set @temp='((isnull(source.'+@item1+','+'0'+')+isnull(source.'+@item2+','+'0'+')+isnull(source.'+@item3+','+'0'+')+isnull(source.'+@item4+','+'0'+')))'
set @query='UPDATE destination 
SET destination.'+@replacecolumn+' ='+@temp+'
FROM dbo.'+@tableName+' AS source
JOIN dbo.'+@tableName+' AS destination ON source.ID = destination.ID'

 EXEC sp_executesql @query
END
SET ANSI_NULLS ON
