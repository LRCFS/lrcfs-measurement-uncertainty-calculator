serverUncertaintySampleVolume = function(input, output, session){
  sampleVolumeData <- reactive({
    data = sampleVolumeReadCSV(input$intputSampleVolumeFileUpload$datapath)
    return(data)
  })
}