calibrationCurveReadCSV = function(filePath = NULL) {

  if(is.null(filePath))
  {
     return(NULL)
  }

  allData = read.csv(filePath,header = TRUE, sep=",", fill = TRUE, stringsAsFactors = FALSE);
  return(allData)
}
