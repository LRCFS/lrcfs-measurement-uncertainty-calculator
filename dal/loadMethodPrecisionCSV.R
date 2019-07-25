methodPrecisionReadCSV = function(filePath = NULL) {
  if(is.null(filePath))
  {
    return(NA)
  }
  
  allData = read.csv(filePath, header = TRUE, sep=",", fill = TRUE)

  return(allData)
}