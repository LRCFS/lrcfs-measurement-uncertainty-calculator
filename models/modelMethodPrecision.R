serverUncertaintyMethodPrecision = function(input, output){
  
  methodPrecisionData <- reactive({
    data = methodPrecisionReadCSV(input$inputMethodPrecisionFileUpload)
    return(data)
  })
  
  methodPrecisionDataWithCalculations = reactive({
    
    caseSampleReplicate = input$inputCaseSampleReplicates
    caseSampleMean = input$inputCaseSampleMeanConcentration
    
    allData = methodPrecisionData(); allData
    uniqeConcentrations = getConcentrations(allData); uniqeConcentrations
    
    calculationsData = data.frame(conc= numeric(0), run=character(0), mean= numeric(0), stdDev = numeric(0), dof = numeric(0), pooledVariance = numeric(0), pooledStdDeviation = numeric(0), stdUncertainty = numeric(0), relativeStdUncertainty = numeric(0)); calculationsData
    
    for(conc in uniqeConcentrations)
    {
      firstConcentration = allData[allData$conc == conc,]; firstConcentration
      firstConcentration$conc = NULL; firstConcentration
      
      dataRuns = colnames(firstConcentration); dataRuns
      dataMeans = colMeans(firstConcentration, na.rm = TRUE); dataMeans
      dataStdDev = apply(firstConcentration, 2, function(x) sd(x, na.rm = TRUE)); dataStdDev
      dataDof = apply(firstConcentration, 2, function(x) length(which(!is.na(x))))-1; dataDof
      
      dataPooledVariance = sum(dataStdDev^2 * dataDof, na.rm = TRUE)/sum(dataDof, na.rm = TRUE); dataPooledVariance
      dataPooledStdDeviation = sqrt(dataPooledVariance)
      dataStdUncertainty = dataPooledStdDeviation/sqrt(caseSampleReplicate)
      dataRelativeStdUncertainty = dataStdUncertainty / caseSampleMean
      
      calculationResults = data.frame("conc"= conc, "run" = dataRuns, "mean" = dataMeans, "stdDev" = dataStdDev, "dof" = dataDof, "pooledVariance" = dataPooledVariance, "pooledStdDeviation" = dataPooledStdDeviation, "stdUncertainty" = dataStdUncertainty, "relativeStdUncertainty" =dataRelativeStdUncertainty)
      calculationsData = rbind(calculationsData, calculationResults)
    }
    return(calculationsData)
  })
  
  output$uploadedMethodPrecisionDataStats <- renderUI({
    data = methodPrecisionData()
    string = sprintf("Uploaded Quality Control Data | Runs: %d | No. Concentrations: %d", getNumberOfRuns(data), getNumberOfConcentrations(data))
    return(string)
  })

  output$methodPrecisionRawData <- DT::renderDataTable(
    methodPrecisionData(),
    rownames = FALSE,
    options = list(scrollX = TRUE, dom = 'tip')
  )
  
  output$methodPrecisionCalculations <- DT::renderDataTable(
    methodPrecisionDataWithCalculations(),
    rownames = FALSE,
    options = list(pageLength = getNumberOfRuns(methodPrecisionData()), scrollX = TRUE, dom = 'tip')
  )
  
  output$methodPrecisionRawDataGraph <- renderPlotly({
    data = methodPrecisionData()
    columnNames = colnames(data)[-1]
    
    plotlyPlot = plot_ly(data, name='Peak Area Ratios', type = 'box') %>%
                         layout(boxmode = "group", xaxis = list(title="Concentration"), yaxis = list(title="Peak Area Ratio"))

    for(trace in columnNames)
    {
      plotlyPlot = plotlyPlot %>% add_trace(x = ~conc, y = as.formula(paste0("~", trace)), name=trace)
    }
    return(plotlyPlot)
  })
  
  output$outputPooledStandardDeviation <- renderUI({
    data =  methodPrecisionDataWithCalculations()
    results = ""
    for(conc in getConcentrations(data))
    {
      results = paste(results, "<h3>",conc,"=",getPooledStandardDeviation(data, conc),"</h3>")
    }
    return(HTML(results))
  }) 
  
  output$outputStandardUncertainty <- renderUI({
    data =  methodPrecisionDataWithCalculations()
    results = ""
    for(conc in getConcentrations(data))
    {
      results = paste(results, "<h3>",conc,"=",getStandardUncertainty(data,conc),"</h3>")
    }
    return(HTML(results))
  }) 
  
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