Declare @StartDatetime	DATETIME = '2018-02-20 00:00:00.000',
		@EndDateTime DATETIME = '2018-03-05 00:00:00.000'
		
Select	CAST(ShiftDate As DATE) As 'Shift Date',
		(DATEPART(HOUR,ShiftDate)/8)+1 AS 'ShiftID',
		Ind.InductionStationName As 'Induction Station Name',
		SUM(DI.InductionCount) AS 'Induction Count'
		FROM   CHS.accusort.DailyInductionStatistics DI
		INNER JOIN CHS.accusort.InductionStation Ind
		ON Ind.InductionStationId = DI.InductionStationId
		Where (ShiftDate between @StartDatetime AND @EndDateTime)
		AND (DI.InductionStationID between 47 AND 51)
		
Group By
		CAST(ShiftDate As DATE),
		(DATEPART(HOUR,ShiftDate)/8),
		InductionStationName
		
Order By
		CAST(ShiftDate As DATE),
		(DATEPART(HOUR,ShiftDate)/8),
		InductionStationName