library(utils)

sampleVolumeReadCSV = function(filePath = NULL) {
  
  #Remember to use $datapath when calling this function if using fileUpload input
  if(is.null(filePath))
  {
    filePath = "data/sampleVolume/sampleVolumeSampleData.csv"
  }

  data = read.csv(filePath, header = TRUE, sep=",", fill = TRUE, stringsAsFactors = FALSE)

  return(data)
}
