expandedUncertaintyResult = reactive({
  
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  
  finalCoverageFactorEffectiveDof = getClosestCoverageFactorEffectiveDof(coverageFactorEffectiveDof, effectiveDof, confidenceInterval)
  
  result = finalCoverageFactorEffectiveDof * combinedUncertaintyResult()
  
  return(result)
})

###################################################################################
# Outputs
###################################################################################

output$display_expandedUncertainty_finalAnswer_top = renderUI({
  return(withMathJax(sprintf("\\(\\text{ExpUncertainty}=%f\\)",expandedUncertaintyResult())))
})

output$display_expandedUncertainty_finalAnswer_bottom = renderUI({
  
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  
  finalCoverageFactorEffectiveDof = getClosestCoverageFactorEffectiveDof(coverageFactorEffectiveDof, effectiveDof, confidenceInterval)
  
  formulas = c("\\text{ExpUncertainty} &= \\text{finalCoverageFactorEffectiveDof} * \\text{CombUncertainty}")
  formulas = c(formulas, sprintf("&= %f * %f", finalCoverageFactorEffectiveDof, combinedUncertaintyResult()))
  forumlas = c(formulas, paste("&=",expandedUncertaintyResult()))
  output = mathJaxAligned(forumlas, 0)
  
  
  return(withMathJax(output))
})

output$display_expandedUncertainty_finalAnswer_dashboard = renderUI({
  return(withMathJax(sprintf("\\(\\text{ExpUncertainty}=%f\\)",expandedUncertaintyResult())))
})


getClosestCoverageFactorEffectiveDof = function(coverageFactorEffectiveDof, effectiveDof, confidenceInterval){
  
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

  result = coverageFactorEffectiveDof[as.character(closestDof),confidenceInterval]
  return(result)
}