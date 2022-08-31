Declare @StartDatetime	DATETIME = '2018-02-20 00:00:00.000',
		@EndDateTime DATETIME = '2018-03-05 00:00:00.000'
			
Select	CAST(ShiftDate AS DATE) AS 'Shift Date',
		(DATEPART(HOUR,DateRecorded)/8)+1 AS 'ShiftID',
		SDPName AS 'SDP',
		SUM(DS.StraightLogicalCount) AS 'Stragiht Logical Count',
		SUM(DS.LeftLogicalCount) AS 'Left Logical Count',
		SUM(DS.RightLogicalCount) AS 'Right Logical Count',
		SUM(DS.StraightPhysicalCount) AS 'Stragiht Physical Count',
		SUM(DS.LeftPhysicalCount) AS 'Left Physical Count',
		SUM(DS.RightPhysicalCount) AS 'Right Physical Count',
		ABS(SUM(DS.StraightLogicalCount) - SUM(DS.StraightPhysicalCount)) AS 'Stragiht Mis Diverts',
		ABS(SUM(DS.LeftLogicalCount) - SUM(DS.LeftPhysicalCount))  AS 'Left Mis Diverts',
		ABS( SUM(DS.RightLogicalCount) - SUM(DS.RightPhysicalCount)) AS 'Right Mis Diverts'
		From CHS.accusort.DailySDPDivertCounts DS
		INNER JOIN CHS.accusort.SDPConfiguration SDP
		ON SDP.SDPID = DS.SDPID
		Where DateRecorded between @StartDatetime AND @EndDateTime
		
Group By
		CAST(ShiftDate AS DATE),
		(DATEPART(HOUR,DateRecorded)/8),
		SDPName
					
Order By
CAST(ShiftDate AS DATE),
(DATEPART(HOUR,DateRecorded)/8),
SDPName