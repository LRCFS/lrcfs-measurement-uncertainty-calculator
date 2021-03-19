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
context('Standard Solution')

#Load in model that test are written against
source("../dal/loadHelperMethods.R")
source("../dal/loadStandardSolutionCSV.R")
source("../controllers/controllerStandardSolution.R")

structure = standardSolutionReadCSV("../www/exampleData/exampleData-calibrationStandard-structure.csv")
equipment = standardSolutionMeasurementsReadCSV("../www/exampleData/exampleData-calibrationStandard-equipment.csv")

instrumentDataWithCalculations = doGetstandardSolutionInstrumentDataWithCalculations(equipment)
solutionDataWithCalculations = doGetStandardSolutionDataWithCalculations(structure, instrumentDataWithCalculations)

test_that("doGetBaseSolution", {
  solution  = "Ref. Std. Solution"
  madeFrom  = ""
  compoundPurity  = 1000000
  compoundTolerance  = 33000
  compoundCoverage  = 2
  standardUncertainty = 16500
  relativeStandardUncertainty = 0.0165
  expectedResults = data.frame(solution,madeFrom,compoundPurity,compoundTolerance,compoundCoverage,standardUncertainty,relativeStandardUncertainty)
  
  expect_equivalent(doGetBaseSolution(solutionDataWithCalculations), expectedResults)
})

test_that("doGetFinalSolutions", {
  solution  = c("Calibrators Range 1","Calibrators Range 2")
  expect_equivalent(doGetFinalSolutions(solutionDataWithCalculations)$solution, solution)
})

test_that("doGetRelativeStandardUncertaintyOfCalibrationSolutions", {
  finalSolutionsData = doGetFinalSolutions(solutionDataWithCalculations)
  expect_equal(doGetRelativeStandardUncertaintyOfCalibrationSolutions(finalSolutionsData), 0.0370551390947778)
})

test_that("doGetUsageUncertainty", {
  expect_equal(doGetUsageUncertainty(instrumentDataWithCalculations), c(3.600000e-05,1.250000e-05,9.000000e-06,4.375000e-05,2.250000e-06,2.083333e-06,3.240000e-04,9.000000e-06,3.125000e-05,2.520000e-04,2.700000e-05,3.125000e-05))
})

test_that("doGetRealtiveStandardUncertaintyForSolution", {
  expect_equal(doGetRealtiveStandardUncertaintyForSolution("Stock Solution A", solutionDataWithCalculations, instrumentDataWithCalculations), 0.0179094946885723)
})

test_that("doGetStandardUncertaintySS", {
  expect_equal(doGetStandardUncertaintySS(2, 4), 0.5)
  expect_equal(doGetStandardUncertaintySS(25, NA), 14.4337567297406)
})

test_that("doGetRelativeStandardUncertaintySS", {
  expect_equal(doGetRelativeStandardUncertaintySS(1, 1), 1)
  expect_equal(doGetRelativeStandardUncertaintySS(1, 2), 0.5)
})