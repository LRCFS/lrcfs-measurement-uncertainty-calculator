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

#Set context for tests for reporting purposes
context('Calibration Curve')

#Load in model that test are written against
source("../dal/loadHelperMethods.R")
source("../dal/loadCalibrationCurveCSV.R")
source("../dal/loadCalibrationCurvePooledDataCSV.R")
source("../dal/loadCalibrationCurveCustomWlsCSV.R")
source("../controllers/controllerCalibrationCurve.R")

exampleDataCc = calibrationCurveReadCSV("../www/exampleData/exampleData-calibrationCurve.csv")
exampleDataSe = calibrationCurvePooledDataReadCSV("../www/exampleData/exampleData-calibrationCurve-pooledStandardError.csv")
exampleDataCcW = calibrationCurveCustomWlsReadCSV("../www/exampleData/exampleData-calibrationCurve-customWeights.csv")
exampleDataSeW = calibrationCurveCustomWlsPooledReadCSV("../www/exampleData/exampleData-calibrationCurve-pooledStandardError-customWeights.csv")

exampleDataCcReformatted = doGetDataCalibrationCurveReformatted(exampleDataCc)

ccX = exampleDataCcReformatted$calibrationDataConcentration
ccY = exampleDataCcReformatted$calibrationDataPeakArea
ccWlsValues = doGetCalibrationCurve_weightedLeastSquared(ccX,ccY,1,exampleDataCcW)
n = doGetCalibrationCurve_n(ccY)
ccWlsStdValues = doGetCalibrationCurve_standardisedWeight(ccWlsValues, n)

caseSampleReplicates = 2
caseSampleMeanConcentration = 3
caseSampleMeanPeakAreaRatio = 1.5
caseSampleWeight = 1

empty=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

test_that('doCheckUsingWls', {
  expect_equal(doCheckUsingWls(1), FALSE)
  expect_equal(doCheckUsingWls(2), TRUE)
  expect_equal(doCheckUsingWls(3), TRUE)
  expect_equal(doCheckUsingWls(4), TRUE)
  expect_equal(doCheckUsingWls(5), TRUE)
  expect_equal(doCheckUsingWls(999), TRUE)
})

test_that('doCheckNeedPeakAreaRatio', {
  expect_equal(doCheckNeedPeakAreaRatio(1), FALSE)
  expect_equal(doCheckNeedPeakAreaRatio(2), FALSE)
  expect_equal(doCheckNeedPeakAreaRatio(3), FALSE)
  expect_equal(doCheckNeedPeakAreaRatio(4), TRUE)
  expect_equal(doCheckNeedPeakAreaRatio(5), TRUE)
  expect_equal(doCheckNeedPeakAreaRatio(999), FALSE)
})

test_that('doCheckMeanPeakAreaRatioSpecified', {
  expect_equal(doCheckMeanPeakAreaRatioSpecified(NA), FALSE)
  expect_equal(doCheckMeanPeakAreaRatioSpecified(1), TRUE)
})

test_that('doCheckUsingCustomWls', {
  expect_equal(doCheckUsingCustomWls(1), FALSE)
  expect_equal(doCheckUsingCustomWls(2), FALSE)
  expect_equal(doCheckUsingCustomWls(3), FALSE)
  expect_equal(doCheckUsingCustomWls(4), FALSE)
  expect_equal(doCheckUsingCustomWls(5), FALSE)
  expect_equal(doCheckUsingCustomWls(999), TRUE)
})

test_that('doGetCalibrationCurve_intercept', {
  expect_equal(doGetCalibrationCurve_intercept(ccX,ccY,ccWlsValues), -0.0415833172328258)
})

test_that('doGetCalibrationCurve_slope', {
  expect_equal(doGetCalibrationCurve_slope(ccX,ccY,ccWlsValues), 0.478403107340967)
})

test_that('doGetCalibrationCurve_linearRegression', {
  expect_equivalent(fitted(doGetCalibrationCurve_linearRegression(ccX,ccY,ccWlsValues)), fitted(lm(ccY~ccX, na.action = na.omit, weights = ccWlsValues)))
})

test_that('doGetCalibrationCurve_rSquared', {
  lr = doGetCalibrationCurve_linearRegression(ccX,ccY,ccWlsValues)
  expect_equal(doGetCalibrationCurve_rSquared(lr), 0.995773514381579)
})

test_that('doGetCalibrationCurve_n', {
  x = exampleDataCc$conc
  expect_equal(doGetCalibrationCurve_n(x), 30)
})

test_that('doGetCalibrationCurve_meanOfX', {
  expect_equal(doGetCalibrationCurve_meanOfX(ccX,ccY,1,exampleDataCcW), 4.3)
})

test_that('doGetCalibrationCurve_sqDeviation', {
  x = exampleDataCc$conc
  expect_equal(doGetCalibrationCurve_sqDeviation(x), c(10.89,10.89,10.89,7.84,7.84,7.84,5.29,5.29,5.29,3.24,3.24,3.24,1.69,1.69,1.69,0.0899999999999999,0.0899999999999999,0.0899999999999999,0.49,0.49,0.49,2.89,2.89,2.89,13.69,13.69,13.69,32.49,32.49,32.49))
})

test_that('doGetCalibrationCurve_sumSqDeviationX', {
  expect_equal(doGetCalibrationCurve_sumSqDeviationX(ccX), 235.8)
})

test_that('doGetCalibrationCurve_weightedSqDeviation', {
  expect_equal(doGetCalibrationCurve_weightedSqDeviation(ccWlsStdValues, ccX), c(10.89,10.89,10.89,7.84,7.84,7.84,5.29,5.29,5.29,3.24,3.24,3.24,1.69,1.69,1.69,0.0899999999999999,0.0899999999999999,0.0899999999999999,0.49,0.49,0.49,2.89,2.89,2.89,13.69,13.69,13.69,32.49,32.49,32.49))
})

test_that('doGetCalibrationCurve_sumWeightedSqDeviation', {
  expect_equal(doGetCalibrationCurve_sumWeightedSqDeviation(ccWlsStdValues, ccX), 235.8)
})

test_that('doGetCalibrationCurve_predicetedY', {
  expect_equal(doGetCalibrationCurve_predicetedY(ccX,ccY,ccWlsStdValues), c(0.436819790108145,0.436819790108145,0.436819790108145,0.676021343778626,0.676021343778626,0.676021343778626,0.915222897449109,0.915222897449109,0.9152228974491091,1.15442445111959,1.15442445111959,1.15442445111959,1.39362600479008,1.39362600479008,1.39362600479008,1.87202911213104,1.87202911213104,1.87202911213104,2.35043221947201,2.35043221947201,2.35043221947201,2.82883532681298,2.82883532681298,2.82883532681298,3.78564154149491,3.78564154149491,3.78564154149491,4.74244775617684,4.74244775617684,4.74244775617684))
})

test_that('doGetCalibrationCurve_errorSqDeviationY', {
  expect_equal(doGetCalibrationCurve_errorSqDeviationY(ccX,ccY,ccWlsStdValues), c(0.00715744863981197,0.000732130595947492,0.0004689715033787,0.00475014631341784,1.02499786129954e-05,4.06940560158216e-06,0.00542507192212939,0.000122902867070858,0.00114240007910853,0.00190032254467746,6.39521498124149e-07,0.00590247768165309,4.44040229978966e-06,0.000482172155760367,0.00260110248959737,0.0125958974418366,0.00143950065238176,0.00397485210008277,0.00192905692264063,0.00173780367388211,0.0170851118045737,0.00356199104065072,0.0236233302858784,0.00469695395170791,0.015817656356622,0.0222564469299544,0.000928398200298868,0.0259917999944934,0.0352219390975367,0.0274954289872989))
})

test_that('doGetCalibrationCurve_weightedErrorSqDeviationY', {
  errorSqDeviationY = doGetCalibrationCurve_errorSqDeviationY(ccX,ccY,ccWlsStdValues);
  
  expect_equal(doGetCalibrationCurve_weightedErrorSqDeviationY(ccWlsStdValues,errorSqDeviationY), c(0.00715744863981197,0.000732130595947492,0.0004689715033787,0.00475014631341784,1.02499786129954e-05,4.06940560158216e-06,0.00542507192212939,0.000122902867070858,0.00114240007910853,0.00190032254467746,6.39521498124149e-07,0.00590247768165309,4.44040229978966e-06,0.000482172155760367,0.00260110248959737,0.0125958974418366,0.00143950065238176,0.00397485210008277,0.00192905692264063,0.00173780367388211,0.0170851118045737,0.00356199104065072,0.0236233302858784,0.00469695395170791,0.015817656356622,0.0222564469299544,0.000928398200298868,0.0259917999944934,0.0352219390975367,0.0274954289872989))
})

test_that('doGetCalibrationCurve_standardErrorOfRegression', {
  expect_equal(doGetCalibrationCurve_standardErrorOfRegression(ccX,ccY,ccWlsStdValues), 0.0904474420274015)
})

test_that('doGetCalibrationCurve_weightedCaseSample', {
  wlsSelectedOption = 1
  sumofwieghts = doGetCalibrationCurve_sumOfWeightedLeastSquared(ccX,ccY,wlsSelectedOption,ccWlsValues)
  expect_equal(doGetCalibrationCurve_weightedCaseSample(caseSampleMeanConcentration,caseSampleMeanPeakAreaRatio,n,sumofwieghts,wlsSelectedOption,ccWlsValues,caseSampleWeight), 1)
})

test_that('doGetCalibrationCurve_degreesOfFreedom', {
  expect_equal(doGetCalibrationCurve_degreesOfFreedom(ccY), 28)
})

test_that('doGetCalibrationCurve_weightedLeastSquared', {
  expect_equal(doGetCalibrationCurve_weightedLeastSquared(ccX,ccY,1,ccWlsValues), c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1))
})

test_that('doGetCalibrationCurve_sumOfWeightedLeastSquared', {
  expect_equal(doGetCalibrationCurve_sumOfWeightedLeastSquared(ccX,ccY,1,ccWlsValues), 30)
})

test_that('doGetCalibrationCurve_standardisedWeight', {
  expect_equal(doGetCalibrationCurve_standardisedWeight(ccWlsValues,n), c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1))
})

test_that('doGetCalibrationCurve_weightedLeastSquaredFunction', {
  expect_equal(doGetCalibrationCurve_weightedLeastSquaredFunction(1)(1), 1)
  expect_equal(doGetCalibrationCurve_weightedLeastSquaredFunction(2)(1), 1)
  expect_equal(doGetCalibrationCurve_weightedLeastSquaredFunction(3)(1), 1)
  expect_equal(doGetCalibrationCurve_weightedLeastSquaredFunction(4)(1), 1)
  expect_equal(doGetCalibrationCurve_weightedLeastSquaredFunction(5)(1), 1)
  expect_equal(is.null(doGetCalibrationCurve_weightedLeastSquaredFunction(999)), TRUE)
})

test_that('doGetCalibrationCurve_wlsLatex', {
  expect_equal(doGetCalibrationCurve_wlsLatex(1), "W=1")
  expect_equal(doGetCalibrationCurve_wlsLatex(2), "W=\\frac{1}{x}")
  expect_equal(doGetCalibrationCurve_wlsLatex(3), "W=\\frac{1}{x^2}")
  expect_equal(doGetCalibrationCurve_wlsLatex(4), "W=\\frac{1}{y}")
  expect_equal(doGetCalibrationCurve_wlsLatex(5), "W=\\frac{1}{y^2}")
  expect_equal(doGetCalibrationCurve_wlsLatex(999), "\\text{Custom}")
})

test_that('doGetCalibrationCurve_uncertaintyOfCalibration', {
  wlsSelectedOption = 1
  expect_equal(doGetCalibrationCurve_uncertaintyOfCalibration(ccX,ccY,wlsSelectedOption,customWls,exampleDataSeW,NA,NA,exampleDataSe,caseSampleReplicates,caseSampleMeanConcentration), 0.125190523965741)
})

test_that('doGetCalibrationCurve_pooledStdErrorOfRegression', {
  wlsSelectedOption = 1
  expect_equal(doGetCalibrationCurve_pooledStdErrorOfRegression(ccX,ccY,wlsSelectedOption,ccWlsStdValues,exampleDataCcW,exampleDataSe), 0.0814643186315265)
})


test_that('doGetCalibrationCurve_relativeStandardUncertainty', {
  wlsSelectedOption = 1
  expect_equal(doGetCalibrationCurve_relativeStandardUncertainty(ccX,ccY,1,NA,NA,NA,NA,exampleDataSe,2,3), 0.0417301746552471)
})




























# 
# 
# test_that('getSqDevation', {
#   expect_equal(getSqDevation(c(1,2,3,4,5)),      c(4,1,0,1,4))
#   expect_equal(getSqDevation(c(0,0,0,0,0)),      c(0,0,0,0,0))
#   expect_equal(getSqDevation(c(10,10,10,10,10)), c(0,0,0,0,0))
#   expect_equal(getSqDevation(c(-1,-2,-3,-4,-5)), c(4,1,0,1,4))
# })
# 
# test_that('getPredicetedY', {
#   expect_equal(getPredicetedY(c(1,2,3,4,5),c(1,2,3,4,5)),    c(1,2,3,4,5))
#   expect_equal(getPredicetedY(c(5,4,3,2,1),c(1,2,3,4,5)),    c(1,2,3,4,5))
#   expect_equal(getPredicetedY(c(1,1,1,1,1),c(1,2,3,4,5)),    c(3,3,3,3,3))
#   expect_equal(getPredicetedY(c(35,5,45,5,55),c(1,2,3,4,5)), c(3.11321,2.54717,3.30189,2.54717,3.49057))
# })
# 
# 
# test_that('getSlope', {
#   expect_equal(getSlope(c(1,2,3,4,5),c(1,2,3,4,5)),  1)
#   expect_equal(getSlope(c(1,2,3,4,5),c(1,1,1,1,1)),  0)
#   expect_equal(getSlope(c(1,2,3,4,5),c(0,3,6,9,12)), 3)
# })
# 
# 
# test_that('getIntercept', {
#   expect_equal(getIntercept(c(1,2,3,4,5),c(1,2,3,4,5)),  0)
#   expect_equal(getIntercept(c(1,2,3,4,5),c(2,3,4,5,6)),  1)
#   expect_equal(getIntercept(c(1,2,3,4,5),c(2,2,2,2,2)),  2)
#   expect_equal(getIntercept(c(1,2,3,4,5),c(0,1,2,3,4)),  -1)
# })
# 
# test_that('getErrorSqDevationY', {
#   #expect_equal(getErrorSqDevationY(c(1,2,3,4,5),c(1,2,3,4,5)),  c(0,0,0,0,0))
#   #do more tests here
# })
# 
# 
# test_that('getDegreesOfFreedom', {
#   expect_equal(getDegreesOfFreedom(c(1,1,1,1,1)), 3)
#   expect_equal(getDegreesOfFreedom(c(1)), -1)
# })
# 
# 
# test_that('getStandardErrorOfRegerssion', {
#   #expect_equal(getStandardErrorOfRegerssion(c(1,2,3,4,5),c(1,2,3,4,5)), 0)
#   #do more tests here
# })
# 
# test_that('getUncertaintyOfCalibration', {
#   #expect_equal(getUncertaintyOfCalibration(c(1,2,3,4,5),c(1,2,3,4,5)), 0)
#   #do more tests here
# })
# 
# test_that('getRelativeStandardUncertainty', {
#   #expect_equal(getRelativeStandardUncertainty(c(1,2,3,4,5),c(1,2,3,4,5)), 0)
#   #do more tests here
# })


