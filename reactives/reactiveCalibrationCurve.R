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

##############################################
# Checkers
##############################################
checkUsingWls = reactive({
  wlsSelectedOption = input$inputWeightLeastSquared
  result = doCheckUsingWls(wlsSelectedOption)
  return(result)
})

checkNeedPeakAreaRatio = reactive({
  wlsSelectedOption = input$inputWeightLeastSquared
  result = doCheckNeedPeakAreaRatio(wlsSelectedOption)
  return(result)
})

checkMeanPeakAreaRatioSpecified = reactive({
  specifiedPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  result = doCheckMeanPeakAreaRatioSpecified(specifiedPeakAreaRatio)
  return(result)
})

checkUsingCustomWls = reactive({
  wlsSelectedOption = input$inputWeightLeastSquared
  result = doCheckUsingCustomWls(wlsSelectedOption)
  return(result)
})



##############################################
# Get data
##############################################
getDataCalibrationCurve = reactive({
  return(doGetDataCalibrationCurve(input$inputCalibrationCurveFileUpload$datapath))
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

getDataCustomWls = reactive({
  if(myReactives$uploadedCustomWls == TRUE)
  {
    data = calibrationCurveCustomWlsReadCSV(input$inputCustomWlsFileUpload$datapath)
    return(data)
  }
  else
  {
    return(NULL)
  }
})

getDataCustomWlsPooled = reactive({
  if(myReactives$uploadedCustomWlsPooled == TRUE)
  {
    data = calibrationCurveCustomWlsPooledReadCSV(input$inputCustomWlsPooledFileUpload$datapath)
    return(data)
  }
  else
  {
    return(NULL)
  }
})

getDataCalibrationCurveReformatted = reactive({
  return(doGetDataCalibrationCurveReformatted(getDataCalibrationCurve()))
})

getDataCalibrationCurveRearranged = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data))return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  ### Get Weighted Squared Devation of X
  weightedSqDevationX = getCalibrationCurve_weightedSqDeviationX();
  
  #Get Weight
  weightedLeastSquared = getCalibrationCurve_weightedLeastSquared()
  
  #standardised weight
  standardisedWeight = getCalibrationCurve_standardisedWeight()
  
  #Get Weight
  wx = standardisedWeight * x
  
  ### Predicted Y value is the regression cofficient of Y compared to X
  predictedY = doGetCalibrationCurve_predicetedY(x,y, standardisedWeight);
  
  ### Get error Sum Squared of y
  errorSqDevationY = doGetCalibrationCurve_errorSqDeviationY(x,y,standardisedWeight);
  weightedErrorSqDevationY = doGetCalibrationCurve_weightedErrorSqDeviationY(standardisedWeight,errorSqDevationY)
  
  ##Get data in dataframe
  rearrangedCalibrationDataFrame = data.frame(getDataCalibrationCurveReformatted()$runNames,x,y,weightedLeastSquared,standardisedWeight,wx,weightedSqDevationX,predictedY,weightedErrorSqDevationY)
  colnames(rearrangedCalibrationDataFrame) = c("$$\\text{Run}$$","$$\\text{Concentration} (x)$$","$$\\text{Peak Area} (y)$$",paste("$$\\text{Weight}(",doGetCalibrationCurve_wlsLatex(input$inputWeightLeastSquared),")$$"),"$$w=W(\\frac{n}{\\sum{W_i}})$$","$$wx$$","$$w(x-\\overline{x})^2$$","$$\\hat{y} = b_0 + b_1x$$","$$w(y - \\hat{y})^2$$")
  
  return(rearrangedCalibrationDataFrame)
})

getDataCalibrationCurveExternalStandardErrorReformatted = reactive({
  data = getDataExternalStandardError();
  dataWeights = getDataCustomWlsPooled();
  
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
  colnames(allData) = c("runNames","conc","peakArea")
  
  #Remove any data with NA enteries
  allDataNaRemoved = allData[!is.na(allData$peakArea),]
  
  dataWithSums = data.frame()
  for(runName in unique(allDataNaRemoved$runNames))
  {
    runData = allDataNaRemoved[allDataNaRemoved$runNames == runName,]
    x = runData$conc
    y = runData$peakArea
    weightedLeastSquared = doGetCalibrationCurve_weightedLeastSquared(x,y,input$inputWeightLeastSquared,data.frame(dataWeights[,runName]))
    
    n = doGetCalibrationCurve_n(runData$conc)
    standardisedWeight = doGetCalibrationCurve_standardisedWeight(weightedLeastSquared, n)
    
    ### Predicted Y value is the regression cofficient of Y compared to X
    predictedY = doGetCalibrationCurve_predicetedY(x,y, standardisedWeight);
    
    errorSqDevationY = doGetCalibrationCurve_errorSqDeviationY(x,y,standardisedWeight);
    weightedErrorSqDevationY = doGetCalibrationCurve_weightedErrorSqDeviationY(standardisedWeight,errorSqDevationY)
    
    runData = cbind(runData, weightedLeastSquared, standardisedWeight, predictedY, weightedErrorSqDevationY)
    
    dataWithSums = rbind(dataWithSums, runData)
  }
  
  return(dataWithSums)
})

getDataCalibrationCurveExternalStandardErrorRearranged = reactive({
  data = getDataCalibrationCurveExternalStandardErrorReformatted()
  if(is.null(data))return(NULL)
  
  runNames = data$runNames
  x = data$conc
  y = data$peakArea
  weightedLeastSquared = data$weightedLeastSquared
  standardisedWeight = data$standardisedWeight
  predictedY = data$predictedY
  weightedErrorSqDevationY = data$weightedErrorSqDevationY
  
  rearrangedExternalStandardErrorDf = data.frame(runNames,x,y,weightedLeastSquared,standardisedWeight,predictedY,weightedErrorSqDevationY)
  colnames(rearrangedExternalStandardErrorDf) = c("$$\\text{Run}$$","$$\\text{Concentration} (x)$$","$$\\text{Peak Area} (y)$$",paste("$$\\text{Weight}(",doGetCalibrationCurve_wlsLatex(input$inputWeightLeastSquared),")$$"),"$$w(x-\\overline{x})^2$$","$$\\hat{y} = b_0 + b_1x$$","$$w(y - \\hat{y})^2$$")
  return(rearrangedExternalStandardErrorDf)
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
  customWls = getDataCustomWls()
  customPooled = getDataCustomWlsPooled()
  
  specifiedPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  extStdErrorData = getDataExternalStandardError()
  caseSampleReplicates = input$inputCaseSampleReplicates
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  caseSampleWeight = input$inputCaseSampleCustomWeight
  
  answer = doGetCalibrationCurve_relativeStandardUncertainty(x,y,wlsSelectedValue,customWls,customPooled,caseSampleWeight,specifiedPeakAreaRatio,extStdErrorData,caseSampleReplicates,caseSampleMeanConcentration)
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

getCalibrationCurve_weightedSqDeviationX = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  standarisedWeight = getCalibrationCurve_standardisedWeight()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  answer = doGetCalibrationCurve_weightedSqDeviation(standarisedWeight, x)
  return(answer)
})

getCalibrationCurve_sumWeightedSqDeviationX = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  standarisedWeight = getCalibrationCurve_standardisedWeight()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  answer = doGetCalibrationCurve_sumWeightedSqDeviation(standarisedWeight, x)
  return(answer)
})


getCalibrationCurve_weightedLeastSquared = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  customWls = getDataCustomWls()
  
  answer = doGetCalibrationCurve_weightedLeastSquared(x,y,input$inputWeightLeastSquared, customWls)
  return(answer)
})

getCalibrationCurve_sumOfWeightedLeastSquared = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  customWls = getDataCustomWls()
  
  answer = doGetCalibrationCurve_sumOfWeightedLeastSquared(x,y,input$inputWeightLeastSquared,customWls)
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
  customWls = getDataCustomWls()
  
  answer = doGetCalibrationCurve_meanOfX(x,y,input$inputWeightLeastSquared,customWls)
  
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

getCalibrationCurve_sumSqDeviationX = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  answer = doGetCalibrationCurve_sumSqDeviationX(x)
  
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

getCalibrationCurve_pooledStdErrorOfRegression = reactive(
{
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  exStdErrorData = getDataExternalStandardError()
  if(is.null(exStdErrorData))
    return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  wlsSelectedOption = input$inputWeightLeastSquared
  customWlsPooled = getDataCustomWlsPooled()
  
  standardisedWeights = getCalibrationCurve_standardisedWeight()
  answer = doGetCalibrationCurve_pooledStdErrorOfRegression(x,y,wlsSelectedOption,standardisedWeights,customWlsPooled,exStdErrorData)
})

getCalibrationCurve_weightedCaseSample = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  n = getCalibrationCurve_n()
  sumOfWeights = getCalibrationCurve_sumOfWeightedLeastSquared()
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  wlsSelectedOption = input$inputWeightLeastSquared
  customwWls = getDataCustomWls()
  caseSampleWeight = input$inputCaseSampleCustomWeight
  specifiedPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  
  answer = doGetCalibrationCurve_weightedCaseSample(caseSampleMeanConcentration,specifiedPeakAreaRatio,n,sumOfWeights,wlsSelectedOption,customwWls,caseSampleWeight)
  return(answer)
})

getCalibrationCurve_uncertaintyOfCalibration = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data)) return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  extStdErrorData = getDataExternalStandardError()
  wlsSelectedOption = input$inputWeightLeastSquared
  customWls = getDataCustomWls()
  customWlsPooled = getDataCustomWlsPooled()
  caseSampleWeight = input$inputCaseSampleCustomWeight
  specifiedPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  caseSampleReplicates = input$inputCaseSampleReplicates
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  
  answer = doGetCalibrationCurve_uncertaintyOfCalibration(x,y,wlsSelectedOption,customWls,customWlsPooled,caseSampleWeight,specifiedPeakAreaRatio,extStdErrorData, caseSampleReplicates, caseSampleMeanConcentration)
  
  return(answer)
})



################################################
# Display
################################################

getCalibrationCurve_wlsLatex = reactive({
  return(doGetCalibrationCurve_wlsLatex(input$inputWeightLeastSquared))
})