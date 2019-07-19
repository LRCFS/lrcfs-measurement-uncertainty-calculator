effectiveDofResult = reactive({
  
  uncCalibrationCurve = calibrationCurveResult()
  uncMethodPrecision = methodPrecisionResult()
  uncStandardSolution = standardSolutionResult()
  uncSampleVolume = sampleVolumeResult()
  combinedUncertainty = combinedUncertaintyResult()
  
  #Degress of Freedom
  #dof cal curve
  x = calibrationCurveDataReformatted()$calibrationDataConcentration
  dofCalibrationCurve = getDegreesOfFreedom(x)
  
  #dof method precision
  dofMethodPrecision = methodPrecisionDof()
  
  #dof Standard Solution
  dofStandardSolution = Inf
  
  #dof Sample Volume
  dofSampleVolume = Inf
  
  result = getEffectiveDegreesOfFreedom(uncCalibrationCurve,dofCalibrationCurve,uncMethodPrecision,dofMethodPrecision,uncStandardSolution,dofStandardSolution,uncSampleVolume,dofSampleVolume,combinedUncertainty)
  return(round(result,numDecimalPlaces))
})

coverageFactorResult = reactive({
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  
  getCoverageFactor(coverageFactorEffectiveDofTable, effectiveDof, confidenceInterval)
})


###################################################################################
# Outputs
###################################################################################

#Display calculations
output$display_coverageFactor_dofCalibrationCurve = renderUI({
  data = calibrationCurveDataReformatted()
  x = data$calibrationDataConcentration
  
  n = getCalibrationCurve_n(x)
  formulas = c("DoF_{\\text{CalCurve}} &= (n_{concs} \\times n_{runs}) - miss_{obvs} -2")
  formulas = c(formulas,paste0("&=",n,"-2"))
  formulas = c(formulas,paste0("&=",n-2))
  output = mathJaxAligned(formulas)
  
  return(withMathJax(output))
})

output$display_coverageFactor_dofMethodPrecision = renderUI({
  n = methodPrecisionDof()
  
  formulas = c("DoF_{\\text{MethodPrec}} &= \\sum{d_{(x_s)}}")
  formulas = c(formulas,paste0("&=",n))
  output = mathJaxAligned(formulas)
  
  return(withMathJax(output))
})

output$display_coverageFactor_dofStandardSolution = renderUI({
  formulas = c("DoF_{\\text{StdSolution}} &= \\infty")
  output = mathJaxAligned(formulas)
  
  return(withMathJax(output))
})

output$display_coverageFactor_dofSampleVolume = renderUI({
  formulas = c("DoF_{\\text{SampleVolume}} &= \\infty")
  output = mathJaxAligned(formulas)
  
  return(withMathJax(output))
})

output$display_coverageFactor_effectiveDegreesOfFreedom = renderUI({
  
  uncCalibrationCurve = calibrationCurveResult()
  uncMethodPrecision = methodPrecisionResult()
  uncStandardSolution = standardSolutionResult()
  uncSampleVolume = sampleVolumeResult()
  combinedUncertainty = combinedUncertaintyResult()
  
  #Degress of Freedom
  #dof cal curve
  x = calibrationCurveDataReformatted()$calibrationDataConcentration
  dofCalibrationCurve = getDegreesOfFreedom(x)
  
  #dof method precision
  dofMethodPrecision = methodPrecisionDof()

  formulas = c("DoF_{\\text{eff}} &=\\frac{\\text{Combined Uncertainty}^4}{\\sum{\\frac{\\text{Individual Uncertainty}^4}{\\text{Individual DoF}}}}")
  formulas = c(formulas, "&= \\frac{\\text{CombUncertainty}^4}{\\frac{u_r(\\text{CalCurve})^4}{DoF_{\\text{CalCurve}}} + \\frac{u_r(\\text{MethodPrec})^4}{DoF_{\\text{MethodPrec}}} + \\frac{u_r(\\text{StdSolution})^4}{DoF_{\\text{StdSolution}}} + \\frac{u_r(\\text{SampleVolume})^4}{DoF_{\\text{SampleVolume}}}}")
  formulas = c(formulas, paste0("&= \\frac{",combinedUncertainty,"^4}{\\frac{",uncCalibrationCurve,"^4}{",dofCalibrationCurve,"} + \\frac{",uncMethodPrecision,"^4}{",dofMethodPrecision,"} + \\frac{",uncStandardSolution,"^4}{\\infty} + \\frac{",uncSampleVolume,"^4}{\\infty}}"))
  
  result = paste("&=", effectiveDofResult())
  formulas = c(formulas, result)
  
  output = mathJaxAligned(formulas)
  return(withMathJax(HTML(output)))
})

output$display_coverageFactor_table <- DT::renderDataTable({
  
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  finalCoverageFactorEffectiveDof = getClosestCoverageFactorEffectiveDof(coverageFactorEffectiveDofTable, effectiveDof)
  coverageFactor = getCoverageFactor(coverageFactorEffectiveDofTable, effectiveDof, confidenceInterval)
  
  coverageFactorEffectiveDofTable[28,1]  = "Inf"
  
  dataTable = datatable(coverageFactorEffectiveDofTable,
                        rownames = FALSE,
                        options = list(pageLength = 100, scrollX = TRUE, dom = '', columnDefs = list(list(className = "dt-right", targets = 0:6))))%>%
    #Row Style
    formatStyle(0,"EffectiveDoF",target = "row", backgroundColor = styleEqual(finalCoverageFactorEffectiveDof, "#D8F5F5"))%>%
    #Colum style
    formatStyle(confidenceInterval, backgroundColor = styleEqual(coverageFactor,"#39cccc","#D8F5F5"), color = styleEqual(coverageFactor,"#FFF","#000"), fontWeight =  styleEqual(coverageFactor,"bold","normal"))
    

  return(dataTable)
})


#Display final answers
output$display_coverageFactor_finalAnswer_top = renderUI({
  confidenceInterval = input$inputConfidenceInterval
  output = paste0("\\(k_{\\text{",round(effectiveDofResult()),",",confidenceInterval,"}}=",coverageFactorResult(),"\\)")
  return(withMathJax(HTML(output)))
})

output$display_coverageFactor_finalAnswer_bottom = renderUI({
  confidenceInterval = input$inputConfidenceInterval
  output = paste0("\\(k_{\\text{",round(effectiveDofResult()),",",confidenceInterval,"}}=",coverageFactorResult(),"\\)")
  return(withMathJax(HTML(output)))
})

output$display_coverageFactor_finalAnswer_dashboard = renderUI({
  confidenceInterval = input$inputConfidenceInterval
  output = paste0("\\(k_{\\text{",round(effectiveDofResult()),",",confidenceInterval,"}}=",coverageFactorResult(),"\\)")
  return(withMathJax(HTML(output)))
})

output$display_coverageFactor_finalAnswer_expandedUncertainty = renderUI({
  return(as.character(coverageFactorResult()))
})

###################################################################################
# Helper Methods
###################################################################################
getEffectiveDegreesOfFreedom = function(uncCalibrationCurve,dofCalibrationCurve,uncMethodPrecision,dofMethodPrecision,uncStandardSolution,dofStandardSolution,uncSampleVolume,dofSampleVolume,combinedUncertainty)
{
  return((combinedUncertainty^4) / (((uncCalibrationCurve^4)/dofCalibrationCurve) + ((uncMethodPrecision^4)/dofMethodPrecision) + ((uncStandardSolution^4)/dofStandardSolution) + ((uncSampleVolume^4)/dofSampleVolume)))
}

getClosestCoverageFactorEffectiveDof = function(coverageFactorEffectiveDof, effectiveDof){
  
  closestDof = 0
  if(effectiveDof > 100)
  {
    closestDof = Inf
  }
  else{
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