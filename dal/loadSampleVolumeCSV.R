sampleVolumeReadCSV = function(filePath = NULL, validate = FALSE) {
  
  #The columns that the data should have
  columnsToCheck = list("measurementDevice" = "Your data must contain...",
                        "measurementVolume" = "Your data must contain...",
                        "measurementTolerance" = "Your data must contain...",
                        "measurementCoverage" = "Your data must contain...",
                        "measurementTimesUsed" = "Your data must contain...")
  
  return(loadCsv(filePath, validate, columnsToCheck))
}

#data = sampleVolumeReadCSV("D:\\Git\\lrcfs-measurement-of-uncertainty\\data\\sampleVolume\\sampleVolumeSampleData.csv", TRUE);data
