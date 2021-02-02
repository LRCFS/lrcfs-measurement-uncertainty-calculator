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

########################################
######### Start Page        ############
########################################
observeEvent(input$help_start_start, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 1)
})

observeEvent(input$help_start_calcurve, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 2)
})

observeEvent(input$help_start_methodprec, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 3)
})

observeEvent(input$help_start_stdsol, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 4)
})

observeEvent(input$help_start_sampleprep, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 5)
})

observeEvent(input$help_start_weightedLeastSquare, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 6)
})

observeEvent(input$help_start_caseSampleData, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 7)
})

observeEvent(input$help_start_confidenceInterval, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 8)
})


########################################
######### Calibration Curve ############
########################################
observeEvent(input$helpCalibrationCurve, {
  session$sendCustomMessage(type = 'runjs_help_calibrationCurve', message = 1)
})