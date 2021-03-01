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
  expect_equal(doGetHomogeneityNumCols(exampleData), 11)
})

test_that("doGetHomogeneityNumWithin", {
  expectedResults = c(3,3,3,3,3,3,3,3,3,2,3)
  names(expectedResults) = colnames(exampleData)
  expect_equal(doGetHomogeneityNumWithin(exampleData), expectedResults)
})

test_that("doGetHomogeneityNumWithinMax", {
  expect_equal(doGetHomogeneityNumWithinMax(exampleData), 3)
})

test_that("doGetHomogeneityMeansWithin", {
  expectedResults = c(2.058,1.88833333333333,2.15866666666667,2.07066666666667,2.023,1.80733333333333,1.959,1.78833333333333,1.84866666666667,1.927,1.83166666666667)
  names(expectedResults) = colnames(exampleData)
  expect_equal(doGetHomogeneityMeansWithin(exampleData), expectedResults)
})

test_that("doGetHomogeneityCalcs", {
  
  vial1 = c(0.0196,0.00489999999999998,0.00489999999999998)
  vial2 = c(0.0040111111111111,0.00100277777777778,0.00100277777777778)
  vial3 = c(0.000215111111111103,0.000053777777777779,0.000053777777777779)
  vial4 = c(0.00139377777777777,0.000348444444444451,0.000348444444444451	)
  vial5 = c(0.00176400000000002,0.000440999999999996,0.000440999999999996)
  vial6 = c(0.00000711111111111073,0.00000177777777777798,0.00000177777777777798)
  vial7 = c(0.001156,0.000289000000000004,0.000289000000000004	)
  vial8 = c(0.00165377777777777,0.000413444444444444,0.000413444444444444)
  vial9 = c(0.00392711111111111,0.00098177777777777,0.00098177777777777)
  vial10 = c(0.013689,0.013689,NA)
  vial11 = c(0.000373777777777773,0.0000934444444444453,0.0000934444444444453)
  expectedResults = data.frame(vial1, vial2, vial3, vial4, vial5, vial6, vial7, vial8, vial9, vial10, vial11)

  expect_equivalent(doGetHomogeneityCalcs(exampleData), expectedResults)
})

test_that("doGetHomogeneitySumOfSquaredDeviation", {
  expectedResults = c(0.0294, 0.00601666666666666, 0.000322666666666661, 0.00209066666666667, 0.00264600000000001, 1.06666666666667e-05, 0.00173400000000001, 0.00248066666666666, 0.00589066666666665, 0.027378, 0.000560666666666663)
  names(expectedResults) = colnames(exampleData)
  expect_equal(doGetHomogeneitySumOfSquaredDeviation(exampleData), expectedResults)
})

test_that("doGetHomogeneitySumOfSquaresWithin", {
  expect_equal(doGetHomogeneitySumOfSquaresWithin(exampleData), 0.0785306666666667)
})

test_that("doGetHomogeneityMeanSumOfSquaresWithin", {
  expect_equal(doGetHomogeneityMeanSumOfSquaresWithin(exampleData), 0.00373955555555555)
})

test_that("doGetHomogeneitySumOfAllValues", {
  expect_equal(doGetHomogeneitySumOfAllValues(exampleData), 62.155)
})

test_that("doGetHomogeneityGrandMean", {
  expect_equal(doGetHomogeneityGrandMean(exampleData), 1.94234375)
})

test_that("doGetexampleDataHomogeneityNumeratorBetween", {
  expectedResults = c(0.0401291044921874,0.00875137532552089,0.140386812825521,0.049400312825521,0.0195162919921873,0.0546834378255208,0.000832291992187504,0.0711576253255209,0.0263261878255208,0.000470861328124999,0.0367482503255208)
  names(expectedResults) = colnames(exampleData)
  expect_equal(doGetDataHomogeneityNumeratorBetween(exampleData), expectedResults)
})

test_that("doGetHomogeneitySumOfSquaresBetween", {
  expect_equal(doGetHomogeneitySumOfSquaresBetween(exampleData), 0.448402552083333)
})

test_that("doGetHomogeneityMeanSumOfSquaresBetween", {
  expect_equal(doGetHomogeneityMeanSumOfSquaresBetween(exampleData), 0.0448402552083333)
})

test_that("doGetHomogeneityFValue", {
  expect_equal(doGetHomogeneityFValue(exampleData), 11.9907979817863)
})

test_that("doGetHomogeneity_standardUncertainty", {
  expect_equal(doGetHomogeneity_standardUncertainty(exampleData), 0.117047995359137)
})

test_that("doGetHomogeneity_relativeStandardUncertainty", {
  expect_equal(doGetHomogeneity_relativeStandardUncertainty(exampleData), 0.0602612155336238)
})

test_that("calcHomogeneitySquares", {
  expect_equal(calcHomogeneitySquares(c(1,10,1)),c(9,36,9))
})

test_that("doGetHomogeneity_degreesOfFreedom", {
  expect_equal(doGetHomogeneity_degreesOfFreedom(exampleData), 31)
})
