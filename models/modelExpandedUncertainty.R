expandedUncertaintyResult = reactive({
  
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  
  finalCoverageFactor = getCoverageFactor(coverageFactorEffectiveDofTable, effectiveDof, confidenceInterval)
  
  result = finalCoverageFactor * combinedUncertaintyResult()
  
  return(round(result,numDecimalPlaces))
})

expandedUncertaintyResultPercentage = reactive({
  expandedUncertainty = expandedUncertaintyResult()
  concentration = input$inputCaseSampleMeanConcentration
  answer = (expandedUncertainty / concentration) * 100

  return(round(answer,numDecimalPlaces))
})

###################################################################################
# Outputs
###################################################################################

output$display_expandedUncertainty_coverageFactorText = renderUI({
  confidenceInterval = input$inputConfidenceInterval
  output = paste0("\\(k_{\\text{",round(effectiveDofResult()),",",confidenceInterval,"}}\\)")
  return(withMathJax(HTML(output)))
})

output$display_expandedUncertainty_meanConcentration <- renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_expandedUncertainty_finalAnswer_top = renderUI({
  return(withMathJax(paste("\\(\\text{ExpUncertainty}=",expandedUncertaintyResult(),"\\)")))
})

output$display_expandedUncertainty_finalAnswer_bottom = renderUI({
  
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  
  finalCoverageFactor = getCoverageFactor(coverageFactorEffectiveDofTable, effectiveDof, confidenceInterval)

  formulas = c(paste0("\\text{ExpUncertainty} &= \\text{Coverage Factor} \\times \\text{Combined Uncertainty} [[break]]"))
  formulas = c(formulas, paste0("\\text{ExpUncertainty} &= k_{\\text{",round(effectiveDof),",",confidenceInterval,"}} \\times \\text{CombUncertainty}"))
  formulas = c(formulas, paste("&= \\bbox[#39CCCC,2pt]{",finalCoverageFactor,"} \\times \\bbox[#605CA8,2pt]{",combinedUncertaintyResult(),"}"))
  formulas = c(formulas, paste("&=",expandedUncertaintyResult()))
  output = mathJaxAligned(formulas, 5,20)
  
  return(withMathJax(output))
})

output$display_expandedUncertainty_finalAnswerPercentage_bottom = renderUI({
  
  expandedUncertainty = expandedUncertaintyResult()
  csMeanConcentration = input$inputCaseSampleMeanConcentration
  answer = (expandedUncertainty / csMeanConcentration) * 100
  
  formulas = c(paste0("\\text{%ExpUncertainty} &= \\frac{\\text{Expanded Uncertainty}}{\\text{Case Sample Mean Concentration}} \\times 100 [[break]]"))
  formulas = c(formulas,paste0("\\text{%ExpUncertainty} &= \\frac{\\text{ExpUncertainty}}{x_s} \\times 100"))
  formulas = c(formulas, paste("&= \\frac{",expandedUncertainty,"}{\\bbox[#F012BE,2pt]{",csMeanConcentration,"}} \\times 100"))
  formulas = c(formulas, paste("&=",expandedUncertaintyResultPercentage(),"\\%"))
  output = mathJaxAligned(formulas,5,20)
  
  return(withMathJax(output))
})

output$display_expandedUncertainty_finalAnswer_dashboard = renderUI({
  return(withMathJax(paste("\\(\\text{ExpUncertainty}=",expandedUncertaintyResult(),"\\)")))
})

output$display_expandedUncertainty_finalAnswerPercentage_dashboard <- renderUI({
  return(withMathJax(paste("\\(\\text{%ExpUncertainty}=",expandedUncertaintyResultPercentage(),"\\%\\)")))
})

output$display_expandedUncertainty_finalAnswer_start <- renderUI({
  formulas = c(paste("\\text{ExpUncertainty} &=",expandedUncertaintyResult()))
  formulas = c(formulas, paste("\\text{%ExpUncertainty} &=",expandedUncertaintyResultPercentage(),"\\%"))
  output = mathJaxAligned(formulas, 10)
  
  return(withMathJax(output))
})