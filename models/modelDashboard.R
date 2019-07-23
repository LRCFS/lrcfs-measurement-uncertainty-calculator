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
