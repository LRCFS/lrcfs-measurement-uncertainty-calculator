library(utils)

methodPrecisionReadCSV = function(filePath = NULL) {

  if(is.null(filePath))
  {
    filePath = "data/methodPrecision/methodPrecisionSampleData.csv"
  }else{
    filePath = filePath$datapath
  }
  
  allData = read.csv(filePath, header = TRUE, sep=",", fill = TRUE)

  return(allData)
}
