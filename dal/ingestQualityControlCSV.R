library(utils)

qualityControlReadCSV = function(filePath = NULL) {

  if(is.null(filePath))
  {
    filePath = "data/qualityControl/qualityControlSampleData.csv"
  }else{
    filePath = filePath$datapath
  }
  
  allData = read.csv(filePath, header = TRUE, sep=",", fill = TRUE)

  return(allData)
}
