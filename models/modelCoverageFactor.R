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

effectiveDofResult = reactive({
  
  uncHomogeneity = getHomogeneity_relativeStandardUncertainty_value()
  uncCalibrationCurve = getResultCalibrationCurve()
  uncMethodPrecision = methodPrecisionResult()
  uncStandardSolution = standardSolutionResult()
  uncSamplePreparation = getResultSamplePreparation()
  combinedUncertainty = combinedUncertaintyResult()
  meanCaseSampleConcentration = input$inputCaseSampleMeanConcentration
  
  #Degress of Freedom
  dofHomogeneity = getHomogeneity_degreesOfFreedom()
  dofCalibrationCurve = getCalibrationCurve_degreesOfFreedom()
  dofMethodPrecision = methodPrecisionDof()
  dofStandardSolution = Inf
  dofSamplePreparation = Inf
  
  result = getEffectiveDegreesOfFreedom(uncHomogeneity,dofHomogeneity,uncCalibrationCurve,dofCalibrationCurve,uncMethodPrecision,dofMethodPrecision,uncStandardSolution,dofStandardSolution,uncSamplePreparation,dofSamplePreparation,combinedUncertainty,meanCaseSampleConcentration)
  return(result)
})

usingManualCoverageFactor = reactive({
  return(doUsingManualCoverageFactor(input$inputManualCoverageFactor))
})

coverageFactorResult = reactive({
  manualCoverageFactor = input$inputManualCoverageFactor
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  
  return(getCoverageFactor(coverageFactorEffectiveDofTable, effectiveDof, confidenceInterval, manualCoverageFactor))
})

###################################################################################
# Outputs
###################################################################################

#Display calculations

output$display_coverageFactor_meanConcentration <- renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_coverageFactor_confidenceInterval = renderUI({
  return(as.character(input$inputConfidenceInterval))
})

output$display_coverageFactor_dofHomogeneity = renderUI({
  data = getDataHomogeneity()
  
  formulas = character()
  
  if(!is.null(data))
  {
    k = getHomogeneityNumCols()
    dof = getHomogeneity_degreesOfFreedom()
    
    formulas = c("{\\LARGE\\nu}_{\\text{Homogeneity}} &= k-1")
    formulas = c(formulas,paste0("&=",k,"-1"))
    formulas = c(formulas,paste0("&= ",colourNumber(dof, input$useColours, HomogeneityColor)))
  }
  else
  {
    formulas = c(paste0("{\\LARGE\\nu}_{\\text{Homogeneity}} &= ", colourNumber(NA, input$useColours, HomogeneityColor)))
  }
  output = mathJaxAligned(formulas, 5)
  
  return(withMathJax(output))
})


output$display_coverageFactor_dofCalibrationCurve = renderUI({
  data = getDataCalibrationCurveReformatted()
  
  formulas = character()
  
  if(!is.null(data))
  {
    n = getCalibrationCurve_n()
    answer = getCalibrationCurve_degreesOfFreedom()
    
    nParamaters = NA
    if(checkUsingCalibartionCurveQuadratic())
    {
      nParamaters = 3
    }
    else
    {
      nParamaters = 2
    }
    
    formulas = c(paste("{\\LARGE\\nu}_{\\text{CalCurve}} &= n-",nParamaters))
    formulas = c(formulas,paste0("&=",n,"-",nParamaters))
    formulas = c(formulas,paste0("&= ",colourNumber(answer, input$useColours, CalibrationCurveColor)))
  }
  else
  {
    formulas = c(paste0("{\\LARGE\\nu}_{\\text{CalCurve}} &= ", colourNumber(NA, input$useColours, CalibrationCurveColor)))
  }
  output = mathJaxAligned(formulas, 5)
  
  return(withMathJax(output))
})

output$display_coverageFactor_dofMethodPrecision = renderUI({
  n = methodPrecisionDof()
  
  formulas = character()
  if(!is.na(n))
  {
    formulas = c("{\\LARGE\\nu}_{\\text{MethodPrec}} &= \\sum{{\\LARGE\\nu}_{\\text{(NV)}}}")
    formulas = c(formulas,paste0("&= ",colourNumber(n, input$useColours, MethodPrecisionColor)))
  }
  else
  {
    formulas = c(paste0("{\\LARGE\\nu}_{\\text{MethodPrec}} &= ", colourNumber(NA, input$useColours, MethodPrecisionColor)))
  }
  output = mathJaxAligned(formulas, 5)
  
  return(withMathJax(output))
})

output$display_coverageFactor_dofStandardSolution = renderUI({
  formulas = c(paste("{\\LARGE\\nu}_{\\text{CalStandard}} &= ",colourNumber(standardSolutionDof(), input$useColours, StandardSolutionColor)))
  output = mathJaxAligned(formulas)
  
  return(withMathJax(output))
})

output$display_coverageFactor_dofSamplePreparation = renderUI({
  formulas = c(paste("{\\LARGE\\nu}_{\\text{SamplePreparation}} &= ",colourNumber(getSamplePreparation_degreesOfFreedom(), input$useColours, SamplePreparationColor)))
  output = mathJaxAligned(formulas)
  
  return(withMathJax(output))
})

coverageFactor_effectiveDegreesOfFreedom_renderer = function(removeColours = FALSE)
{
  uncHomogeneity = getHomogeneity_relativeStandardUncertainty()
  uncCalibrationCurve = formatNumberForDisplay(getResultCalibrationCurve(),input)
  uncMethodPrecision = formatNumberForDisplay(methodPrecisionResult(),input)
  uncStandardSolution = formatNumberForDisplay(standardSolutionResult(),input)
  uncSamplePreparation = formatNumberForDisplay(getResultSamplePreparation(),input)
  combinedUncertainty = formatNumberForDisplay(combinedUncertaintyResult(),input)
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  
  #Degrees of Freedom
  dofHomogeneity = getHomogeneity_degreesOfFreedom()
  dofCalibrationCurve = getCalibrationCurve_degreesOfFreedom()
  dofMethodPrecision = methodPrecisionDof()
  
  if(is.na(uncHomogeneity)){hoText = ""}else{hoText = "+ \\frac{u_r( \\text{Homogeneity})^4}{{ \\LARGE\\nu}_{ \\text{Homogeneity}}}"}
  if(is.na(uncCalibrationCurve)){ccText = ""}else{ccText = "+ \\frac{u_r( \\text{CalCurve})^4}{{ \\LARGE\\nu}_{ \\text{CalCurve}}}"}
  if(is.na(uncMethodPrecision)){mpText = ""}else{mpText = "+ \\frac{u_r( \\text{MethodPrec})^4}{{ \\LARGE\\nu}_{ \\text{MethodPrec}}}"}
  if(is.na(uncStandardSolution)){ssText = ""}else{ssText = "+ \\frac{u_r( \\text{CalStandard})^4}{{ \\LARGE\\nu}_{ \\text{CalStandard}}}"}
  if(is.na(uncSamplePreparation)){svText = ""}else{svText = "+ \\frac{u_r( \\text{SamplePreparation})^4}{{ \\LARGE\\nu}_{ \\text{SamplePreparation}}}"}
  componentTexts = paste0(hoText,ccText,mpText,ssText,svText) #Combine all the text values
  componentTexts = sub('.', '', componentTexts)#Remove the first character (which is going to be a plus symbol +)
  
  if(is.na(uncHomogeneity)){hoValue = ""}else{hoValue = paste("+ \\frac{",colourNumberBackground(uncHomogeneity, HomogeneityColor, "#FFF",input$useColours),"^4}{",colourNumber(dofHomogeneity, input$useColours, HomogeneityColor),"}")}
  if(is.na(uncCalibrationCurve)){ccValue = ""}else{ccValue = paste("+ \\frac{",colourNumberBackground(uncCalibrationCurve, CalibrationCurveColor, "#FFF",input$useColours),"^4}{",colourNumber(dofCalibrationCurve, input$useColours, CalibrationCurveColor),"}")}
  if(is.na(uncMethodPrecision)){mpValue = ""}else{mpValue = paste("+ \\frac{",colourNumberBackground(uncMethodPrecision, MethodPrecisionColor, "#FFF",input$useColours),"^4}{",colourNumber(dofMethodPrecision, input$useColours, MethodPrecisionColor),"}")}
  if(is.na(uncStandardSolution)){ssValue = ""}else{ssValue = paste("+ \\frac{",colourNumberBackground(uncStandardSolution, StandardSolutionColor, "#FFF",input$useColours),"^4}{",colourNumber(standardSolutionDof(), input$useColours, StandardSolutionColor),"}")}
  if(is.na(uncSamplePreparation)){svValue = ""}else{svValue = paste("+ \\frac{",colourNumberBackground(uncSamplePreparation, SamplePreparationColor, "#FFF",input$useColours),"^4}{",colourNumber(getSamplePreparation_degreesOfFreedom(), input$useColours, SamplePreparationColor),"}")}
  componentValues = paste0(hoValue,ccValue,mpValue,ssValue,svValue) #Combine all the text values
  componentValues = sub('.', '', componentValues)#Remove the first character (which is going to be a plus symbol +)
  
  formulas = c("{\\LARGE\\nu}_{\\text{eff}} &=\\frac{(\\frac{\\text{CombUncertainty}}{x_s})^4}{\\sum{\\frac{u_r\\text{(Individual Uncertainty Component)}^4}{{\\LARGE\\nu}_{\\text{(Individual Uncertainty Component)}}}}} [[break]]")       
  formulas = c(formulas, paste("{\\LARGE\\nu}_{\\text{eff}} &= \\frac{(\\frac{\\text{CombUncertainty}}{x_s})^4}{",componentTexts,"}"))
  formulas = c(formulas, paste0("&= \\frac{(\\frac{",colourNumberBackground(combinedUncertainty,CombinedUncertaintyColor,"#FFF",input$useColours),"}{",ColourCaseSampleMeanConcentration(caseSampleMeanConcentration,input$useColours),"})^4}{",componentValues,"}"))
  
  result = paste("&=", formatNumberForDisplay(effectiveDofResult(),input))
  formulas = c(formulas, result)
  
  output = mathJaxAligned(formulas, 5, 20, removeColours)
  return(withMathJax(HTML(output)))
}

output$display_coverageFactor_effectiveDegreesOfFreedom = renderUI({
  return(coverageFactor_effectiveDegreesOfFreedom_renderer())
})

output$display_coverageFactor_table <- DT::renderDataTable({
  
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  finalCoverageFactorEffectiveDof = getClosestCoverageFactorEffectiveDof(coverageFactorEffectiveDofTable, effectiveDof)
  coverageFactor = coverageFactorResult()
  
  coverageFactorEffectiveDofTable[nrow(coverageFactorEffectiveDofTable),1]  = "Inf"
  
  dataTable = datatable(coverageFactorEffectiveDofTable,
                        rownames = FALSE,
                        options = list(pageLength = 100, scrollX = TRUE, dom = '', columnDefs = list(list(className = "dt-right", targets = 0:ncol(coverageFactorEffectiveDofTable)-1))))%>%
    #Row Style
    formatStyle(0,"EffectiveDoF",target = "row", backgroundColor = styleEqual(finalCoverageFactorEffectiveDof, CoverageFactorTableHighligthColor))%>%
    #Colum style
    formatStyle(confidenceInterval, backgroundColor = styleEqual(coverageFactor,CoverageFactorColor,CoverageFactorTableHighligthColor), color = styleEqual(coverageFactor,"#FFF","#000"), fontWeight =  styleEqual(coverageFactor,"bold","normal"))
    

  return(dataTable)
})


#Display final answers
output$display_coverageFactor_finalAnswer_top = renderUI({
  confidenceInterval = input$inputConfidenceInterval
  output = paste0("\\(k_{\\text{",formatNumberForDisplay(effectiveDofResult(),input),",",confidenceInterval,"}}=",coverageFactorResult(),"\\)")
  return(withMathJax(HTML(output)))
})

output$display_coverageFactor_finalAnswer_bottom = renderUI({
  confidenceInterval = input$inputConfidenceInterval
  formulas = c(paste0("k_{{\\large\\nu_{\\text{eff}}},{\\small CL\\%}} = k_{\\text{",formatNumberForDisplay(effectiveDofResult(),input),",",confidenceInterval,"}}=",coverageFactorResult()))
  output = mathJaxAligned(formulas)
  
  return(withMathJax(HTML(output)))
})

output$display_coverageFactor_finalAnswer_dashboard = renderUI({
  confidenceInterval = input$inputConfidenceInterval
  
  output = NULL
  if(usingManualCoverageFactor())
  {
    output = paste0("\\(k=",coverageFactorResult(),"\\)")
  }
  else
  {
    output = paste0("\\(k_{\\text{",formatNumberForDisplay(effectiveDofResult(),input),",",confidenceInterval,"}}=",coverageFactorResult(),"\\)")
  }
  
  return(withMathJax(HTML(output)))
})

output$display_coverageFactor_finalAnswer_expandedUncertainty = renderUI({
  return(as.character(coverageFactorResult()))
})