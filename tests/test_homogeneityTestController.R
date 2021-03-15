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
context('Testing Homogeneity Test Controller')

#Load in model that test are written against
source("../dal/loadHelperMethods.R")
source("../dal/loadHomogeneityCSV.R")
source("../controllers/controllerHomogeneityTest.R")

exampleData = homogeneityReadCSV("../www/exampleData/exampleData-homogeneity.csv")

test_that("doGetHomogeneityTestAlphaValue", {
  expect_equal(doGetHomogeneityTestAlphaValue(NA), 0.05)
  expect_equal(doGetHomogeneityTestAlphaValue("TEST"), 0.05)
  expect_equal(doGetHomogeneityTestAlphaValue(0.999), 0.999)
  expect_equal(doGetHomogeneityTestAlphaValue(0.9991), 0.999)
  expect_equal(doGetHomogeneityTestAlphaValue(0.001), 0.001)
  expect_equal(doGetHomogeneityTestAlphaValue(0.0009), 0.001)
  expect_equal(doGetHomogeneityTestAlphaValue(0.5), 0.5)
})

test_that("doGetHomogeneityTestConfidenceLevel", {
  expect_equal(doGetHomogeneityTestConfidenceLevel(NA), 95)
  expect_equal(doGetHomogeneityTestConfidenceLevel("TEST"), 95)
  expect_equal(doGetHomogeneityTestConfidenceLevel(0.999), 0.1)
  expect_equal(doGetHomogeneityTestConfidenceLevel(0.9991), 0.1)
  expect_equal(doGetHomogeneityTestConfidenceLevel(0.001), 99.9)
  expect_equal(doGetHomogeneityTestConfidenceLevel(0.0009), 99.9)
  expect_equal(doGetHomogeneityTestConfidenceLevel(0.5), 50)
})

test_that("doGetHomogeneityTestWithinDof", {
  expect_equal(doGetHomogeneityTestWithinDof(exampleData), 10)
})

test_that("doGetHomogeneityTestBetweenDof", {
  expect_equal(doGetHomogeneityTestBetweenDof(exampleData), 9)
})

test_that("doGetHomogeneityTestFCritical", {
  expect_equal(doGetHomogeneityTestFCritical(exampleData, 0.05), 3.02038294702137)
})

test_that("doGetHomogeneityTestPass", {
  expect_equal(doGetHomogeneityTestPass(exampleData, 0.05), TRUE)
})