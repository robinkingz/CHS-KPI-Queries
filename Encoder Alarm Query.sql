SELECT *
  FROM [CHS].[accusort].[DeviceFaultLog_HSI]
  where DeviceTypeID = 11
  and FaultCode = 1
  and FaultStart between '2017-09-01 00:00:00:000' and '2018-03-05 00:00:00:000'
  order by FaultStart desc