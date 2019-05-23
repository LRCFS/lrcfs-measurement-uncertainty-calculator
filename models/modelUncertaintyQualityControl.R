serverUncertaintyQualityControl = function(input, output){
  
  
  output$uploadedQualityControlDataStats <- renderUI({
    data = qualityControlReadCSV()
    string = sprintf("Uploaded Quality Control Data | Runs: %d | No. Concentrations: %d", dim(data)[2]-1, length(unique(data$conc)))
    return(string)
  })

  output$qualityControlRawData <- DT::renderDataTable(
    qualityControlReadCSV(),
    rownames = FALSE,
    options = list(scrollX = TRUE, dom = 'tip')
  )
  
  output$qualityControlCalculations <- DT::renderDataTable(
    getQualityControlFormattedData(),
    rownames = FALSE,
    options = list(pageLength = getNumberOfRuns(), scrollX = TRUE, dom = 'tip')
  )
  
  output$qualityControlRawDataGraph <- renderPlotly({
    plot_ly(qualityControlReadCSV(), name='Peak Area Ratios', type = 'box', mode='markers') %>%
      layout(boxmode = "group", xaxis = list(title="Concentration"), yaxis = list(title="Peak Area Ratio")) %>%
      add_trace(x = ~conc, y = ~run1, name="run1") %>%
      add_trace(x = ~conc, y = ~run2, name="run2") %>%
      add_trace(x = ~conc, y = ~run3, name="run3") %>%
      add_trace(x = ~conc, y = ~run4, name="run4") %>%
      add_trace(x = ~conc, y = ~run5, name="run5") %>%
      add_trace(x = ~conc, y = ~run6, name="run6") %>%
      add_trace(x = ~conc, y = ~run7, name="run7") %>%
      add_trace(x = ~conc, y = ~run8, name="run8") %>%
      add_trace(x = ~conc, y = ~run9, name="run9") %>%
      add_trace(x = ~conc, y = ~run10, name="run10") %>%
      add_trace(x = ~conc, y = ~run11, name="run11")
  })
  
  
  output$qualityControlFormattedData <- DT::renderDataTable(
    getQualityControlFormattedData(),
    rownames = FALSE,
    options = list(scrollX = TRUE, dom = 'tip')
  )
  
  output$outputPooledStandardDeviation <- renderUI({
    results = ""
    for(conc in getConcentrations())
    {
      results = paste(results, "<h3>",conc,"=",getPooledStandardDeviation(conc),"</h3>")
    }
    return(HTML(results))
  }) 
  
  output$outputStandardUncertainty <- renderUI({
    results = ""
    for(conc in getConcentrations())
    {
      results = paste(results, "<h3>",conc,"=",getStandardUncertainty(conc),"</h3>")
    }
    return(HTML(results))
  }) 
  
  output$outputRealtiveStandardUncertainties <- renderUI({
    results = ""
    for(conc in getConcentrations())
    {
      results = paste(results, "<h3>",conc,"=",getRealtiveStandardUncertainty(conc),"</h3>")
    }
    return(HTML(results))
  })
  
  output$outputQualityControlAnswer <- renderUI({
    # answer = ""
    # for(conc in getConcentrations())
    # {
    #   getRealtiveStandardUncertainty(conc)^2 * 
    # }
    return("HTML(results)")
  })
  
}

getPooledStandardDeviation = function(concentration){
  data = getQualityControlFormattedData()
  return(data[data$conc==concentration,]$pooledStdDeviation[1])
}

getStandardUncertainty = function(concentration){
  data = getQualityControlFormattedData()
  return(data[data$conc==concentration,]$stdUncertainty[1])
}

getRealtiveStandardUncertainty = function(concentration){
  data = getQualityControlFormattedData()
  return(data[data$conc==concentration,]$relativeStdUncertainty[1])
}

getConcentrations = function(){
  return(unique(qualityControlReadCSV()$conc))
}

getNumberOfConcentrations = function(){
  return(length(unique(qualityControlReadCSV()$conc)))
}

getNumberOfRuns = function(){
  return(dim(qualityControlReadCSV())[2]-1)
}

getQualityControlFormattedData = function(){
  
  caseSampleReplicate = 2
  caseSampleMean = 2
  
  allData = qualityControlReadCSV(); allData
  uniqeConcentrations = unique(allData$conc); uniqeConcentrations
  
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
  calculationsData
  return(calculationsData)
}

