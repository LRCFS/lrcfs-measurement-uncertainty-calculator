###########################################################################
#
# Measurement Uncertainty Calculator - Copyright (C) 2019
# Leverhulme Research Centre for Forensic Science
# Roy Mudie, Joyce Klu, Niamh Nic Daeid
# Website: https://github.com/LRCFS/lrcfs-measurement-uncertainty-calculator/
# Contact: lrc@dundee.ac.uk
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
###########################################################################

doGetDataCalibrationCurve = function(filePath)
{
  if(is.null(filePath))
  {
    return(NULL)
  }
  
  data = calibrationCurveReadCSV(filePath)
  return(data)
}

doGetDataCalibrationCurveReformatted = function(data)
{
  if(is.null(data))
  {
    return(NULL)
  }
  numConc = nrow(data)
  numRuns = ncol(data)-1
  
  ## Set x = concentration and y = peak area ratios
  runNames = rep(colnames(data)[-1], each=numConc)
  calibrationDataConcentration = rep(data$conc,numRuns)
  
  data = data[,-1]
  calibrationDataPeakArea = unlist(c(data), use.names = FALSE)
  
  allData = data.frame(runNames, calibrationDataConcentration, calibrationDataPeakArea)
  colnames(allData) = c("runNames","calibrationDataConcentration","calibrationDataPeakArea")
  
  #Remove any data with NA entries
  allDataNaRemoved = allData[!is.na(allData$calibrationDataPeakArea),]
  
  return(allDataNaRemoved)
}

doCheckUsingWls = function(wlsSelectedOption)
{
  if(wlsSelectedOption == 1)
  {
    return(FALSE)
  }
  return(TRUE)
}
doCheckNeedPeakAreaRatio = function(wlsSelectedOption, usingCalibartionCurveQuadratic)
{
  if(wlsSelectedOption == 4 || wlsSelectedOption == 5 || usingCalibartionCurveQuadratic)
  {
    return(TRUE)
  }
  return(FALSE)
}
doCheckMeanPeakAreaRatioSpecified = function(specifiedPeakAreaRatio)
{
  if(is.na(specifiedPeakAreaRatio))
  {
    return(FALSE)
  }
  return(TRUE)
}
doCheckUsingCustomWls = function(wlsSelectedOption)
{
  if(wlsSelectedOption == 999)
  {
    return(TRUE)
  }
  return(FALSE)
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
  if(is.null(x) || is.null(y) || is.null(wlsValues) || length(wlsValues) == 0) return(NULL)
  
  linearRegerssion = lm(y~x, na.action = na.omit, weights = wlsValues)
  return(linearRegerssion)
}

doGetCalibrationCurve_rSquared = function(linearRegression)
{
  if(is.null(linearRegression) || is.na(linearRegression)) return(NA)
  
  rSquare = summary.lm(linearRegression)$r.squared
}

doGetCalibrationCurve_n = function(values)
{
  if(is.null(values)) return(NULL)

  n = length(values[!is.na(values)])
  return(n)
}

doGetCalibrationCurve_meanOfX = function(x,y,wlsSelectedOption,customWls){
  if(is.null(x) | is.null(y)) return(NA)
  
  meanOfX = 0
  if(doCheckUsingWls(wlsSelectedOption))
  {
    weightedLeastSquared = doGetCalibrationCurve_weightedLeastSquared(x,y,wlsSelectedOption,customWls)
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

doGetCalibrationCurve_sqDeviation = function(values){
  sqDevation = (values - mean(values))^2
  return(sqDevation)
}

doGetCalibrationCurve_sumSqDeviationX = function(x)
{
  answer = sum(doGetCalibrationCurve_sqDeviation(x))
  return(answer)
}

doGetCalibrationCurve_weightedSqDeviation = function(weights, values){
  weightedSqDeviation = weights * (values - mean(values))^2
  return(weightedSqDeviation)
}

doGetCalibrationCurve_sumWeightedSqDeviation = function(weights, values){
  answer = sum(doGetCalibrationCurve_weightedSqDeviation(weights, values))
  return(answer)
}

doGetCalibrationCurve_predicetedY = function(x,y,wlsValues){
  calCurve = doGetCalibrationCurve_linearRegression(x,y,wlsValues) # Regression Cofficients
  predictedY = fitted(calCurve)
  #remove naming for vector of numbers
  predictedY = unname(predictedY)
  return(predictedY)
}

doGetCalibrationCurve_errorSqDeviationY = function(x,y,wlsValues){
  errorSqDeviationY = (na.omit(y) - doGetCalibrationCurve_predicetedY(x,y,wlsValues))^2
  return (errorSqDeviationY)
}

doGetCalibrationCurve_weightedErrorSqDeviationY = function(wlsValues,errorSqDeviationY)
{
  return(wlsValues * errorSqDeviationY)
}

doGetCalibrationCurve_standardErrorOfRegression = function(x,y,wlsValues){
  if(is.null(x) || is.null(y) || is.null(wlsValues) || length(wlsValues) == 0) return(NULL)
  
  linearRegression = doGetCalibrationCurve_linearRegression(x,y,wlsValues)
  standardErrorOfRegression = summary.lm(linearRegression)$sigma
  return(standardErrorOfRegression)
}

doGetCalibrationCurve_weightedCaseSample = function(caseSampleMeanConcentration,caseSampleMeanPar,n,sumofwieghts,wlsSelectedOption,customWls,caseSampleWeight){
  
  weightedCaseSample = 0
  if(wlsSelectedOption == 999)
  {
    weightedCaseSample = caseSampleWeight
  }
  else
  {
    weightedCaseSample = doGetCalibrationCurve_weightedLeastSquared(caseSampleMeanConcentration,caseSampleMeanPar,wlsSelectedOption,customWls)
  }
  standarisedWeightedCaseSample = weightedCaseSample * (n/sumofwieghts)
  
  return(standarisedWeightedCaseSample)
}
  
doGetCalibrationCurve_degreesOfFreedom = function(values){
  if(is.null(values)) return(NULL)
  degressOfFreedom = doGetCalibrationCurve_n(values)-2
  return(degressOfFreedom)
}

doGetCalibrationCurve_weightedLeastSquared = function(x,y,wlsSelectedOption,customWls){
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
  else if(wlsSelectedOption == 999)
  {
    return(customWls[,1])
  }
  else
  {
    return(NULL)
  }
}

doGetCalibrationCurve_sumOfWeightedLeastSquared = function(x,y,wlsSelectedOption,customWls){
  answer = sum(doGetCalibrationCurve_weightedLeastSquared(x,y,wlsSelectedOption,customWls))
  return(answer)
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
  else if(wlsSelectedOption == 2 | wlsSelectedOption == 4)
  {
    wlsFunc = function(value){
      return(1/(value))
    }
    return(wlsFunc)
  }
  else if(wlsSelectedOption == 3 | wlsSelectedOption == 5)
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
  
  if(wlsSelectedOption == 999)
    return("\\text{Custom}")
  
  return("")
}

doGetCalibrationCurve_uncertaintyOfCalibration = function(x,y,wlsSelectedOption,customWls,customWlsPooled,caseSampleWeight,caseSampleMeanPar,extStdErrorData, caseSampleReplicates, caseSampleMeanConcentration)
{
  n = doGetCalibrationCurve_n(y)
  sumOfWeights = doGetCalibrationCurve_sumOfWeightedLeastSquared(x,y,wlsSelectedOption,customWls)
  wlsValues = doGetCalibrationCurve_weightedLeastSquared(x,y,wlsSelectedOption,customWls)
  standardisedWeight = doGetCalibrationCurve_standardisedWeight(wlsValues, n)
  
  syx = 0
  if(is.null(extStdErrorData))
  {
    syx = doGetCalibrationCurve_standardErrorOfRegression(x,y,standardisedWeight)
  }
  else
  {
    syx = doGetCalibrationCurve_pooledStdErrorOfRegression(x,y,wlsSelectedOption,standardisedWeight,customWlsPooled,extStdErrorData)
  }
  
  weightedCaseSample = doGetCalibrationCurve_weightedCaseSample(caseSampleMeanConcentration,caseSampleMeanPar,n,sumOfWeights,wlsSelectedOption,customWls,caseSampleWeight)
  peakAreaRatioOfCaseSample = caseSampleMeanPar
  sumWeightedSqDeviationX = doGetCalibrationCurve_sumWeightedSqDeviation(standardisedWeight, x)
  meanOfX = doGetCalibrationCurve_meanOfX(x,y,wlsSelectedOption,customWls)
  sumSqDeviationX = doGetCalibrationCurve_sumSqDeviationX(x)
  slope = doGetCalibrationCurve_slope(x,y,wlsValues)
  n = doGetCalibrationCurve_n(y)
  
  uncertaintyOfCalibration = (syx / slope) * (sqrt((1/(weightedCaseSample*caseSampleReplicates))+(1/n)+((caseSampleMeanConcentration-meanOfX)^2 / (sumWeightedSqDeviationX))))
  
  return(uncertaintyOfCalibration)
}

doGetCalibrationCurve_pooledStdErrorOfRegression = function(x,y,wlsSelectedOption,wlsValues,customWlsPooled,exStdErrData){
  if(wlsSelectedOption == 999 && is.null(customWlsPooled)) return(NULL)
  
  exStdErrRunData = exStdErrData
  exStdErrRunData$conc = NULL
  
  n = doGetCalibrationCurve_n(y)
  
  results = list()
  for(i in colnames(exStdErrRunData))
  {
    weightedLeastSquared = doGetCalibrationCurve_weightedLeastSquared(exStdErrData$conc,exStdErrRunData[,i],wlsSelectedOption,data.frame(customWlsPooled[,i]))
    n = doGetCalibrationCurve_n(exStdErrRunData[,i])
    standardisedWeights = doGetCalibrationCurve_standardisedWeight(weightedLeastSquared, n)
    seor = doGetCalibrationCurve_standardErrorOfRegression(exStdErrData$conc,exStdErrRunData[,i],standardisedWeights)
    
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

doGetCalibrationCurve_relativeStandardUncertainty = function(x,y,wlsSelectedOption,customWls,customWlsPooled,caseSampleWeight,specifiedPeakAreaRatio,extStdErrorData,caseSampleReplicates,caseSampleMeanConcentration){
  uncertaintyOfCalibration = doGetCalibrationCurve_uncertaintyOfCalibration(x,y,wlsSelectedOption,customWls,customWlsPooled,caseSampleWeight,specifiedPeakAreaRatio,extStdErrorData, caseSampleReplicates, caseSampleMeanConcentration)
  answer = uncertaintyOfCalibration / caseSampleMeanConcentration
  return(answer)
}