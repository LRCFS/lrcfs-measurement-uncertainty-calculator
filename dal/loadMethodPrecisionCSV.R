methodPrecisionReadCSV = function(filePath = NULL) {
  if(is.null(filePath))
  {
    return(NULL)
  }
  
  data = read.csv(filePath, header = TRUE, sep=",", fill = TRUE)
  data = removeEmptyData(data)

  return(data)
}