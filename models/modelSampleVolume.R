###################################################################################
# Outputs
###################################################################################

#Reactive properties
sampleVolumeData <- reactive({
  data = sampleVolumeReadCSV(input$intputSampleVolumeFileUpload$datapath)
  return(data)
})

sampleVolumeResult = reactive ({
  data = sampleVolumeData()
  result = get_sampleVolume_relativeStandardUncertainty(data)
  answer = 0
  for(i in 1:nrow(data))
  {
    answer = answer + (result[i]^2 * data[i,]$measurementTimesUsed)
  }
  answer = sqrt(answer)
  return(round(answer,numDecimalPlaces))
})


#Display input data
output$display_sampleVolume_rawDataTable = DT::renderDataTable(
  sampleVolumeData(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)


#Display calculations
output$display_sampleVolume_standardUncertainty = renderUI({
  
  data = sampleVolumeData()
  
  formulas = c("u\\text{(SampleVolume)}_{\\text{(Instrument)}} &= \\frac{\\text{measurementTolerance}}{\\text{measurementCoverage}}")

  for(sampleVolumeItem in rownames(sampleVolumeData()))
  {
    sampleVolumeItemData = data[sampleVolumeItem,]

    measurementDevice = sampleVolumeItemData$measurementDevice
    measurementTolerance = sampleVolumeItemData$measurementTolerance
    measurementCoverage = sampleVolumeItemData$measurementCoverage
    answerValue = get_sampleVolume_standardUncerainty(sampleVolumeItemData)
    
    formulas = c(formulas, paste("u\\text{(SampleVolume)}_{\\text{(",measurementDevice,")}} &= \\frac{",measurementTolerance,"}{",measurementCoverage,"} = ", answerValue))
  }
  output = mathJaxAligned(formulas)
  
  return(withMathJax(output))
})

output$display_sampleVolume_relativeStandardUncertainty = renderUI({
  
  data = sampleVolumeData()
  
  formulas = c("u_r\\text{(SampleVolume)}_{\\text{(Instrument)}} &= \\frac{u\\text{(SampleVolume)}_{\\text{(Instrument)}}}{\\text{measurementVolume}}")
  
  for(sampleVolumeItem in rownames(sampleVolumeData()))
  {
    sampleVolumeItemData = data[sampleVolumeItem,]
    
    measurementDevice = sampleVolumeItemData$measurementDevice
    stdUnc = get_sampleVolume_standardUncerainty(sampleVolumeItemData)
    measurementVolume = sampleVolumeItemData$measurementVolume
    answerValue = get_sampleVolume_relativeStandardUncertainty(sampleVolumeItemData)
    
    formulas = c(formulas, paste("u_r\\text{(SampleVolume)}_{\\text{(",measurementDevice,")}} &= \\frac{",stdUnc,"}{",measurementVolume,"} = ",answerValue))
  }
  output = mathJaxAligned(formulas)
  
  return(withMathJax(output))
})

#Display final answers
output$display_sampleVolume_finalAnswer_top = renderUI({
  return(withMathJax(sprintf("\\(u_r\\text{(SampleVolume)}=%f\\)",sampleVolumeResult())))
})

output$display_sampleVolume_finalAnswer_bottom = renderUI({
  
  data = sampleVolumeData()
  
  formulas = c("u_r\\text{(SampleVolume)} &= \\sqrt{\\sum{(u_r(SampleVolume)_{(\\text{measurementDevice})}^2\\times\\text{measurementTimesUsed}})}")
  
  formula = "&= \\sqrt{"
  for(sampleVolumeItem in rownames(data))
  {
    
    sampleVolumeItemData = data[sampleVolumeItem,]
    
    relativeStandardUncertainty = get_sampleVolume_relativeStandardUncertainty(sampleVolumeItemData)
    
    if(sampleVolumeItem == 1){
      string = paste(relativeStandardUncertainty,"^2")
    }
    else{
      string = paste("+",relativeStandardUncertainty,"^2")
    }

    formula = paste(formula, string, "\\times", sampleVolumeItemData$measurementTimesUsed)
  }
  formula = paste(formula, "}")
  
  formulas = c(formulas,formula)
  
  formulas = c(formulas, paste("&= ", sampleVolumeResult()))
  
  output = mathJaxAligned(formulas)
  
  return(withMathJax(output))
  
})

output$display_sampleVolume_finalAnswer_dashboard = renderUI({
  return(withMathJax(sprintf("\\(u_r\\text{(SampleVolume)}=%f\\)",sampleVolumeResult())))
})

output$display_sampleVolume_finalAnswer_combinedUncertainty = renderUI({
  return(paste(sampleVolumeResult()))
})

output$display_sampleVolume_finalAnswer_coverageFactor = renderUI({
  return(paste(sampleVolumeResult()))
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

