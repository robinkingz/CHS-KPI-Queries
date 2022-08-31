Declare @StartDatetime	DATETIME = '2018-02-20 00:00:00.000',
		@EndDateTime DATETIME = '2018-03-05 00:00:00.000'
			
Select	CAST(SkewedTrayDetected AS DATE) AS 'Shift Date',
		(DATEPART(HOUR,SkewedTrayDetected)/8)+1 AS 'ShiftID',
		CarrierID AS 'Carrier Number',
		InductionStation AS [Induction Station],		
		CHS.accusort.usp_GetCPCDateFull(SkewedTrayDetected) AS [Skewed Tray Detected],
		CHS.accusort.usp_GetCPCDateFull(OffloadTime)	AS [Skewed Tray Offloaded]
		From CHS.accusort.SkewedCarriers
		Where SkewedTrayDetected between @StartDatetime AND @EndDateTime

Order By
CAST(SkewedTrayDetected AS DATE),
(DATEPART(HOUR,SkewedTrayDetected)/8),
SkewedTrayDetected,
CarrierID