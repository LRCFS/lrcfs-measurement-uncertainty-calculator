serverUncertaintyMethodPrecision = function(input, output){
  
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
      dataRelativeStdUncertainty = dataStdUncertainty / caseSampleMean
      
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
    columnNames = colnames(data)[-1]
    
    plotlyPlot = plot_ly(data, name='Peak Area Ratios', type = 'box') %>%
                         layout(boxmode = "group", xaxis = list(title="Concentration"), yaxis = list(title="Peak Area Ratio"))

    #Add plots for each run
    for(trace in columnNames)
    {
      plotlyPlot = plotlyPlot %>% add_trace(x = ~conc, y = as.formula(paste0("~", trace)), name=trace)
    }
    return(plotlyPlot)
  })
  
  #Display the Pooled Standard Deviation for each concentration in the data
  output$outputPooledStandardDeviation <- renderUI({
    data =  methodPrecisionDataWithCalculations()
    results = ""
    for(conc in getConcentrations(data))
    {
      results = paste(results, "<h3>",conc,"=",getPooledStandardDeviation(data, conc),"</h3>")
    }
    return(HTML(results))
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
  
  output$outputMethodPrecisionAnswer <- renderUI({
    # answer = ""
    # for(conc in getConcentrations())
    # {
    #   getRealtiveStandardUncertainty(conc)^2 * 
    # }
    return("HTML(results)")
  })
  
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