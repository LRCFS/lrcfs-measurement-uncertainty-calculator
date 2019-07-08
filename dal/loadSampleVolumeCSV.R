library(utils)

sampleVolumeReadCSV = function(filePathSampleVolumeData = NULL) {
  
  if(is.null(filePathSampleVolumeData))
  {
    filePathSamplevolumeData = "data/sampleVolume/sampleVolumeSampleData.csv"
  }else{
    filePathSamplevolumeData = filePathSamplevolumeData #use filePathSamplevolumeData$datapath (note add $DATAPATH no the end) if loading from file upload dialouge)
  }

  sampleVolumeData = read.csv(filePathSamplevolumeData, header = TRUE, sep=",", fill = TRUE, stringsAsFactors = FALSE)

  return(sampleVolumeData)
}
