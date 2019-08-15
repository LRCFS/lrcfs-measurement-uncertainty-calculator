methodPrecisionReadCSV = function(filePath = NULL, validate = FALSE) {

  #The columns that the data should have
  columnsToCheck = list("conc" = "Your data must contain information about the concentrations of each run.",
                        "run1" = "Your data must contain at least one run.")

  return(loadCsv(filePath, validate, columnsToCheck))
}

#data = methodPrecisionReadCSV("D:\\Git\\lrcfs-measurement-of-uncertainty\\data\\methodPrecision\\methodPrecisionSampleData.csv");data
