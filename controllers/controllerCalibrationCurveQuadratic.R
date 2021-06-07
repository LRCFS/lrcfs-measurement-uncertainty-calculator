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

doGetCalibrationCurveQuadratic_quadraticRegression = function(data)
{
  if(is.null(data)) return(NA)
  
  return(1)
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