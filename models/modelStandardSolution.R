standardSolutionData = reactive({
  data = standardSolutionReadCSV()
  print(data)
  return(data)
})

standardSolutionMeasurementData = reactive({
  data = standardSolutionMeasurementsReadCSV()
  return(data)
})

standardSolutionDataWithCalculations = reactive({
  #Calculate standard uncertainty and relative standard uncertainty of base solution
  solutionData = standardSolutionData()
  
  standardUncertainty = mapply(getStandardUncertaintySS, solutionData$compoundTolerance)
  relativeStandardUncertainty = getRelativeStandardUncertaintySS(standardUncertainty, solutionData$compoundPurity)
  calculationResults = data.frame("standardUncertainty" = standardUncertainty, "relativeStandardUncertainty" = relativeStandardUncertainty)
  solutionDataWithCalculations = cbind(solutionData, calculationResults)
  return(solutionDataWithCalculations)
})

standardSolutionInstrumentDataWithCalculations = reactive({
  #Calculate standard uncertainty and relative standard uncertainty of instruments
  measurementData = standardSolutionMeasurementData()
  
  standardUncertainty = mapply(getStandardUncertaintySS, measurementData$measurementTolerance)
  relativeStandardUncertainty = getRelativeStandardUncertaintySS(standardUncertainty, measurementData$measurementVolume)
  calculationResults = data.frame("standardUncertainty" = standardUncertainty, "relativeStandardUncertainty" = relativeStandardUncertainty)
  instrumentDataWithCalculations = cbind(measurementData, calculationResults)
  
  #Calculate the usage uncertainty
  usageUncertainty = getUsageUncertainty(instrumentDataWithCalculations)
  calculationResults = data.frame("usageUncertainty" = usageUncertainty)
  instrumentDataWithCalculations = cbind(instrumentDataWithCalculations, calculationResults)
  
  return(instrumentDataWithCalculations)
})

standardSolutionResult = reactive({
  
  solutionData = standardSolutionData()
  solutionDataWithCalculations = standardSolutionDataWithCalculations()

  #calculate realtive Standard Uncertainty For each Solution
  #Probably want to make this recursive to cope with any data order
  for(i in rownames(solutionDataWithCalculations))
  {
    if(is.na(solutionDataWithCalculations[i, "relativeStandardUncertainty"]))
    {
      realtiveStandardUncertaintyForSolution = getRealtiveStandardUncertaintyForSolution(solutionData[i, "solution"], solutionDataWithCalculations, standardSolutionInstrumentDataWithCalculations())
      solutionDataWithCalculations[i, "relativeStandardUncertainty"] = realtiveStandardUncertaintyForSolution
    }
  }
  
  finalSolutionsData = getFinalSolutions(solutionDataWithCalculations)
  relativeStandardUncertaintyOfCalibrationSolutions = round(getRelativeStandardUncertaintyOfCalibrationSolutions(finalSolutionsData),numDecimalPlaces)
  
  return(relativeStandardUncertaintyOfCalibrationSolutions)
})
  
  
###################################################################################
# Outputs
###################################################################################

#Display input data
output$display_standardSolution_solutionRawData <- DT::renderDataTable(
  standardSolutionData(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)

output$display_standardSolution_measurementsRawData <- DT::renderDataTable(
  standardSolutionMeasurementData(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)

output$display_standardSolution_solutionsNetwork <- renderGrViz({
  # solutionData = standardSolutionData()
  # measurementData = standardSolutionMeasurementData()
  # solutionAndMeasurementData = standardSolutionMergeData(solutionData, measurementData)
  solutionNetwork = standardSolutionBuildNetwork(standardSolutionData())
  plot(solutionNetwork)
})


#Display calculations
output$display_standardSolution_standardUncertainty <- renderUI({

  #Get the distinct insturments based on the name, volume and tolerance
  data = standardSolutionInstrumentDataWithCalculations() %>% distinct(measurementDevice, measurementVolume, measurementTolerance, .keep_all = TRUE)
  
  formulas = c("u\\text{(Insturment)}_{\\text{Vol,Tol}} &= \\frac{\\text{Insturment Tolerance}}{\\text{Coverage Factor}}")
  
  for(sampleVolumeItem in rownames(data))
  {
    sampleVolumeItemData = data[sampleVolumeItem,]

    measurementDevice = sampleVolumeItemData$measurementDevice
    measurementVolume = sampleVolumeItemData$measurementVolume
    measurementCoverage = sampleVolumeItemData$measurementCoverage
    measurementTolerance = sampleVolumeItemData$measurementTolerance
    answerValue = sampleVolumeItemData$standardUncertainty
    
    if(is.na(measurementCoverage))
    {
      measurementCoverage = "\\sqrt{3}"
    }
    
    formulas = c(formulas, paste0("u\\text{(",measurementDevice,")}_{\\text{(",measurementVolume,",",measurementTolerance,")}} &= \\frac{",measurementTolerance,"}{",measurementCoverage,"} = ", answerValue))
  }
  output = mathJaxAligned(formulas)
  
  return(withMathJax(output))

})

output$display_standardSolution_relativeStandardUncertainty <- renderUI({

  #Get the distinct insturments based on the name, volume and tolerance
  data = standardSolutionInstrumentDataWithCalculations() %>% distinct(measurementDevice, measurementVolume, measurementTolerance, .keep_all = TRUE)
  
  formulas = c("u_r\\text{(Insturment)}_{\\text{Vol,Tol}} &= \\frac{u\\text{(Insturment)}_{\\text{Vol,Tol}}}{\\text{Instrument Volume}}")
  
  for(instrumentRow in rownames(data))
  {
    instrumentData = data[instrumentRow,]
    
    measurementDevice = instrumentData$measurementDevice
    measurementVolume = instrumentData$measurementVolume
    measurementCoverage = instrumentData$measurementCoverage
    measurementTolerance = instrumentData$measurementTolerance
    measurementStandardUncertainty = instrumentData$standardUncertainty
    answerValue = instrumentData$relativeStandardUncertainty
    
    formulas = c(formulas, paste0("u_r\\text{(",measurementDevice,")}_{\\text{(",measurementVolume,",",measurementTolerance,")}} &= \\frac{",measurementStandardUncertainty,"}{",measurementVolume,"} = ", answerValue))
  }
  output = mathJaxAligned(formulas)
  
  return(withMathJax(output))
  
})

output$display_standardSolution_solutionsDataWithCalculations <- DT::renderDataTable(
  standardSolutionDataWithCalculations(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)

output$display_standardSolution_measurementDataWithCalculations <- DT::renderDataTable(
  standardSolutionInstrumentDataWithCalculations(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)


#Display final answers
output$display_standardSolution_finalAnswer_top <- renderUI({
  return(withMathJax(sprintf("\\(u_r(\\text{StdSolution})=%f\\)",standardSolutionResult())))
})

output$display_standardSolution_finalAnswer_bottom <- renderUI({
  return(withMathJax(sprintf("\\(u_r(\\text{StdSolution})=%f\\)",standardSolutionResult())))
})

output$display_standardSolution_finalAnswer_dashboard <- renderUI({
  return(withMathJax(sprintf("\\(u_r(\\text{StdSolution})=%f\\)",standardSolutionResult())))
})

output$display_standardSolution_finalAnswer_combinedUncertainty <- renderUI({
  return(paste(standardSolutionResult()))
})


###################################################################################
# Helper Methods
###################################################################################

getFinalSolutions = function(solutionDataWithCalculations)
{
  finalSolutions = data.frame()
  
  for(i in rownames(solutionDataWithCalculations))
  {
    solutionName = solutionDataWithCalculations[i,"solution"]
    numRows = nrow(solutionDataWithCalculations[solutionDataWithCalculations$madeFrom == solutionName,])
    if(numRows == 0)
    {
      finalSolutions = rbind(finalSolutions, solutionDataWithCalculations[i,])
    }
  }
  return(finalSolutions)
}

getRelativeStandardUncertaintyOfCalibrationSolutions = function(calibrationSolutionsData)
{
  answer = sqrt(sum((calibrationSolutionsData$relativeStandardUncertainty)^2))
  return(answer)
}

getUsageUncertainty = function(instrumentDataWithCalculations)
{
  return((instrumentDataWithCalculations$relativeStandardUncertainty)^2 * instrumentDataWithCalculations$measurementTimesUsed)
}

getRealtiveStandardUncertaintyForSolution = function(solutionName, solutionData, measurementData){

  madeFrom = solutionData[solutionData$solution == solutionName,]$madeFrom
  parentRelativeStandardUncertainty = solutionData[solutionData$solution == madeFrom,]$relativeStandardUncertainty

  instrumentData = measurementData[measurementData$solution == solutionName,]

  number = (parentRelativeStandardUncertainty)^2 + sum(instrumentData$usageUncertainty)
  number = sqrt(number)
  if(length(number) > 0)
  {
    return(number)
  }
  else
  {
    return(NA)
  }
}

getStandardUncertaintySS = function(numerator, denumerator = NA){
  if(is.na(denumerator) | denumerator == "NA" | denumerator == "" | denumerator == 0)
  {
    denumerator = sqrt(3)
  }
  stdUncertainty = numerator / denumerator
  return(round(stdUncertainty,numDecimalPlaces))
}

getRelativeStandardUncertaintySS = function(standardUncertainty, denumerator){
  relStdUncertainty = standardUncertainty / denumerator
  return(round(relStdUncertainty,numDecimalPlaces))
}