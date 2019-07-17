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
    dataMeans = round(colMeans(dataForConcentration, na.rm = TRUE), numDecimalPlaces)
    
    #Calculate the standard deveation for each concentration (using SD function and removing NA values)
    dataStdDev = round(apply(dataForConcentration, 2, function(x) sd(x, na.rm = TRUE)), numDecimalPlaces)
    
    #Calculate the Degrees of Freedom for each concentration (using length function but removing NA values then removing 1 (this is how you get DOF))
    dataDof = apply(dataForConcentration, 2, function(x) length(which(!is.na(x))))-1
    
    #pooledStandardDeviationNumerator
    dataPooledStandardDeviationNumerator = round(dataStdDev^2 * dataDof, numDecimalPlaces)
    
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
    calculationResults = data.frame("conc"= concentration, "run" = dataRuns, "mean" = dataMeans, "stdDev" = dataStdDev, "dof" = dataDof, "pooledStandardDeviationNumerator" = dataPooledStandardDeviationNumerator, "pooledVariance" = dataPooledVariance, "pooledStdDeviation" = dataPooledStdDeviation, "stdUncertainty" = dataStdUncertainty, "relativeStdUncertainty" =dataRelativeStdUncertainty)
    #Appened the result dataframe with the results from this concentrations calculations
    calculationsData = rbind(calculationsData, calculationResults)
  }
  
  return(calculationsData)
})

methodPrecisionDataWithCalculationsNeatHeaders = reactive({
  print(methodPrecisionDataWithCalculations())
  data = data.frame(methodPrecisionDataWithCalculations()$conc,methodPrecisionDataWithCalculations()$run,methodPrecisionDataWithCalculations()$mean,methodPrecisionDataWithCalculations()$stdDev,methodPrecisionDataWithCalculations()$dof,methodPrecisionDataWithCalculations()$pooledStandardDeviationNumerator)
  colnames(data) = c("$$\\text{Nominal Value (NV)}$$","$$\\text{Run}$$","$$\\text{Mean (} \\overline{x})$$","$$\\text{Standard Deviation (} S)$$","$$\\text{Degrees of Freedom (} d)$$","$$S^2 \\times d$$")
  return(data)
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
  methodPrecisionDataWithCalculationsNeatHeaders(),
  rownames = FALSE,
  options = list(pageLength = getNumberOfRuns(methodPrecisionData()), scrollX = TRUE, dom = 'tip', columnDefs = list(list(className = 'dt-right', targets = 0:5)))
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

  #Add plots for each run
  for(trace in runNames)
  {
    plotlyPlot = plotlyPlot %>% add_trace(x = ~conc, y = as.formula(paste0("~", trace)), name=sprintf("Method-%s",trace))
  }
  
  
  return(plotlyPlot)
})

output$outputSumOfDof <- renderUI({

  data = methodPrecisionDataWithCalculations()

  formula = character()
  for(conc in getConcentrations(data))
  {
    formula = c(formula, paste0("\\sum{d}_{(",conc,")} &= ", getSumDofForConcentration(data, conc)))
  }
  results = mathJaxAligned(formula)

  return(withMathJax(results))
})

output$outputSumOfS2d <- renderUI({
  
  data = methodPrecisionDataWithCalculations()
  
  formula = character()
  for(conc in getConcentrations(data))
  {
    formula = c(formula, paste0("\\sum{(S^2 \\times d)_{(",conc,")}} &= ", getSumPooledStandardDeviationNumeratorForConcentration(data,conc)))
  }
  results = mathJaxAligned(formula)
  
  return(withMathJax(results))
  
})




#Display the Pooled Standard Deviation for each concentration in the data
output$outputPooledStandardDeviation <- renderUI({
  
  data =  methodPrecisionDataWithCalculations()
  
  formula = c("S_p &= \\sqrt{\\frac{\\sum\\limits_i{(S_i^2 \\times d_i)}}{\\sum\\limits_i d_i}}")

  for(conc in getConcentrations(data))
  {
    
    formula = c(formula, paste0("S_{p(",conc,")} &= \\sqrt{\\frac{",getSumPooledStandardDeviationNumeratorForConcentration(data,conc),"}{",getSumDofForConcentration(data, conc),"}} = ", getPooledStandardDeviation(data, conc)))
  }
  
  results = mathJaxAligned(formula)

  return(withMathJax(HTML(results)))
}) 

#Display the Standard Uncertainty for each concentration in the data
output$outputStandardUncertainty <- renderUI({
  data =  methodPrecisionDataWithCalculations()
  
  formula = c("u(\\text{MethodPrec}) &= \\frac{S_p}{\\sqrt{r_s}}")
  
  for(conc in getConcentrations(data))
  {
    formula = c(formula, paste0("u(\\text{MethodPrec})_{(",conc,")} &= \\frac{",getPooledStandardDeviation(data, conc),"}{\\sqrt{",input$inputCaseSampleReplicates,"}} = ", getStandardUncertainty(data, conc)))
  }
  
  results = mathJaxAligned(formula)
  
  return(withMathJax(HTML(results)))
}) 

#Display the Realtive Standard Uncertainties for each concentration in the data
output$outputRealtiveStandardUncertainties <- renderUI({
  data =  methodPrecisionDataWithCalculations()
  
  formula = c("u_r(\\text{MethodPrec}) &= \\frac{u}{\\text{NV}}")
  
  for(conc in getConcentrations(data))
  {
    formula = c(formula, paste0("u_r(\\text{MethodPrec})_{(",conc,")} &= \\frac{",getStandardUncertainty(data, conc),"}{",conc,"} = ", getRealtiveStandardUncertainty(data, conc)))
  }
  
  results = mathJaxAligned(formula)
  
  return(withMathJax(HTML(results)))
})

output$display_methodPrecision_finalAnswer_top <- renderUI({
  return(withMathJax(sprintf("\\(u_r(\\text{MethodPrec})=%f\\)",methodPrecisionResult())))
})

output$display_methodPrecision_finalAnswer_bottom = renderUI({

  data =  methodPrecisionDataWithCalculations()
  closetConcentration = getMethodPrecisionFinalAnswerClosestConcentration(data, input$inputCaseSampleMeanConcentration)
  
  concs = ""
  for(i in getConcentrations(data))
  {
    concs = paste0(concs,i,",")
  }
  
  output = paste("Of concentrations ", concs, " the closet to Case Sample Mean \\((x_s)\\) = ",input$inputCaseSampleMeanConcentration," is ",closetConcentration,"<br /><br />")
  
  output = paste(output, "\\(u_r(\\text{MethodPrec})_{(", closetConcentration, ")}=", methodPrecisionResult(), "\\)")
  
  return(withMathJax(HTML(output)))
})

output$display_methodPrecision_finalAnswer_dashboard <- renderUI({
  return(withMathJax(sprintf("\\(u_r(\\text{MethodPrec})=%f\\)",methodPrecisionResult())))
})

output$display_methodPrecision_finalAnswer_combinedUncertainty <- renderUI({
  return(paste(methodPrecisionResult()))
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

getSumDofForConcentration = function(data, concentration)
{
  answer = sum(data[data$conc==concentration,]$dof)
  return(answer)
}

getSumPooledStandardDeviationNumeratorForConcentration = function(data, concentration)
{
  answer = sum(data[data$conc==concentration,]$pooledStandardDeviationNumerator)
  return(answer)
}