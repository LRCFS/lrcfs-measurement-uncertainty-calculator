sampleVolumeReadCSV = function(filePath = NULL, validate = FALSE) {
  
  #The columns that the data should have
  columnsToCheck = list("equipment" = "Your data must contain...",
                        "equipmentVolume" = "Your data must contain...",
                        "equipmentTolerance" = "Your data must contain...",
                        "equipmentCoverage" = "Your data must contain...",
                        "equipmentTimesUsed" = "Your data must contain...")
  
  return(loadCsv(filePath, validate, columnsToCheck))
}

#data = sampleVolumeReadCSV("D:\\Git\\lrcfs-measurement-of-uncertainty\\data\\sampleVolume\\sampleVolumeSampleData.csv", TRUE);data
