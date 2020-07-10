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
  
  uncCalibrationCurve = getResultCalibrationCurve()
  uncMethodPrecision = methodPrecisionResult()
  uncStandardSolution = standardSolutionResult()
  uncSampleVolume = getResultSampleVolume()
  combinedUncertainty = combinedUncertaintyResult()
  meanCaseSampleConcentration = input$inputCaseSampleMeanConcentration
  
  #Degress of Freedom
  #dof cal curve
  dofCalibrationCurve = getCalibrationCurve_degreesOfFreedom()
  
  #dof method precision
  dofMethodPrecision = methodPrecisionDof()
  
  #dof Standard Solution
  dofStandardSolution = Inf
  
  #dof Sample Volume
  dofSampleVolume = Inf
  
  result = getEffectiveDegreesOfFreedom(uncCalibrationCurve,dofCalibrationCurve,uncMethodPrecision,dofMethodPrecision,uncStandardSolution,dofStandardSolution,uncSampleVolume,dofSampleVolume,combinedUncertainty,meanCaseSampleConcentration)
  return(result)
})

coverageFactorResult = reactive({
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  
  return(getCoverageFactor(coverageFactorEffectiveDofTable, effectiveDof, confidenceInterval))
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

output$display_coverageFactor_dofCalibrationCurve = renderUI({
  data = getDataCalibrationCurveReformatted()
  
  formulas = character()
  
  if(!is.null(data))
  {
    n = getCalibrationCurve_n()
    formulas = c("{\\LARGE\\nu}_{\\text{CalCurve}} &= n -2")
    formulas = c(formulas,paste0("&=",n,"-2"))
    formulas = c(formulas,paste0("&= ",colourNumber(n-2, input$useColours, input$colour1)))
  }
  else
  {
    formulas = c("{\\LARGE\\nu}_{\\text{CalCurve}} &= NA")
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
    formulas = c(formulas,paste0("&= ",colourNumber(n, input$useColours, input$colour2)))
  }
  else
  {
    formulas = c("{\\LARGE\\nu}_{\\text{MethodPrec}} &= NA")
  }
  output = mathJaxAligned(formulas, 5)
  
  return(withMathJax(output))
})

output$display_coverageFactor_dofStandardSolution = renderUI({
  formulas = c(paste("{\\LARGE\\nu}_{\\text{StdSolution}} &= ",colourNumber(standardSolutionDof(), input$useColours, input$colour3)))
  output = mathJaxAligned(formulas)
  
  return(withMathJax(output))
})

output$display_coverageFactor_dofSampleVolume = renderUI({
  formulas = c(paste("{\\LARGE\\nu}_{\\text{SampleVolume}} &= ",colourNumber(getSampleVolume_degreesOfFreedom(), input$useColours, input$colour4)))
  output = mathJaxAligned(formulas)
  
  return(withMathJax(output))
})

output$display_coverageFactor_effectiveDegreesOfFreedom = renderUI({
  
  uncCalibrationCurve = formatNumberForDisplay(getResultCalibrationCurve(),input)
  uncMethodPrecision = formatNumberForDisplay(methodPrecisionResult(),input)
  uncStandardSolution = formatNumberForDisplay(standardSolutionResult(),input)
  uncSampleVolume = formatNumberForDisplay(getResultSampleVolume(),input)
  combinedUncertainty = formatNumberForDisplay(combinedUncertaintyResult(),input)
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  
  #Degrees of Freedom
  #dof cal curve
  dofCalibrationCurve = getCalibrationCurve_degreesOfFreedom()

  #dof method precision
  dofMethodPrecision = methodPrecisionDof()
  
  formulas = c("{\\LARGE\\nu}_{\\text{eff}} &=\\frac{(\\frac{\\text{CombUncertainty}}{x_s})^4}{\\sum{\\frac{u_r\\text{(Individual Uncertainty Component)}^4}{{\\LARGE\\nu}_{\\text{(Individual Uncertainty Component)}}}}} [[break]]")       
  formulas = c(formulas, "{\\LARGE\\nu}_{\\text{eff}} &= \\frac{(\\frac{\\text{CombUncertainty}}{x_s})^4}{\\frac{u_r(\\text{CalCurve})^4}{{\\LARGE\\nu}_{\\text{CalCurve}}} + \\frac{u_r(\\text{MethodPrec})^4}{{\\LARGE\\nu}_{\\text{MethodPrec}}} + \\frac{u_r(\\text{StdSolution})^4}{{\\LARGE\\nu}_{\\text{StdSolution}}} + \\frac{u_r(\\text{SampleVolume})^4}{{\\LARGE\\nu}_{\\text{SampleVolume}}}}")
  formulas = c(formulas, paste0("&= \\frac{(\\frac{",colourNumberBackground(combinedUncertainty,CombinedUncertaintyColor,"#FFF"),"}{",ColourCaseSampleMeanConcentration(caseSampleMeanConcentration),"})^4}{\\frac{",colourNumberBackground(uncCalibrationCurve, CalibrationCurveColor, "#FFF"),"^4}{",colourNumber(dofCalibrationCurve, input$useColours, input$colour1),"} + \\frac{",colourNumberBackground(uncMethodPrecision, MethodPrecisionColor, "#FFF"),"^4}{",colourNumber(dofMethodPrecision, input$useColours, input$colour2),"} + \\frac{",colourNumberBackground(uncStandardSolution, StandardSolutionColor, "#FFF"),"^4}{",colourNumber(standardSolutionDof(), input$useColours, input$colour3),"} + \\frac{",colourNumberBackground(uncSampleVolume, SampleVolumeColor, "#FFF"),"^4}{",colourNumber(getSampleVolume_degreesOfFreedom(), input$useColours, input$colour4),"}}"))
  
  result = paste("&=", formatNumberForDisplay(effectiveDofResult(),input))
  formulas = c(formulas, result)
  
  output = mathJaxAligned(formulas, 5, 20)
  return(withMathJax(HTML(output)))
})

output$display_coverageFactor_table <- DT::renderDataTable({
  
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  finalCoverageFactorEffectiveDof = getClosestCoverageFactorEffectiveDof(coverageFactorEffectiveDofTable, effectiveDof)
  coverageFactor = getCoverageFactor(coverageFactorEffectiveDofTable, effectiveDof, confidenceInterval)
  
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
  formulas = c(paste0("k_{{\\large\\nu_{\\text{eff}}},{\\small CI\\%}} = k_{\\text{",formatNumberForDisplay(effectiveDofResult(),input),",",confidenceInterval,"}}=",coverageFactorResult()))
  output = mathJaxAligned(formulas)
  
  return(withMathJax(HTML(output)))
})

output$display_coverageFactor_finalAnswer_dashboard = renderUI({
  confidenceInterval = input$inputConfidenceInterval
  output = paste0("\\(k_{\\text{",formatNumberForDisplay(effectiveDofResult(),input),",",confidenceInterval,"}}=",coverageFactorResult(),"\\)")
  return(withMathJax(HTML(output)))
})

output$display_coverageFactor_finalAnswer_expandedUncertainty = renderUI({
  return(as.character(coverageFactorResult()))
})

###################################################################################
# Helper Methods
###################################################################################
getEffectiveDegreesOfFreedom = function(uncCalibrationCurve,dofCalibrationCurve,uncMethodPrecision,dofMethodPrecision,uncStandardSolution,dofStandardSolution,uncSampleVolume,dofSampleVolume,combinedUncertainty, meanCaseSampleConcentration)
{
  dofCu = (combinedUncertainty / meanCaseSampleConcentration)^4
  
  dofCc = uncCalibrationCurve^4 / dofCalibrationCurve
  dofMp = uncMethodPrecision^4 / dofMethodPrecision
  dofSs = uncStandardSolution^4 / dofStandardSolution
  dofSv = uncSampleVolume^4 / dofSampleVolume
  dofSum = sum(dofCc, dofMp, dofSs, dofSv, na.rm = TRUE)
  
  calc = dofCu / dofSum
  
  return(calc)
}


getHighestPossibleDofInCoverageFactorEffectiveDof = function(coverageFactorEffectiveDof)
{
  possibleDofs = coverageFactorEffectiveDof$EffectiveDoF
  maxPossibleDof = sort(possibleDofs, decreasing = TRUE)[2] #Sort the numbers then take the second highest value (as the highest is going to be the infinite value)
  return(maxPossibleDof)
}

getClosestCoverageFactorEffectiveDof = function(coverageFactorEffectiveDof, effectiveDof){
  
  highestPossibleDof = getHighestPossibleDofInCoverageFactorEffectiveDof(coverageFactorEffectiveDof)
  
  closestDof = 0
  if(is.na(effectiveDof) | effectiveDof < 1)
  {
    closestDof = 1
  }
  else if(effectiveDof > highestPossibleDof)
  {
    closestDof = Inf
  }
  else
  {
    for(dof in rownames(coverageFactorEffectiveDof))
    {
      if(abs(as.numeric(dof) - effectiveDof) < abs(closestDof - effectiveDof))
      {
        closestDof = as.numeric(dof)
      }
    }
  }
  
  return(as.character(closestDof))
}

getCoverageFactor = function(coverageFactorEffectiveDof, effectiveDof, confidenceInterval){
  
  closestDof = getClosestCoverageFactorEffectiveDof(coverageFactorEffectiveDof, effectiveDof)
  
  result = coverageFactorEffectiveDof[as.character(closestDof),confidenceInterval]
  return(result)
}