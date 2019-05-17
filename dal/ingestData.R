library(readxl);

readExcel = function(filePath = NULL) {

  if(is.null(filePath))
  {
    filePath = "data/ExampleCalibrationData.xlsx"
  }else{
    filePath = filePath$datapath
  }
  
  ### Extract Run 1 to Run 6 calibration data
  
  cIndex <- seq(1,19,by =3); cIndex ##Column numbers in excelsheet for the Ratios
  
  allData = read_xlsx(filePath, range = "A5:T15");
  requiredData = allData[,cIndex];
  colnames(requiredData) = c('Concentration','Run1','Run2','Run3','Run4','Run5','Run6')
  
  return(requiredData)
}
