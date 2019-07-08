serverEffectiveDof = function(input, output, session){
  

  
  output$display_effectiveDof_finalAnswer_top = renderText({
    answerValue = 1
    return(paste("\\(\\text{EffectiveDoF}=\\)",answerValue))
  })
  
  output$display_effectiveDof_finalAnswer_bottom = renderText({
    
    combinedUncertainty = 1
    
    uncCalibrationCurve = 1
    uncMethodPrecision = 1
    uncStandardSolution = 1
    uncSampleVolume = 1
    
    dofCalibrationCurve = 1
    dofMethodPrevision = 1
    dofStandardSolution = 1
    dofSampleVolume = 1
    
    answerValue = (combinedUncertainty^4) / (((uncCalibrationCurve^4)/dofCalibrationCurve) + ((uncMethodPrecision^4)/dofMethodPrevision) + ((uncStandardSolution^4)/dofStandardSolution) + ((uncSampleVolume^4)/dofSampleVolume))
    
    return(answerValue)
  })
  
  
}

get_effectiveDof_finalAnswer = function(){
  
  
  
  
  
  
  
}