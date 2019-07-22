###################################################################################
# Outputs
###################################################################################

output$display_dashboard_replicates <- renderUI({
  string = paste(input$inputCaseSampleReplicates)
  return(string)
})

output$display_dashboard_meanConcentration <- renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_dashboard_confidenceInterval <- renderUI({
  string = paste(input$inputConfidenceInterval)
  return(string)
})

output$display_dashboard_finalAnswer <- renderUI({
  
  expandedUncertainty = expandedUncertaintyResult()
  concentration = input$inputCaseSampleMeanConcentration
  answer = round((expandedUncertainty / concentration) * 100,numDecimalPlaces)
  
  formulas = c(paste("\\text{%ExpUncertainty} &=",answer))
  output = mathJaxAligned(formulas)

  return(withMathJax(output))
})
