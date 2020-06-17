##############################################
# Checkers
##############################################
checkUsingWls = reactive({
  wlsSelectedOption = input$inputWeightLeastSquared
  result = doCheckUsingWls(wlsSelectedOption)
  return(result)
})

checkMeanPeakAreaRatioSpecified = reactive({
  specifiedPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  result = doCheckMeanPeakAreaRatioSpecified(specifiedPeakAreaRatio)
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
  
  #standardised weight
  standardisedWeight = getCalibrationCurve_standardisedWeight()
  
  #Get Weight
  wx = standardisedWeight * x
  wy = standardisedWeight * y
  
  ### Predicted Y value is the regression cofficient of Y compared to X
  predictedY = doGetCalibrationCurve_predicetedY(x,y, standardisedWeight);
  
  ### Get error Sum Squared of y
  errorSqDevationY = doGetCalibrationCurve_errorSqDeviationY(x,y,standardisedWeight);
  weightedErrorSqDevationY = doGetCalibrationCurve_weightedErrorSqDeviationY(standardisedWeight,errorSqDevationY)
  
  weightedXSquared = doGetCalibrationCurve_weightedXSquared(standardisedWeight,x)
  
  ##Get data in dataframe
  rearrangedCalibrationDataFrame = data.frame(getDataCalibrationCurveReformatted()$runNames,x,y,weightedLeastSquared,standardisedWeight,wx,wy,weightedXSquared,sqDevationX,predictedY,errorSqDevationY,weightedErrorSqDevationY)
  colnames(rearrangedCalibrationDataFrame) = c("$$\\text{Run}$$","$$\\text{Concentration} (x)$$","$$\\text{Peak Area} (y)$$",paste("$$\\text{Weight}(",doGetCalibrationCurve_wlsLatex(input$inputWeightLeastSquared),")$$"),"$$w_i=W_i(\\frac{n}{\\sum{W_i}})$$","$$w_ix_i$$","$$w_iy_i$$","$$wx^2$$","$$\\text{Sq. Deviation} (x_i-\\overline{x})^2$$","$$\\hat{y}_i = b_0 + b_1x_i$$","$$(y_i - \\hat{y}_i)^2$$","$$w_i(y_i - \\hat{y}_i)^2$$")
  
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
  specifiedPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  extStdErrorData = getDataExternalStandardError()
  caseSampleReplicates = input$inputCaseSampleReplicates
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  
  answer = doGetCalibrationCurve_relativeStandardUncertainty(x,y,wlsSelectedValue,specifiedPeakAreaRatio,extStdErrorData,caseSampleReplicates,caseSampleMeanConcentration)
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

getCalibrationCurve_standardisedWeight = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  wls = getCalibrationCurve_weightedLeastSquared()
  n = getCalibrationCurve_n()
  
  answer = doGetCalibrationCurve_standardisedWeight(wls, n)
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

  standarisedWeight = getCalibrationCurve_standardisedWeight()
  
  answer = doGetCalibrationCurve_slope(x,y,standarisedWeight)
  
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
  standardisedWeight = getCalibrationCurve_standardisedWeight()
  
  answer = sum(standardisedWeight * x)
  
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
  standardisedWeight = getCalibrationCurve_standardisedWeight()
  
  answer = sum(standardisedWeight * y)
  
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
  standardisedWeight = getCalibrationCurve_standardisedWeight()
  errorSqDevationY = getCalibrationCurve_errorSqDeviationY()
  
  answer = doGetCalibrationCurve_weightedErrorSqDeviationY(standardisedWeight,errorSqDevationY)
})

getCalibrationCurve_standardErrorOfRegression = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  standardisedWeights = getCalibrationCurve_standardisedWeight()
  
  answer = doGetCalibrationCurve_standardErrorOfRegression(x,y,standardisedWeights)
  return(answer)
})

# getCalibrationCurve_peakAreaRatioOfCaseSample = reactive({
#   data = getDataCalibrationCurveReformatted()
#   if(is.null(data))return(NULL)
#   
#   x = data$calibrationDataConcentration
#   y = data$calibrationDataPeakArea
#   caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
#   wlsSelectedOption = input$inputWeightLeastSquared
#   specifiedPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
#   
#   answer = doGetCalibrationCurve_peakAreaRatioOfCaseSample(x,y,caseSampleMeanConcentration,wlsSelectedOption,specifiedPeakAreaRatio)
#   return(answer)
# })

getCalibrationCurve_weightedCaseSampleDenominator = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  wlsSelectedOption = input$inputWeightLeastSquared
  specifiedPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  
  answer = doGetCalibrationCurve_weightedCaseSampleDenominator(x,y,wlsSelectedOption,caseSampleMeanConcentration,specifiedPeakAreaRatio)
  return(answer)
})

getCalibrationCurve_weightedCaseSample = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  wlsSelectedOption = input$inputWeightLeastSquared
  specifiedPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  
  answer = doGetCalibrationCurve_weightedCaseSample(x,y,caseSampleMeanConcentration,wlsSelectedOption,specifiedPeakAreaRatio)
  return(answer)
})

getCalibrationCurve_uncertaintyOfCalibration = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  extStdErrorData = getDataExternalStandardError()
  wlsSelectedOption = input$inputWeightLeastSquared
  specifiedPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  caseSampleReplicates = input$inputCaseSampleReplicates
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  
  answer = doGetCalibrationCurve_uncertaintyOfCalibration(x,y,wlsSelectedOption,specifiedPeakAreaRatio,extStdErrorData, caseSampleReplicates, caseSampleMeanConcentration)
  
  return(answer)
})



################################################
# Display
################################################

getCalibrationCurve_wlsLatex = reactive({
  return(doGetCalibrationCurve_wlsLatex(input$inputWeightLeastSquared))
})