###################################################################################
# Outputs
###################################################################################

output$test <- renderUI({
  string = paste(input$inputCaseSampleReplicates)
  return(string)
})