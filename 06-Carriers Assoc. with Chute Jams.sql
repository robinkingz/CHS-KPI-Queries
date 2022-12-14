Declare		@GlobalStartDateTime DATETIME = '2018-02-20 00:00:00.000',
			@GlobalEndDateTime DATETIME = '2018-03-05 00:00:00.000',
			@InternalStartDateTime DATETIME, 
			@InternalEndDateTime DATETIME,
			@NumberOfDays INT,
			@NumberOfShifts INT
			
Set			@NumberOfDays = DATEDIFF(DAY,@GlobalStartDateTime,@GlobalEndDateTime)
Set			@NumberOfShifts = @NumberOfDays*3
Set			@InternalStartDateTime = @GlobalStartDateTime
Set			@InternalEndDateTime = DATEADD(hour, 8, @GlobalStartDateTime)

Create Table #TempCCJ
			(
			ShiftDate Date,
			ShiftID Int,
			ChuteID Int,
			FaultDateTime DateTime2,
			InductionStation Int,
			CarrierID Int,
			OffloadTime DateTime2,
			)

--Print		@NumberOfDays
--Print		@NumberOfShifts			

While		@NumberOfShifts > 0
Begin		
			Insert Into #TempCCJ (ShiftDate,ShiftID)
			Select	CAST(@InternalStartDateTime As Date) As 'Shift Date',
					(DATEPART(HOUR,@InternalStartDateTime)/8)+1 AS 'ShiftID'
			Insert Into #TempCCJ (ChuteID,FaultDateTime,InductionStation,CarrierID,OffloadTime)
			EXEC	[CHS].[accusort].[usp_Report_CarriersCausingJams]
			@CultureID = NULL,
			@StartDateTime = @InternalStartDateTime,
			@EndDateTime = @InternalEndDateTime
			Set		@NumberOfShifts =  @NumberOfShifts-1
			Set		@InternalStartDateTime = @InternalEndDateTime
			Set		@InternalEndDateTime = 	DATEADD(hour, 8, @InternalStartDateTime)			
				
End

Select * from #TempCCJ
Drop Table #TempCCJ