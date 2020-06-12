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

output$display_dashboard_meanPar <- renderUI({
  if(checkUsingWls())
  {
    infoBox(withMathJax(HTML("Case Sample<br />Mean Peak Area Ratio\\((y_s)\\)")),input$inputCaseSampleMeanPeakAreaRatio, width=3, icon=icon("chart-bar"), color="orange")
  }
})

output$display_dashboard_confidenceInterval <- renderUI({
  string = paste(input$inputConfidenceInterval)
  return(string)
})
