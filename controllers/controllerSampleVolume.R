doGetSampleVolume_standardUncerainty = function(data){
  numerator = data$equipmentTolerance
  denumerator = data$equipmentCoverage
  
  if(is.na(denumerator) | denumerator == "NA" | denumerator == "" | denumerator == 0)
  {
    denumerator = sqrt(3)
  }
  answer = numerator / denumerator
  
  return(answer)
}

doGetSampleVolume_relativeStandardUncertainty = function(data)
{
  stdUnc = doGetSampleVolume_standardUncerainty(data)
  
  answer = stdUnc / data$equipmentVolume
  
  return(answer)
}


doGetSampleVolume_result = function(data)
{
  if(is.null(data))
  {
    return(NA)
  }
  
  result = doGetSampleVolume_relativeStandardUncertainty(data)
  answer = 0
  for(i in 1:nrow(data))
  {
    answer = answer + (result[i]^2 * data[i,]$equipmentTimesUsed)
  }
  answer = sqrt(answer)
  return(answer)
}