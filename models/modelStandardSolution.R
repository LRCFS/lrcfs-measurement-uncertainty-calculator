###########################################################################
#
# Measurement Uncertainty Calculator - Copyright (C) 2019
# Leverhulme Research Centre for Forensic Science
# Roy Mudie, Joyce Klu, Niamh Nic Daeid
# Website: https://github.com/LRCFS/lrcfs-measurement-uncertainty-calculator/
# Contact: lrc@dundee.ac.uk
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
###########################################################################

standardSolutionData = reactive({
  if(myReactives$uploadedStandardSolutionStructure == TRUE & myReactives$uploadedStandardSolutionEquipment == TRUE)
  {
    data = standardSolutionReadCSV(input$inputStandardSolutionStructureFileUpload$datapath)
    return(data)
  }
  else
  {
    return(NULL)
  }
})

standardSolutionMeasurementData = reactive({
  if(myReactives$uploadedStandardSolutionStructure == TRUE & myReactives$uploadedStandardSolutionEquipment == TRUE)
  {
    data = standardSolutionMeasurementsReadCSV(input$inputStandardSolutionEquipmentFileUpload$datapath)
    return(data)
  }
  else
  {
    return(NULL)
  }
})

standardSolutionDataWithCalculations = reactive({
  #Calculate standard uncertainty and relative standard uncertainty of base solution
  solutionData = standardSolutionData()
  instrumentDataWithCalculations = standardSolutionInstrumentDataWithCalculations()
  return(doGetStandardSolutionDataWithCalculations(solutionData,instrumentDataWithCalculations))
})

standardSolutionInstrumentDataWithCalculations = reactive({
  #Calculate standard uncertainty and relative standard uncertainty of instruments
  measurementData = standardSolutionMeasurementData()
  return(doGetstandardSolutionInstrumentDataWithCalculations(measurementData))
})

standardSolutionResult = reactive({
  if(myReactives$uploadedStandardSolutionStructure == FALSE | myReactives$uploadedStandardSolutionEquipment == FALSE)
  {
    return(NA)
  }
    
  #Get all the solutions with all their calculations
  solutionDataWithCalculations = standardSolutionDataWithCalculations()

  #From all the solutions, we just want the final ones - the solutions that nothing else is made from
  finalSolutionsData = doGetFinalSolutions(solutionDataWithCalculations)
  
  #Calculate our final answer based on our final calibration solutions
  relativeStandardUncertaintyOfCalibrationSolutions = doGetRelativeStandardUncertaintyOfCalibrationSolutions(finalSolutionsData)
  
  return(relativeStandardUncertaintyOfCalibrationSolutions)
})

standardSolutionDof = reactive({
  if(myReactives$uploadedStandardSolutionStructure == FALSE | myReactives$uploadedStandardSolutionEquipment == FALSE)
  {
    return(NA)
  }
  else
  {
    return("\\infty")
  }
})
  
  
###################################################################################
# Outputs
###################################################################################

#Display input data
output$display_standardSolution_solutionRawData = DT::renderDataTable(
  standardSolutionData(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)

output$display_standardSolution_measurementsRawData = DT::renderDataTable(
  standardSolutionMeasurementData(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)

output$display_standardSolution_solutionsNetwork = renderGrViz({
  # solutionData = standardSolutionData()
  # measurementData = standardSolutionMeasurementData()
  # solutionAndMeasurementData = standardSolutionMergeData(solutionData, measurementData)
  solutionNetwork = standardSolutionBuildNetwork(standardSolutionData())
  plot(solutionNetwork)
})


#Display calculations
output$display_standardSolution_equipmentStandardUncertainty = renderUI({

  #Get the distinct insturments based on the name, volume and tolerance
  data = standardSolutionInstrumentDataWithCalculations() %>% distinct(equipment, equipmentVolume, equipmentTolerance, .keep_all = TRUE)
  
  formulas = c("u\\text{(Equipment)}_{\\text{(Vol,Tol)}} &= \\frac{\\text{Tolerance}}{\\text{Coverage Factor}} [[break]]")
  
  for(sampleVolumeItem in rownames(data))
  {
    sampleVolumeItemData = data[sampleVolumeItem,]

    equipment = sampleVolumeItemData$equipment
    equipmentVolume = formatNumberForDisplay(sampleVolumeItemData$equipmentVolume,input)
    equipmentCoverage = formatNumberForDisplay(sampleVolumeItemData$equipmentCoverage,input)
    equipmentTolerance = formatNumberForDisplay(sampleVolumeItemData$equipmentTolerance,input)
    answerValue = formatNumberForDisplay(sampleVolumeItemData$standardUncertainty,input)
    
    if(is.na(equipmentCoverage))
    {
      equipmentCoverage = "\\sqrt{3}"
    }
    
    formulas = c(formulas, paste0("u\\text{(",equipment,")}_{\\text{(",equipmentVolume,",",equipmentTolerance,")}} &= \\frac{",equipmentTolerance,"}{",equipmentCoverage,"} = ",colourNumber(answerValue, input$useColours, input$colour1)))
  }
  output = mathJaxAligned(formulas, 10, 20)
  
  return(withMathJax(output))

})

output$display_standardSolution_equipmentRelativeStandardUncertainty = renderUI({

  #Get the distinct Equipment based on the name, volume and tolerance
  data = standardSolutionInstrumentDataWithCalculations() %>% distinct(equipment, equipmentVolume, equipmentTolerance, .keep_all = TRUE)
  
  formulas = c("u_r\\text{(Equipment)}_{\\text{(Vol,Tol)}} &= \\frac{u\\text{(Equipment)}_{\\text{(Vol,Tol)}}}{\\text{Volume}} [[break]]")
  
  for(instrumentRow in rownames(data))
  {
    instrumentData = data[instrumentRow,]
    
    equipment = instrumentData$equipment
    equipmentVolume = formatNumberForDisplay(instrumentData$equipmentVolume,input)
    equipmentCoverage = formatNumberForDisplay(instrumentData$equipmentCoverage,input)
    equipmentTolerance = formatNumberForDisplay(instrumentData$equipmentTolerance,input)
    measurementStandardUncertainty = formatNumberForDisplay(instrumentData$standardUncertainty,input)
    answerValue = formatNumberForDisplay(instrumentData$relativeStandardUncertainty,input)
    
    formulas = c(formulas, paste0("u_r\\text{(",equipment,")}_{\\text{(",equipmentVolume,",",equipmentTolerance,")}} &= \\frac{",colourNumber(measurementStandardUncertainty, input$useColours, input$colour1),"}{",equipmentVolume,"} = ",colourNumber(answerValue, input$useColours, input$colour2)))
  }
  output = mathJaxAligned(formulas, 10, 20)
  
  return(withMathJax(output))
  
})

standardSolution_solutionRelativeStandardUncertainty_renderer = function(removeColours = FALSE)
{
  solutionData = standardSolutionDataWithCalculations()
  instrumentsData = standardSolutionInstrumentDataWithCalculations()
  
  if(is.null(solutionData) && is.null(instrumentsData)) return (NA)
  
  #Display base solution relative standard uncertainty
  baseSolution = doGetBaseSolution(solutionData)
  
  formulas = c(paste0("u_r\\text{(",baseSolution$solution,")} &= \\frac{u\\text{(",baseSolution$solution,")}}{\\text{Purity}} = \\frac{\\frac{Tolerance}{Coverage}}{\\text{Purity}} = \\frac{\\frac{",baseSolution$compoundTolerance,"}{",baseSolution$compoundCoverage,"}}{",baseSolution$compoundPurity,"} = ",colourNumber(formatNumberForDisplay(baseSolution$relativeStandardUncertainty,input), input$useColours, input$colour3)," [[break]]"))
  
  #Show base formula for relative standard uncertainty of solution calculations
  formulas = c(formulas, "u_r\\text{(WorkingSolution)} &= \\sqrt{u_r\\text{(Parent Solution)}^2 + \\sum{[u_r\\text{(Equipment)}^2_{\\text{(Vol,Tol)}} \\times N\\text{(Equipment)}_{\\text{(Vol,Tol)}}]}} [[break]]")
  
  for(i in rownames(solutionData))
  {
    solution = solutionData[i,]
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
        instrumentEquationsNames = paste0(instrumentEquationsNames,plus,"[u_r\\text{(",instrument$equipment,")}^2_{\\text{",instrument$equipmentVolume,",",instrument$equipmentTolerance,"}} \\times N\\text{(",instrument$equipment,")}_{\\text{",instrument$equipmentVolume,",",instrument$equipmentTolerance,"}}]")
        instrumentEquationsValues = paste0(instrumentEquationsValues,plus,"[",colourNumber(formatNumberForDisplay(instrument$relativeStandardUncertainty,input), input$useColours, input$colour2),"^2\\times",instrument$equipmentTimesUsed,"]")
      }
      formulas = c(formulas, paste0("u_r\\text{(",solution$solution,")} &= \\sqrt{u_r\\text{(",solutionParent$solution,")}^2",instrumentEquationsNames,"}"))
      formulas = c(formulas, paste0("&= \\sqrt{",colourNumber(formatNumberForDisplay(solutionParent$relativeStandardUncertainty,input), input$useColours, input$colour3),"^2",instrumentEquationsValues,"}"))
      formulas = c(formulas, paste0("&= ",colourNumber(formatNumberForDisplay(solution$relativeStandardUncertainty,input), input$useColours, input$colour3)," [[break]]"))
    }
  }
  
  output = mathJaxAligned(formulas, 5, 30, removeColours)
  return(withMathJax(output))
}

output$display_standardSolution_solutionRelativeStandardUncertainty = renderUI({
  return(standardSolution_solutionRelativeStandardUncertainty_renderer())
})

output$display_standardSolution_solutionsDataWithCalculations = DT::renderDataTable(
  standardSolutionDataWithCalculations(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)

output$display_standardSolution_measurementDataWithCalculations = DT::renderDataTable(
  standardSolutionInstrumentDataWithCalculations(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)


#Display final answers
output$display_standardSolution_finalAnswer_top = renderUI({
  return(paste("\\(u_r\\text{(CalStandard)}=\\)",formatNumberForDisplay(standardSolutionResult(),input)))
})

standardSolution_finalAnswer_renderer = function(removeColours = FALSE)
{
  result = standardSolutionResult()
  if(is.na(result)) return(NA)
  
  finalSolutionsData = doGetFinalSolutions(standardSolutionDataWithCalculations())
  equationNames = ""
  equationValues = ""
  
  for(i in 1:nrow(finalSolutionsData))
  {
    solution = finalSolutionsData[i,]
    plus = "+"
    if(i == 1)
    {
      plus = ""
    }
    equationNames = paste0(equationNames, plus, "u_r\\text{(",solution$solution,")}^2")
    equationValues = paste0(equationValues, plus, formatNumberForDisplay(solution$relativeStandardUncertainty,input),"^2")
  }
  formulas = c("u_r(\\text{CalStandard}) &= \\sqrt{\\sum{u_r\\text{(Calibration Curve Spiking Range)}^2}}[[break]]")
  formulas = c(formulas, paste0("u_r(\\text{CalStandard}) &=\\sqrt{",equationNames,"}[[break]]"))
  formulas = c(formulas, paste0("&=\\sqrt{",equationValues,"}"))
  formulas = c(formulas, paste0("&=",formatNumberForDisplay(result,input)))
  
  output = mathJaxAligned(formulas, 5, 20, removeColours)
  return(withMathJax(output))
}

output$display_standardSolution_finalAnswer_bottom = renderUI({
  return(standardSolution_finalAnswer_renderer())
})

output$display_standardSolution_finalAnswer_dashboard = renderUI({
  return(paste("\\(u_r\\text{(CalStandard)}=\\)",formatNumberForDisplay(standardSolutionResult(),input)))
})

output$display_standardSolution_finalAnswer_combinedUncertainty = renderUI({
  return(paste(formatNumberForDisplay(standardSolutionResult(),input)))
})

output$display_standardSolution_finalAnswer_coverageFactor = renderUI({
  return(paste(formatNumberForDisplay(standardSolutionResult(),input)))
})