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
context('Testing modelStandardSolution.R functions')

#Load in model that tests are written against
source("../dal/loadStandardSolutionCSV.R")
source("../models/modelApplication.R")
source("../models/modelStandardSolution.R")

# testData = standardSolutionReadCSV("../data/standardSolution/standardSolutionSampleData-compoundAndSolutions.csv", "../data/standardSolution/standardSolutionSampleData-measurementInformation.csv");

test_that('getStandardUncertainty_solution', {
  expect_equal(getStandardUncertainty_solution(33000,2),16500)
  expect_equal(getStandardUncertainty_solution(33000,0),19052.559)
  expect_equal(getStandardUncertainty_solution(33000,NA),19052.559)
  expect_equal(getStandardUncertainty_solution(33000),19052.559)
  expect_equal(getStandardUncertainty_solution(33000,),19052.559)
  expect_equal(getStandardUncertainty_solution(33000,""),19052.559)
})

test_that('getRelativeStandardUncertainty_solution', {
  expect_equal(getRelativeStandardUncertainty_solution(16500, 1000000),0.0165)
})

# test_that('getRsu_solution', {
#   print("testing 1232")
#   expect_equal(getTest(testData),1)
# })





