calibrationCurveReadCSV = function(filePath = NULL) {

  if(is.null(filePath))
  {
    filePath = "data/calibrationCurve/calibrationCurveSampleData.csv"
  }else{
    filePath = filePath$datapath
  }

  allData = read.csv(filePath,header = TRUE, sep=",", fill = TRUE, stringsAsFactors = FALSE);
  return(allData)
}
