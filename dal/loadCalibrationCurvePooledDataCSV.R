calibrationCurvePooledDataReadCSV = function(filePath = NULL) {
  if(is.null(filePath))
  {
    return(NULL)
  }

  data = read.csv(filePath,header = TRUE, sep=",", fill = TRUE, stringsAsFactors = FALSE);
  data = removeEmptyData(data)
  
  return(data)
}
