###################################################################################
# Outputs
###################################################################################

#Reactive properties
sampleVolumeData <- reactive({
  data = sampleVolumeReadCSV(input$intputSampleVolumeFileUpload$datapath)
  return(data)
})

sampleVolumeResult = reactive ({
  result = get_sampleVolume_relativeStandardUncertainty(sampleVolumeData())
  return(result)
})


#Display input data
output$display_sampleVolume_rawDataTable = DT::renderDataTable(
  sampleVolumeData(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)


#Display calculations
output$display_sampleVolume_standardUncertainty = renderText({
  answerValue = get_sampleVolume_standardUncerainty(sampleVolumeData())
  return(answerValue)
})


#Display final answers
output$display_sampleVolume_finalAnswer_top = renderUI({
  return(withMathJax(sprintf("\\(u_r\\text{(SampleVolume)}=%f\\)",sampleVolumeResult())))
})

output$display_sampleVolume_finalAnswer_bottom = renderUI({
  return(withMathJax(sprintf("\\(u_r\\text{(SampleVolume)}=%f\\)",sampleVolumeResult())))
})

output$display_sampleVolume_finalAnswer_dashboard = renderUI({
  return(withMathJax(sprintf("\\(u_r\\text{(SampleVolume)}=%f\\)",sampleVolumeResult())))
})
  


###################################################################################
# Helper Methods
###################################################################################

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

