combinedUncertaintyResult = reactive({
  meanConcentration = input$inputCaseSampleMeanConcentration
  uncCalibrationCurve = getResultCalibrationCurve()
  uncMethodPrecision = methodPrecisionResult()
  uncStandardSolution = standardSolutionResult()
  uncSampleVolume = sampleVolumeResult()
  
  result = get_combinedUncertainty_finalAnswer(meanConcentration, uncCalibrationCurve, uncMethodPrecision, uncStandardSolution, uncSampleVolume)
  return(result)
})

###################################################################################
# Outputs
###################################################################################

output$display_combinedUncertainty_meanConcentration <- renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_combinedUncertainty_finalAnswer_top = renderUI({
  return(paste("\\(\\text{CombUncertainty}=\\)",combinedUncertaintyResult()))
})
  
output$display_combinedUncertainty_finalAnswer_bottom = renderUI({
  cc = getResultCalibrationCurve()
  mp = methodPrecisionResult()
  ss = standardSolutionResult()
  sv = sampleVolumeResult()
  
  formula = c("\\text{CombUncertainty} &= x_s \\sqrt{\\sum{u_r\\text{(Individual Uncertainty Component)}^2}} [[break]]")
  formula = c(formula, "\\text{CombUncertainty} &= x_s \\sqrt{u_r(\\text{CalCurve})^2 + u_r(\\text{MethodPrec})^2 + u_r(\\text{StdSolution})^2 + u_r(\\text{SampleVolume})^2}")
  formula = c(formula, paste("&= \\bbox[#F012BE,2pt]{",input$inputCaseSampleMeanConcentration,"} \\sqrt{\\bbox[#0073B7,2pt]{",cc,"}^2+\\bbox[#DD4B39,2pt]{",mp,"}^2+\\bbox[#00A65A,2pt]{",ss,"}^2+\\bbox[#D81B60,2pt]{",sv,"}^2}"))
  formula = c(formula, paste("&= ",combinedUncertaintyResult()))
  output = mathJaxAligned(formula, 5, 20)
  
  return(withMathJax(HTML(output)))
})

output$display_combinedUncertainty_finalAnswer_dashboard = renderUI({
  return(paste("\\(u_r\\text{(CombUncertainty)}=\\)",combinedUncertaintyResult()))
})

output$display_combinedUncertainty_finalAnswer_coverageFactor = renderUI({
  return(as.character(combinedUncertaintyResult()))
})

output$display_combinedUncertainty_finalAnswer_expandedUncertainty = renderUI({
  return(as.character(combinedUncertaintyResult()))
})

###################################################################################
# Helper Methods
###################################################################################
get_combinedUncertainty_finalAnswer = function(meanConcentration, uncCalibrationCurve, uncMethodPrecision, uncStandardSolution, uncSampleVolume)
{
  sumUncertainties = sum(uncCalibrationCurve^2,uncMethodPrecision^2,uncStandardSolution^2,uncSampleVolume^2, na.rm = TRUE)
  answer = meanConcentration * sqrt(sumUncertainties)
  return(answer)
}