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
context('Testing Homogeneity Controller')

#Load in model that test are written against
source("../dal/loadHelperMethods.R")
source("../dal/loadHomogeneityCSV.R")
source("../controllers/controllerHomogeneity.R")

exampleData = homogeneityReadCSV("../www/exampleData/exampleData-homogeneity.csv")

test_that("doGetHomogeneityNumCols", {
  expect_equal(doGetHomogeneityNumCols(exampleData), 10)
})

test_that("doGetHomogeneityNumWithin", {
  expectedResults = c(2,2,2,2,2,2,2,2,2,2)
  names(expectedResults) = colnames(exampleData)
  expect_equal(doGetHomogeneityNumWithin(exampleData), expectedResults)
})

test_that("doGetHomogeneityMeansWithin", {
  expectedResults = c(3.5385,3.524,3.5295,3.5035,3.4975,3.5125,3.541,3.4935,3.4965,3.499)
  names(expectedResults) = colnames(exampleData)
  expect_equal(doGetHomogeneityMeansWithin(exampleData), expectedResults)
})

test_that("doGetHomogeneityCalcs", {
  
  vial1 = c(0.000462250000000003,0.000462250000000003)
  vial2 = c(0.0000249999999999989,0.0000249999999999989)
  vial3 = c(0.0000302500000000007,0.0000302500000000007)
  vial4 = c(0.0000302500000000007,0.0000302499999999958)
  vial5 = c(0.000272249999999991,0.000272250000000006)
  vial6 = c(0.0000562500000000043,0.0000562499999999976	)
  vial7 = c(0.00176399999999998,0.00176400000000002)
  vial8 = c(0.000272249999999991,0.000272250000000006)
  vial9 = c(0.000210249999999999,0.000210249999999999	)
  vial10 = c(0.0000809999999999981,0.0000809999999999981)
  expectedResults = data.frame(vial1, vial2, vial3, vial4, vial5, vial6, vial7, vial8, vial9, vial10)

  expect_equivalent(doGetHomogeneityCalcs(exampleData), expectedResults)
})

test_that("doGetHomogeneitySumOfSquaredDeviation", {
  expectedResults = c(0.000924500000000006, 4.99999999999979e-05, 6.05000000000013e-05, 6.04999999999964e-05, 0.000544499999999997, 0.000112500000000002, 0.00352800000000001, 0.000544499999999997, 0.000420499999999998, 0.000161999999999996)
  names(expectedResults) = colnames(exampleData)
  expect_equal(doGetHomogeneitySumOfSquaredDeviation(exampleData), expectedResults)
})

test_that("doGetHomogeneitySumOfSquaresWithin", {
  expect_equal(doGetHomogeneitySumOfSquaresWithin(exampleData), 0.0064075)
})

test_that("doGetHomogeneityMeanSumOfSquaresWithin", {
  expect_equal(doGetHomogeneityMeanSumOfSquaresWithin(exampleData), 0.00064075)
})

test_that("doGetHomogeneitySumOfAllValues", {
  expect_equal(doGetHomogeneitySumOfAllValues(exampleData), 70.271)
})

test_that("doGetHomogeneityNumOfValues", {
  expect_equal(doGetHomogeneityNumOfValues(exampleData), 20)
})

test_that("doGetHomogeneitySumOfNjSquared", {
  expect_equal(doGetHomogeneitySumOfNjSquared(exampleData), 40)
})

test_that("doGetHomogeneityGrandMean", {
  expect_equal(doGetHomogeneityGrandMean(exampleData), 3.51355)
})

test_that("doGetexampleDataHomogeneityNumeratorBetween", {
  expectedResults = c(0.001245005,0.000218405000000003,0.000508805000000008,0.000202005000000005,0.000515205000000022,2.20499999999905e-06,0.00150700500000005,0.000804004999999992,0.000581404999999985,0.000423404999999991)
  names(expectedResults) = colnames(exampleData)
  expect_equal(doGetDataHomogeneityNumeratorBetween(exampleData), expectedResults)
})

test_that("doGetHomogeneitySumOfSquaresBetween", {
  expect_equal(doGetHomogeneitySumOfSquaresBetween(exampleData), 0.00600745000000005)
})

test_that("doGetHomogeneityMeanSumOfSquaresBetween", {
  expect_equal(doGetHomogeneityMeanSumOfSquaresBetween(exampleData), 0.00066749444444445)
})

test_that("doGetHomogeneityFValue", {
  expect_equal(doGetHomogeneityFValue(exampleData), 1.04173928122427)
})

test_that("doGetHomogeneity_standardUncertaintyA", {
  expect_equal(doGetHomogeneity_standardUncertaintyA(exampleData), 0.0036568049199028)
})

test_that("doGetHomogeneity_standardUncertaintyB", {
  expect_equal(doGetHomogeneity_standardUncertaintyB(exampleData), 0.0119697976448351)
})

test_that("doGetHomogeneity_standardUncertainty", {
  expect_equal(doGetHomogeneity_standardUncertainty(exampleData), 0.0119697976448351)
})

test_that("doGetHomogeneity_relativeStandardUncertainty", {
  expect_equal(doGetHomogeneity_relativeStandardUncertainty(exampleData), 0.00340675318263154)
})

test_that("calcHomogeneitySquares", {
  expect_equal(calcHomogeneitySquares(c(1,10,1)),c(9,36,9))
})

test_that("doGetHomogeneity_degreesOfFreedom", {
  expect_equal(doGetHomogeneity_degreesOfFreedom(exampleData), 9)
})
