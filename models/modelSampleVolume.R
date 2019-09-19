###################################################################################
# Outputs
###################################################################################

#Reactive properties
sampleVolumeData <- reactive({
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

sampleVolumeResult = reactive ({
  data = sampleVolumeData()
  if(is.null(data))
  {
    return(NA)
  }
  
  result = get_sampleVolume_relativeStandardUncertainty(data)
  answer = 0
  for(i in 1:nrow(data))
  {
    answer = answer + (result[i]^2 * data[i,]$measurementTimesUsed)
  }
  answer = sqrt(answer)
  return(answer)
})

sampleVolumeDof = reactive({
  if(myReactives$uploadedSampleVolume == FALSE)
  {
    return(NA)
  }
  else
  {
    return("\\infty")
  }
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
  if(is.null(data))
  {
    return(NA)
  }
  
  formulas = c("u\\text{(Equipment)} &= \\frac{\\text{Tolerance}}{\\text{Coverage}} [[break]]")

  for(sampleVolumeItem in rownames(sampleVolumeData()))
  {
    sampleVolumeItemData = data[sampleVolumeItem,]

    measurementDevice = sampleVolumeItemData$measurementDevice
    measurementTolerance = sampleVolumeItemData$measurementTolerance
    measurementCoverage = sampleVolumeItemData$measurementCoverage
    answerValue = get_sampleVolume_standardUncerainty(sampleVolumeItemData)
    
    formulas = c(formulas, paste0("u\\text{(",measurementDevice,")} &= \\frac{",measurementTolerance,"}{",measurementCoverage,"} = \\color{",color1,"}{", answerValue, "}"))
  }
  output = mathJaxAligned(formulas, 10, 20)
  
  return(withMathJax(output))
})

output$display_sampleVolume_relativeStandardUncertainty = renderUI({
  
  data = sampleVolumeData()
  if(is.null(data))
  {
    return(NA)
  }
  
  formulas = c("u_r\\text{(Equipment)} &= \\frac{u\\text{(Equipment)}}{\\text{Volume}} [[break]]")
  
  for(sampleVolumeItem in rownames(sampleVolumeData()))
  {
    sampleVolumeItemData = data[sampleVolumeItem,]
    
    measurementDevice = sampleVolumeItemData$measurementDevice
    stdUnc = get_sampleVolume_standardUncerainty(sampleVolumeItemData)
    measurementVolume = sampleVolumeItemData$measurementVolume
    answerValue = get_sampleVolume_relativeStandardUncertainty(sampleVolumeItemData)
    
    formulas = c(formulas, paste0("u_r\\text{(",measurementDevice,")} &= \\frac{\\color{",color1,"}{",stdUnc,"}}{",measurementVolume,"} = ", answerValue))
  }
  output = mathJaxAligned(formulas, 10, 20)
  
  return(withMathJax(output))
})

#Display final answers
output$display_sampleVolume_finalAnswer_top = renderUI({
  return(paste("\\(u_r\\text{(SampleVolume)}=\\)",formatNumberForDisplay(sampleVolumeResult(),input)))
})

output$display_sampleVolume_finalAnswer_bottom = renderUI({
  
  data = sampleVolumeData()
  if(is.null(data))
  {
    return(NA)
  }
  
  formulas = c("u_r\\text{(SampleVolume)} &= \\sqrt{\\sum{[u_r\\text{(Equipment)}^2 \\times N\\text{(Equipment)}}]}")
  
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
  
  formulas = c(formulas, paste("&= ", formatNumberForDisplay(sampleVolumeResult(),input)))
  
  output = mathJaxAligned(formulas, 5, 20)
  
  return(withMathJax(output))
  
})

output$display_sampleVolume_finalAnswer_dashboard = renderUI({
  return(paste("\\(u_r\\text{(SampleVolume)}=\\)",formatNumberForDisplay(sampleVolumeResult(),input)))
})

output$display_sampleVolume_finalAnswer_combinedUncertainty = renderUI({
  return(paste(formatNumberForDisplay(sampleVolumeResult(),input)))
})

output$display_sampleVolume_finalAnswer_coverageFactor = renderUI({
  return(paste(formatNumberForDisplay(sampleVolumeResult(),input)))
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

