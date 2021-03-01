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
context('Testing Coverage Factor')

#Load in model that test are written against
source("../controllers/controllerCoverageFactor.R")

test_that("getEffectiveDegreesOfFreedom", {
  #expect_equal(getEffectiveDegreesOfFreedom(uncHomogeneity,dofHomogeneity,uncCalibrationCurve,dofCalibrationCurve,uncMethodPrecision,dofMethodPrecision,uncStandardSolution,dofStandardSolution,uncSamplePreparation,dofSamplePreparation,combinedUncertainty,meanCaseSampleConcentration), 11)
  expect_equal(getEffectiveDegreesOfFreedom(1,1,1,1,1,1,1,1,1,1,1,1), 0.2)
  expect_equal(getEffectiveDegreesOfFreedom(0,0,0,0,0,0,0,0,0,0,0,0), NaN)
  expect_equal(getEffectiveDegreesOfFreedom(0,0,0,0,0,0,0,0,0,0,1,0), Inf)
  expect_equal(getEffectiveDegreesOfFreedom(1,2,3,4,5,6,7,8,9,10,3,2), 0.00468255)
  expect_equal(getEffectiveDegreesOfFreedom(NA,NA,NA,NA,NA,NA,NA,NA,1,Inf,3,2), Inf)
})