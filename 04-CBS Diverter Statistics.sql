Declare		@StartDatetime	DATETIME = '2018-02-20 00:00:00.000',
			@EndDateTime DATETIME = '2018-03-05 00:00:00.000'
		
Select		CAST(ShiftDate As Date) As 'ShiftDate',
			(DATEPART(HOUR,ShiftDate)/8)+1 AS 'ShiftID',
			DiverterName As 'Diverter',
			SUM(DDS.AttemptedDiverts) AS 'Trays Assigned',
			SUM(DDS.DivertNotConfirmed) AS 'Diver Not Attempted',
			SUM(DDS.DivertConfirmed + DDS.DivertFailed) AS 'Divert Attempted',
			SUM(DDS.DivertConfirmed) AS 'Divert Successful',
			SUM(DDS.DivertFailed) AS 'Divert Failed',
			(CAST( SUM(DDS.DivertNotConfirmed) AS FLOAT) /  
						CASE WHEN CAST(SUM(DDS.AttemptedDiverts) AS FLOAT) > 0 THEN CAST(SUM(DDS.AttemptedDiverts) AS FLOAT)
					    	ELSE 
							CASE WHEN CAST(SUM(DDS.DivertNotConfirmed) AS FLOAT) > 0 THEN CAST(SUM(DDS.DivertNotConfirmed) AS FLOAT)
							ELSE

							CAST(1 AS FLOAT) 
							END
						END) * 100 AS 'Divert Not Attempted %',
			 (CAST( SUM(DDS.DivertConfirmed) AS FLOAT) /  
						CASE WHEN CAST(SUM(DDS.DivertConfirmed + DDS.DivertFailed) AS FLOAT) > 0 THEN CAST(SUM(DDS.DivertConfirmed + DDS.DivertFailed) AS FLOAT)
					    	ELSE 
							CASE WHEN CAST(SUM(DDS.DivertConfirmed) AS FLOAT) > 0 THEN CAST(SUM(DDS.DivertConfirmed) AS FLOAT)
							ELSE

							CAST(1 AS FLOAT) 
							END
						END) * 100 AS 'Divert Sucessfull %',
			  (CAST( SUM(DDS.DivertFailed) AS FLOAT) /  
								  CASE WHEN CAST(SUM(DDS.DivertConfirmed + DDS.DivertFailed) AS FLOAT) > 0 THEN CAST(SUM(DDS.DivertConfirmed + DDS.DivertFailed) AS FLOAT)
					    			  ELSE 
									CASE WHEN CAST( SUM(DDS.DivertFailed) AS FLOAT) > 0 THEN CAST( SUM(DDS.DivertFailed) AS FLOAT)
									ELSE
										CAST(1 AS FLOAT)
									END	
								  END) *100 AS 'Divert Failed %'

FROM		CHS.accusort.DailyDivertStatistics DDS
			INNER JOIN CHS.accusort.DivertLocation DL
			ON DL.ControllerTypeID = DDS.ControllerTypeID AND DL.DiverterID = DDS.DiverterID AND DL.ControllerTypeID =2
			Where ShiftDate between @StartDatetime AND @EndDateTime

Group By	CAST(ShiftDate As Date),
			(DATEPART(HOUR,ShiftDate)/8)+1,
			DiverterName

Order By	CAST(ShiftDate As Date),
			(DATEPART(HOUR,ShiftDate)/8)+1,
			DiverterName