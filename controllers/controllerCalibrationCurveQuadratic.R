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

doCheckUsingCalibartionCurveQuadratic = function(quadraticFileUploaded)
{
  return(quadraticFileUploaded)
}

doGetCalibrationCurveQuadratic_n = function(data)
{
  if(is.null(data)) return(NA)
  
  n = nrow(data)
  return(n)
}

doGetCalibrationCurveQuadratic_regression = function(data)
{
  if(is.null(data))return(NA)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  xSquared = doGetCalibrationCurveQuadratic_xSquared(data)

  regerssion = lm(y ~ x + xSquared, na.action = na.omit)
  return(regerssion)
}

doGetCalibrationCurveQuadratic_intercept = function(data)
{
  if(is.null(data))return(NA)

  regerssion = doGetCalibrationCurveQuadratic_regression(data)
  intercept = coef(regerssion)[1]
  #remove naming to get single number
  intercept = unname(intercept)
  return(intercept)
}

doGetCalibrationCurveQuadratic_slopeB1 = function(data)
{
  if(is.null(data))return(NA)
  
  regerssion = doGetCalibrationCurveQuadratic_regression(data)
  slope = coef(regerssion)[2];
  #remove naming to get single number
  slope = unname(slope)
  return(slope)
}

doGetCalibrationCurveQuadratic_slopeB2 = function(data)
{
  if(is.null(data))return(NA)
  
  regerssion = doGetCalibrationCurveQuadratic_regression(data)
  slope = coef(regerssion)[3];
  #remove naming to get single number
  slope = unname(slope)
  return(slope)
}

doGetCalibrationCurveQuadratic_rSquaredAdjusted = function(data)
{
  if(is.null(data))return(NA)
  
  regerssion = doGetCalibrationCurveQuadratic_regression(data)
  
  if(is.null(regerssion) || is.na(regerssion))
  {
    return(NA)
  }
  else
  {
    rSquared = summary.lm(regerssion)$r.squared
    return(rSquared)
  }
}

doGetCalibrationCurveQuadratic_xSquared = function(data)
{
  if(is.null(data))return(NA)
  
  return(data$calibrationDataConcentration^2)
}

doGetCalibrationCurveQuadratic_sumOfXSquared = function(data)
{
  if(is.null(data))return(NA)
  
  return(sum(doGetCalibrationCurveQuadratic_xSquared(data)))
}

doGetCalibrationCurveQuadratic_meanOfXSquared = function(data)
{
  if(is.null(data))return(NA)
  
  return(mean(doGetCalibrationCurveQuadratic_xSquared(data)))
}

doGetCalibrationCurveQuadratic_yHat = function(data)
{
  if(is.null(data))return(NA)
  
  regerssion = doGetCalibrationCurveQuadratic_regression(data) # Regression Cofficients
  predictedY = fitted(regerssion)
  #remove naming for vector of numbers
  predictedY = unname(predictedY)
  return(predictedY)
}

doGetCalibrationCurveQuadratic_yResidual = function(data)
{
  if(is.null(data))return(NA)
  
  y = data$calibrationDataPeakArea
  
  yResidual = (na.omit(y) - doGetCalibrationCurveQuadratic_yHat(data))^2
  return (yResidual)
}

doGetCalibrationCurveQuadratic_sumOfX = function(data)
{
  if(is.null(data))return(NA)
  
  x = data$calibrationDataConcentration
  
  return(sum(x))
}

doGetCalibrationCurveQuadratic_meanOfX = function(data)
{
  if(is.null(data))return(NA)
  
  x = data$calibrationDataConcentration
  
  return(mean(x))
}

doGetCalibrationCurveQuadratic_sumOfY = function(data)
{
  y = data$calibrationDataPeakArea
  
  if(is.null(data))return(NA)
  
  return(sum(y))
}

doGetCalibrationCurveQuadratic_meanOfY = function(data)
{
  if(is.null(data))return(NA)
  
  y = data$calibrationDataPeakArea
  
  return(mean(y))
}

doGetCalibrationCurveQuadratic_sumOfResiduals = function(data)
{
  if(is.null(data))return(NA)
  
  return(sum(doGetCalibrationCurveQuadratic_yResidual(data)))
}

doGetCalibrationCurveQuadratic_standardErrorOfRegression = function(data)
{
  if(is.null(data))return(NA)
  
  regression = doGetCalibrationCurveQuadratic_regression(data)
  standardErrorOfRegression = summary.lm(regression)$sigma
  return(standardErrorOfRegression)
}

doGetCalibrationCurveQuadratic_variancePeakAreaRatio = function(data, caseSampleReplicates)
{
  if(is.null(data))return(NA)

  standardErrorOfRegression = doGetCalibrationCurveQuadratic_standardErrorOfRegression(data)
  answer = (standardErrorOfRegression^2)/caseSampleReplicates
  
  return(answer)
}

doGetCalibrationCurveQuadratic_varianceMeanOfY = function(data)
{
  if(is.null(data))return(NA)
  
  standardErrorOfRegression = doGetCalibrationCurveQuadratic_standardErrorOfRegression(data)
  n = doGetCalibrationCurveQuadratic_n(data)
  answer = (standardErrorOfRegression^2)/n
  
  return(answer)
}

doGetCalibrationCurveQuadratic_designMatrix = function(data)
{
  if(is.null(data))return(NA)
  
  x = data$calibrationDataConcentration
  xS = doGetCalibrationCurveQuadratic_xSquared(data)
  id = rep(1,length(x))
  
  designMatrix = cbind(id,x,xS)
  return(designMatrix)
}

doGetCalibrationCurveQuadratic_designMatrixTransposed = function(data)
{
  if(is.null(data))return(NA)
  return(t(doGetCalibrationCurveQuadratic_designMatrix(data)))
}

doGetCalibrationCurveQuadratic_designMatrixMultiply = function(data)
{
  if(is.null(data))return(NA)
  answer = doGetCalibrationCurveQuadratic_designMatrixTransposed(data) %*% doGetCalibrationCurveQuadratic_designMatrix(data)
  return(answer)
}

doGetCalibrationCurveQuadratic_designMatrixMultiplyInverse = function(data)
{
  if(is.null(data))return(NA)
  answer = solve(doGetCalibrationCurveQuadratic_designMatrixMultiply(data))
  return(answer)
}

doGetCalibrationCurveQuadratic_covarianceMatrix = function(data)
{
  if(is.null(data))return(NA)
  answer = doGetCalibrationCurveQuadratic_standardErrorOfRegression(data)^2 * doGetCalibrationCurveQuadratic_designMatrixMultiplyInverse(data)
  return(answer)
}

doGetCalibrationCurveQuadratic_discriminant = function(data, meanPeakAreaRatio)
{
  if(is.null(data))return(NA)
  
  interceptB0 = doGetCalibrationCurveQuadratic_intercept(data)
  slopeB1 = doGetCalibrationCurveQuadratic_slopeB1(data)
  slopeB2 = doGetCalibrationCurveQuadratic_slopeB2(data)
  meanX = doGetCalibrationCurveQuadratic_meanOfX(data)
  meanXs = doGetCalibrationCurveQuadratic_meanOfXSquared(data)
  meanY = doGetCalibrationCurveQuadratic_meanOfY(data)
  
  answer = slopeB1^2 - ((4 * slopeB2) * (meanY - meanPeakAreaRatio - (slopeB1 * meanX) - (slopeB2 * meanXs)))
  return(answer)
}

doGetCalibrationCurveQuadratic_partialDerivativeSlope1 = function(data,meanPeakAreaRatio)
{
  if(is.null(data))return(NA)
  
  discriminant = doGetCalibrationCurveQuadratic_discriminant(data,meanPeakAreaRatio)
  slopeB1 = doGetCalibrationCurveQuadratic_slopeB1(data)
  slopeB2 = doGetCalibrationCurveQuadratic_slopeB2(data)
  meanX = doGetCalibrationCurveQuadratic_meanOfX(data)
  
  topFrac = -1 + (0.5*discriminant)^(-0.5) * ((2*slopeB1) + (4*slopeB2*meanX))
  bottomFrac = 2 * slopeB2
  answer = topFrac / bottomFrac
  return(answer)
}

doGetCalibrationCurveQuadratic_partialDerivativeSlope2 = function(data,meanPeakAreaRatio)
{
  if(is.null(data))return(NA)
  
  discriminant = doGetCalibrationCurveQuadratic_discriminant(data,meanPeakAreaRatio)
  slopeB1 = doGetCalibrationCurveQuadratic_slopeB1(data)
  slopeB2 = doGetCalibrationCurveQuadratic_slopeB2(data)
  meanX = doGetCalibrationCurveQuadratic_meanOfX(data)
  meanY = doGetCalibrationCurveQuadratic_meanOfY(data)
  meanXs = doGetCalibrationCurveQuadratic_meanOfXSquared(data)
  
  topFrac1 = slopeB1 - discriminant^(0.5)
  bottomFrac1 = 2 * slopeB2
  frac1 = topFrac1 / bottomFrac1
  
  topFrac2 = ((0.5*discriminant)^(-0.5)) * ((4*meanPeakAreaRatio) - (4*meanY) + (4*slopeB1*meanX) + (8*slopeB2*meanXs))
  bottomFrac2 = 2 * slopeB2
  frac2 = topFrac2 / bottomFrac2
  
  answer = frac1 + frac2
  
  return(answer)
}

doGetCalibrationCurveQuadratic_partialDerivativeMeanOfY = function(data,meanPeakAreaRatio)
{
  if(is.null(data))return(NA)
  
  discriminant = doGetCalibrationCurveQuadratic_discriminant(data,meanPeakAreaRatio)
  
  answer = -discriminant^(-0.5)
  return(answer)
}

doGetCalibrationCurveQuadratic_partialDerivativeCaseSampleMeanPeakAreaRatio = function(data,meanPeakAreaRatio)
{
  if(is.null(data))return(NA)
  
  discriminant = doGetCalibrationCurveQuadratic_discriminant(data,meanPeakAreaRatio)
  
  answer = discriminant^(-0.5)
  return(answer)
}

doGetCalibrationCurveQuadratic_varianceOfSlope1 = function(data)
{
  if(is.null(data))return(NA)
  
  answer = doGetCalibrationCurveQuadratic_covarianceMatrix(data)[2,2]
  return(answer)
}

doGetCalibrationCurveQuadratic_varianceOfSlope2 = function(data)
{
  if(is.null(data))return(NA)
  
  answer = doGetCalibrationCurveQuadratic_covarianceMatrix(data)[3,3]
  return(answer)
}

doGetCalibrationCurveQuadratic_covarianceOfSlope1and2 = function(data)
{
  if(is.null(data))return(NA)
  
  answer = doGetCalibrationCurveQuadratic_covarianceMatrix(data)[2,3]
  return(answer)
}

doGetCalibrationCurveQuadratic_uncertaintyOfCalibrationSquared = function(data,meanPeakAreaRatio,caseSampleReplicates)
{
  if(is.null(data))return(NA)
  
  partialDerivativeSlope1 = doGetCalibrationCurveQuadratic_partialDerivativeSlope1(data,meanPeakAreaRatio)
  partialDerivativeSlope2 = doGetCalibrationCurveQuadratic_partialDerivativeSlope2(data,meanPeakAreaRatio)
  partialDerivativeMeanOfY = doGetCalibrationCurveQuadratic_partialDerivativeMeanOfY(data,meanPeakAreaRatio)
  partialDerivativeCaseSampleMeanPeakAreaRatio = doGetCalibrationCurveQuadratic_partialDerivativeCaseSampleMeanPeakAreaRatio(data,meanPeakAreaRatio)
  
  varianceOfSlope1 = doGetCalibrationCurveQuadratic_varianceOfSlope1(data)
  varianceOfSlope2 = doGetCalibrationCurveQuadratic_varianceOfSlope2(data)
  varianceMeanOfY = doGetCalibrationCurveQuadratic_varianceMeanOfY(data)
  variancePeakAreaRatio = doGetCalibrationCurveQuadratic_variancePeakAreaRatio(data,caseSampleReplicates)
  covarianceOfSlope1and2 = doGetCalibrationCurveQuadratic_covarianceOfSlope1and2(data)
  
  part1 = partialDerivativeSlope1^2 * varianceOfSlope1
  part2 = partialDerivativeSlope2^2 * varianceOfSlope2
  part3 = partialDerivativeMeanOfY^2 * varianceMeanOfY
  part4 = partialDerivativeCaseSampleMeanPeakAreaRatio^2 * variancePeakAreaRatio
  part5 = 2*partialDerivativeSlope1*partialDerivativeSlope2*covarianceOfSlope1and2
  answer = part1+part2+part3+part4+part5
  
  return(answer)
}

doGetCalibrationCurveQuadratic_uncertaintyOfCalibration = function(data,meanPeakAreaRatio,caseSampleReplicates)
{
  if(is.null(data))return(NA)
  
  uncertaintyOfCalibrationSquared = doGetCalibrationCurveQuadratic_uncertaintyOfCalibrationSquared(data,meanPeakAreaRatio,caseSampleReplicates)
  answer = sqrt(uncertaintyOfCalibrationSquared)
  return(answer)
}

doGetCalibrationCurveQuadratic_relativeStandardUncertaintyOfCalibration = function(data,caseSampleMeanPeakAreaRatio,caseSampleReplicates,caseSampleMeanConcentration)
{
  if(is.null(data))return(NA)
  
  uncertaintyOfCalibration = doGetCalibrationCurveQuadratic_uncertaintyOfCalibration(data,caseSampleMeanPeakAreaRatio,caseSampleReplicates)
  answer = uncertaintyOfCalibration/caseSampleMeanConcentration
  return(answer)
  
}