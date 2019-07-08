serverUncertaintySampleVolume = function(input, output, session){
  sampleVolumeData <- reactive({
    data = sampleVolumeReadCSV(input$intputSampleVolumeFileUpload$datapath)
    return(data)
  })
  
  
  
  #Display outputs
  output$display_sampleVolume_rawDataTable = DT::renderDataTable(
    sampleVolumeData(),
    rownames = FALSE,
    options = list(scrollX = TRUE, dom = 'tip')
  )
  
  output$display_sampleVolume_standardUncertainty = renderText({
    answerValue = get_sampleVolume_standardUncerainty(sampleVolumeData())
    return(answerValue)
  })
  
  output$display_sampleVolume_finalAnswer_top = renderText({
    answerValue = get_sampleVolume_relativeStandardUncertainty(sampleVolumeData())
    return(paste("\\(u_r\\text{(SampleVolume)}=\\)",answerValue))
  })
  
  output$display_sampleVolume_finalAnswer_bottom = renderText({
    answerValue = get_sampleVolume_relativeStandardUncertainty(sampleVolumeData())
    return(answerValue)
  })
}



get_sampleVolume_standardUncerainty = function(data){

  numerator = data$measurementTolerance
  denumerator = data$measurementCoverage
  
  if(is.na(denumerator) | denumerator == "NA" | denumerator == "" | denumerator == 0)
  {
    denumerator = sqrt(3)
  }
  stdUncertainty = numerator / denumerator
  return(stdUncertainty)

}


get_sampleVolume_relativeStandardUncertainty = function(data)
{
  stdUnc = get_sampleVolume_standardUncerainty(data)
  
  relStdUnc = stdUnc / data$measurementVolume
  return(relStdUnc)
}

