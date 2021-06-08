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
source("../controllers/controllerCalibrationCurve.R")
source("../controllers/controllerCalibrationCurveQuadratic.R")

exampleData = calibrationCurveReadCSV("../www/exampleData/exampleData-calibrationCurve-quadratic.csv")
exampleDataReformatted = doGetDataCalibrationCurveReformatted(exampleData)

caseSampleReplicates = 2
caseSampleMeanConcentration = 3

empty=c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

# test_that('doGetCalibrationCurveQuadratic_regression', {
#   
# })
# test_that('doGetCalibrationCurveQuadratic_intercept', {
# 
# })
# test_that('doGetCalibrationCurveQuadratic_slopeB1', {
# 
# })
# test_that('doGetCalibrationCurveQuadratic_slopeB2', {
#   
# })
# test_that('doGetCalibrationCurveQuadratic_rSquaredAdjusted', {
#   
# })
# test_that('doGetCalibrationCurveQuadratic_xSquared', {
# 
# })
# test_that('doGetCalibrationCurveQuadratic_yHat', {
# 
# })
# test_that('doGetCalibrationCurveQuadratic_yResidual', {
#   
# })
# test_that('doGetCalibrationCurveQuadratic_sumOfX', {
#   
# })
# test_that('doGetCalibrationCurveQuadratic_meanOfX', {
#   
# })
# test_that('doGetCalibrationCurveQuadratic_sumOfY', {
#   
# })
# test_that('doGetCalibrationCurveQuadratic_meanOfY', {
#   
# })
# test_that('doGetCalibrationCurveQuadratic_sumOfResiduals', {
#   
# })
test_that('doGetCalibrationCurveQuadratic_standardErrorOfRegression', {
  expect_equal(doGetCalibrationCurveQuadratic_standardErrorOfRegression(exampleDataReformatted), 0.156217761071475)
})

# 
# test_that('doGetCalibrationCurveQuadratic_designMatrix', {
#   
# })
# 
# test_that('doGetCalibrationCurveQuadratic_designMatrixTransposed', {
#   
# })
# 
# test_that('doGetCalibrationCurveQuadratic_designMatrixMultiply', {
#   
# })
# 
# 
# test_that('doGetCalibrationCurveQuadratic_designMatrixMultiplyInverse', {
#   
# })
# 
# test_that('doGetCalibrationCurveQuadratic_covarianceMatrix', {
# 
# })



