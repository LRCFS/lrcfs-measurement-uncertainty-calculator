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
context('Combined Uncertainty Controller')

#Load in model that test are written against
source("../controllers/controllerCombinedUncertainty.R")

test_that("doGetCombinedUncertaintyResult", {
	meanConcentration = 1
	uncHomogeneity = 1
	uncCalibrationCurve = 1
	uncMethodPrecision = 1
	uncStandardSolution = 1
	uncSamplePreparation = 1
	expect_equal(doGetCombinedUncertaintyResult(meanConcentration, uncHomogeneity, uncCalibrationCurve, uncMethodPrecision, uncStandardSolution, uncSamplePreparation), 2.23606797749979)
	
	meanConcentration = 2
	uncHomogeneity = 2
	uncCalibrationCurve = 2
	uncMethodPrecision = 2
	uncStandardSolution = 2
	uncSamplePreparation = 2
	expect_equal(doGetCombinedUncertaintyResult(meanConcentration, uncHomogeneity, uncCalibrationCurve, uncMethodPrecision, uncStandardSolution, uncSamplePreparation), 8.944271909999159)
})