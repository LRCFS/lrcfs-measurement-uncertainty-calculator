standardSolutionData = reactive({
  data = standardSolutionReadCSV(input$inputStandardSolutionStructureFileUpload$datapath)
  return(data)
})

standardSolutionMeasurementData = reactive({
  data = standardSolutionMeasurementsReadCSV(input$inputStandardSolutionEquipmentFileUpload$datapath)
  return(data)
})

standardSolutionDataWithCalculations = reactive({
  #Calculate standard uncertainty and relative standard uncertainty of base solution
  solutionData = standardSolutionData()

  standardUncertainty = mapply(getStandardUncertaintySS, solutionData$compoundTolerance, solutionData$compoundCoverage)
  relativeStandardUncertainty = getRelativeStandardUncertaintySS(standardUncertainty, solutionData$compoundPurity)
  calculationResults = data.frame("standardUncertainty" = standardUncertainty, "relativeStandardUncertainty" = relativeStandardUncertainty)
  solutionDataWithCalculations = cbind(solutionData, calculationResults)
  
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

  return(solutionDataWithCalculations)
})

standardSolutionInstrumentDataWithCalculations = reactive({
  #Calculate standard uncertainty and relative standard uncertainty of instruments
  measurementData = standardSolutionMeasurementData()
  
  standardUncertainty = mapply(getStandardUncertaintySS, measurementData$measurementTolerance, measurementData$measurementCoverage)
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
  #Get all the solutions with all their calculations
  solutionDataWithCalculations = standardSolutionDataWithCalculations()

  #From all the solutions, we just want the final ones - the solutions that nothing else is made from
  finalSolutionsData = getFinalSolutions(solutionDataWithCalculations)
  
  #Calculate our final answer based on our final calibration solutions
  relativeStandardUncertaintyOfCalibrationSolutions = getRelativeStandardUncertaintyOfCalibrationSolutions(finalSolutionsData)
  
  return(round(relativeStandardUncertaintyOfCalibrationSolutions,numDecimalPlaces))
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
output$display_standardSolution_equipmentStandardUncertainty <- renderUI({

  #Get the distinct insturments based on the name, volume and tolerance
  data = standardSolutionInstrumentDataWithCalculations() %>% distinct(measurementDevice, measurementVolume, measurementTolerance, .keep_all = TRUE)
  
  formulas = c("u\\text{(Insturment)}_{\\text{(Vol,Tol)}} &= \\frac{\\text{Insturment Tolerance}}{\\text{Coverage Factor}} [[break]]")
  
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
    
    formulas = c(formulas, paste0("u\\text{(",measurementDevice,")}_{\\text{(",measurementVolume,",",measurementTolerance,")}} &= \\frac{",measurementTolerance,"}{",measurementCoverage,"} = \\color{",color1,"}{", answerValue,"}"))
  }
  output = mathJaxAligned(formulas, 10, 20)
  
  return(withMathJax(output))

})

output$display_standardSolution_equipmentRelativeStandardUncertainty <- renderUI({

  #Get the distinct insturments based on the name, volume and tolerance
  data = standardSolutionInstrumentDataWithCalculations() %>% distinct(measurementDevice, measurementVolume, measurementTolerance, .keep_all = TRUE)
  
  formulas = c("u_r\\text{(Insturment)}_{\\text{(Vol,Tol)}} &= \\frac{u\\text{(Insturment)}_{\\text{(Vol,Tol)}}}{\\text{Instrument Volume}} [[break]]")
  
  for(instrumentRow in rownames(data))
  {
    instrumentData = data[instrumentRow,]
    
    measurementDevice = instrumentData$measurementDevice
    measurementVolume = instrumentData$measurementVolume
    measurementCoverage = instrumentData$measurementCoverage
    measurementTolerance = instrumentData$measurementTolerance
    measurementStandardUncertainty = instrumentData$standardUncertainty
    answerValue = instrumentData$relativeStandardUncertainty
    
    formulas = c(formulas, paste0("u_r\\text{(",measurementDevice,")}_{\\text{(",measurementVolume,",",measurementTolerance,")}} &= \\frac{\\color{",color1,"}{",measurementStandardUncertainty,"}}{",measurementVolume,"} = \\color{",color2,"}{", answerValue,"}"))
  }
  output = mathJaxAligned(formulas, 10, 20)
  
  return(withMathJax(output))
  
})

output$display_standardSolution_solutionRelativeStandardUncertainty <- renderUI({
  
  solutionData = standardSolutionDataWithCalculations()
  instrumentsData = standardSolutionInstrumentDataWithCalculations()
  
  #Display base solution relative standard uncertainty
  baseSolution = getBaseSolution(solutionData)
  formulas = c(paste0("u_r\\text{(",baseSolution$solution,")} &= \\frac{u\\text{(",baseSolution$solution,")}}{\\text{Purity}} = \\frac{\\frac{Tolerance}{Coverage}}{\\text{Purity}} = \\frac{\\frac{",baseSolution$compoundTolerance,"}{",baseSolution$compoundCoverage,"}}{",baseSolution$compoundPurity,"} = \\color{",color3,"}{",baseSolution$relativeStandardUncertainty,"} [[break]]"))
  
  #Show base formula for relative standard uncertainty of solution calculations
  formulas = c(formulas, "u_r\\text{(Solution)} &= \\sqrt{u_r\\text{(Parent Solution)}^2 + \\sum{[u_r\\text{(Insturment)}^2_{\\text{(Vol,Tol)}} \\times N\\text{(Insturment)}_{\\text{(Vol,Tol)}}]}} [[break]]")
  
  for(i in rownames(solutionData))
  {
    solution = solutionData[i,]
    print(solution)
    if(solution$madeFrom != "")
    {
      solutionParent = solutionData[solutionData$solution == solution$madeFrom,]
      solutionInstruments = instrumentsData[instrumentsData$solution == solution$solution,]
      
      instrumentEquationsNames = ""
      instrumentEquationsValues = ""
      for(i in rownames(solutionInstruments))
      {
        instrument = instrumentsData[i,]
        plus = "+"
        if(i == 0)
        {
          plus = ""
        }
        instrumentEquationsNames = paste0(instrumentEquationsNames,plus,"[u_r\\text{(",instrument$measurementDevice,")}^2_{\\text{",instrument$measurementVolume,",",instrument$measurementTolerance,"}} \\times N\\text{(",instrument$measurementDevice,")}_{\\text{",instrument$measurementVolume,",",instrument$measurementTolerance,"}}]")
        instrumentEquationsValues = paste0(instrumentEquationsValues,plus,"[\\color{",color2,"}{",instrument$relativeStandardUncertainty,"}^2\\times",instrument$measurementTimesUsed,"]")
      }
      
      formulas = c(formulas, paste0("u_r\\text{(",solution$solution,")} &= \\sqrt{u_r\\text{(",solutionParent$solution,")}^2",instrumentEquationsNames,"}"))
      formulas = c(formulas, paste0("&= \\sqrt{\\color{",color3,"}{",round(solutionParent$relativeStandardUncertainty,numDecimalPlaces),"}^2",instrumentEquationsValues,"}"))
      formulas = c(formulas, paste0("&= \\color{",color3,"}{",round(solution$relativeStandardUncertainty,numDecimalPlaces),"} [[break]]"))
    }
  }
  
  output = mathJaxAligned(formulas, 5, 30)
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
  return(paste("\\(u_r\\text{(StdSolution)}=\\)",standardSolutionResult()))
})

output$display_standardSolution_finalAnswer_bottom <- renderUI({
  
  formulas = character()
  finalSolutionsData = getFinalSolutions(standardSolutionDataWithCalculations())
  equationNames = ""
  equationValues = ""
  
  for(i in 1:nrow(finalSolutionsData))
  {
    print(i)
    solution = finalSolutionsData[i,]
    plus = "+"
    if(i == 1)
    {
      plus = ""
    }
    equationNames = paste0(equationNames, plus, "u_r\\text{(",solution$solution,")}^2")
    equationValues = paste0(equationValues, plus, round(solution$relativeStandardUncertainty,numDecimalPlaces),"^2")
  }
  formulas = c(formulas, paste0("u_r(\\text{StdSolution})&=\\sqrt{",equationNames,"}[[break]]"))
  formulas = c(formulas, paste0("u_r(\\text{StdSolution})&=\\sqrt{",equationValues,"}"))
  formulas = c(formulas, paste0("&=",standardSolutionResult()))
  
  output = mathJaxAligned(formulas, 5, 20)
  return(withMathJax(output))
})

output$display_standardSolution_finalAnswer_dashboard <- renderUI({
  return(paste("\\(u_r\\text{(StdSolution)}=\\)",standardSolutionResult()))
})

output$display_standardSolution_finalAnswer_combinedUncertainty <- renderUI({
  return(paste(standardSolutionResult()))
})

output$display_standardSolution_finalAnswer_coverageFactor <- renderUI({
  return(paste(standardSolutionResult()))
})


###################################################################################
# Helper Methods
###################################################################################

getBaseSolution = function(solutionDataWithCalculation)
{
  baseSolution = solutionDataWithCalculation[solutionDataWithCalculation$madeFrom == "",]
  return(baseSolution)
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
  return(round(stdUncertainty,numDecimalPlaces))
}

getRelativeStandardUncertaintySS = function(standardUncertainty, denumerator){
  relStdUncertainty = standardUncertainty / denumerator
  return(round(relStdUncertainty,numDecimalPlaces))
}