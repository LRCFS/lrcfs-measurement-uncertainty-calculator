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
context('Sample Preparation Controller')

#Load in model that test are written against
source("../dal/loadHelperMethods.R")
source("../dal/loadSamplePreparationCSV.R")
source("../controllers/controllerSamplePreparation.R")

exampleData = samplePreparationReadCSV("../www/exampleData/exampleData-samplePreparation.csv")

test_that("doGetSamplePreparation_standardUncerainty", {
  expect_equal(doGetSamplePreparation_standardUncerainty(exampleData), 2.5)
})

test_that("doGetSamplePreparation_relativeStandardUncertainty", {
  expect_equal(doGetSamplePreparation_relativeStandardUncertainty(exampleData), 0.0025)
})

test_that("doGetSamplePreparation_result", {
  expect_equal(doGetSamplePreparation_result(exampleData), 0.0025)
})