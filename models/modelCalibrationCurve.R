################################
## Fixed properties
################################
getUncertaintyOfCalibrationLatex = "u\\text{(CalCurve)} &= \\frac{S_{y/x}}{b_1} \\sqrt{\\frac{1}{r_s} + \\frac{1}{n} + \\frac{(x_s - \\overline{x})^2}{S_{xx}} }"
getRelativeStandardUncertaintyLatex = "u_r\\text{(CalCurve)} &= \\frac{u\\text{(CalCurve)}}{x_s}"
getStandardErrorOfRegressionLatex = "S_{y/x} &= \\sqrt{\\frac{\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2}{n-2}}"


calibrationCurveData <- reactive({
  data = calibrationCurveReadCSV(input$intputCalibrationCurveFileUpload)
  return(data)
})

calibrationCurveResult = reactive({
  x = calibrationCurveDataReformatted()$calibrationDataConcentration
  y = calibrationCurveDataReformatted()$calibrationDataPeakArea
  
  return(getRelativeStandardUncertainty(x,y,input$inputCaseSampleReplicates,input$inputCaseSampleMeanConcentration))
})

calibrationCurveDataReformatted <- reactive({
  data = calibrationCurveData();
  
  numConc = nrow(data)
  numRuns = ncol(data)-1

  ## Set x = concentration and y = peack area ratios
  runNames = rep(colnames(data)[-1], each=numConc)
  calibrationDataConcentration <- rep(data$conc,numRuns)

  data = data[,-1]
  calibrationDataPeakArea <- unlist(c(data), use.names = FALSE)
  
  allData = data.frame(runNames, calibrationDataConcentration, calibrationDataPeakArea)
  colnames(allData) = c("runNames","calibrationDataConcentration","calibrationDataPeakArea")

  #Remove any data with NA enteries
  allDataNaRemoved = allData[!is.na(allData$calibrationDataPeakArea),]
  
  return(allDataNaRemoved)
})

rearrangedCalibrationDataDT = function(){
  x = calibrationCurveDataReformatted()$calibrationDataConcentration
  y = calibrationCurveDataReformatted()$calibrationDataPeakArea
  
  ### Get Squared Devation of X
  sqDevationX = getSqDevation(x);
  
  ### Predicted Y value is the regression cofficient of Y compared to X
  predictedY = getPredicetedY(x,y);
  
  ### Get error Sum Squared of y
  errorSqDevationY = getErrorSqDevationY(x, y);
  
  ##Get data in dataframe
  rearrangedCalibrationDataFrame = data.frame(calibrationCurveDataReformatted()$runNames,x,y,sqDevationX,predictedY,errorSqDevationY)
  colnames(rearrangedCalibrationDataFrame) = c("$$\\text{Run}$$","$$x$$","$$y$$","$$(x_i-\\overline{x})^2$$","$$\\hat{y}_i = b_0 + b_1x_i$$","$$(y_i - \\hat{y}_i)^2$$")
  
  return(rearrangedCalibrationDataFrame)
}


###################################################################################
# Outputs
###################################################################################

output$display_calibrationCurve_uncertaintyOfCalibrationLatex = renderUI({
  forumla = gsub("&=", "=", getUncertaintyOfCalibrationLatex)
  formula = paste0("$$",forumla,"$$")
  return(withMathJax(HTML(formula)))
})

output$display_calibrationCurve_standardErrorOfRegressionLatex = renderUI({
  forumla = gsub("&=", "=", getStandardErrorOfRegressionLatex)
  formula = paste0("$$",forumla,"$$")
  return(withMathJax(HTML(formula)))
})

  #Calibration Cruve Calculations
  output$calibrationData <- DT::renderDataTable(
    calibrationCurveData(),
    rownames = FALSE,
    options = list(scrollX = TRUE, dom = 'tip')
  )

  output$rearrangedCalibrationData <- DT::renderDataTable(
    rearrangedCalibrationDataDT(),
    rownames = FALSE,
    options = list(scrollX = TRUE, dom = 'tip', columnDefs = list(list(className = 'dt-right', targets = 0:5)))
  )
  
  output$uploadedCalibrationDataStats <- renderUI({
    data = calibrationCurveData()
    return(sprintf("Uploaded Calibration Data | Runs: %d | No. Concentrations: %d", dim(data)[2]-1, dim(data)[1]))
  })
  
  output$display_calibrationCurve_meanOfX <- renderUI({
    meanOfX = getCalibrationCurveMeanOfX(calibrationCurveDataReformatted())

    formulas = c("\\overline{x} &= \\frac{\\sum{x_i}}{n}")
    forumlas = c(formulas, paste("&=",meanOfX))
    output = mathJaxAligned(forumlas, 0)
    
    return(withMathJax(HTML(output)))
  })

  output$display_calibrationCurve_sumSqDevationX <- renderUI({
    x = calibrationCurveDataReformatted()$calibrationDataConcentration
    sumSqDevationX = sum(getSqDevation(x))
    
    formulas = c("S_{xx} &= \\sum\\limits_{i=1}^n(x_i - \\overline{x})^2")
    forumlas = c(formulas, paste("&=",sumSqDevationX))
    output = mathJaxAligned(forumlas, 0)
    
    return(withMathJax(HTML(output)))
  })
  
  output$display_calibrationCurve_errorSumSqY <- renderUI({
    y = calibrationCurveDataReformatted()$calibrationDataPeakArea
    x = calibrationCurveDataReformatted()$calibrationDataConcentration
    errorSqDevationY = sum(getErrorSqDevationY(x,y))
    
    formulas = c("S_{y\\hat{y}} &=\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2")
    forumlas = c(formulas, paste("&=",errorSqDevationY))
    output = mathJaxAligned(forumlas, 0)
    
    return(withMathJax(HTML(output)))
  })
  
  output$standardErrorOfRegression <- renderUI({
    x = calibrationCurveDataReformatted()$calibrationDataConcentration
    y = calibrationCurveDataReformatted()$calibrationDataPeakArea
    
    degreesOfFreedom = getDegreesOfFreedom(x)
    errorSumSqY = sum(getErrorSqDevationY(x,y))
    stdErrorOfRegression = getStandardErrorOfRegerssion(x,y)
    
    formulas = c(getStandardErrorOfRegressionLatex)
    formulas = c(formulas, paste("&= \\sqrt{\\frac{",errorSumSqY,"}{",degreesOfFreedom,"}}"))
    forumlas = c(formulas, paste("&=",stdErrorOfRegression))
    output = mathJaxAligned(forumlas)
    
    return(withMathJax(HTML(output)))
    
    
  })

  output$uncertaintyOfCalibration <- renderUI({
    x = calibrationCurveDataReformatted()$calibrationDataConcentration
    y = calibrationCurveDataReformatted()$calibrationDataPeakArea
    
    stdErrorOfRegression = getStandardErrorOfRegerssion(x,y)
    slope = getSlope(x,y)
    caseSampleReps = input$inputCaseSampleReplicates
    reps = length(x)
    caseSampleMeanConc = input$inputCaseSampleMeanConcentration
    meanX = mean(x)
    sumSqDevationX = sum(getSqDevation(x))
    uncertaintyOfCalibration = getUncertaintyOfCalibration(x,y,caseSampleReps,caseSampleMeanConc)
    
    formulas = c(getUncertaintyOfCalibrationLatex)
    formulas = c(formulas, paste("&=\\frac{",stdErrorOfRegression,"}{",slope,"} \\sqrt{\\frac{1}{",caseSampleReps,"} + \\frac{1}{",reps,"} + \\frac{(",caseSampleMeanConc," - ",meanX,")^2}{",sumSqDevationX,"} }"))
    forumlas = c(formulas, paste("&=",uncertaintyOfCalibration))
    output = mathJaxAligned(forumlas)
    
    return(withMathJax(HTML(output)))
  })
  
  
  output$peakAreaRatios <- renderPlotly({
    x = calibrationCurveDataReformatted()$calibrationDataConcentration
    y = calibrationCurveDataReformatted()$calibrationDataPeakArea
    
    slope = getSlope(x,y)
    intercept = getIntercept(x,y)
    
    royTestErrorBarThing_relativeStandardUncertainty = getRelativeStandardUncertainty(x,y,input$inputCaseSampleReplicates,input$inputCaseSampleMeanConcentration)
    
    royTestErrorBarThing = expandedUncertaintyResult()
    
    
    fit = lm(y~x)
    
    plot_ly(x = x, y = y, name='Peak Area Ratios', type = 'scatter', mode='markers') %>%
      add_lines(x = x, y = fitted(fit), name="Calibration Curve") %>%
      add_ribbons(x = x,
                  ymin = fitted(fit) - royTestErrorBarThing,
                  ymax = fitted(fit) + royTestErrorBarThing,
                  line = list(color = 'rgba(7, 164, 181, 0.05)'),
                  fillcolor = 'rgba(7, 164, 181, 0.2)',
                  name = "Relative Standard Uncertainty") %>%
      layout(xaxis = list(title="Concentration"), yaxis = list(title="Peak Area Ratio")) %>%
      add_annotations(x= 0.5,y= 0.8,xref="paper",yref="paper",text=paste0("$y = ",intercept,"+",slope,"x$"),showarrow = F)    
  })
  
  
  
  
output$display_calibrationCurve_finalAnswer_top <- renderText({
  return(paste("\\(u_r\\text{(CalCurve)}=\\)",calibrationCurveResult()))
})

output$display_calibrationCurve_finalAnswer_bottom <- renderUI({
  x = calibrationCurveDataReformatted()$calibrationDataConcentration
  y = calibrationCurveDataReformatted()$calibrationDataPeakArea
  
  uncertaintyOfCalibration = getUncertaintyOfCalibration(x,y,input$inputCaseSampleReplicates,input$inputCaseSampleMeanConcentration)
  relativeStandardUncertainty = calibrationCurveResult()
  
  formulas = c(getRelativeStandardUncertaintyLatex)
  formulas = c(formulas, paste("&=\\frac{",uncertaintyOfCalibration,"}{",input$inputCaseSampleMeanConcentration,"}"))
  forumlas = c(formulas, paste("&=",relativeStandardUncertainty))
  
  output = mathJaxAligned(forumlas)
  
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurve_finalAnswer_dashboard <- renderUI({
  return(withMathJax(sprintf("\\(u_r\\text{(CalCurve)}=%f\\)",calibrationCurveResult())))
})

output$display_calibrationCurve_finalAnswer_combinedUncertainty <- renderUI({
  return(paste(calibrationCurveResult()))
})
  
  

###################################################################################
# Helper Methods
###################################################################################

getCalibrationCurveMeanOfX = function(calibrationCurveDataReformatted){
  x = calibrationCurveDataReformatted$calibrationDataConcentration
  meanOfX = mean(x)
  print(meanOfX)
  return(round(meanOfX, numDecimalPlaces))
}
getSqDevation = function(values){
  sqDevation = (values - mean(values))^2
  sqDevation = round(sqDevation, numDecimalPlaces)
  return(sqDevation)
}

getPredicetedY = function(x, y){
  calCurve = lm(y~x) # Regression Cofficients
  predictedY =  fitted(calCurve)
  predictedY = round(predictedY, numDecimalPlaces)
  #remove naming for vector of numbers
  predictedY = unname(predictedY)
  return(predictedY)
}

getSlope = function(x,y){
  linearRegerssion = lm(y~x)
  slope <- coef(linearRegerssion)[2];
  slope = round(slope, numDecimalPlaces)
  #remove naming to get single number
  slope = unname(slope)
  return(slope)
}

getIntercept = function(x,y){
  linearRegerssion = lm(y~x)
  intercept = coef(linearRegerssion)[1]
  intercept = round(intercept, numDecimalPlaces)
  #remove naming to get single number
  intercept = unname(intercept)
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

getUncertaintyOfCalibration = function(x, y, caseSampleReplicates, caseSampleMeanConcentration)
{
  uncertaintyOfCalibration = (getStandardErrorOfRegerssion(x,y) / getSlope(x,y)) * (sqrt((1/caseSampleReplicates)+(1/length(x))+(caseSampleMeanConcentration-mean(x))^2 / sum(getSqDevation(x))))
  uncertaintyOfCalibration = round(uncertaintyOfCalibration, numDecimalPlaces)
  
  return(uncertaintyOfCalibration)
}

getRelativeStandardUncertainty = function(x,y,caseSampleReplicates,caseSampleMeanConcentration){
  uncertaintyOfCalibration = getUncertaintyOfCalibration(x,y,caseSampleReplicates,caseSampleMeanConcentration)
  
  relativeStandardUncertainty = uncertaintyOfCalibration / caseSampleMeanConcentration
  relativeStandardUncertainty = round(relativeStandardUncertainty, numDecimalPlaces)
  
  return(relativeStandardUncertainty)
}