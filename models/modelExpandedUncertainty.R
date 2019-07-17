expandedUncertaintyResult = reactive({
  
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  
  finalCoverageFactor = getCoverageFactor(coverageFactorEffectiveDofTable, effectiveDof, confidenceInterval)
  
  result = finalCoverageFactor * combinedUncertaintyResult()
  
  return(round(result,numDecimalPlaces))
})

###################################################################################
# Outputs
###################################################################################

output$display_expandedUncertainty_finalAnswer_top = renderUI({
  return(withMathJax(paste("\\(\\text{ExpUncertainty}=",expandedUncertaintyResult(),"\\)")))
})

output$display_expandedUncertainty_finalAnswer_bottom = renderUI({
  
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  
  finalCoverageFactor = getCoverageFactor(coverageFactorEffectiveDofTable, effectiveDof, confidenceInterval)
  
  formulas = c("\\text{ExpUncertainty} &= k \\times \\text{CombUncertainty}")
  formulas = c(formulas, paste("&=",finalCoverageFactor,"\\times",combinedUncertaintyResult()))
  forumlas = c(formulas, paste("&=",expandedUncertaintyResult()))
  output = mathJaxAligned(forumlas, 0)
  
  
  return(withMathJax(output))
})

output$display_expandedUncertainty_finalAnswer_dashboard = renderUI({
  return(withMathJax(paste("\\(\\text{ExpUncertainty}=",expandedUncertaintyResult(),"\\)")))
})


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