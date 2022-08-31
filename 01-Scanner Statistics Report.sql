Declare @StartDatetime	DATETIME = '2018-02-20 00:00:00.000',
		@EndDateTime DATETIME = '2018-03-05 00:00:00.000'
			
Select	CAST(ShiftDate AS DATE) AS 'Shift Date',
		(DATEPART(HOUR,ShiftDate)/8)+1 AS 'ShiftID',
		ScannerName AS 'Scanner Location',
		SUM(DS.FrontGoodReadCount) AS 'Front Read Count',
		SUM(DS.SideGoodReadCount) AS 'Side Read Count',
		SUM(DS.GoodReadCount) AS 'Good Read Count',
		SUM(DS.NoReadCount) AS 'No Read Count',
		SUM(DS.MultiReadCount) AS 'Multi Read Count',
		SUM(DS.NoDataCount) AS 'No Data Count',
		SUM(DS.TotalCartCount) AS 'Total Cart Count',
		FrontReadPercent =   ((CAST( SUM(DS.FrontGoodReadCount) AS FLOAT) / 
							    CASE WHEN CAST(SUM(DS.TotalCartCount) AS FLOAT) > 0 THEN CAST(SUM(DS.TotalCartCount) AS FLOAT)
							    ELSE CAST(1 AS FLOAT)
							    END)*100),
						SideReadPercent =   ((CAST( SUM(DS.SideGoodReadCount) AS FLOAT) / 
							    CASE WHEN CAST(SUM(DS.TotalCartCount) AS FLOAT) > 0 THEN CAST(SUM(DS.TotalCartCount) AS FLOAT)
							    ELSE CAST(1 AS FLOAT)
							    END)*100),
					  	GoodReadPercent = (((CAST(SUM(DS.GoodReadCount) AS FLOAT) + CAST(SUM(DS.MultiReadCount) AS FLOAT)) / 
							    CASE WHEN CAST(SUM(DS.TotalCartCount) AS FLOAT) > 0 THEN CAST(SUM(DS.TotalCartCount) AS FLOAT)
							    ELSE CAST(1 AS FLOAT)
							    END)*100),
					  	NoReadPercent =   ((CAST( SUM(DS.NoReadCount) AS FLOAT) / 
							    CASE WHEN CAST(SUM(DS.TotalCartCount) AS FLOAT) > 0 THEN CAST(SUM(DS.TotalCartCount) AS FLOAT)
							    ELSE CAST(1 AS FLOAT)
							    END)*100)
		From CHS.accusort.DailyScannerStatistics DS
		INNER JOIN CHS.accusort.ScannerLocation SL
		ON SL.ScannerTypeID = DS.ScannerTypeID AND SL.ScannerID = DS.ScannerID
		Where ShiftDate between @StartDatetime AND @EndDateTime
		
Group By
		CAST(ShiftDate AS DATE),
		(DATEPART(HOUR,ShiftDate)/8),
		ScannerName
					
Order By
CAST(ShiftDate AS DATE),
(DATEPART(HOUR,ShiftDate)/8),
ScannerName