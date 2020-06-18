doCheckUsingWls = function(wlsSelectedOption)
{
  if(wlsSelectedOption == 1)
  {
    return(FALSE)
  }
  return(TRUE)
}
doCheckMeanPeakAreaRatioSpecified = function(specifiedPeakAreaRatio)
{
  if(is.na(specifiedPeakAreaRatio))
  {
    return(FALSE)
  }
  return(TRUE)
}
doGetCalibrationCurve_intercept = function(x,y,wlsValues){
  linearRegerssion = doGetCalibrationCurve_linearRegression(x,y,wlsValues)
  intercept = coef(linearRegerssion)[1]
  #remove naming to get single number
  intercept = unname(intercept)
  return(intercept)
}

doGetCalibrationCurve_slope = function(x,y,wlsValues){
  linearRegerssion = doGetCalibrationCurve_linearRegression(x,y,wlsValues)
  slope = coef(linearRegerssion)[2];
  #remove naming to get single number
  slope = unname(slope)
  return(slope)
}

doGetCalibrationCurve_linearRegression = function(x,y,wlsValues)
{
  linearRegerssion = lm(y~x, na.action = na.omit, weights = wlsValues)
  return(linearRegerssion)
}

doGetCalibrationCurve_rSquared = function(linearRegression)
{
  rSquare = summary.lm(linearRegression)$r.squared
}

doGetCalibrationCurve_n = function(values)
{
  if(is.null(values)) return(NULL)

  n = length(values[!is.na(values)])
  return(n)
}

doGetCalibrationCurve_meanOfX = function(x,y,wlsSelectedOption){
  if(is.null(x) | is.null(y)) return(NA)
  
  meanOfX = 0
  if(doCheckUsingWls(wlsSelectedOption))
  {
    weightedLeastSquared = doGetCalibrationCurve_weightedLeastSquared(x,y,wlsSelectedOption)
    n = doGetCalibrationCurve_n(y)
    standardisedWeights = doGetCalibrationCurve_standardisedWeight(weightedLeastSquared, n)
    wx = standardisedWeights * x
    meanOfX = mean(wx)
  }
  else
  {
    meanOfX = mean(x)
  }
  return(meanOfX)
}

doGetCalibrationCurve_meanOfY = function(x,y,wlsSelectedOption){
  if(is.null(x) | is.null(y)) return(NA)
  
  meanOfY = 0
  if(doCheckUsingWls(wlsSelectedOption))
  {
    weightedLeastSquared = doGetCalibrationCurve_weightedLeastSquared(x,y,wlsSelectedOption)
    n = doGetCalibrationCurve_n(y)
    standardisedWeights = doGetCalibrationCurve_standardisedWeight(weightedLeastSquared, n)
    wy = standardisedWeights * y
    meanOfY = mean(wy)
  }
  else
  {
    meanOfY = mean(y)
  }
  
  return(meanOfY)
}

doGetCalibrationCurve_sumSqDeviationX = function(x)
{
  answer = sum(doGetCalibrationCurve_sqDeviation(x))
  return(answer)
}

doGetCalibrationCurve_sqDeviation = function(values){
  sqDevation = (values - mean(values))^2
  return(sqDevation)
}

doGetCalibrationCurve_sumOfWeightedXSquared = function(x,y,wlsSelectedOption){
  if(is.null(x) | is.null(y)) return(NA)
  
  n = doGetCalibrationCurve_n(y)
  weightedLeastSquared = doGetCalibrationCurve_weightedLeastSquared(x,y,wlsSelectedOption)
  standardisedWeight = doGetCalibrationCurve_standardisedWeight(weightedLeastSquared, n)
  weightedXSquared = doGetCalibrationCurve_weightedXSquared(standardisedWeight,x)
  
  answer = sum(weightedXSquared)
  return(answer)
}

doGetCalibrationCurve_errorSqDeviationY = function(x,y,wlsValues){
  errorSqDeviationY = (na.omit(y) - doGetCalibrationCurve_predicetedY(x,y,wlsValues))^2
  return (errorSqDeviationY)
}

doGetCalibrationCurve_predicetedY = function(x,y,wlsValues){
  calCurve = doGetCalibrationCurve_linearRegression(x,y,wlsValues) # Regression Cofficients
  predictedY = fitted(calCurve)
  #remove naming for vector of numbers
  predictedY = unname(predictedY)
  return(predictedY)
}

doGetCalibrationCurve_weightedErrorSqDeviationY = function(wlsValues,errorSqDeviationY)
{
  return(wlsValues * errorSqDeviationY)
}

doGetCalibrationCurve_weightedXSquared = function(wlsValues,x)
{
  return(wlsValues * x^2)
}

doGetCalibrationCurve_standardErrorOfRegression = function(x,y,wlsValues){
  linearRegression = doGetCalibrationCurve_linearRegression(x,y,wlsValues)
  standardErrorOfRegression = summary.lm(linearRegression)$sigma
  return(standardErrorOfRegression)
}

doGetCalibrationCurve_weightedCaseSampleDenominator = function(x,y,wlsSelectedOption,caseSampleMeanConcentration,caseSampleMeanPar)
{
  if(wlsSelectedOption == 1)
  {
    return(1)
  }
  else if(wlsSelectedOption == 2 | wlsSelectedOption == 3)
  {
    return(caseSampleMeanConcentration)
  }
  else(wlsSelectedOption == 4 | wlsSelectedOption == 5)
  {
    return(caseSampleMeanPar)
  }
}

doGetCalibrationCurve_weightedCaseSample = function(x,y,caseSampleMeanConcentration,wlsSelectedOption,caseSampleMeanPar){
  
  answer = doGetCalibrationCurve_weightedLeastSquared(caseSampleMeanConcentration,caseSampleMeanPar,wlsSelectedOption)
  
  return(answer)
}
  
doGetCalibrationCurve_degreesOfFreedom = function(values){
  if(is.null(values)) return(NULL)
  degressOfFreedom = doGetCalibrationCurve_n(values)-2
  return(degressOfFreedom)
}

doGetCalibrationCurve_weightedLeastSquared = function(x,y,wlsSelectedOption){
  wlsFunction = doGetCalibrationCurve_weightedLeastSquaredFunction(wlsSelectedOption)
  
  if(wlsSelectedOption == 1)
  {
    return(rep(1,length(x)))
  }
  else if(wlsSelectedOption == 2 | wlsSelectedOption == 3)
  {
    return(wlsFunction(x))
  }
  else if(wlsSelectedOption == 4 | wlsSelectedOption == 5)
  {
    return(wlsFunction(y))
  }
  else
  {
    return(NULL)
  }
}

doGetCalibrationCurve_standardisedWeight = function(wls, n){
  answer = wls * (n/sum(wls))
  return(answer)
}

doGetCalibrationCurve_weightedLeastSquaredFunction = function(wlsSelectedOption){
  if(wlsSelectedOption == 1)
  {
    wlsFunc = function(value){
      return(value)
    }
    return(wlsFunc)
  }
  else if(wlsSelectedOption == 2 | wlsSelectedOption == 4 | wlsSelectedOption == 6)
  {
    wlsFunc = function(value){
      return(1/(value))
    }
    return(wlsFunc)
  }
  else if(wlsSelectedOption == 3 | wlsSelectedOption == 5 | wlsSelectedOption == 7)
  {
    wlsFunc = function(value){
      return(1/value^2)
    }
    return(wlsFunc)
  }
  else{
    return(NULL)
  }
}

doGetCalibrationCurve_wlsLatex = function(wlsSelectedOption){
  if(wlsSelectedOption == 1)
    return("W=1")
  
  if(wlsSelectedOption == 2)
    return("W=\\frac{1}{x}")
  
  if(wlsSelectedOption == 3)
    return("W=\\frac{1}{x^2}")
  
  if(wlsSelectedOption == 4)
    return("W=\\frac{1}{y}")
  
  if(wlsSelectedOption == 5)
    return("W=\\frac{1}{y^2}")
  
  return("")
}

doGetCalibrationCurve_uncertaintyOfCalibration = function(x,y,wlsSelectedOption,caseSampleMeanPar,extStdErrorData, caseSampleReplicates, caseSampleMeanConcentration)
{
  wlsValues = doGetCalibrationCurve_weightedLeastSquared(x,y,wlsSelectedOption)
  
  syx = 0
  if(is.null(extStdErrorData))
  {
    syx = doGetCalibrationCurve_standardErrorOfRegression(x,y,wlsValues)
  }
  else
  {
    syx = doGetCalibrationCurve_pooledStdErrorOfRegression(x,y,wlsValues,extStdErrorData)
  }
  
  weightedCaseSample = doGetCalibrationCurve_weightedCaseSample(x,y,caseSampleMeanConcentration,wlsSelectedOption,caseSampleMeanPar)
  peakAreaRatioOfCaseSample = caseSampleMeanPar
  calCurveMeanOfY = getCalibrationCurve_meanOfY()
  sumOfWeightedXSquared = getCalibrationCurve_sumOfWeightedXSquared()
  meanOfX = getCalibrationCurve_meanOfX()
  sumSqDeviationX = doGetCalibrationCurve_sumSqDeviationX(x)
  slope = getCalibrationCurve_slope()
  n = getCalibrationCurve_n()
  
  uncertaintyOfCalibration = 0
  if(doCheckUsingWls(wlsSelectedOption))
  {
    uncertaintyOfCalibration = (syx / slope) * (sqrt((1/(weightedCaseSample*caseSampleReplicates))+(1/n)+((peakAreaRatioOfCaseSample-calCurveMeanOfY)^2 / (slope^2*(sumOfWeightedXSquared-n*meanOfX^2)))))
  }
  else
  {
    uncertaintyOfCalibration = (syx / slope) * (sqrt((1/caseSampleReplicates)+(1/n)+((caseSampleMeanConcentration-meanOfX)^2 / sumSqDeviationX)))
  }
  
  return(uncertaintyOfCalibration)
}

doGetCalibrationCurve_pooledStdErrorOfRegression = function(x,y,wlsValues,exStdErrData){
  exStdErrRunData = exStdErrData
  exStdErrRunData$conc = NULL
  
  results = list()
  for(i in colnames(exStdErrRunData))
  {
    weightedLeastSquared = doGetCalibrationCurve_weightedLeastSquared(exStdErrData$conc,exStdErrRunData[,i],input$inputWeightLeastSquared)
    seor = doGetCalibrationCurve_standardErrorOfRegression(exStdErrData$conc,exStdErrRunData[,i],weightedLeastSquared)
    
    answer = data.frame(seor)
    names(answer) = i
    results = c(results, answer)
  }
  
  results = unlist(results)
  lengths = unlist(apply(exStdErrRunData, 2, doGetCalibrationCurve_n), use.names = FALSE)
  
  numeratorExternalDataSum = sum((results ^ 2) * (lengths -1))
  numeratorSum = (doGetCalibrationCurve_standardErrorOfRegression(x,y,wlsValues)^2) * (doGetCalibrationCurve_n(y) - 1)
  numerator = numeratorExternalDataSum + numeratorSum 
  
  demoninatorExternalDataSum = sum(lengths - 1)
  demoninatorSum = doGetCalibrationCurve_n(y) - 1
  demoninator = demoninatorExternalDataSum + demoninatorSum
  
  answer = sqrt(numerator/demoninator)
  
  return(answer)
}

doGetCalibrationCurve_relativeStandardUncertainty = function(x,y,wlsSelectedOption,specifiedPeakAreaRatio,extStdErrorData,caseSampleReplicates,caseSampleMeanConcentration){
  uncertaintyOfCalibration = doGetCalibrationCurve_uncertaintyOfCalibration(x,y,wlsSelectedOption,specifiedPeakAreaRatio,extStdErrorData, caseSampleReplicates, caseSampleMeanConcentration)
  answer = uncertaintyOfCalibration / caseSampleMeanConcentration
  return(answer)
}