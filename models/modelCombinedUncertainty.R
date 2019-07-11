combinedUncertaintyResult = reactive({
  meanConcentration = input$inputCaseSampleMeanConcentration
  uncCalibrationCurve = calibrationCurveResult()
  uncMethodPrecision = methodPrecisionResult()
  uncStandardSolution = relativeStandardUncertaintyOfCalibrationSolutions
  uncSampleVolume = sampleVolumeResult()
  
  result = get_combinedUncertainty_finalAnswer(meanConcentration, uncCalibrationCurve, uncMethodPrecision, uncStandardSolution, uncSampleVolume)
  return(result)
})

###################################################################################
# Outputs
###################################################################################
output$display_combinedUncertainty_finalAnswer_top = renderUI({
  return(withMathJax(sprintf("\\(\\text{CombUncertainty}=%f\\)",combinedUncertaintyResult())))
})
  
output$display_combinedUncertainty_finalAnswer_bottom = renderUI({
  return(withMathJax(sprintf("\\(\\text{CombUncertainty}=%f\\)",combinedUncertaintyResult())))
})

output$display_combinedUncertainty_finalAnswer_dashboard = renderUI({
  return(withMathJax(sprintf("\\(\\text{CombUncertainty}=%f\\)",combinedUncertaintyResult())))
})



renderUI({
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