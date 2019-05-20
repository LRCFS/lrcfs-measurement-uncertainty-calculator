################################
## Fixed properties
################################

numDecimalPlaces = 5
getUncertaintyOfCalibrationLatex = "$$u\\text{(CalCurve)} = \\frac{S_{y/x}}{b_1} \\sqrt{\\frac{1}{r_s} + \\frac{1}{n} + \\frac{(x_s - \\overline{x})^2}{S_{xx}} }$$"
getRelativeStandardUncertaintyLatex = "$$u_r\\text{(CalCurve)} = \\frac{u\\text{(CalCurve)}}{x_s}$$"


################################
## Server Function
################################
serverUncertaintyCalibrationCurve = function(input, output){
  ##############################################
  ## Calibration Cruve Calculations
  ##############################################
  
  data <- reactive({
    data = readExcel(input$fileUpload)
    return(data)
  })
  
  dataReformatted <- reactive({
    data = data();
    
    ## Set x = concentration and y = peack area ratios
    runNames = rep(colnames(data)[-1], each=10)
    calibrationDataConcentration <- rep(data$Concentration,6)
    calibrationDataPeakArea <- c(data$Run1,data$Run2,data$Run3,data$Run4,data$Run5,data$Run6)
    
    allData = data.frame(runNames, calibrationDataConcentration, calibrationDataPeakArea)
    colnames(allData) = c("runNames","calibrationDataConcentration","calibrationDataPeakArea")
    return(allData)
  })
  
  output$calibrationData <- DT::renderDataTable(
    data(),
    rownames = FALSE,
    options = list(scrollX = TRUE, dom = 'tip')
  )
  
  rearrangedCalibrationDataDT = function(){
    x = dataReformatted()$calibrationDataConcentration
    y = dataReformatted()$calibrationDataPeakArea
    
    ### Get Sum Squared of X
    sqDevationX = getSqDevation(x);
    
    ### Predicted Y value is the regression cofficient of Y compared to X
    predictedY = getPredicetedY(x,y);
    
    ### Get error Sum Squared of y
    errorSqDevationY = getErrorSqDevationY(x, y);
    
    ##Get data in dataframe
    rearrangedCalibrationDataFrame = data.frame(dataReformatted()$runNames,x,y,sqDevationX,predictedY,errorSqDevationY)
    rearrangedCalibrationDataFrame
    colnames(rearrangedCalibrationDataFrame) = c("Run","$$x$$","$$y$$","$$(x_i-\\overline{x})^2$$","$$\\hat{y}_i = b_0 + b_1x_i$$","$$(y_i - \\hat{y}_i)^2$$")
    
    return(rearrangedCalibrationDataFrame)
  }
  
  output$rearrangedCalibrationData <- DT::renderDataTable(
    rearrangedCalibrationDataDT(),
    rownames = FALSE,
    options = list(scrollX = TRUE, dom = 'tip')
  )
  
  output$uploadedCalibrationDataStats <- renderUI({
    
    
    return(paste("Uploaded Calibration Data | Runs: ", dim(data())[2]-1 , " | No. Concentrations: ", dim(data())[1]))
  })
  
  output$uncertaintyOfCalibrationCurve <- renderText({
    x = dataReformatted()$calibrationDataConcentration
    y = dataReformatted()$calibrationDataPeakArea
    
    relativeStandardUncertainty = getRelativeStandardUncertainty(x,y,input)
    
    #Add uncertaintly of calibration curve notation to start of answer
    return(paste("\\(u_r\\text{(CalCurve)}=\\)",relativeStandardUncertainty))
  })

  output$xMean <- renderText({
    x = dataReformatted()$calibrationDataConcentration;
    xMean = mean(x)
    return(xMean)
  })

  output$sumSqDevationX <- renderText({
    x = dataReformatted()$calibrationDataConcentration

    sumSqDevationX = sum(getSqDevation(x))
    return(sumSqDevationX)
  })
  
  output$errorSumSqY <- renderText({
    y = dataReformatted()$calibrationDataPeakArea
    x = dataReformatted()$calibrationDataConcentration
    
    errorSqDevationY = sum(getErrorSqDevationY(x,y))
    return(errorSqDevationY)
  })
  
  output$standardErrorOfRegression <- renderUI({
    x = dataReformatted()$calibrationDataConcentration
    y = dataReformatted()$calibrationDataPeakArea
    
    degreesOfFreedom = getDegreesOfFreedom(x)
    errorSumSqY = sum(getErrorSqDevationY(x,y))
    stdErrorOfRegression = getStandardErrorOfRegerssion(x,y)

    withMathJax(HTML(paste("$$S_{y/x} = \\sqrt{\\frac{\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2}{n-2}}$$$$ = \\sqrt{\\frac{",errorSumSqY,"}{",degreesOfFreedom,"}}$$",h4(stdErrorOfRegression))))
  })

  output$uncertaintyOfCalibration <- renderUI({
    x = dataReformatted()$calibrationDataConcentration
    y = dataReformatted()$calibrationDataPeakArea
    
    uncertaintyOfCalibration = getUncertaintyOfCalibration(x,y,input)
    
    withMathJax(HTML(paste(getUncertaintyOfCalibrationLatex,
                   "$$=\\frac{",getStandardErrorOfRegerssion(x,y),"}{",getSlope(x,y),"} \\sqrt{\\frac{1}{",input$inputCaseSampleReplicates,"} + \\frac{1}{",length(x),"} + \\frac{(",input$inputCaseSampleMeanConcentration," - ",mean(x),")^2}{",sum(getSqDevation(x)),"} }$$", h4(uncertaintyOfCalibration))))
  })
  
  output$relativeStandardUncertainty <- renderUI({
    x = dataReformatted()$calibrationDataConcentration
    y = dataReformatted()$calibrationDataPeakArea
    
    relativeStandardUncertainty = getRelativeStandardUncertainty(x,y,input)
    
    withMathJax(HTML(paste(getRelativeStandardUncertaintyLatex,
                 "$$=\\frac{",getUncertaintyOfCalibration(x,y,input),"}{",input$inputCaseSampleMeanConcentration,"}$$",h4(relativeStandardUncertainty)))
    )
  })

  output$peakAreaRatios <- renderPlotly({
    x = dataReformatted()$calibrationDataConcentration
    y = dataReformatted()$calibrationDataPeakArea
    
    slope = round(getSlope(x,y),numDecimalPlaces)
    intercept = round(getIntercept(x,y),numDecimalPlaces)

    fit = lm(y~x)
    
    plot_ly(x = x, y = y, name='Peak Area Ratios', type = 'scatter', mode='markers') %>%
      add_lines(x = x, y = fitted(fit), name="Calibration Curve") %>%
      layout(xaxis = list(title="Concentration"), yaxis = list(title="Peak Area Ratio")) %>%
      add_annotations(x= 0.5,y= 0.8,xref="paper",yref="paper",text=paste0("$y = ",intercept,"+",slope,"x$"),showarrow = F)    
  })
  
  output$dashboardUncertaintyOfCalibrationCurve <- renderText({
    x = dataReformatted()$calibrationDataConcentration
    y = dataReformatted()$calibrationDataPeakArea
    
    relativeStandardUncertainty = getRelativeStandardUncertainty(x,y,input)
    
    #Add uncertaintly of calibration curve notation to start of answer
    return(paste("\\(u_r\\text{(CalCurve)}=\\)",relativeStandardUncertainty))
  })
}

################################
## Helper functions and methods
################################

getSqDevation = function(val){
  sqDevation = (val - mean(val))^2
  sqDevation = round(sqDevation, numDecimalPlaces)
  return(sqDevation)
}

getPredicetedY = function(x, y){
  calCurve = lm(y~x) # Regression Cofficients
  predictedY =  fitted(calCurve)
  predictedY = round(predictedY, numDecimalPlaces)
  return(predictedY)
}

getSlope = function(x,y){
  linearRegerssion = lm(y~x)
  slope <- coef(linearRegerssion)[2];
  slope = round(slope, numDecimalPlaces)
  return(slope)
}

getIntercept = function(x,y){
  linearRegerssion = lm(y~x)
  intercept = coef(linearRegerssion)[1]
  intercept = round(intercept, numDecimalPlaces)
  return(intercept)
}


getErrorSqDevationY = function(x, y){
  errorSqDevationY = (y - getPredicetedY(x, y))^2
  errorSqDevationY= round(errorSqDevationY, numDecimalPlaces)
  return (errorSqDevationY)
}

getDegreesOfFreedom = function(x){
  degressOfFreedom = length(x)-2
  degressOfFreedom = round(degressOfFreedom, numDecimalPlaces)
  return(degressOfFreedom)
}

getStandardErrorOfRegerssion = function(x, y){
  degreesOfFreedom = getDegreesOfFreedom(x);
  errorSumSqY = sum(getErrorSqDevationY(x,y))
  standardErrorOfRegerssion = sqrt(errorSumSqY/degreesOfFreedom)
  standardErrorOfRegerssion= round(standardErrorOfRegerssion, numDecimalPlaces)
  return(standardErrorOfRegerssion)
}

getUncertaintyOfCalibration = function(x, y, input)
{
  uncertaintyOfCalibration = (getStandardErrorOfRegerssion(x,y) / getSlope(x,y)) * (sqrt((1/input$inputCaseSampleReplicates)+(1/length(x))+(input$inputCaseSampleMeanConcentration-mean(x))^2 / sum(getSqDevation(x))))
  uncertaintyOfCalibration = round(uncertaintyOfCalibration, numDecimalPlaces)
  return(uncertaintyOfCalibration)
}

getRelativeStandardUncertainty = function(x,y,input){
  relativeStandardUncertainty = getUncertaintyOfCalibration(x,y,input) / input$inputCaseSampleMeanConcentration
  relativeStandardUncertainty = round(relativeStandardUncertainty, numDecimalPlaces)
  return(relativeStandardUncertainty)
}



