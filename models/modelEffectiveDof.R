effectiveDofResult = reactive({
  
  uncCalibrationCurve = calibrationCurveResult()
  uncMethodPrecision = methodPrecisionResult()
  uncStandardSolution = relativeStandardUncertaintyOfCalibrationSolutions
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
  return(result)
})


###################################################################################
# Outputs
###################################################################################

#Display calculations
output$display_effectiveDof_calculations = renderUI({
  
  uncCalibrationCurve = calibrationCurveResult()
  uncMethodPrecision = methodPrecisionResult()
  uncStandardSolution = relativeStandardUncertaintyOfCalibrationSolutions
  uncSampleVolume = sampleVolumeResult()
  combinedUncertainty = combinedUncertaintyResult()
  
  #Degress of Freedom
  #dof cal curve
  x = calibrationCurveDataReformatted()$calibrationDataConcentration
  dofCalibrationCurve = getDegreesOfFreedom(x)
  
  #dof method precision
  dofMethodPrecision = methodPrecisionDof()
  
  output = paste(output, "<br /><br />")
  
  calcNumbers = sprintf("$$= \\frac{%f^4}{\\frac{%f^4}{%f} + \\frac{%f^4}{%f} + \\frac{%f^4}{\\infty} + \\frac{%f^4}{\\infty}}$$",
                 combinedUncertainty,uncCalibrationCurve,dofCalibrationCurve,uncMethodPrecision,dofMethodPrecision,uncStandardSolution,uncSampleVolume)
  output = paste(output, calcNumbers)
  
  output = paste(output, "<br /><br />")
  
  result = sprintf("$$=%f$$", effectiveDofResult())
  output = paste(output, result)
  
  
  
  
  
  
  
  
  # test = "$$\\begin{align}
  #    \\ x^2 &=  \\text{Chi-Squared} \\\\
  #    \\ sum &= \\text{summation} \\\\
  #    \\ o &=  \\text{the observed values} \\\\
  #    \\ e &=  \\text{the expected values}
  #    \\end{align}$$"
  # 
  # 
  # test = "$$\\begin{align} \\ x^2 &=  \\text{Chi-Squared} \\\\ \\ sum &= \\text{summation} \\\\ \\end{align}$$"
  #    
  # 
  # 
  # outputs = c("x^2 &= \\text{royChi-Squared}", "sum &= \\text{roySummation}")
  # 
  # start = "$$\\begin{align}"
  # end = "\\end{align}$$"
  # formulas = ""
  # for(element in outputs)
  # {
  #   formulas = paste("\\",formulas, element,"\\\\")
  # }
  # 
  # output = paste(output, start, formulas, end)
  # 
  # 
  # output = paste(output, test)
  
  
  
  
  
  formulas = character()
  
  formulas = c(formulas, "EffectiveDoF &=\\frac{\\text{Combined Uncertainty}^4}{\\sum{\\frac{\\text{(Individual Uncertainty)}^4}{\\text{Individual DoF}}}}")
  formulas = c(formulas, "&= \\frac{CombUncertainty^4}{\\frac{uncCalibrationCurve^4}{dofCalibrationCurve} + \\frac{uncMethodPrecision^4}{dofMethodPrecision} + \\frac{uncStandardSolution^4}{dofStandardSolution} + \\frac{uncSampleVolume^4}{dofSampleVolume}}")
  
  calcNumbers = sprintf("&= \\frac{%f^4}{\\frac{%f^4}{%f} + \\frac{%f^4}{%f} + \\frac{%f^4}{\\infty} + \\frac{%f^4}{\\infty}}",
                        combinedUncertainty,uncCalibrationCurve,dofCalibrationCurve,uncMethodPrecision,dofMethodPrecision,uncStandardSolution,uncSampleVolume)
  formulas = c(formulas, calcNumbers)
  
  result = sprintf("&=%f", effectiveDofResult())
  formulas = c(formulas, result)
  
  output = mathJaxAligned(formulas)
  return(withMathJax(HTML(output)))
})


#Display final answers
output$display_effectiveDof_finalAnswer_top = renderUI({
  return(withMathJax(sprintf("\\(\\text{EffectiveDoF}=%f\\)",effectiveDofResult())))
})

output$display_effectiveDof_finalAnswer_bottom = renderUI({
  return(withMathJax(sprintf("\\(\\text{EffectiveDoF}=%f\\)",effectiveDofResult())))
})

output$display_effectiveDof_finalAnswer_dashboard = renderUI({
  return(withMathJax(sprintf("\\(\\text{EffectiveDoF}=%f\\)",effectiveDofResult())))
})

###################################################################################
# Helper Methods
###################################################################################
getEffectiveDegreesOfFreedom = function(uncCalibrationCurve,dofCalibrationCurve,uncMethodPrecision,dofMethodPrecision,uncStandardSolution,dofStandardSolution,uncSampleVolume,dofSampleVolume,combinedUncertainty)
{
  return((combinedUncertainty^4) / (((uncCalibrationCurve^4)/dofCalibrationCurve) + ((uncMethodPrecision^4)/dofMethodPrecision) + ((uncStandardSolution^4)/dofStandardSolution) + ((uncSampleVolume^4)/dofSampleVolume)))
}