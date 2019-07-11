#Load raw data from CSV file
methodPrecisionData <- reactive({
  data = methodPrecisionReadCSV(input$inputMethodPrecisionFileUpload)
  return(data)
})

#Get data and run calculations and store in data.frame for easy access
methodPrecisionDataWithCalculations = reactive({
  
  #Get the inputs for use in calculations
  caseSampleReplicate = input$inputCaseSampleReplicates
  caseSampleMean = input$inputCaseSampleMeanConcentration
  
  #Get all the data and unique concentraions
  allData = methodPrecisionData();
  uniqeConcentrations = getConcentrations(allData);
  
  #Create empty dataframe to return results
  calculationsData = data.frame(conc= numeric(0), run=character(0), mean= numeric(0), stdDev = numeric(0), dof = numeric(0), pooledVariance = numeric(0), pooledStdDeviation = numeric(0), stdUncertainty = numeric(0), relativeStdUncertainty = numeric(0)); calculationsData
  
  #For each concentration in the unique concentrations loaded from our data
  for(concentration in uniqeConcentrations)
  {
    ################################
    # Load the runs and get some basic info
    ################################
    
    #Get the data for just the one concentration
    dataForConcentration = allData[allData$conc == concentration,]
    
    #Remove "conc" (concentration column) for making calculations easier
    dataForConcentration$conc = NULL
    
    #Get the names of the runs (e.g. run1, run2, run3 etc)
    dataRuns = colnames(dataForConcentration)
    
    ################################
    # Do the calculations
    ################################
    
    #Calculate the means for each run
    dataMeans = colMeans(dataForConcentration, na.rm = TRUE)
    
    #Calculate the standard deveation for each concentration (using SD function and removing NA values)
    dataStdDev = apply(dataForConcentration, 2, function(x) sd(x, na.rm = TRUE))
    
    #Calculate the Degrees of Freedom for each concentration (using length function but removing NA values then removing 1 (this is how you get DOF))
    dataDof = apply(dataForConcentration, 2, function(x) length(which(!is.na(x))))-1
    
    #Calculate the Pooled Variance
    dataPooledVariance = sum(dataStdDev^2 * dataDof, na.rm = TRUE)/sum(dataDof, na.rm = TRUE)
    
    #Calculate the Pooled Standard Deviation
    dataPooledStdDeviation = sqrt(dataPooledVariance)
    
    #Calculate the Standard Uncertainty
    dataStdUncertainty = dataPooledStdDeviation/sqrt(caseSampleReplicate)
    
    #Calculate the Standard Uncertainty
    dataRelativeStdUncertainty = dataStdUncertainty / concentration
    
    ################################
    # Append the data for return
    ################################
    
    #Full all the data in a dataframe
    calculationResults = data.frame("conc"= concentration, "run" = dataRuns, "mean" = dataMeans, "stdDev" = dataStdDev, "dof" = dataDof, "pooledVariance" = dataPooledVariance, "pooledStdDeviation" = dataPooledStdDeviation, "stdUncertainty" = dataStdUncertainty, "relativeStdUncertainty" =dataRelativeStdUncertainty)
    #Appened the result dataframe with the results from this concentrations calculations
    calculationsData = rbind(calculationsData, calculationResults)
  }
  
  return(calculationsData)
})

methodPrecisionResult = reactive({
  data =  methodPrecisionDataWithCalculations()
  closetConcentration = getMethodPrecisionFinalAnswerClosestConcentration(data, input$inputCaseSampleMeanConcentration)
  return(getMethodPrecisionFinalAnswer(data, closetConcentration))
})

methodPrecisionDof = reactive({
  data =  methodPrecisionDataWithCalculations()
  closetConcentration = getMethodPrecisionFinalAnswerClosestConcentration(data, input$inputCaseSampleMeanConcentration)
  return(getMethodPrecisionDof(data, closetConcentration))
})

###################################################################################
# Outputs
###################################################################################

#Output the title while showing the number of runs and number of concentrations in the data
output$uploadedMethodPrecisionDataStats <- renderUI({
  data = methodPrecisionData()
  string = sprintf("Uploaded Quality Control Data | Runs: %d | No. Concentrations: %d", getNumberOfRuns(data), getNumberOfConcentrations(data))
  return(string)
})

#Show a datatable with the RAW data loaded (hides searching with dom attribute)
output$methodPrecisionRawData <- DT::renderDataTable(
  methodPrecisionData(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)

#Show a datatable with all the calculations in it
#Get the number of runs and use that as the page size to make navigation a little more straight forward
output$methodPrecisionCalculations <- DT::renderDataTable(
  methodPrecisionDataWithCalculations(),
  rownames = FALSE,
  options = list(pageLength = getNumberOfRuns(methodPrecisionData()), scrollX = TRUE, dom = 'tip')
)

#Display a graph of the raw data as a box plot
output$methodPrecisionRawDataGraph <- renderPlotly({
  data = methodPrecisionData()
  runNames = colnames(data)[-1]
  concentrations = getConcentrations(data)
  
  plotlyPlot = plot_ly(data, name='Peak Area Ratios', type = 'box') %>%
                       layout(boxmode = "group", xaxis = list(title="Concentration"), yaxis = list(title="Peak Area Ratio"))

  #Add plots for each concentration row
  rowConcRun = 1
  oldRowConc = 0
  for(i in 1:nrow(data)) {
    row <- data[i,]
    rowConc = row$conc
    
    if(rowConc != oldRowConc)
    {
      oldRowConc = rowConc
      rowConcRun = 1
    }
    
    #Remove concentration column and return rotate table to get list of values
    row$conc = NULL
    row = melt(row)
    
    #print(row)
    plotlyPlot = plotlyPlot %>% add_trace(x = rowConc, y = row$value, name=sprintf("Conc%d-Rep%d",rowConc,rowConcRun))
    
    rowConcRun = rowConcRun + 1
  }
  
  # #Pooled concentrations
  # for(conc in concentrations) {
  #   concData = data[data[,1] == conc,]
  #   concData$conc = NULL
  #   concData = melt(concData)
  #   
  #   plotlyPlot = plotlyPlot %>% add_trace(x = conc, y = concData$value, name=sprintf("PooledConc%d",conc))
  # }
  # 
  # #Add plots for each run
  # for(trace in runNames)
  # {
  #   plotlyPlot = plotlyPlot %>% add_trace(x = ~conc, y = as.formula(paste0("~", trace)), name=sprintf("Method-%s",trace))
  # }
  
  
  return(plotlyPlot)
})

#Display the Pooled Standard Deviation for each concentration in the data
output$outputPooledStandardDeviation <- renderUI({
  
  results = "$$S_p = \\sqrt{\\frac{\\sum\\limits_i S_i^2 \\times d_i}{\\sum\\limits_i d_i}}$$"
  
  data =  methodPrecisionDataWithCalculations()
  for(conc in getConcentrations(data))
  {
    results = paste(results, "<h3>",conc,"=",getPooledStandardDeviation(data, conc),"</h3>")
  }
  return(withMathJax(HTML(results)))
}) 

#Display the Standard Uncertainty for each concentration in the data
output$outputStandardUncertainty <- renderUI({
  data =  methodPrecisionDataWithCalculations()
  results = ""
  for(conc in getConcentrations(data))
  {
    results = paste(results, "<h3>",conc,"=",getStandardUncertainty(data,conc),"</h3>")
  }
  return(HTML(results))
}) 

#Display the Realtive Standard Uncertainties for each concentration in the data
output$outputRealtiveStandardUncertainties <- renderUI({
  data =  methodPrecisionDataWithCalculations()
  results = ""
  for(conc in getConcentrations(data))
  {
    results = paste(results, "<h3>",conc,"=",getRealtiveStandardUncertainty(data,conc),"</h3>")
  }
  return(HTML(results))
})

output$display_methodPrecision_finalAnswer_top <- renderUI({
  return(withMathJax(sprintf("\\(u_r(\\text{MethodPrec})=%f\\)",methodPrecisionResult())))
})

output$display_methodPrecision_finalAnswer_bottom = renderUI({
  data =  methodPrecisionDataWithCalculations()
  closetConcentration = getMethodPrecisionFinalAnswerClosestConcentration(data, input$inputCaseSampleMeanConcentration)
  results = paste("<h3>",closetConcentration,"=",methodPrecisionResult(),"</h3>")
  return(HTML(results))
})

output$display_methodPrecision_finalAnswer_dashboard <- renderUI({
  return(withMathJax(sprintf("\\(u_r(\\text{MethodPrec})=%f\\)",methodPrecisionResult())))
})
  

###################################################################################
# Helper Methods
###################################################################################

getMethodPrecisionFinalAnswerClosestConcentration = function(data, caseSampleMeanConcentration)
{
  closestConcentration = 0
  
  for(conc in getConcentrations(data))
  {
    if(abs(conc - caseSampleMeanConcentration) < abs(closestConcentration - caseSampleMeanConcentration))
    {
      closestConcentration = conc
    }
  }
  
  return(closestConcentration)
}

getMethodPrecisionFinalAnswer = function(data, closestConcentration)
{
  getRealtiveStandardUncertainty(data,closestConcentration)
}

getMethodPrecisionDof = function(data, closestConcentration)
{
  answer = sum(data[data$conc==closestConcentration,]$dof)
  return(answer)
}

getPooledStandardDeviation = function(data, concentration){
  answer = round(data[data$conc==concentration,]$pooledStdDeviation[1],numDecimalPlaces)
  return(answer)
}

getStandardUncertainty = function(data, concentration){
  answer = round(data[data$conc==concentration,]$stdUncertainty[1],numDecimalPlaces)
  return(answer)
}

getRealtiveStandardUncertainty = function(data, concentration){
  answer = round(data[data$conc==concentration,]$relativeStdUncertainty[1],numDecimalPlaces)
  return(answer)
}

getConcentrations = function(data){
  return(unique(data$conc))
}

getNumberOfConcentrations = function(data){
  return(length(unique(data$conc)))
}

getNumberOfRuns = function(data){
  return(dim(data)[2]-1)
}