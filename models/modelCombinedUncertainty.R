serverCombinedUncertainty = function(input, output, session){
  
  #Display outputs
  output$display_combinedUncertainty_finalAnswer_top = renderText({
    
    meanConcentration = input$inputCaseSampleMeanConcentration
    uncCalibrationCurve = 1
    uncMethodPrecision = 1
    uncStandardSolution = 1
    uncSampleVolume = 1
    
    answerValue = get_combinedUncertainty_finalAnswer(meanConcentration, uncCalibrationCurve, uncMethodPrecision, uncStandardSolution, uncSampleVolume)
    
    return(paste("\\(\\text{CombUncertainty}=\\)",answerValue))
  })
  
  output$display_combinedUncertainty_finalAnswer_bottom = renderText({
    
    meanConcentration = input$inputCaseSampleMeanConcentration
    uncCalibrationCurve = 1
    uncMethodPrecision = 1
    uncStandardSolution = 1
    uncSampleVolume = 1
    
    answerValue = get_combinedUncertainty_finalAnswer(meanConcentration, uncCalibrationCurve, uncMethodPrecision, uncStandardSolution, uncSampleVolume)

    return(answerValue)
  })

}


get_combinedUncertainty_finalAnswer = function(meanConcentration, uncCalibrationCurve, uncMethodPrecision, uncStandardSolution, uncSampleVolume)
{
  answer = meanConcentration * sqrt(uncCalibrationCurve^2 + uncMethodPrecision^2 + uncStandardSolution^2 + uncSampleVolume^2)
  return(answer)
}