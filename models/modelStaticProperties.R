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

APP_DEV = "Leverhulme Research Centre for Forensic Science"
APP_DEV_SHORT = "LRCFS"
APP_NAME = "Measurement Uncertainty Calculator"
APP_NAME_SHORT = "MUCalc"
APP_VER = "3.2.0"
APP_LINK = "https://github.com/LRCFS/lrcfs-measurement-uncertainty-calculator"
APP_DOI_URL = "https://zenodo.org/badge/latestdoi/187221339"
APP_DOI_BAGE_URL = "https://zenodo.org/badge/187221339.svg"
APP_DOI_HTML = paste0("<a href='",APP_DOI_URL,"'><img src='",APP_DOI_BAGE_URL,"' alt='DOI Badge'/></a>")

#Properties used by formatNumber helperFunction
# numDecimalPlaces = 6
# useScientificNotationIfLessThan = 0.001
# numScientificNotationDigits = 2

#Default values for the user editable colours
# colour1 = "#3FA5BE"
# colour2 = "#FCA311"
# colour3 = "#8E0554"
# colour4 = "#007A3D"
# colour5 = "#DD4B39"
# colour6 = "#FF007F"
# colour7 = "#8F8F8F"
# colour8 = "#002DB2"
# colour9 = "#00D900"
colour1 = "#FC8003"
colour2 = "#009500"
colour3 = "#FD0000"
colour4 = "#6828A2"
colour5 = "#8C4600"
colour6 = "#D73FA9"
colour7 = "#4A4A4A"
colour8 = "#A0A200"
colour9 = "#00A3BB"
colour10 = "#003F95"

colour11 = "#005315" #Dark Green
colour12 = "#8A0900" #Dark Red
# colour13 = "#FD0000"
# colour14 = "#6828A2"
# colour15 = "#8C4600"
# colour16 = "#D73FA9"

caseSampleReplicatesColour =        "#00C0EF" #shiny "aqua"
caseSampleMeanConcentrationColour = "#F012BE" #shiny "fuchsia"
caseSampleMeanParColour =           "#FF851B" #shiny "orange"
caseSampleWeightColour =            "#DD4B39" #shiny "red"

CombinedUncertaintyColor =          '#605CA8' #shiny "purple"
CoverageFactorColor =               '#39CCCC' #shiny "teal"
CoverageFactorTableHighligthColor = '#D8F5F5'
HomogeneityColor =                  '#001f3f' #shiny "navy"
CalibrationCurveColor =             '#0073B7' #shiny "blue"
MethodPrecisionColor =              '#DD4B39' #shiny "red"
StandardSolutionColor =             '#00A65A' #shiny "green"
SamplePreparationColor =            '#D81B60' #shiny "maroon"


coverageFactorEffectiveDofTable = coverageFactorEffectiveDofReadCSV()