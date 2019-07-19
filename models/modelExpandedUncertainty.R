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

output$display_expandedUncertainty_coverageFactorText = renderUI({
  confidenceInterval = input$inputConfidenceInterval
  output = paste0("\\(k_{\\text{",round(effectiveDofResult()),",",confidenceInterval,"}}\\)")
  return(withMathJax(HTML(output)))
})

output$display_expandedUncertainty_finalAnswer_top = renderUI({
  return(withMathJax(paste("\\(\\text{ExpUncertainty}=",expandedUncertaintyResult(),"\\)")))
})

output$display_expandedUncertainty_finalAnswer_bottom = renderUI({
  
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  
  finalCoverageFactor = getCoverageFactor(coverageFactorEffectiveDofTable, effectiveDof, confidenceInterval)
  
  formulas = c(paste0("\\text{ExpUncertainty} &= k_{\\text{",round(effectiveDof),",",confidenceInterval,"}} \\times \\text{CombUncertainty}"))
  formulas = c(formulas, paste("&=",finalCoverageFactor,"\\times",combinedUncertaintyResult()))
  forumlas = c(formulas, paste("&=",expandedUncertaintyResult()))
  output = mathJaxAligned(forumlas, 0)
  
  
  return(withMathJax(output))
})

output$display_expandedUncertainty_finalAnswer_dashboard = renderUI({
  return(withMathJax(paste("\\(\\text{ExpUncertainty}=",expandedUncertaintyResult(),"\\)")))
})