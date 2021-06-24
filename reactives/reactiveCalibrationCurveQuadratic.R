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

checkUsingCalibartionCurveQuadratic = reactive({
  return(doCheckUsingCalibartionCurveQuadratic(myReactives$uploadedCalibrationCurveQuadratic))
})

getCalibrationCurveQuadratic_n = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  value = doGetCalibrationCurveQuadratic_n(data)
  value = formatNumberForDisplay(value, input)
  value = colourNumber(value, input$useColours, input$colour7)
  
  return(value)
})

getCalibrationCurveQuadratic_regression = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data))return(NA)
  return(doGetCalibrationCurveQuadratic_regression(data))
})

getCalibrationCurveQuadratic_intercept_value = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  return(doGetCalibrationCurveQuadratic_intercept(data))
})

getCalibrationCurveQuadratic_intercept = reactive({
  value = getCalibrationCurveQuadratic_intercept_value()
  value = formatNumberForDisplay(value, input)
  return(value)
})

getCalibrationCurveQuadratic_slopeB1_value = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  return(doGetCalibrationCurveQuadratic_slopeB1(data))
})

getCalibrationCurveQuadratic_slopeB1 = reactive({
  value = getCalibrationCurveQuadratic_slopeB1_value()
  value = formatNumberForDisplay(value, input)
  value = colourNumber(value, input$useColours, input$colour5)
  return(value)
})

getCalibrationCurveQuadratic_slopeB2_value = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  return(doGetCalibrationCurveQuadratic_slopeB2(data))
})

getCalibrationCurveQuadratic_slopeB2 = reactive({
  value = getCalibrationCurveQuadratic_slopeB2_value()
  value = formatNumberForDisplay(value, input)
  value = colourNumber(value, input$useColours, input$colour6)
  return(value)
})

getCalibrationCurveQuadratic_rSquaredAdjusted = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)

  value = doGetCalibrationCurveQuadratic_rSquaredAdjusted(data)
  value = formatNumberForDisplay(value, input)
  return(value)
})

getCalibrationCurveQuadratic_xSquared = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)

  value = doGetCalibrationCurveQuadratic_xSquared(data)
  value = formatNumberForDisplay(value, input)
  return(value)
})

getCalibrationCurveQuadratic_sumOfXSquared = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)

  value = doGetCalibrationCurveQuadratic_sumOfXSquared(data)
  value = formatNumberForDisplay(value, input)
  return(value)
})

getCalibrationCurveQuadratic_meanOfXSquared = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)

  value = doGetCalibrationCurveQuadratic_meanOfXSquared(data)
  value = formatNumberForDisplay(value, input)
  value = colourNumber(value, input$useColours, input$colour3)
  return(value)
})

getCalibrationCurveQuadratic_yHat = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)

  value = doGetCalibrationCurveQuadratic_yHat(data)
  value = formatNumberForDisplay(value, input)
  return(value)
})

getCalibrationCurveQuadratic_yResidual = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)

  value = doGetCalibrationCurveQuadratic_yResidual(data)
  value = formatNumberForDisplay(value, input)
  return(value)
})

getDataCalibrationCurveQuadratic_rearranged = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data))return(NA)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  xSquared = getCalibrationCurveQuadratic_xSquared();
  yHat = getCalibrationCurveQuadratic_yHat()
  yResiduals = getCalibrationCurveQuadratic_yResidual()

  ##Get data in dataframe
  rearrangedCalibrationDataFrame = data.frame(getDataCalibrationCurveReformatted()$runNames,x,y,xSquared,yHat,yResiduals)
  colnames(rearrangedCalibrationDataFrame) = c("$$\\text{Run}$$","$$\\text{Concentration} (x)$$","$$\\text{Peak Area} (y)$$","$$x^2$$","$$\\hat{y} = b_0 + b_1x + b_2x^2$$","$$(y-\\hat{y})^2$$")
  
  return(rearrangedCalibrationDataFrame)
})

getDataCalibrationCurveQuadraticPooledStandardError_rearranged = reactive({
  data = getDataCalibrationCurveExternalStandardErrorReformatted()
  if(is.null(data))return(NA)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  xSquared = getCalibrationCurveQuadratic_pooledStandardError_xSquared();
  yHat = getCalibrationCurveQuadratic_pooledStandardError_yHat()
  yResiduals = getCalibrationCurveQuadratic_pooledStandardError_yResidual()
  
  ##Get data in dataframe
  rearrangedCalibrationDataFrame = data.frame(getDataCalibrationCurveReformatted()$runNames,x,y,xSquared,yHat,yResiduals)
  colnames(rearrangedCalibrationDataFrame) = c("$$\\text{Run}$$","$$\\text{Concentration} (x)$$","$$\\text{Peak Area} (y)$$","$$x^2$$","$$\\hat{y} = b_0 + b_1x + b_2x^2$$","$$(y-\\hat{y})^2$$")
  
  return(rearrangedCalibrationDataFrame)
})

getCalibrationCurveQuadratic_pooledStandardError_xSquared = reactive({
  data = getDataCalibrationCurveExternalStandardErrorReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  value = doGetCalibrationCurveQuadratic_xSquared(data)
  value = formatNumberForDisplay(value, input)
  return(value)
})

getCalibrationCurveQuadratic_pooledStandardError_yHat = reactive({
  data = getDataCalibrationCurveExternalStandardErrorReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  value = doGetCalibrationCurveQuadratic_yHat(data)
  value = formatNumberForDisplay(value, input)
  return(value)
})

getCalibrationCurveQuadratic_pooledStandardError_yResidual = reactive({
  data = getDataCalibrationCurveExternalStandardErrorReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  value = doGetCalibrationCurveQuadratic_yResidual(data)
  value = formatNumberForDisplay(value, input)
  return(value)
})

getCalibrationCurveQuadratic_sumOfX = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)

  value = doGetCalibrationCurveQuadratic_sumOfX(data)
  value = formatNumberForDisplay(value, input)
  return(value)
})

getCalibrationCurveQuadratic_meanOfX = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)

  value = doGetCalibrationCurveQuadratic_meanOfX(data)
  value = formatNumberForDisplay(value, input)
  value = colourNumber(value, input$useColours, input$colour1)
  return(value)
})

getCalibrationCurveQuadratic_sumOfY = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)

  value = doGetCalibrationCurveQuadratic_sumOfY(data)
  value = formatNumberForDisplay(value, input)
  return(value)
})

getCalibrationCurveQuadratic_meanOfY = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)

  value = doGetCalibrationCurveQuadratic_meanOfY(data)
  value = formatNumberForDisplay(value, input)
  value = colourNumber(value, input$useColours, input$colour2)
  return(value)
})

getCalibrationCurveQuadratic_sumOfResiduals = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)

  value = doGetCalibrationCurveQuadratic_sumOfResiduals(data)
  value = formatNumberForDisplay(value, input)
  return(value)
})

getCalibrationCurveQuadratic_standardErrorOfRegression = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)

  value = doGetCalibrationCurveQuadratic_standardErrorOfRegression(data)
  value = formatNumberForDisplay(value, input)
  value = colourNumber(value, input$useColours, input$colour5)
  return(value)
})

getCalibrationCurveQuadratic_variancePeakAreaRatio = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  caseSampleReplicates = input$inputCaseSampleReplicates
  
  value = doGetCalibrationCurveQuadratic_variancePeakAreaRatio(data, caseSampleReplicates)
  value = formatNumberForDisplay(value, input)
  value = colourNumber(value, input$useColours, input$colour8)
  return(value)
})

getCalibrationCurveQuadratic_varianceMeanOfY = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  value = doGetCalibrationCurveQuadratic_varianceMeanOfY(data)
  value = formatNumberForDisplay(value, input)
  value = colourNumber(value, input$useColours, input$colour10)
  return(value)
})

getCalibrationCurveQuadratic_discriminant = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  meanPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio

  value = doGetCalibrationCurveQuadratic_discriminant(data, meanPeakAreaRatio)
  value = formatNumberForDisplay(value, input)
  value = colourNumber(value, input$useColours, input$colour9)
  return(value)
})

getCalibrationCurveQuadratic_partialDerivativeSlope1 = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  meanPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  
  value = doGetCalibrationCurveQuadratic_partialDerivativeSlope1(data,meanPeakAreaRatio)
  value = formatNumberForDisplay(value, input)
  value = colourNumber(value, input$useColours, input$colour4)
  return(value)
})

getCalibrationCurveQuadratic_partialDerivativeSlope2 = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  meanPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  
  value = doGetCalibrationCurveQuadratic_partialDerivativeSlope2(data,meanPeakAreaRatio)
  value = formatNumberForDisplay(value, input)
  return(value)
})

getCalibrationCurveQuadratic_partialDerivativeMeanOfY = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  meanPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  
  value = doGetCalibrationCurveQuadratic_partialDerivativeMeanOfY(data,meanPeakAreaRatio)
  value = formatNumberForDisplay(value, input)
  value = colourNumber(value, input$useColours, input$colour11)
  return(value)
})

getCalibrationCurveQuadratic_partialDerivativeCaseSampleMeanPeakAreaRatio = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  meanPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio

  value = doGetCalibrationCurveQuadratic_partialDerivativeCaseSampleMeanPeakAreaRatio(data,meanPeakAreaRatio)
  value = formatNumberForDisplay(value, input)
  return(value)
})

getCalibrationCurveQuadratic_varianceOfSlope1 = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  value = doGetCalibrationCurveQuadratic_varianceOfSlope1(data)
  value = formatNumberForDisplay(value, input)
  value = colourNumber(value, input$useColours, input$colour12)
  return(value)
})

getCalibrationCurveQuadratic_varianceOfSlope2 = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  value = doGetCalibrationCurveQuadratic_varianceOfSlope2(data)
  value = formatNumberForDisplay(value, input)
  value = colourNumber(value, input$useColours, input$colour12)
  return(value)
})

getCalibrationCurveQuadratic_covarianceOfSlope1and2 = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  value = doGetCalibrationCurveQuadratic_covarianceOfSlope1and2(data)
  value = formatNumberForDisplay(value, input)
  value = colourNumber(value, input$useColours, input$colour12)
  return(value)
})

getCalibrationCurveQuadratic_uncertaintyOfCalibrationSquared = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  meanPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  caseSampleReplicates = input$inputCaseSampleReplicates
  
  value = doGetCalibrationCurveQuadratic_uncertaintyOfCalibrationSquared(data,meanPeakAreaRatio,caseSampleReplicates)
  value = formatNumberForDisplay(value, input)
  return(value)
})

getCalibrationCurveQuadratic_uncertaintyOfCalibration = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  meanPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  caseSampleReplicates = input$inputCaseSampleReplicates
  
  value = doGetCalibrationCurveQuadratic_uncertaintyOfCalibration(data,meanPeakAreaRatio,caseSampleReplicates)
  value = formatNumberForDisplay(value, input)
  return(value)
})

getCalibrationCurveQuadratic_relativeStandardUncertaintyOfCalibration = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data) || !checkUsingCalibartionCurveQuadratic())return(NA)
  
  caseSampleMeanPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  caseSampleReplicates = input$inputCaseSampleReplicates
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  
  value = doGetCalibrationCurveQuadratic_relativeStandardUncertaintyOfCalibration(data,caseSampleMeanPeakAreaRatio,caseSampleReplicates,caseSampleMeanConcentration)
  value = formatNumberForDisplay(value, input)
  return(value)
})

