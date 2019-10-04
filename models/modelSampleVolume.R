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

  formulas = c("u\\text{(Equipment)} &= \\frac{\\text{Tolerance}}{\\text{Coverage}} [[break]]")

  for(sampleVolumeItem in rownames(data))
  {
    sampleVolumeItemData = data[sampleVolumeItem,]

    equipment = sampleVolumeItemData$equipment
    equipmentTolerance = sampleVolumeItemData$equipmentTolerance
    equipmentCoverage = sampleVolumeItemData$equipmentCoverage
    answerValue = doGetSampleVolume_standardUncerainty(sampleVolumeItemData)
    
    formulas = c(formulas, paste0("u\\text{(",equipment,")} &= \\frac{",equipmentTolerance,"}{",equipmentCoverage,"} = \\color{",color1,"}{", answerValue, "}"))
  }
  output = mathJaxAligned(formulas, 10, 20)
  
  return(withMathJax(output))
})

output$display_sampleVolume_relativeStandardUncertainty = renderUI({
  data = getDataSampleVolume()
  if(is.null(data)) return(NA)
  
  formulas = c("u_r\\text{(Equipment)} &= \\frac{u\\text{(Equipment)}}{\\text{Volume}} [[break]]")
  
  for(sampleVolumeItem in rownames(data))
  {
    sampleVolumeItemData = data[sampleVolumeItem,]
    
    equipment = sampleVolumeItemData$equipment
    stdUnc = doGetSampleVolume_standardUncerainty(sampleVolumeItemData)
    equipmentVolume = sampleVolumeItemData$equipmentVolume
    answerValue = doGetSampleVolume_relativeStandardUncertainty(sampleVolumeItemData)
    
    formulas = c(formulas, paste0("u_r\\text{(",equipment,")} &= \\frac{\\color{",color1,"}{",stdUnc,"}}{",equipmentVolume,"} = ", answerValue))
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
  
  formulas = c("u_r\\text{(SampleVolume)} &= \\sqrt{\\sum{[u_r\\text{(Equipment)}^2 \\times N\\text{(Equipment)}}]}")
  
  formula = "&= \\sqrt{"
  for(sampleVolumeItem in rownames(data))
  {
    
    sampleVolumeItemData = data[sampleVolumeItem,]
    
    relativeStandardUncertainty = doGetSampleVolume_relativeStandardUncertainty(sampleVolumeItemData)
    
    if(sampleVolumeItem == 1){
      string = paste(relativeStandardUncertainty,"^2")
    }
    else{
      string = paste("+",relativeStandardUncertainty,"^2")
    }

    formula = paste(formula, string, "\\times", sampleVolumeItemData$equipmentTimesUsed)
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