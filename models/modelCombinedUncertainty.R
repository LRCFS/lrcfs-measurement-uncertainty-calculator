combinedUncertaintyResult = reactive({
  meanConcentration = input$inputCaseSampleMeanConcentration
  uncCalibrationCurve = calibrationCurveResult()
  uncMethodPrecision = methodPrecisionResult()
  uncStandardSolution = standardSolutionResult()
  uncSampleVolume = sampleVolumeResult()
  
  result = round(get_combinedUncertainty_finalAnswer(meanConcentration, uncCalibrationCurve, uncMethodPrecision, uncStandardSolution, uncSampleVolume),numDecimalPlaces)
  return(result)
})

###################################################################################
# Outputs
###################################################################################



output$display_combinedUncertainty_finalAnswer_top = renderUI({
  return(withMathJax(paste("\\(\\text{CombUncertainty}=%f\\)",combinedUncertaintyResult())))
})
  
output$display_combinedUncertainty_finalAnswer_bottom = renderUI({
  cc = calibrationCurveResult()
  mp = methodPrecisionResult()
  ss = standardSolutionResult()
  sv = sampleVolumeResult()
  
  formula = c("\\text{CombUncertainty} &= x_s \\sqrt{u_r(\\text{CalCurve})^2 + u_r(\\text{MethodPrec})^2 + u_r(\\text{StdSolution})^2 + u_r(\\text{SampleVolume})^2}")
  
  formula = c(formula, paste("&= ",input$inputCaseSampleMeanConcentration," \\sqrt{",cc,"^2+",mp,"^2+",ss,"^2+",sv,"^2}"))
  
  formula = c(formula, paste("&= ",combinedUncertaintyResult()))
  
  return(withMathJax(HTML(mathJaxAligned(formula))))
})

output$display_combinedUncertainty_finalAnswer_dashboard = renderUI({
  return(withMathJax(sprintf("\\(\\text{CombUncertainty}=%f\\)",combinedUncertaintyResult())))
})

###################################################################################
# Helper Methods
###################################################################################
get_combinedUncertainty_finalAnswer = function(meanConcentration, uncCalibrationCurve, uncMethodPrecision, uncStandardSolution, uncSampleVolume)
{
  answer = meanConcentration * sqrt(uncCalibrationCurve^2 + uncMethodPrecision^2 + uncStandardSolution^2 + uncSampleVolume^2)
  return(answer)
}