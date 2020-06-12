###################################################################################
# Outputs
###################################################################################

#Display input data
output$display_sampleVolume_rawDataTable = DT::renderDataTable(
  getDataSampleVolume(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)

#Display calculations
output$display_sampleVolume_standardUncertainty = renderUI({
  data = getDataSampleVolume()
  if(is.null(data)) return(NA)

  formulas = c("u\\text{(Equipment)}_{\\text{(Vol,Tol)}} &= \\frac{\\text{Tolerance}}{\\text{Coverage Factor}} [[break]]")

  for(sampleVolumeItem in rownames(data))
  {
    sampleVolumeItemData = data[sampleVolumeItem,]

    equipment = sampleVolumeItemData$equipment
    equipmentVolume = sampleVolumeItemData$equipmentVolume
    equipmentTolerance = sampleVolumeItemData$equipmentTolerance
    equipmentCoverage = sampleVolumeItemData$equipmentCoverage
    answerValue = formatNumberForDisplay(doGetSampleVolume_standardUncerainty(sampleVolumeItemData), input);
    
    formulas = c(formulas, paste0("u\\text{(",equipment,")}_{\\text{(",equipmentVolume,",",equipmentTolerance,")}} &= \\frac{",equipmentTolerance,"}{",equipmentCoverage,"} = ", colourNumber(answerValue, input$useColours, input$colour1)))
  }
  output = mathJaxAligned(formulas, 10, 20)
  
  return(withMathJax(output))
})

output$display_sampleVolume_relativeStandardUncertainty = renderUI({
  data = getDataSampleVolume()
  if(is.null(data)) return(NA)
  
  formulas = c("u_r\\text{(Equipment)}_{\\text{(Vol,Tol)}} &= \\frac{u\\text{(Equipment)}_{\\text{(Vol,Tol)}}}{\\text{Volume}} [[break]]")
  
  for(sampleVolumeItem in rownames(data))
  {
    sampleVolumeItemData = data[sampleVolumeItem,]
    
    equipment = sampleVolumeItemData$equipment
    stdUnc = formatNumberForDisplay(doGetSampleVolume_standardUncerainty(sampleVolumeItemData), input)
    equipmentVolume = sampleVolumeItemData$equipmentVolume
    equipmentTolerance = sampleVolumeItemData$equipmentTolerance
    answerValue = formatNumberForDisplay(doGetSampleVolume_relativeStandardUncertainty(sampleVolumeItemData), input)
    
    formulas = c(formulas, paste0("u_r\\text{(",equipment,")}_{\\text{(",equipmentVolume,",",equipmentTolerance,")}} &= \\frac{",colourNumber(stdUnc, input$useColours, input$colour1),"}{",equipmentVolume,"} = ", answerValue))
  }
  output = mathJaxAligned(formulas, 10, 20)
  
  return(withMathJax(output))
})

#Display final answers
output$display_sampleVolume_finalAnswer_top = renderUI({
  return(paste("\\(u_r\\text{(SampleVolume)}=\\)",formatNumberForDisplay(getResultSampleVolume(),input)))
})

output$display_sampleVolume_finalAnswer_bottom = renderUI({
  data = getDataSampleVolume()
  if(is.null(data)) return(NA)
  
  formulas = c("u_r\\text{(SampleVolume)} &= \\sqrt{\\sum{[u_r(\\text{Equipment})_{\\text{(Vol,Tol)}}^2 \\times N(\\text{Equipment})_{\\text{(Vol,Tol)}}}]}")
  
  formula = "&= \\sqrt{"
  for(sampleVolumeItem in rownames(data))
  {
    
    sampleVolumeItemData = data[sampleVolumeItem,]
    
    relativeStandardUncertainty = formatNumberForDisplay(doGetSampleVolume_relativeStandardUncertainty(sampleVolumeItemData),input)
    
    if(sampleVolumeItem == 1){
      string = paste("[",relativeStandardUncertainty,"^2")
    }
    else{
      string = paste("+ [",relativeStandardUncertainty,"^2")
    }

    formula = paste(formula, string, "\\times", sampleVolumeItemData$equipmentTimesUsed, "]")
  }
  formula = paste(formula, "}")
  
  formulas = c(formulas,formula)
  
  formulas = c(formulas, paste("&= ", formatNumberForDisplay(getResultSampleVolume(),input)))
  
  output = mathJaxAligned(formulas, 5, 20)
  
  return(withMathJax(output))
  
})

output$display_sampleVolume_finalAnswer_dashboard = renderUI({
  return(paste("\\(u_r\\text{(SampleVolume)}=\\)",formatNumberForDisplay(getResultSampleVolume(),input)))
})

output$display_sampleVolume_finalAnswer_combinedUncertainty = renderUI({
  return(paste(formatNumberForDisplay(getResultSampleVolume(),input)))
})

output$display_sampleVolume_finalAnswer_coverageFactor = renderUI({
  return(paste(formatNumberForDisplay(getResultSampleVolume(),input)))
})