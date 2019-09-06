##############################################
# Checkers
##############################################
checkUsingWls = reactive({
  wlsSelectedOption = input$inputWeightLeastSquared
  result = doCheckUsingWls(wlsSelectedOption)
  return(result)
})

##############################################
# Get data
##############################################
getDataCalibrationCurve = reactive({
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

getDataExternalStandardError = reactive({
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

getDataCalibrationCurveReformatted = reactive({
  data = getDataCalibrationCurve();
  if(is.null(data))
  {
    return(NULL)
  }
  numConc = nrow(data)
  numRuns = ncol(data)-1

  ## Set x = concentration and y = peack area ratios
  runNames = rep(colnames(data)[-1], each=numConc)
  calibrationDataConcentration = rep(data$conc,numRuns)

  data = data[,-1]
  calibrationDataPeakArea = unlist(c(data), use.names = FALSE)
  
  allData = data.frame(runNames, calibrationDataConcentration, calibrationDataPeakArea)
  colnames(allData) = c("runNames","calibrationDataConcentration","calibrationDataPeakArea")

  #Remove any data with NA enteries
  allDataNaRemoved = allData[!is.na(allData$calibrationDataPeakArea),]
  
  return(allDataNaRemoved)
})

getDataCalibrationCurveRearranged = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data))return(NULL)

  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  ### Get Squared Devation of X
  sqDevationX = doGetCalibrationCurve_sqDeviation(x);
  
  #Get Weight
  weightedLeastSquared = getCalibrationCurve_weightedLeastSquared()
  
  #Get Weight
  wx = weightedLeastSquared * x
  wy = weightedLeastSquared * y
  
  ### Predicted Y value is the regression cofficient of Y compared to X
  predictedY = doGetCalibrationCurve_predicetedY(x,y, weightedLeastSquared);
  
  ### Get error Sum Squared of y
  errorSqDevationY = doGetCalibrationCurve_errorSqDeviationY(x,y,weightedLeastSquared);
  weightedErrorSqDevationY = doGetCalibrationCurve_weightedErrorSqDeviationY(weightedLeastSquared,errorSqDevationY)
  
  weightedXSquared = doGetCalibrationCurve_weightedXSquared(weightedLeastSquared,x)
  
  ##Get data in dataframe
  rearrangedCalibrationDataFrame = data.frame(getDataCalibrationCurveReformatted()$runNames,x,y,weightedLeastSquared,wx,wy,weightedXSquared,sqDevationX,predictedY,errorSqDevationY,weightedErrorSqDevationY)
  colnames(rearrangedCalibrationDataFrame) = c("$$\\text{Run}$$","$$\\text{Concentration} (x)$$","$$\\text{Peak Area} (y)$$",paste("$$\\text{Weight}(",doGetCalibrationCurve_wlsLatex(input$inputWeightLeastSquared),")$$"),"$$w_ix_i$$","$$w_iy_i$$","$$wx^2$$","$$\\text{Sq. Deviation} (x_i-\\overline{x})^2$$","$$\\hat{y}_i = b_0 + b_1x_i$$","$$(y_i - \\hat{y}_i)^2$$","$$w_i(y_i - \\hat{y}_i)^2$$")
  
  return(rearrangedCalibrationDataFrame)
})


##############################################
# Get Data Statistics
##############################################
getCalibrationCurve_numberOfRuns = reactive({
  data = getDataCalibrationCurve()
  answer = dim(data)[2]-1
  return(answer)
})

getCalibrationCurve_numberOfReplicates = reactive({
  data = getDataCalibrationCurve()
  answer = max(table(data["conc"]))
  return(answer)
})

getCalibrationCurve_numberOfConcentrations = reactive({
  data = getDataCalibrationCurve()
  answer = length(table(data["conc"]))
  return(answer)
})

getCalibrationCurve_numberOfPeakAreaRatios = reactive({
  dataReformatted = getDataCalibrationCurveReformatted()
  y = dataReformatted$calibrationDataPeakArea
  answer = getCalibrationCurve_n()
  return(answer)
})

##############################################
# Get Results
##############################################

getResultCalibrationCurve = reactive({
  data = getDataCalibrationCurveReformatted()
    if(is.null(data)) return(NA)

  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  wlsSelectedValue = input$inputWeightLeastSquared
  extStdErrorData = getDataExternalStandardError()
  caseSampleReplicates = input$inputCaseSampleReplicates
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  
  answer = doGetCalibrationCurve_relativeStandardUncertainty(x,y,wlsSelectedValue,extStdErrorData,caseSampleReplicates,caseSampleMeanConcentration)
  return(answer)
})

getCalibrationCurve_degreesOfFreedom = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NA)
  x = data$calibrationDataConcentration
  
  answer = doGetCalibrationCurve_degreesOfFreedom(x)
  return(answer)
})


##############################################
# Get Numbers
##############################################
getCalibrationCurve_weightedLeastSquared = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  answer = doGetCalibrationCurve_weightedLeastSquared(x,y,input$inputWeightLeastSquared)
  return(answer)
})

getCalibrationCurve_intercept = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  weightedLeastSquared = getCalibrationCurve_weightedLeastSquared()
  
  answer = doGetCalibrationCurve_intercept(x,y,weightedLeastSquared)
  
  return(answer)
})

getCalibrationCurve_linearRegression = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  weightedLeastSquared = getCalibrationCurve_weightedLeastSquared()
  
  answer = doGetCalibrationCurve_linearRegression(x,y,weightedLeastSquared)
  return(answer)
})

getCalibrationCurve_rSquared = function(linearRegression)
{
  linearRegression = getCalibrationCurve_linearRegression()
  answer = doGetCalibrationCurve_rSquared(linearRegression)
  return(answer)
}

getCalibrationCurve_slope = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  
  weightedLeastSquared = getCalibrationCurve_weightedLeastSquared()
  
  answer = doGetCalibrationCurve_slope(x,y,weightedLeastSquared)
  
  return(answer)
})

getCalibrationCurve_n = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  y = data$calibrationDataPeakArea
  
  answer = doGetCalibrationCurve_n(y)
  
  return(answer)
})

getCalibrationCurve_sumOfX = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration

  answer = sum(x)
  
  return(answer)
})

getCalibrationCurve_sumOfWeightedX = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  weightedLeastSquared = getCalibrationCurve_weightedLeastSquared()
  
  answer = sum(weightedLeastSquared * x)
  
  return(answer)
})

getCalibrationCurve_meanOfX = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  answer = doGetCalibrationCurve_meanOfX(x,y,input$inputWeightLeastSquared)
  
  return(answer)
})

getCalibrationCurve_sumOfY = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  y = data$calibrationDataPeakArea
  
  answer = sum(y)
  
  return(answer)
})

getCalibrationCurve_sumOfWeightedY = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  y = data$calibrationDataPeakArea
  weightedLeastSquared = getCalibrationCurve_weightedLeastSquared()
  
  answer = sum(weightedLeastSquared * y)
  
  return(answer)
})

getCalibrationCurve_meanOfY = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  wlsSelectedOption = input$inputWeightLeastSquared
  
  answer = doGetCalibrationCurve_meanOfY(x,y,wlsSelectedOption)
  return(answer)
})

getCalibrationCurve_sumSqDeviationX = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  answer = doGetCalibrationCurve_sumSqDeviationX(x)
  
  return(answer)
})

getCalibrationCurve_sumOfWeightedXSquared = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  wlsSelectedOption = input$inputWeightLeastSquared
  
  answer = doGetCalibrationCurve_sumOfWeightedXSquared(x,y,wlsSelectedOption)
  return(answer)
})

getCalibrationCurve_errorSqDeviationY = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  weightedLeastSquared = getCalibrationCurve_weightedLeastSquared()
  
  answer = doGetCalibrationCurve_errorSqDeviationY(x,y,weightedLeastSquared)
  return(answer)
})

getCalibrationCurve_weightedErrorSqDeviationY = reactive({
  weightedLeastSquared = getCalibrationCurve_weightedLeastSquared()
  errorSqDevationY = getCalibrationCurve_errorSqDeviationY()
  
  answer = doGetCalibrationCurve_weightedErrorSqDeviationY(weightedLeastSquared,errorSqDevationY)
})

getCalibrationCurve_standardErrorOfRegression = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  weightedLeastSquared = getCalibrationCurve_weightedLeastSquared()
  
  answer = doGetCalibrationCurve_standardErrorOfRegression(x,y,weightedLeastSquared)
  return(answer)
})

getCalibrationCurve_peakAreaRatioOfCaseSample = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data))return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  wlsSelectedOption = input$inputWeightLeastSquared
  
  answer = doGetCalibrationCurve_peakAreaRatioOfCaseSample(x,y,caseSampleMeanConcentration,wlsSelectedOption)
  return(answer)
})

getCalibrationCurve_weightedCaseSampleDenominator = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  wlsSelectedOption = input$inputWeightLeastSquared
  
  answer = doGetCalibrationCurve_weightedCaseSampleDenominator(x,y,wlsSelectedOption,caseSampleMeanConcentration)
  return(answer)
})

getCalibrationCurve_weightedCaseSample = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  wlsSelectedOption = input$inputWeightLeastSquared
    
  answer = doGetCalibrationCurve_weightedCaseSample(x,y,caseSampleMeanConcentration,wlsSelectedOption)
  return(answer)
})

getCalibrationCurve_uncertaintyOfCalibration = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  extStdErrorData = getDataExternalStandardError()
  wlsSelectedOption = input$inputWeightLeastSquared
  caseSampleReplicates = input$inputCaseSampleReplicates
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  
  answer = doGetCalibrationCurve_uncertaintyOfCalibration(x,y,wlsSelectedOption,extStdErrorData, caseSampleReplicates, caseSampleMeanConcentration)
    
  return(answer)
})



################################################
# Display
################################################

getCalibrationCurve_wlsLatex = reactive({
  return(doGetCalibrationCurve_wlsLatex(input$inputWeightLeastSquared))
})


###################################################################################
# Outputs
###################################################################################
output$display_calibrationCurve_replicates = renderUI({
  string = paste(input$inputCaseSampleReplicates)
  return(string)
})

output$display_calibrationCurve_meanConcentration = renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$calibrationData = DT::renderDataTable(
  getDataCalibrationCurve(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)

output$rearrangedCalibrationData = DT::renderDataTable(
  sapply(getDataCalibrationCurveRearranged(), formatNumberForDisplay),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip', columnDefs = list(list(className = 'dt-right', targets = 0:5)))
)

output$uploadedCalibrationDataStats = renderUI({
  numberOfRuns = getCalibrationCurve_numberOfRuns()
  numberOfReplicates = getCalibrationCurve_numberOfReplicates()
  numberOfConcentrations = getCalibrationCurve_numberOfConcentrations()
  numberOfPeakAreaRatios = getCalibrationCurve_numberOfPeakAreaRatios()
  
  return(HTML(sprintf("Uploaded Calibration Data<br />Runs: %d | Reps: %d | Concentration Levels: %d | Peak Area Ratios: %d",numberOfRuns, numberOfReplicates, numberOfConcentrations, numberOfPeakAreaRatios)))
})

output$display_calibrationCurve_linearRegression = renderUI({
  intercept = formatNumberForDisplay(getCalibrationCurve_intercept())
  slope = formatNumberForDisplay(getCalibrationCurve_slope())
  rSquare = formatNumberForDisplay(getCalibrationCurve_rSquared())
  n = getCalibrationCurve_n()
  
  formulas = c(paste0("\\text{Intercept}(b_0) &=",intercept))
  formulas = c(formulas, paste0("\\text{Slope}(b_1) &= \\color{",color6,"}{",slope,"}"))
  formulas = c(formulas, paste0("R^2 &=",rSquare))
  formulas = c(formulas, paste0("n &= \\color{",color5,"}{",n,"}"))
  output = mathJaxAligned(formulas, 10)
  
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurve_meanOfX = renderUI({
  if(checkUsingWls()) return(NULL) #Don't display if we're using Weighted Least Square

  sumOfX = formatNumberForDisplay(getCalibrationCurve_sumOfX())
  n = getCalibrationCurve_n()
  answer = formatNumberForDisplay(getCalibrationCurve_meanOfX())
  
  formulas = c("\\overline{x} &= \\frac{\\sum{x_i}}{n}")
  formulas = c(formulas, paste("& = \\frac{",sumOfX,"}{",n,"}"))
  formulas = c(formulas, paste("&=\\color{",color1,"}{",answer),"}")
  output = mathJaxAligned(formulas, 5)
  
  box(title = "Mean of \\(x\\)", width = 3, withMathJax(HTML(output)))
})

output$display_calibrationCurve_weightedMeanOfX = renderUI({
  if(!checkUsingWls()) return(NULL) #Only display if we're using Weighted Least Square

  sumOfWeightedX = formatNumberForDisplay(getCalibrationCurve_sumOfWeightedX())
  n = getCalibrationCurve_n()
  answer = formatNumberForDisplay(getCalibrationCurve_meanOfX())
  
  formulas = c("\\overline{x}_w &= \\frac{\\sum{w_ix_i}}{n}")
  formulas = c(formulas, paste("& = \\frac{",sumOfWeightedX,"}{",n,"}"))
  formulas = c(formulas, paste("&=\\color{",color1,"}{",answer),"}")
  output = mathJaxAligned(formulas, 5)

  box(title = "Mean of Weighted \\(x\\)", width = 3, withMathJax(HTML(output)))
})

output$display_calibrationCurve_meanOfY = renderUI({
  if(checkUsingWls()) return(NULL) #Don't display if we're using Weighted Least Square
  
  sumOfY = formatNumberForDisplay(getCalibrationCurve_sumOfY())
  n = getCalibrationCurve_n()
  answer = formatNumberForDisplay(getCalibrationCurve_meanOfY())
  
  formulas = c("\\overline{y} &= \\frac{\\sum{y_i}}{n}")
  formulas = c(formulas, paste("& = \\frac{",sumOfY,"}{",n,"}"))
  formulas = c(formulas, paste("&=\\color{",color1,"}{",answer),"}")
  output = mathJaxAligned(formulas, 5)
  
  box(title = "Mean of \\(y\\)", width = 3, withMathJax(HTML(output)))
})

output$display_calibrationCurve_weightedMeanOfY = renderUI({
  if(!checkUsingWls()) return(NULL) #Only display if we're using Weighted Least Square

  sumOfWeightedY = formatNumberForDisplay(getCalibrationCurve_sumOfWeightedY())
  n = getCalibrationCurve_n()
  answer = formatNumberForDisplay(getCalibrationCurve_meanOfY())
  
  formulas = c("\\overline{y}_w &= \\frac{\\sum{w_iy_i}}{n}")
  formulas = c(formulas, paste("& = \\frac{",sumOfWeightedY,"}{",n,"}"))
  formulas = c(formulas, paste("&=\\color{",color1,"}{",answer),"}")
  output = mathJaxAligned(formulas, 5)
  
  box(title = "Mean of Weighted \\(y\\)", width = 3, withMathJax(HTML(output)))
})

output$display_calibrationCurve_sumOfSquaredDeviationOfX = renderUI({
  if(checkUsingWls()) return(NULL) #Don't display if we're using Weighted Least Square
    
  answer = formatNumberForDisplay(getCalibrationCurve_sumSqDeviationX())
  
  formulas = c("S_{xx} &= \\sum\\limits_{i=1}^n(x_i - \\overline{x})^2")
  formulas = c(formulas, paste("&=\\color{",color2,"}{",answer,"}"))
  output = mathJaxAligned(formulas, 5)
  
  box(title = "Sum of Squared Deviation of \\(x\\)",
      width = 3,
      withMathJax(HTML(output))
      )
})

output$display_calibrationCurve_sumOfWeightedXSquared = renderUI({
  if(!checkUsingWls()) return(NULL) #Only display if we're using Weighted Least Square
    
  data = getDataCalibrationCurveReformatted()
  y = data$calibrationDataPeakArea
  x = data$calibrationDataConcentration
  
  answer = formatNumberForDisplay(getCalibrationCurve_sumOfWeightedXSquared())
  
  formulas = c(paste("\\sum{w_ix_i^2} = \\color{",color2,"}{",answer,"}"))
  output = mathJaxAligned(formulas, 5)
  
  box(title = "Sum of \\(wx^2\\)",
      width = 3,
      withMathJax(HTML(output))
  )
})

output$display_calibrationCurve_errorSumSqY = renderUI({
  errorSqDeviationY = getCalibrationCurve_errorSqDeviationY()
  if(checkUsingWls())
  {
    errorSqDeviationY = getCalibrationCurve_weightedErrorSqDeviationY()
  }
  answer = formatNumberForDisplay(sum(errorSqDeviationY))

  
  formulas = c(paste("S_{y\\hat{y}} &=\\sum\\limits_{i=1}^n",if(checkUsingWls())"w_i","(y_i-\\hat{y}_i)^2"))
  formulas = c(formulas, paste("&=\\color{",color3,"}{",answer,"}"))
  output = mathJaxAligned(formulas, 5)
  
  return(withMathJax(HTML(output)))
})

output$standardErrorOfRegression = renderUI({
  n = getCalibrationCurve_n()

  errorSqDeviationY = getCalibrationCurve_errorSqDeviationY()
  if(checkUsingWls())
  {
    errorSqDeviationY = getCalibrationCurve_weightedErrorSqDeviationY()
  }
  sumErrorSqDeviationY = formatNumberForDisplay(sum(errorSqDeviationY))
  
  answer = formatNumberForDisplay(getCalibrationCurve_standardErrorOfRegression())
  
  formulas = c(paste("S_{",if(checkUsingWls())"w"else"y/x","} &= \\sqrt{\\frac{\\sum\\limits_{i=1}^n",if(checkUsingWls())"w_i","(y_i-\\hat{y}_i)^2}{n-2}}","[[break]]"))
  formulas = c(formulas, paste("S_{",if(checkUsingWls())"w"else"y/x","} &= \\sqrt{\\frac{\\color{",color3,"}{",sumErrorSqDeviationY,"}}{\\color{",color5,"}{",n,"}-2}}"))
  formulas = c(formulas, paste("&=\\color{",color4,"}{",answer,"}"))
  output = mathJaxAligned(formulas, 5, 20)
  
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurve_peakAreaRatioOfCaseSample = renderUI({
  if(!checkUsingWls()) return(NULL)
    
  intercept = formatNumberForDisplay(getCalibrationCurve_intercept())
  slope = formatNumberForDisplay(getCalibrationCurve_slope())
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  answer = formatNumberForDisplay(getCalibrationCurve_peakAreaRatioOfCaseSample())
  
  formulas = c("y_s &= b_0 + b_1x_s")
  formulas = c(formulas, paste("&= ",intercept," + ",slope,"\\times",caseSampleMeanConcentration))
  formulas = c(formulas, paste("&= ",answer))
  output = mathJaxAligned(formulas, 5, 20)
  
  box(width=3,
      title = "Peak Area Ratio of Case Sample",
      output
  )
})

output$display_calibrationCurve_weightedCaseSample = renderUI({
  if(!checkUsingWls()) return(NULL)
    
  wlsSelectedOption = input$inputWeightLeastSquared
  
  weightedCaseSampleDenominator = formatNumberForDisplay(getCalibrationCurve_weightedCaseSampleDenominator())
  answer = formatNumberForDisplay(getCalibrationCurve_weightedCaseSample())
  
  formulas = c(paste("w_s &=", getCalibrationCurve_wlsLatex()))
  
  #If we're using a squared demoniator then add a squared sign
  if(wlsSelectedOption == 3 | wlsSelectedOption == 5)
    formulas = c(formulas, paste("&= \\frac{1}{",weightedCaseSampleDenominator,"^2}"))
  else
    formulas = c(formulas, paste("&= \\frac{1}{",weightedCaseSampleDenominator,"}"))
  
  formulas = c(formulas, paste("&=",answer))
  output = mathJaxAligned(formulas, 5, 20)
  
  box(width=3,
      title = "Weight used for Case Sample",
      output
  )
})

output$display_calibrationCurve_uncertaintyOfCalibration = renderUI({
  data = getDataCalibrationCurveReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  weightedLeastSquared = getCalibrationCurve_weightedLeastSquared()
  
  exStdErrData = getDataExternalStandardError()

  stdErrorOfRegression = 0
  if(is.null(exStdErrData))
  {
    stdErrorOfRegression = doGetCalibrationCurve_standardErrorOfRegression(x,y,weightedLeastSquared)
  }
  else
  {
    stdErrorOfRegression = doGetCalibrationCurve_pooledStdErrorOfRegression(x,y,weightedLeastSquared,exStdErrData)
  }
  stdErrorOfRegression = formatNumberForDisplay(stdErrorOfRegression)
  
  slope = formatNumberForDisplay(getCalibrationCurve_slope())
  caseSampleReps = input$inputCaseSampleReplicates
  n = getCalibrationCurve_n()
  caseSampleMeanConc = input$inputCaseSampleMeanConcentration
  meanX = formatNumberForDisplay(getCalibrationCurve_meanOfX())
  sumSqDevationX = formatNumberForDisplay(getCalibrationCurve_sumSqDeviationX())
  
  weightedCaseSample = formatNumberForDisplay(getCalibrationCurve_weightedCaseSample())
  peakAreaRatioOfCaseSample = formatNumberForDisplay(getCalibrationCurve_peakAreaRatioOfCaseSample())
  calCurveMeanOfY = formatNumberForDisplay(getCalibrationCurve_meanOfY())
  sumOfWeightedXSquared = formatNumberForDisplay(getCalibrationCurve_sumOfWeightedXSquared())

  answer = formatNumberForDisplay(getCalibrationCurve_uncertaintyOfCalibration())
  
  if(is.null(exStdErrData))
  {
    if(checkUsingWls())
      formulas = c("u\\text{(CalCurve)} &= \\frac{S_{w}}{b_1} \\sqrt{\\frac{1}{w_{s}} + \\frac{1}{n} + \\frac{(y_s - \\overline{y_w})^2}{b_1^2[\\sum{wx^2-n(\\overline{x}_w)^2}]} } [[break]]")
    else
      formulas = c("u\\text{(CalCurve)} &= \\frac{S_{y/x}}{b_1} \\sqrt{\\frac{1}{r_s} + \\frac{1}{n} + \\frac{(x_s - \\overline{x})^2}{S_{xx}} } [[break]]")
  }
  else
  {
    if(checkUsingWls())
      formulas = c("u\\text{(CalCurve)} &= \\frac{S_{w_{p}}}{b_1} \\sqrt{\\frac{1}{w_{s}} + \\frac{1}{n} + \\frac{(y_s - \\overline{y_w})^2}{b_1^2[\\sum{wx^2-n(\\overline{x}_w)^2}]} } [[break]]")
    else
      formulas = c("u\\text{(CalCurve)} &= \\frac{S_{p_{y/x}}}{b_1} \\sqrt{\\frac{1}{r_s} + \\frac{1}{n} + \\frac{(x_s - \\overline{x})^2}{S_{xx}} } [[break]]")
  }
  
  if(!checkUsingWls())
  {
    formulas = c(formulas, paste("u\\text{(CalCurve)}&=\\frac{\\color{",color4,"}{",stdErrorOfRegression,"}}{\\color{",color6,"}{",slope,"}} \\sqrt{\\frac{1}{\\bbox[#00C0EF,2pt]{\\color{#FFF}{",caseSampleReps,"}}} + \\frac{1}{\\color{",color5,"}{",n,"}} + \\frac{(\\bbox[#F012BE,2pt]{\\color{#FFF}{",caseSampleMeanConc,"}} - \\color{",color1,"}{",meanX,"})^2}{\\color{",color2,"}{",sumSqDevationX,"}} }"))
  }
  else
  {
    formulas = c(formulas, paste("u\\text{(CalCurve)}&=\\frac{\\color{",color4,"}{",stdErrorOfRegression,"}}{\\color{",color6,"}{",slope,"}} \\sqrt{\\frac{1}{\\bbox[#00C0EF,2pt]{\\color{#FFF}{",weightedCaseSample,"}}} + \\frac{1}{\\color{",color5,"}{",n,"}} + \\frac{(\\bbox[#F012BE,2pt]{\\color{#FFF}{",peakAreaRatioOfCaseSample,"}} - \\color{",color1,"}{",calCurveMeanOfY,"})^2}{",slope,"^2[",sumOfWeightedXSquared,"-",n,"\\times",meanX,"^2]}}"))
  }
  
  
  formulas = c(formulas, paste("&=",answer))
  output = mathJaxAligned(formulas, 5, 20)
  
  return(withMathJax(HTML(output)))
})


output$peakAreaRatios = renderPlotly({
  data = getDataCalibrationCurveReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea

  slope = formatNumberForDisplay(getCalibrationCurve_slope())
  intercept = formatNumberForDisplay(getCalibrationCurve_intercept())

  linearRegression = getCalibrationCurve_linearRegression()
  
  plot_ly(x = x, y = y, name='Peak Area Ratios', type = 'scatter', mode='markers') %>%
    add_lines(x = x, y = fitted(linearRegression), name="Calibration Curve") %>%
    layout(xaxis = list(title="Concentration"), yaxis = list(title="Peak Area Ratio")) %>%
    add_annotations(x= 0.5,y= 0.8,xref="paper",yref="paper",text=paste0("$y = ",intercept,"+",slope,"x$"),showarrow = F)    
})

output$display_calibrationCurve_externalStandardErrorUploadedData = renderUI({
  exStdErrorData = getDataExternalStandardError()
  if(is.null(exStdErrorData))
    return(NULL)
  
  numberOfRuns = dim(exStdErrorData)[2]-1 #get the number of columns and minus 1 (because one column in the concentration)
  numberOfReplicates = max(table(exStdErrorData["conc"])) #count the number of occurances of each value in the concentration column, then get the max value (because some might be missing some)
  concentrationLevels = length(table(exStdErrorData["conc"])) #table the concentration column and count the length
  
  #To get the total number of peak areas we want to get just the runs
  exStdErrorRunData = exStdErrorData
  exStdErrorRunData$conc = NULL #so remove the conc column
  lengths = apply(exStdErrorRunData, 2, doGetCalibrationCurve_n) #then count all the runs lengths
  numberOfPeakAreaRatios = sum(lengths) #and add them together
                   
  boxTitle = HTML(sprintf("External Calibration Curve Data<br />Runs: %d | Reps: %d | Concentration Levels: %d | Peak Area Ratios: %d",numberOfRuns,numberOfReplicates,concentrationLevels,numberOfPeakAreaRatios))
  
  tabBox(width=12, side="right",
         title = boxTitle,
         tabPanel("Raw Data",
                  DT::renderDataTable(
                    getDataExternalStandardError(),
                    rownames = FALSE,
                    options = list(scrollX = TRUE, dom = 'tip')
                  )
         )
  )
})

output$display_calibrationCurve_externalStandardErrorOfRuns = renderUI({
  exStdErrorData = getDataExternalStandardError()
  if(is.null(exStdErrorData))
    return(NULL)
  
  exStdErrorRunData = exStdErrorData
  exStdErrorRunData$conc = NULL
  
  runNames = colnames(exStdErrorRunData)
  lengths = apply(exStdErrorRunData, 2, doGetCalibrationCurve_n)
  results = c()

  for(i in runNames)
  {
    weightedLeastSquared = doGetCalibrationCurve_weightedLeastSquared(exStdErrorData$conc,exStdErrorRunData[,i],input$inputWeightLeastSquared)
    seor = doGetCalibrationCurve_standardErrorOfRegression(exStdErrorData$conc,exStdErrorRunData[,i],weightedLeastSquared)
    results = c(results, formatNumberForDisplay(seor))
  }

  formulas = c(paste("S_{{",if(checkUsingWls())"w"else"y/x","}_{(j)}} &= \\sqrt{\\frac{\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2}{n_{(j)}-2}} [[break]]"))

  for(i in 1:length(results))
  {
    formulas = c(formulas, paste0("S_{{",if(checkUsingWls())"w"else"y/x","}_{(\\text{",runNames[i],"})}}&=", results[i], " \\hspace{15pt} n_{(\\text{",runNames[i],"})} = ", lengths[i]))
  }
  
  output = mathJaxAligned(formulas, 5, 20)
  
  box(title=paste("Standard Error of Regression (External Calibration Data) \\((S_{{",if(checkUsingWls())"w"else"y/x","}_{(j)}})\\)"), width = 5, withMathJax(HTML(output)))
})

output$display_calibrationCurve_externalStandardErrorOfRunsPooled = renderUI({
  exStdErrorData = getDataExternalStandardError()
  if(is.null(exStdErrorData))
    return(NULL)
  
  data = getDataCalibrationCurveReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  weightedLeastSquared = getCalibrationCurve_weightedLeastSquared()
  
  answer = formatNumberForDisplay(doGetCalibrationCurve_pooledStdErrorOfRegression(x,y,weightedLeastSquared,exStdErrorData))
  
  formulas = c(paste("S_{",if(checkUsingWls())"w_{(p)}"else"p_{(x/y)}","} &= \\sqrt{\\frac{\\sum{(n-1)S^2_{",if(checkUsingWls())"w"else"y/x","}}}{\\sum{(n-1)}}} [[break]]"))
  formulas = c(formulas, paste("S_{",if(checkUsingWls())"w_{(p)}"else"p_{(x/y)}","} &= \\sqrt{\\frac{(n-1)S^2_{",if(checkUsingWls())"w"else"y/x","} + \\sum{(n_{(j)}-1)S^2_{",if(checkUsingWls())"w"else"y/x","_{(j)}}}}{(n-1) + \\sum{(n_{(j)}-1)}}} [[break]]"))
  
  exStdErrorRunData = exStdErrorData
  exStdErrorRunData$conc = NULL
  
  results = list()
  for(i in colnames(exStdErrorRunData))
  {
    weightedLeastSquared = doGetCalibrationCurve_weightedLeastSquared(exStdErrorData$conc,exStdErrorRunData[,i],input$inputWeightLeastSquared)
    seor = doGetCalibrationCurve_standardErrorOfRegression(exStdErrorData$conc,exStdErrorRunData[,i],weightedLeastSquared)
    
    df = data.frame(seor)
    names(df) = i
    results = c(results, df)
  }
  
  results = unlist(results)
  lengths = unlist(apply(exStdErrorRunData, 2, doGetCalibrationCurve_n), use.names = FALSE)
  
  n1 = doGetCalibrationCurve_n(y)
  n2 = lengths[1]
  n3 = lengths[length(results)]
  
  s1 = formatNumberForDisplay(doGetCalibrationCurve_standardErrorOfRegression(x,y,weightedLeastSquared))
  s2 = formatNumberForDisplay(results[1])
  s3 = formatNumberForDisplay(results[length(results)])
  
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
 
  box(title=paste("Pooled Standard Error of Regression (External Calibration Data) \\((S_{",if(checkUsingWls())"w_{(p)}"else"p_{(x/y)}","})\\)"), width = 7,withMathJax(HTML(output)))
})
  
output$display_calibrationCurve_finalAnswer_top = renderText({
  return(paste("\\(u_r\\text{(CalCurve)}=\\)",getResultCalibrationCurve()))
})

output$display_calibrationCurve_finalAnswer_bottom = renderUI({
  uncertaintyOfCalibration = formatNumberForDisplay(getCalibrationCurve_uncertaintyOfCalibration())
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  answer = formatNumberForDisplay(getResultCalibrationCurve())
  
  formulas = c("u_r\\text{(CalCurve)} &= \\frac{\\text{Uncertatiny of Calibration}}{\\text{Case Sample Mean Concentration}} [[break]]")
  formulas = c(formulas, "u_r\\text{(CalCurve)} &= \\frac{u\\text{(CalCurve)}}{x_s}")
  formulas = c(formulas, paste("&=\\frac{",uncertaintyOfCalibration,"}{\\bbox[#F012BE,2pt]{",caseSampleMeanConcentration,"}}"))
  formulas = c(formulas, paste("&=",answer))
  
  output = mathJaxAligned(formulas, 5, 20)
  
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurve_finalAnswer_dashboard = renderUI({
  return(paste("\\(u_r\\text{(CalCurve)}=\\)",getResultCalibrationCurve()))
})

output$display_calibrationCurve_finalAnswer_combinedUncertainty = renderUI({
  return(paste(getResultCalibrationCurve()))
})

output$display_calibrationCurve_finalAnswer_coverageFactor = renderUI({
  return(paste(getResultCalibrationCurve()))
})