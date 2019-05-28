library(utils)

standardSolutionReadCSV = function(filePath = NULL) {

  if(is.null(filePath))
  {
    filePath = "data/standardSolution/standardSolutionSampleData.csv"
  }else{
    filePath = filePath$datapath
  }
  
  allData = read.csv(filePath, header = TRUE, sep=",", fill = TRUE)

  return(allData)
}
