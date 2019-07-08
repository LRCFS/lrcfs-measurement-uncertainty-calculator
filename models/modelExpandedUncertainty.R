serverExpandedUncertainty = function(input, output, session){
  

  
  output$display_expandedUncertainty_finalAnswer_top = renderText({
    answerValue = 1
    return(paste("\\(\\text{EffectiveDoF}=\\)",answerValue))
  })
  
  output$display_expandedUncertainty_finalAnswer_bottom = renderText({
    answerValue = 1
    return(answerValue)
  })
  
  
}