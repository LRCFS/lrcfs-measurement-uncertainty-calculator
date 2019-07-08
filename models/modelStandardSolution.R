serverUncertaintyStandardSolution = function(input, output){
  
  solutionData = standardSolutionReadCSV()
  measurementData = standardSolutionMeasurementsReadCSV()
  solutionAndMeasurementData = standardSolutionMergeData(solutionData, measurementData)
  solutionNetwork = standardSolutionBuildNetwork(solutionData)

  #Calculate standard uncertainty and relative standard uncertainty of base solution
  standardUncertainty = mapply(getStandardUncertaintySS, solutionData$compoundTolerance, solutionData$compoundCoverage)
  relativeStandardUncertainty = getRelativeStandardUncertaintySS(standardUncertainty, solutionData$compoundPurity)
  calculationResults = data.frame("standardUncertainty" = standardUncertainty, "relativeStandardUncertainty" = relativeStandardUncertainty)
  solutionDataWithCalculations = cbind(solutionData, calculationResults)
  print(solutionDataWithCalculations)
  
  #Calculate standard uncertainty and relative standard uncertainty of instruments
  standardUncertainty = mapply(getStandardUncertaintySS, measurementData$measurementTolerance, measurementData$measurementCoverage)
  relativeStandardUncertainty = getRelativeStandardUncertaintySS(standardUncertainty, measurementData$measurementVolume)
  calculationResults = data.frame("standardUncertainty" = standardUncertainty, "relativeStandardUncertainty" = relativeStandardUncertainty)
  instrumentDataWithCalculations = cbind(measurementData, calculationResults)

  #Calculate the usage uncertainty
  usageUncertainty = getUsageUncertainty(instrumentDataWithCalculations)
  calculationResults = data.frame("usageUncertainty" = usageUncertainty)
  instrumentDataWithCalculations = cbind(instrumentDataWithCalculations, calculationResults)
  print(instrumentDataWithCalculations)
  
  
  #calculate realtive Standard Uncertainty For each Solution
  #Probably want to make this recursive to cope with any data order
  for(i in rownames(solutionDataWithCalculations))
  {
    if(is.na(solutionDataWithCalculations[i, "relativeStandardUncertainty"]))
    {
      realtiveStandardUncertaintyForSolution = getRealtiveStandardUncertaintyForSolution(solutionData[i, "solution"], solutionDataWithCalculations, instrumentDataWithCalculations)
      solutionDataWithCalculations[i, "relativeStandardUncertainty"] = realtiveStandardUncertaintyForSolution
    }
  }

  print(solutionDataWithCalculations)
  
  finalSolutionsData = getFinalSolutions(solutionDataWithCalculations)
  relativeStandardUncertaintyOfCalibrationSolutions = getRelativeStandardUncertaintyOfCalibrationSolutions(finalSolutionsData)
  
  # print(solutionData)
  # print(measurementData)
  # print(solutionAndMeasurementData)
  # print(solutionNetwork)
  # plot(solutionNetwork)
  
  output$uncertaintyOfStandardSolution <- renderText({
    return(paste("\\(u_r\\text{(StdSolution)}=\\)",relativeStandardUncertaintyOfCalibrationSolutions))
  })
  
  #Loaded RAW data views
  output$standardSolutionRawData <- DT::renderDataTable(
    solutionData,
    rownames = FALSE,
    options = list(scrollX = TRUE, dom = 'tip')
  )
  
  output$standardSolutionMeasurementsRawData <- DT::renderDataTable(
    measurementData,
    rownames = FALSE,
    options = list(scrollX = TRUE, dom = 'tip')
  )

  output$standardSolutionNetwork <- renderGrViz({
    plot(solutionNetwork)
  })
  
  #Show calcs
  output$test <- renderUI({
    box(title = "Mean of X", width = 4, height=150,"\\(\\overline{x} = \\frac{\\sum{x_i}}{n}\\)", "test")
  })
  
  #Calcualtation table views
  output$solutionsDataWithCalculations <- DT::renderDataTable(
    solutionDataWithCalculations,
    rownames = FALSE,
    options = list(scrollX = TRUE, dom = 'tip')
  )
  
  output$measurementDataWithCalculations <- DT::renderDataTable(
    instrumentDataWithCalculations,
    rownames = FALSE,
    options = list(scrollX = TRUE, dom = 'tip')
  )
  
  output$uncertaintyOfStandardSolutionAnswer <- renderText({
    return(paste("\\(u_r\\text{(StdSolution)}=\\)",relativeStandardUncertaintyOfCalibrationSolutions))
  })
}

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
  return(stdUncertainty)
}


getRelativeStandardUncertaintySS = function(standardUncertainty, denumerator){
  relStdUncertainty = standardUncertainty / denumerator
  return(relStdUncertainty)
}

