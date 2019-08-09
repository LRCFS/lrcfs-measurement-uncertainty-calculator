################################
## Fixed properties
################################
getUncertaintyOfCalibrationLatex = "u\\text{(CalCurve)} &= \\frac{S_{y/x}}{b_1} \\sqrt{\\frac{1}{r_s} + \\frac{1}{n} + \\frac{(x_s - \\overline{x})^2}{S_{xx}} }"
getRelativeStandardUncertaintyLatex = "u_r\\text{(CalCurve)} &= \\frac{u\\text{(CalCurve)}}{x_s}"
getStandardErrorOfRegressionLatex = "S_{y/x} &= \\sqrt{\\frac{\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2}{n-2}}"


calibrationCurveData <- reactive({
  if(myReactives$uploadedCalibrationCurve == TRUE)
  {
    data = calibrationCurveReadCSV(input$inputCalibrationCurveFileUpload$datapath)
    return(data)
  }
  else
  {
    return(NULL)
  }
})

calibrationCurveResult = reactive({
  data = calibrationCurveDataReformatted()
  if(is.null(data))
  {
    return(NA)
  }
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  return(getRelativeStandardUncertainty(x,y,input$inputCaseSampleReplicates,input$inputCaseSampleMeanConcentration))
})

calibrationCurveDataReformatted <- reactive({
  data = calibrationCurveData();
  
  if(is.null(data))
  {
    return(NULL)
  }
  
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
  data = calibrationCurveDataReformatted()
  if(is.null(data))
  {
    return(NULL)
  }
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  ### Get Squared Devation of X
  sqDevationX = getSqDevation(x);
  
  ### Predicted Y value is the regression cofficient of Y compared to X
  predictedY = getPredicetedY(x,y);
  
  ### Get error Sum Squared of y
  errorSqDevationY = getErrorSqDevationY(x, y);
  
  ##Get data in dataframe
  rearrangedCalibrationDataFrame = data.frame(calibrationCurveDataReformatted()$runNames,x,y,sqDevationX,predictedY,errorSqDevationY)
  colnames(rearrangedCalibrationDataFrame) = c("$$\\text{Run}$$","$$\\text{Concentration} (x)$$","$$\\text{Peak Area} (y)$$","$$\\text{Squared Deviation} (x_i-\\overline{x})^2$$","$$\\hat{y}_i = b_0 + b_1x_i$$","$$(y_i - \\hat{y}_i)^2$$")
  
  return(rearrangedCalibrationDataFrame)
}


###################################################################################
# Outputs
###################################################################################

output$display_calibrationCurve_replicates <- renderUI({
  string = paste(input$inputCaseSampleReplicates)
  return(string)
})

output$display_calibrationCurve_meanConcentration <- renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_calibrationCurve_uncertaintyOfCalibrationLatex = renderUI({
  formula = gsub("&=", "=", getUncertaintyOfCalibrationLatex)
  formula = paste0("$$",formula,"$$")
  return(withMathJax(HTML(formula)))
})

output$display_calibrationCurve_standardErrorOfRegressionLatex = renderUI({
  formula = gsub("&=", "=", getStandardErrorOfRegressionLatex)
  formula = paste0("$$",formula,"$$")
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
  
  output$display_calibrationCurve_linearRegression <- renderUI({
    data = calibrationCurveDataReformatted()
    y = data$calibrationDataPeakArea
    x = data$calibrationDataConcentration
    
    intercept = round(getIntercept(x,y),numDecimalPlaces)
    slope = round(getSlope(x,y),numDecimalPlaces)
    n = getCalibrationCurve_n(x)
    linearRegression = lm(y~x)
    rSquare = round(summary.lm(linearRegression)$r.squared,numDecimalPlaces)
    
    formulas = c(paste0("\\text{Intercept}(b_0) &=",intercept))
    formulas = c(formulas, paste0("\\text{Slope}(b_1) &= \\color{",color6,"}{",slope,"}"))
    formulas = c(formulas, paste0("R^2 &=",rSquare))
    formulas = c(formulas, paste0("n &= \\color{",color5,"}{",n,"}"))
    output = mathJaxAligned(formulas, 10)
    
    return(withMathJax(HTML(output)))
  })
  
  output$display_calibrationCurve_meanOfX <- renderUI({
    data = calibrationCurveDataReformatted()
    meanOfX = getCalibrationCurveMeanOfX(data)

    formulas = c("\\overline{x} &= \\frac{\\sum{x_i}}{n}")
    formulas = c(formulas, paste("&=\\color{",color1,"}{",meanOfX),"}")
    output = mathJaxAligned(formulas, 5)
    
    return(withMathJax(HTML(output)))
  })

  output$display_calibrationCurve_sumSqDevationX <- renderUI({
    x = calibrationCurveDataReformatted()$calibrationDataConcentration
    sumSqDevationX = sum(getSqDevation(x))
    
    formulas = c("S_{xx} &= \\sum\\limits_{i=1}^n(x_i - \\overline{x})^2")
    formulas = c(formulas, paste("&=\\color{",color2,"}{",sumSqDevationX,"}"))
    output = mathJaxAligned(formulas, 5)
    
    return(withMathJax(HTML(output)))
  })
  
  output$display_calibrationCurve_errorSumSqY <- renderUI({
    data = calibrationCurveDataReformatted()
    y = data$calibrationDataPeakArea
    x = data$calibrationDataConcentration
    errorSqDevationY = sum(getErrorSqDevationY(x,y))
    
    formulas = c("S_{y\\hat{y}} &=\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2")
    formulas = c(formulas, paste("&=\\color{",color3,"}{",errorSqDevationY,"}"))
    output = mathJaxAligned(formulas, 5)
    
    return(withMathJax(HTML(output)))
  })
  
  output$standardErrorOfRegression <- renderUI({
    data = calibrationCurveDataReformatted()
    x = data$calibrationDataConcentration
    y = data$calibrationDataPeakArea
    
    n = getCalibrationCurve_n(x)
    errorSumSqY = sum(getErrorSqDevationY(x,y))
    stdErrorOfRegression = getStandardErrorOfRegerssion(x,y)
    
    formulas = c(paste(getStandardErrorOfRegressionLatex,"[[break]]"))
    formulas = c(formulas, paste("S_{y/x} &= \\sqrt{\\frac{\\color{",color3,"}{",errorSumSqY,"}}{\\color{",color5,"}{",n,"}-2}}"))
    formulas = c(formulas, paste("&=\\color{",color4,"}{",stdErrorOfRegression,"}"))
    output = mathJaxAligned(formulas, 5, 20)
    
    return(withMathJax(HTML(output)))
    
    
  })

  output$uncertaintyOfCalibration <- renderUI({
    data = calibrationCurveDataReformatted()
    x = data$calibrationDataConcentration
    y = data$calibrationDataPeakArea
    
    stdErrorOfRegression = getStandardErrorOfRegerssion(x,y)
    slope = getSlope(x,y)
    caseSampleReps = input$inputCaseSampleReplicates
    n = getCalibrationCurve_n(x)
    caseSampleMeanConc = input$inputCaseSampleMeanConcentration
    meanX = getCalibrationCurveMeanOfX(data)
    sumSqDevationX = sum(getSqDevation(x))
    uncertaintyOfCalibration = getUncertaintyOfCalibration(x,y,caseSampleReps,caseSampleMeanConc)
    
    formulas = c(paste(getUncertaintyOfCalibrationLatex,"[[break]]"))
    formulas = c(formulas, paste("u\\text{(CalCurve)}&=\\frac{\\color{",color4,"}{",stdErrorOfRegression,"}}{\\color{",color6,"}{",slope,"}} \\sqrt{\\frac{1}{\\bbox[#00C0EF,2pt]{\\color{#FFF}{",caseSampleReps,"}}} + \\frac{1}{\\color{",color5,"}{",n,"}} + \\frac{(\\bbox[#F012BE,2pt]{\\color{#FFF}{",caseSampleMeanConc,"}} - \\color{",color1,"}{",meanX,"})^2}{\\color{",color2,"}{",sumSqDevationX,"}} }"))
    formulas = c(formulas, paste("&=",uncertaintyOfCalibration))
    output = mathJaxAligned(formulas, 5, 20)
    
    return(withMathJax(HTML(output)))
  })
  
  
  output$peakAreaRatios <- renderPlotly({
    data = calibrationCurveDataReformatted()
    x = data$calibrationDataConcentration
    y = data$calibrationDataPeakArea
    
    slope = getSlope(x,y)
    intercept = getIntercept(x,y)
    
    # royTestErrorBarThing_relativeStandardUncertainty = getRelativeStandardUncertainty(x,y,input$inputCaseSampleReplicates,input$inputCaseSampleMeanConcentration)
    # royTestErrorBarThing = expandedUncertaintyResult()
    
    fit = lm(y~x)
    
    plot_ly(x = x, y = y, name='Peak Area Ratios', type = 'scatter', mode='markers') %>%
      add_lines(x = x, y = fitted(fit), name="Calibration Curve") %>%
      # add_ribbons(x = x,
      #             ymin = fitted(fit) - royTestErrorBarThing,
      #             ymax = fitted(fit) + royTestErrorBarThing,
      #             line = list(color = 'rgba(7, 164, 181, 0.05)'),
      #             fillcolor = 'rgba(7, 164, 181, 0.2)',
      #             name = "Relative Standard Uncertainty") %>%
      layout(xaxis = list(title="Concentration"), yaxis = list(title="Peak Area Ratio")) %>%
      add_annotations(x= 0.5,y= 0.8,xref="paper",yref="paper",text=paste0("$y = ",intercept,"+",slope,"x$"),showarrow = F)    
  })
  
  
  
  
output$display_calibrationCurve_finalAnswer_top <- renderText({
  return(paste("\\(u_r\\text{(CalCurve)}=\\)",calibrationCurveResult()))
})

output$display_calibrationCurve_finalAnswer_bottom <- renderUI({
  data = calibrationCurveDataReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  uncertaintyOfCalibration = getUncertaintyOfCalibration(x,y,input$inputCaseSampleReplicates,input$inputCaseSampleMeanConcentration)
  relativeStandardUncertainty = calibrationCurveResult()
  
  formulas = c("u_r\\text{(CalCurve)} &= \\frac{\\text{Uncertatiny of Calibration}}{\\text{Case Sample Mean Concentration}} [[break]]")
  formulas = c(formulas, getRelativeStandardUncertaintyLatex)
  formulas = c(formulas, paste("&=\\frac{",uncertaintyOfCalibration,"}{\\bbox[#F012BE,2pt]{",input$inputCaseSampleMeanConcentration,"}}"))
  formulas = c(formulas, paste("&=",relativeStandardUncertainty))
  
  output = mathJaxAligned(formulas, 5, 20)
  
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurve_finalAnswer_dashboard <- renderUI({
  return(paste("\\(u_r\\text{(CalCurve)}=\\)",calibrationCurveResult()))
})

output$display_calibrationCurve_finalAnswer_combinedUncertainty <- renderUI({
  return(paste(calibrationCurveResult()))
})

output$display_calibrationCurve_finalAnswer_coverageFactor <- renderUI({
  return(paste(calibrationCurveResult()))
})
  
  

###################################################################################
# Helper Methods
###################################################################################

getCalibrationCurveMeanOfX = function(calibrationCurveDataReformatted){
  data = calibrationCurveDataReformatted()
  if(is.null(data))
  {
    return(NA)
  }
  meanOfX = mean(data$calibrationDataConcentration)
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

getCalibrationCurve_n = function(calibrationDataConcentration)
{
  n = length(calibrationDataConcentration)
  return(n)
}