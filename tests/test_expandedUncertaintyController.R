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
context('Expanded Uncertainty Controller')

#Load in model that test are written against
source("../controllers/controllerExpandedUncertainty.R")

test_that("doGetExpandedUncertaintyResult", {
	coverageFactorResult = 5
	combinedUncertaintyResult = 5
	expect_equal(doGetExpandedUncertaintyResult(coverageFactorResult,combinedUncertaintyResult), 25)
})

test_that("doGetExpandedUncertaintyResultPercentage", {
	caseSampleMeanConcentration = 2
	coverageFactorResult = 4.5
	combinedUncertaintyResult = 0.138
	expect_equal(doGetExpandedUncertaintyResultPercentage(caseSampleMeanConcentration,coverageFactorResult,combinedUncertaintyResult), 31.05)
})