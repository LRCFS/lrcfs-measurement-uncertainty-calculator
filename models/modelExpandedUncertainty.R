expandedUncertaintyResult = reactive({
  
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  
  finalCoverageFactor = getCoverageFactor(coverageFactorEffectiveDofTable, effectiveDof, confidenceInterval)
  
  result = finalCoverageFactor * combinedUncertaintyResult()
  
  return(result)
})

expandedUncertaintyResultPercentage = reactive({
  expandedUncertainty = expandedUncertaintyResult()
  concentration = input$inputCaseSampleMeanConcentration
  answer = (expandedUncertainty / concentration) * 100

  return(answer)
})

###################################################################################
# Outputs
###################################################################################

output$display_expandedUncertainty_coverageFactorText = renderUI({
  confidenceInterval = input$inputConfidenceInterval
  output = paste0("\\(k_{\\text{",formatNumberForDisplay(effectiveDofResult(),input),",",confidenceInterval,"}}\\)")
  return(withMathJax(HTML(output)))
})

output$display_expandedUncertainty_meanConcentration <- renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_expandedUncertainty_finalAnswer_top = renderUI({
  return(withMathJax(paste("\\(\\text{ExpUncertainty}=",formatNumberForDisplay(expandedUncertaintyResult(),input),"\\)")))
})

output$display_expandedUncertainty_finalAnswer_bottom = renderUI({
  
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  
  finalCoverageFactor = getCoverageFactor(coverageFactorEffectiveDofTable, effectiveDof, confidenceInterval)

  
  
  formulas = c(paste0("\\text{ExpUncertainty} &= k_{\\text{",formatNumberForDisplay(effectiveDof,input),",",confidenceInterval,"}} \\times \\text{CombUncertainty}"))
  formulas = c(formulas, paste("&= ",colourNumberBackground(formatNumberForDisplay(finalCoverageFactor,input),CoverageFactorColor,"#FFF")," \\times ", colourNumberBackground(formatNumberForDisplay(combinedUncertaintyResult(),input),CombinedUncertaintyColor,"#FFF")))
  formulas = c(formulas, paste("&=",formatNumberForDisplay(expandedUncertaintyResult(),input)))
  output = mathJaxAligned(formulas, 5,20)
  
  return(withMathJax(output))
})

output$display_expandedUncertainty_finalAnswerPercentage_bottom = renderUI({
  
  expandedUncertainty = expandedUncertaintyResult()
  csMeanConcentration = input$inputCaseSampleMeanConcentration
  answer = expandedUncertaintyResultPercentage()
  
  formulas = c(paste0("\\text{%ExpUncertainty} &= \\frac{\\text{ExpUncertainty}}{x_s} \\times 100"))
  formulas = c(formulas, paste("&= \\frac{",formatNumberForDisplay(expandedUncertainty,input),"}{",ColourCaseSampleMeanConcentration(csMeanConcentration),"} \\times 100"))
  formulas = c(formulas, paste("&=",formatNumberForDisplay(answer,input),"\\%"))
  output = mathJaxAligned(formulas,5,20)
  
  return(withMathJax(output))
})

output$display_expandedUncertainty_finalAnswer_dashboard = renderUI({
  return(withMathJax(paste("\\(\\text{ExpUncertainty}=",formatNumberForDisplay(expandedUncertaintyResult(),input),"\\)")))
})

output$display_expandedUncertainty_finalAnswerPercentage_dashboard <- renderUI({
  return(withMathJax(paste("\\(\\text{%ExpUncertainty}=",formatNumberForDisplay(expandedUncertaintyResultPercentage(),input),"\\%\\)")))
})

output$display_expandedUncertainty_finalAnswer_start <- renderUI({
  #formulas = c(paste("\\text{ExpUncertainty} &=",expandedUncertaintyResult()))
  #formulas = c(formulas, paste("\\text{%ExpUncertainty} &=",expandedUncertaintyResultPercentage(),"\\% [[break]]"))
  formulas = c(paste("\\text{Concentration} &=",input$inputCaseSampleMeanConcentration,"\\pm",formatNumberForDisplay(expandedUncertaintyResult(),input)))
  output = mathJaxAligned(formulas, 10, 20)
  
  return(withMathJax(output))
})