serverUncertaintyStandardSolution = function(input, output){
  
  # methodPrecisionData <- reactive({
  #   data = methodPrecisionReadCSV(input$inputMethodPrecisionfileUpload)
  #   return(data)
  # })
  
  # output$uploadedMethodPrecisionDataStats <- renderUI({
  #  data = methodPrecisionData()
  #  string = sprintf("Uploaded Quality Control Data | Runs: %d | No. Concentrations: %d", getNumberOfRuns(data), getNumberOfConcentrations(data))
  #  return(string)
  # })

  # output$methodPrecisionCalculations <- DT::renderDataTable(
  #  methodPrecisionDataWithCalculations(),
  #  rownames = FALSE,
  #  options = list(pageLength = getNumberOfRuns(methodPrecisionData()), scrollX = TRUE, dom = 'tip')
  # )
  
  # output$methodPrecisionRawDataGraph <- renderPlotly({
  #  data = methodPrecisionData()
  #  columnNames = colnames(data)[-1]
  #  
  #  plotlyPlot = plot_ly(data, name='Peak Area Ratios', type = 'box') %>%
  #                       layout(boxmode = "group", xaxis = list(title="Concentration"), yaxis = list(title="Peak Area Ratio"))
  #  
  #  for(trace in columnNames)
  #  {
  #    plotlyPlot = plotlyPlot %>% add_trace(x = ~conc, y = as.formula(paste0("~", trace)), name=trace)
  #  }
  #  return(plotlyPlot)
  # })
}

# getPooledStandardDeviation = function(data, concentration){
#   return(data[data$conc==concentration,]$pooledStdDeviation[1])
# }

