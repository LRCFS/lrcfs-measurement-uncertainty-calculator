calibrationCurveReadCSV = function(filePath = NULL) {
  if(is.null(filePath))
  {
    return(NULL)
  }
  if(!str_detect(filePath,"(\\.csv|\\.CSV)$"))
  {
    return(NULL)
  }

  data = read.csv(filePath,header = TRUE, sep=",", fill = TRUE, stringsAsFactors = FALSE);
  data = removeEmptyData(data)

  return(data)
}
