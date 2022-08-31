Declare		@StartDatetime	DATETIME = '2018-02-20 00:00:00.000',
			@EndDateTime DATETIME = '2018-03-05 00:00:00.000'
			
Select		CAST(ShiftDATE As Date) As 'Shift Date',
			(DATEPART(HOUR,ShiftDATE)/8)+1 AS 'ShiftID',
			BufferName As 'Buffer Name',
			LaneID As 'Lane',
			SUM(DBP.AttemptedDiverts) AS 'Tray Assigned',
						SUM(DBP.SuccessfullDiverts + DBP.FailedDiverts ) AS 'Divert Attempted',
						SUM(DBP.SuccessfullDiverts) AS 'Divert Successful',
						SUM(DBP.DivertNotConfirmed) AS 'Divert Not Successful',
						SUM(DBP.FailedDiverts) AS 'Divert Failed',
						((CAST(SUM(DBP.SuccessfullDiverts) AS FLOAT) /
								CASE WHEN CAST(SUM(DBP.SuccessfullDiverts + DBP.FailedDiverts ) AS FLOAT) > 0 THEN CAST(SUM(DBP.SuccessfullDiverts + DBP.FailedDiverts ) AS FLOAT)
								ELSE 
									CASE WHEN CAST(SUM(DBP.SuccessfullDiverts) AS FLOAT) > 0 THEN CAST(SUM(DBP.SuccessfullDiverts) AS FLOAT)
									ELSE CAST(1 AS FLOAT) 
									END		
								END)) * 100 AS [Divert Successful Percent],
						((CAST(SUM(DBP.FailedDiverts) AS FLOAT) /
								CASE WHEN CAST(SUM(DBP.SuccessfullDiverts + DBP.FailedDiverts ) AS FLOAT) > 0 THEN CAST(SUM(DBP.SuccessfullDiverts + DBP.FailedDiverts ) AS FLOAT)
								ELSE 
									CASE WHEN CAST(SUM(DBP.FailedDiverts) AS FLOAT) > 0 THEN CAST(SUM(DBP.FailedDiverts) AS FLOAT)
									ELSE CAST(1 AS FLOAT) 
									END		
								END)) * 100 AS [Divert Failed Percent]

FROM		CHS.accusort.DailyBufferProductionLog DBP
			INNER JOIN CHS.accusort.StorageBuffer SB
			ON SB.BufferId = DBP.BufferID
			Where ShiftDate between @StartDatetime AND @EndDateTime
			
Group By	CAST(ShiftDATE As Date),
			(DATEPART(HOUR,ShiftDATE)/8),
			BufferName,
			LaneID
			
Order By	CAST(ShiftDATE As Date),
			(DATEPART(HOUR,ShiftDATE)/8),
			BufferName,
			LaneID