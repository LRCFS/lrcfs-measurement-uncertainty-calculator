calibrationCurvePooledDataReadCSV = function(filePath = NULL, validate = FALSE) {
  #The columns that the data should have
  columnsToCheck = list("conc" = "Your data must contain information about the concentrations of each run.",
                        "run1" = "Your data must contain at least one run.")
  
  return(loadCsv(filePath, validate, columnsToCheck))
}

#data = calibrationCurvePooledDataReadCSV("D:\\Git\\lrcfs-measurement-of-uncertainty\\data\\calibrationCurve\\calibrationCurveSampleData - One Run - External Error 2.csv", TRUE);data
