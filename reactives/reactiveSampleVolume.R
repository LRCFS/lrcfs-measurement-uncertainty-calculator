getDataSampleVolume = reactive({
  if(myReactives$uploadedSampleVolume == TRUE)
  {
    data = sampleVolumeReadCSV(input$inputSampleVolumeFileUpload$datapath)
    return(data)
  }
  else
  {
    return(NULL)
  }
})

getResultSampleVolume = reactive ({
  data = getDataSampleVolume()
  if(is.null(data)) return(NA)
  
  answer = doGetSampleVolume_result(data)
  return(answer)
})

getSampleVolume_degreesOfFreedom = reactive({
  if(myReactives$uploadedSampleVolume == FALSE)
  {
    return(NA)
  }
  else
  {
    return("\\infty")
  }
})

getSampleVolume_standardUncerainty = reactive({
  data = getDataSampleVolume()
  return(doGetSampleVolume_standardUncerainty(data))
})

getSampleVolume_relativeStandardUncertainty = reactive({
  data = getDataSampleVolume()
  return(doGetSampleVolume_relativeStandardUncertainty(data))
})


