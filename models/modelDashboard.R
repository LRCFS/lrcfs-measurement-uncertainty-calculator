###################################################################################
# Outputs
###################################################################################

output$dashboardReplicates <- renderUI({
  string = paste(input$inputCaseSampleReplicates)
  return(string)
})

output$dashboardMeanConcentration <- renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})
