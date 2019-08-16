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

externalStandardErrorData <- reactive({
  if(myReactives$uploadedExternalStandardError == TRUE)
  {
    data = calibrationCurvePooledDataReadCSV(input$inputExternalStandardErrorFileUpload$datapath)
    return(data)
  }
  else
  {
    return(NULL)
  }
})



calibrationCurveResult = reactive({
  data = calibrationCurveDataReformatted()
  extStdErrorData = externalStandardErrorData()
  if(is.null(data))
  {
    return(NA)
  }
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  return(getRelativeStandardUncertainty(x,y,extStdErrorData,input$inputCaseSampleReplicates,input$inputCaseSampleMeanConcentration))
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
  reps = max(table(data["conc"]))
  
  dataReformatted = calibrationCurveDataReformatted()
  y = dataReformatted$calibrationDataPeakArea

  par = getCalibrationCurve_n(y)
  
  return(HTML(sprintf("Uploaded Calibration Data<br />Runs: %d | Reps: %d | Concentration Levels: %d | Peak Area Ratios: %d", dim(data)[2]-1, reps, length(table(data["conc"])), par)))
})

output$display_calibrationCurve_linearRegression <- renderUI({
  data = calibrationCurveDataReformatted()
  y = data$calibrationDataPeakArea
  x = data$calibrationDataConcentration
  
  intercept = round(getIntercept(x,y),numDecimalPlaces)
  slope = round(getSlope(x,y),numDecimalPlaces)
  n = getCalibrationCurve_n(y)
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
  
  n = getCalibrationCurve_n(y)
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
  
  exStdErrData = externalStandardErrorData()

  stdErrorOfRegression = 0
  if(is.null(exStdErrData))
  {
    stdErrorOfRegression = getStandardErrorOfRegerssion(x,y)
  }
  else
  {
    stdErrorOfRegression = getPooledStdErrorOfRegression(x,y,exStdErrData)
  }
  
  slope = getSlope(x,y)
  caseSampleReps = input$inputCaseSampleReplicates
  n = getCalibrationCurve_n(y)
  caseSampleMeanConc = input$inputCaseSampleMeanConcentration
  meanX = getCalibrationCurveMeanOfX(data)
  sumSqDevationX = sum(getSqDevation(x))
  uncertaintyOfCalibration = getUncertaintyOfCalibration(x,y,exStdErrData,caseSampleReps,caseSampleMeanConc)
  
  
  
  if(is.null(exStdErrData))
  {
    formulas = c("u\\text{(CalCurve)} &= \\frac{S_{y/x}}{b_1} \\sqrt{\\frac{1}{r_s} + \\frac{1}{n} + \\frac{(x_s - \\overline{x})^2}{S_{xx}} } [[break]]")
  }
  else
  {
    formulas = c("u\\text{(CalCurve)} &= \\frac{S_{p_{y/x}}}{b_1} \\sqrt{\\frac{1}{r_s} + \\frac{1}{n} + \\frac{(x_s - \\overline{x})^2}{S_{xx}} } [[break]]")
  }
  
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

output$display_calibrationCurve_externalStandardErrorUploadedData = renderUI({
  exStdErrorData = externalStandardErrorData()
  if(is.null(exStdErrorData))
    return(NULL)
  
  numberOfRuns = dim(exStdErrorData)[2]-1 #get the number of columns and minus 1 (because one column in the concentration)
  numberOfReplicates = max(table(exStdErrorData["conc"])) #count the number of occurances of each value in the concentration column, then get the max value (because some might be missing some)
  concentrationLevels = length(table(exStdErrorData["conc"])) #table the concentration column and count the length
  
  #To get the total number of peak areas we want to get just the runs
  exStdErrorRunData = exStdErrorData
  exStdErrorRunData$conc = NULL #so remove the conc column
  lengths = apply(exStdErrorRunData, 2, getCalibrationCurve_n) #then count all the runs lengths
  numberOfPeakAreaRatios = sum(lengths) #and add them together
                   
  boxTitle = HTML(sprintf("External Calibration Curve Data<br />Runs: %d | Reps: %d | Concentration Levels: %d | Peak Area Ratios: %d",numberOfRuns,numberOfReplicates,concentrationLevels,numberOfPeakAreaRatios))
  
  tabBox(width=12, side="right",
         title = boxTitle,
         tabPanel("Raw Data",
                  DT::renderDataTable(
                    externalStandardErrorData(),
                    rownames = FALSE,
                    options = list(scrollX = TRUE, dom = 'tip')
                  )
         )
  )
})

output$display_calibrationCurve_externalStandardErrorOfRuns = renderUI({
  exStdErrorData = externalStandardErrorData()
  if(is.null(exStdErrorData))
    return(NULL)
  
  exStdErrorRunData = exStdErrorData
  exStdErrorRunData$conc = NULL
  
  results = apply(exStdErrorRunData, 2, getStandardErrorOfRegerssion, x = exStdErrorData$conc)
  lengths = apply(exStdErrorRunData, 2, getCalibrationCurve_n)
  
  formulas = c("S_{{y/x}_{(j)}} &= \\sqrt{\\frac{\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2}{n_{(j)}-2}} [[break]]")

  for(i in 1:length(results))
  {
    formulas = c(formulas, paste0("S_{{y/x}_{(\\text{",names(results)[i],"})}}&=", results[i], " \\hspace{15pt} n_{(\\text{",names(results)[i],"})} = ", lengths[i]))
    formulas = c(formulas, paste0())
  }
  
  output = mathJaxAligned(formulas, 5, 20)
  
  box(title="Standard Error of Regression (External Calibration Data) \\((S_{{y/x}_{(j)}})\\)", width = 5, withMathJax(HTML(output)))
})

output$display_calibrationCurve_externalStandardErrorOfRunsPooled = renderUI({
  exStdErrorData = externalStandardErrorData()
  if(is.null(exStdErrorData))
    return(NULL)
  
  data = calibrationCurveDataReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  answer = getPooledStdErrorOfRegression(x,y,exStdErrorData)
  
  formulas = c("S_{p_{(y/x)}} &= \\sqrt{\\frac{\\sum{(n-1)S^2_{y/x}}}{\\sum{(n-1)}}} [[break]]")
  formulas = c(formulas, "S_{p_{(y/x)}} &= \\sqrt{\\frac{(n-1)S^2_{y/x} + \\sum{(n_{(j)}-1)S^2_{{y/x}_(j)}}}{(n-1) + \\sum{(n_{(j)}-1)}}} [[break]]")
  
  exStdErrorRunData = exStdErrorData
  exStdErrorRunData$conc = NULL
  results = unlist(apply(exStdErrorRunData, 2, getStandardErrorOfRegerssion, x = exStdErrorData$conc), use.names = FALSE)
  lengths = unlist(apply(exStdErrorRunData, 2, getCalibrationCurve_n), use.names = FALSE)
  
  n1 = getCalibrationCurve_n(y)
  n2 = lengths[1]
  n3 = lengths[length(results)]
  
  s1 = getStandardErrorOfRegerssion(x,y)
  s2 = results[1]
  s3 = results[length(results)]
  
  end = ""
  if(length(results) > 2)
  {
    endNumerator = paste(" + \\ldots + (",n3,"-1) \\times ",s3,"^2")
    endDemoninator = paste(" + \\ldots + (",n3,"-1)")
  }
  else if(length(results) == 2)
  {
    endNumerator = paste(" + (",n3,"-1) \\times ",s3,"^2")
    endDemoninator = paste(" + (",n3,"-1)")
  }
  else
  {
    endNumerator = ""
    endDemoninator = ""
  }
  
  formulas = c(formulas, paste0("&= \\sqrt{\\frac{(",n1,"-1) \\times ",s1,"^2 + (",n2,"-1) \\times ",s2,"^2",endNumerator,"}{(",n1,"-1) + (",n2,"-1)",endDemoninator,"}} [[break]]"))

  formulas = c(formulas, paste0("&=\\color{",color4,"}{", answer, "}"))
  
  output = mathJaxAligned(formulas, 5, 20)
 
  box(title="Pooled Standard Error of Regression (External Calibration Data) \\((S_{p_{(y/x)}})\\)", width = 7,withMathJax(HTML(output)))
})
  
  
  
  
output$display_calibrationCurve_finalAnswer_top <- renderText({
  return(paste("\\(u_r\\text{(CalCurve)}=\\)",calibrationCurveResult()))
})

output$display_calibrationCurve_finalAnswer_bottom <- renderUI({
  data = calibrationCurveDataReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  extStdErrorData = externalStandardErrorData()
  
  uncertaintyOfCalibration = getUncertaintyOfCalibration(x,y,extStdErrorData,input$inputCaseSampleReplicates,input$inputCaseSampleMeanConcentration)
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
  calCurve = lm(y~x, na.action = na.omit) # Regression Cofficients
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
  errorSqDevationY = (na.omit(y) - getPredicetedY(x, y))^2
  errorSqDevationY= round(errorSqDevationY, numDecimalPlaces)
  return (errorSqDevationY)
}

getDegreesOfFreedom = function(values){
  degressOfFreedom = getCalibrationCurve_n(values)-2
  degressOfFreedom = round(degressOfFreedom, numDecimalPlaces)
  return(degressOfFreedom)
}

getStandardErrorOfRegerssion = function(x, y){
  linearRegerssion = lm(y~x)
  standardErrorOfRegerssion = summary.lm(linearRegerssion)$sigma
  standardErrorOfRegerssion= round(standardErrorOfRegerssion, numDecimalPlaces)
  return(standardErrorOfRegerssion)
  
  # degreesOfFreedom = getDegreesOfFreedom(y);
  # errorSumSqY = sum(getErrorSqDevationY(x,y))
  # standardErrorOfRegerssion = sqrt(errorSumSqY/degreesOfFreedom)
  # standardErrorOfRegerssion= round(standardErrorOfRegerssion, numDecimalPlaces)
  # return(standardErrorOfRegerssion)
}

getUncertaintyOfCalibration = function(x, y, extStdErrorData, caseSampleReplicates, caseSampleMeanConcentration)
{
  syx = 0
  if(is.null(extStdErrorData))
  {
    syx = getStandardErrorOfRegerssion(x,y)
  }
  else
  {
    syx = getPooledStdErrorOfRegression(x,y,extStdErrorData)
  }
  
  uncertaintyOfCalibration = (syx / getSlope(x,y)) * (sqrt((1/caseSampleReplicates)+(1/getCalibrationCurve_n(x))+(caseSampleMeanConcentration-mean(x))^2 / sum(getSqDevation(x))))
  uncertaintyOfCalibration = round(uncertaintyOfCalibration, numDecimalPlaces)
  
  return(uncertaintyOfCalibration)
}

getPooledStdErrorOfRegression = function(x,y,exStdErrData){
  exStdErrRunData = exStdErrData
  exStdErrRunData$conc = NULL
  
  results = unlist(apply(exStdErrRunData, 2, getStandardErrorOfRegerssion, x = exStdErrData$conc), use.names = FALSE)
  lengths = unlist(apply(exStdErrRunData, 2, getCalibrationCurve_n), use.names = FALSE)
  
  numeratorExternalDataSum = sum((results ^ 2) * (lengths -1))
  numeratorSum = (getStandardErrorOfRegerssion(x,y)^2) * (getCalibrationCurve_n(y) - 1)
  numerator = numeratorExternalDataSum + numeratorSum 
  
  demoninatorExternalDataSum = sum(lengths - 1)
  demoninatorSum = getCalibrationCurve_n(y) - 1
  demoninator = demoninatorExternalDataSum + demoninatorSum
  
  answer = sqrt(numerator/demoninator)
  
  return(round(answer,numDecimalPlaces))
}

getRelativeStandardUncertainty = function(x,y,extStdErrorData,caseSampleReplicates,caseSampleMeanConcentration){
  uncertaintyOfCalibration = getUncertaintyOfCalibration(x,y,extStdErrorData,caseSampleReplicates,caseSampleMeanConcentration)
  
  relativeStandardUncertainty = uncertaintyOfCalibration / caseSampleMeanConcentration
  relativeStandardUncertainty = round(relativeStandardUncertainty, numDecimalPlaces)
  
  return(relativeStandardUncertainty)
}

getCalibrationCurve_n = function(values)
{
  n = length(values[!is.na(values)])
  return(n)
}