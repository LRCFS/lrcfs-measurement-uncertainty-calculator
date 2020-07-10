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

calibrationCurvePooledDataReadCSV = function(filePath = NULL, validate = FALSE) {
  #The columns that the data should have
  columnsToCheck = list("conc" = "Your data must contain information about the concentrations of each run.",
                        "run1" = "Your data must contain at least one run.")
  
  return(loadCsv(filePath, validate, columnsToCheck))
}

#data = calibrationCurvePooledDataReadCSV("D:\\Git\\lrcfs-measurement-of-uncertainty\\data\\calibrationCurve\\calibrationCurveSampleData - One Run - External Error 2.csv", TRUE);data
