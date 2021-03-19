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
context('Method Precision Controller')

#Load in model that test are written against
source("../dal/loadHelperMethods.R")
source("../dal/loadMethodPrecisionCSV.R")
source("../controllers/controllerMethodPrecision.R")

exampleData = methodPrecisionReadCSV("../www/exampleData/exampleData-methodPrecision.csv")
exampleDataWithCalculations = doGetMethodPrecisionDataWithCalculations(exampleData, 2, 3)

test_that("calcMethodPrecisionDof", {
  expect_equal(calcMethodPrecisionDof(c(1,1)), 1)
})

test_that("getMethodPrecisionFinalAnswerClosestConcentration", {
  expect_equal(getMethodPrecisionFinalAnswerClosestConcentration(exampleDataWithCalculations, 1), 2)
  expect_equal(getMethodPrecisionFinalAnswerClosestConcentration(exampleDataWithCalculations, 2), 2)
  expect_equal(getMethodPrecisionFinalAnswerClosestConcentration(exampleDataWithCalculations, 3), 2)
  expect_equal(getMethodPrecisionFinalAnswerClosestConcentration(exampleDataWithCalculations, 3.5), 2) # should go down to 2 rather than up to 5
  expect_equal(getMethodPrecisionFinalAnswerClosestConcentration(exampleDataWithCalculations, 4), 5)
  expect_equal(getMethodPrecisionFinalAnswerClosestConcentration(exampleDataWithCalculations, 5), 5)
  expect_equal(getMethodPrecisionFinalAnswerClosestConcentration(exampleDataWithCalculations, 6), 5)
  expect_equal(getMethodPrecisionFinalAnswerClosestConcentration(exampleDataWithCalculations, 7), 5)
  expect_equal(getMethodPrecisionFinalAnswerClosestConcentration(exampleDataWithCalculations, 8), 10)
  expect_equal(getMethodPrecisionFinalAnswerClosestConcentration(exampleDataWithCalculations, 9), 10)
  expect_equal(getMethodPrecisionFinalAnswerClosestConcentration(exampleDataWithCalculations, 10), 10)
  expect_equal(getMethodPrecisionFinalAnswerClosestConcentration(exampleDataWithCalculations, 11), 10)
})

test_that("getMethodPrecisionFinalAnswer", {
  expect_equal(getMethodPrecisionFinalAnswer(exampleDataWithCalculations,2), 0.0248847910305698)
})
 
test_that("getMethodPrecisionDof", {
  expect_equal(getMethodPrecisionDof(exampleDataWithCalculations,2), 22)
  expect_equal(getMethodPrecisionDof(exampleDataWithCalculations,5), 22)
  expect_equal(getMethodPrecisionDof(exampleDataWithCalculations,10), 20)
})

test_that("getPooledStandardDeviation", {
  expect_equal(getPooledStandardDeviation(exampleDataWithCalculations,2), 0.0683169973082257)
  expect_equal(getPooledStandardDeviation(exampleDataWithCalculations,5), 0.104121141566985)
  expect_equal(getPooledStandardDeviation(exampleDataWithCalculations,10), 0.225248270433612)
})

test_that("getStandardUncertainty", {
  expect_equal(getStandardUncertainty(exampleDataWithCalculations,2), 0.0483074120669495)
  expect_equal(getStandardUncertainty(exampleDataWithCalculations,5), 0.0736247652668996)
  expect_equal(getStandardUncertainty(exampleDataWithCalculations,10), 0.159274579474148)
})

test_that("getRealtiveStandardUncertainty", {
  expect_equal(getRealtiveStandardUncertainty(exampleDataWithCalculations,2),0.0248847910305698)
  expect_equal(getRealtiveStandardUncertainty(exampleDataWithCalculations,5),0.0154413375309523)
  expect_equal(getRealtiveStandardUncertainty(exampleDataWithCalculations,10),0.0163374758907372)
})

test_that("getConcentrations", {
  expect_equal(getConcentrations(exampleDataWithCalculations), c(2,5,10))
})

test_that("getNumberOfConcentrations", {
  expect_equal(getNumberOfConcentrations(exampleData), 3)
})

test_that("getNumberOfRuns", {
  expect_equal(getNumberOfRuns(exampleData), 11)
})

test_that("getSumDofForConcentration", {
  expect_equal(getSumDofForConcentration(exampleDataWithCalculations,2), 22)
  expect_equal(getSumDofForConcentration(exampleDataWithCalculations,5), 22)
  expect_equal(getSumDofForConcentration(exampleDataWithCalculations,10), 20)
})

test_that("getMeanConcForNv", {
  expect_equal(getMeanConcForNv(exampleDataWithCalculations,2), 1.94124242424242)
  expect_equal(getMeanConcForNv(exampleDataWithCalculations,5), 4.7680303030303)
  expect_equal(getMeanConcForNv(exampleDataWithCalculations,10), 9.74903225806452)
})

test_that("getSumPooledStandardDeviationNumeratorForConcentration", {
  expect_equal(getSumPooledStandardDeviationNumeratorForConcentration(exampleDataWithCalculations,2), 0.102678666666667)
  expect_equal(getSumPooledStandardDeviationNumeratorForConcentration(exampleDataWithCalculations,5), 0.238506666666667)
  expect_equal(getSumPooledStandardDeviationNumeratorForConcentration(exampleDataWithCalculations,10), 1.01473566666667)
})

