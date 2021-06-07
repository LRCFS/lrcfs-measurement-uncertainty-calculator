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

getCalibrationCurveQuadratic_quadraticRegression = reactive({
  return(doGetCalibrationCurveQuadratic_quadraticRegression(NULL))
})

getCalibrationCurveQuadratic_intercept = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data))return(NULL)
  return(doGetCalibrationCurveQuadratic_intercept(data))
})

getCalibrationCurveQuadratic_slopeB1 = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data))return(NULL)
  return(doGetCalibrationCurveQuadratic_slopeB1(data))
})

getCalibrationCurveQuadratic_slopeB2 = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data))return(NULL)
  return(doGetCalibrationCurveQuadratic_slopeB2(data))
})

getCalibrationCurveQuadratic_rSquaredAdjusted = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data))return(NULL)
  return(doGetCalibrationCurveQuadratic_rSquaredAdjusted(data))
})

getCalibrationCurveQuadratic_xSquared = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data))return(NULL)
  return(doGetCalibrationCurveQuadratic_xSquared(data))
})

getCalibrationCurveQuadratic_yHat = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data))return(NULL)
  return(doGetCalibrationCurveQuadratic_yHat(data))
})

getCalibrationCurveQuadratic_yResidual = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data))return(NULL)
  return(doGetCalibrationCurveQuadratic_yResidual(data))
})

getDataCalibrationCurveQuadratic_rearranged = reactive({
  data = getDataCalibrationCurveReformatted()
  if(is.null(data))return(NULL)
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  xSquared = getCalibrationCurveQuadratic_xSquared();
  yHat = getCalibrationCurveQuadratic_yHat()
  yResiduals = getCalibrationCurveQuadratic_yResidual()

  ##Get data in dataframe
  rearrangedCalibrationDataFrame = data.frame(getDataCalibrationCurveReformatted()$runNames,x,y,xSquared,yHat,yResiduals)
  colnames(rearrangedCalibrationDataFrame) = c("$$\\text{Run}$$","$$\\text{Concentration} (x)$$","$$\\text{Peak Area} (y)$$","$$x^2$$","$$\\hat{y} = b_0 + b_1x + b_2x^2$$","$$y-\\hat{y}^2$$")
  
  return(rearrangedCalibrationDataFrame)
})