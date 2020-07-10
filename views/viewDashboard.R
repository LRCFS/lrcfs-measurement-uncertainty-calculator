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

tabDashboard = tabItem(tabName = "dashboard", 
                       fluidRow(
                         infoBox(HTML("Case Sample<br />Replicates \\((r_s)\\)"),HTML(paste(uiOutput("display_dashboard_replicates"))), width=3, icon=icon("vials"), color="aqua"),
                         infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_dashboard_meanConcentration"))), width=3, icon=icon("map-marker"), color="fuchsia"),
                         uiOutput("display_dashboard_meanPar"),
                         infoBox("Confidence Interval\\(({\\small CI\\%})\\)",HTML(paste(uiOutput("display_dashboard_confidenceInterval"))), width=3, icon=icon("percentage"), color="yellow")
                       ),
                       fluidRow(
                         valueBox("Uncertainty of Calibration Curve", uiOutput("display_calibrationCurve_finalAnswer_dashboard"), width = 6, color = "blue", icon = icon("chart-line")),
                         valueBox("Uncertainty of Method Precision", uiOutput("display_methodPrecision_finalAnswer_dashboard"), width = 6, color = "red", icon = icon("bullseye")),
                         valueBox("Uncertainty of Standard Solution", uiOutput("display_standardSolution_finalAnswer_dashboard"), width = 6, color = "green", icon = icon("flask")),
                         valueBox("Uncertainty of Sample Volume", uiOutput("display_sampleVolume_finalAnswer_dashboard"), width = 6, color = "maroon", icon = icon("vial")),
                         valueBox("Combined Uncertainty", uiOutput("display_combinedUncertainty_finalAnswer_dashboard"), width = 6, color = "purple", icon = icon("arrows-alt-v")),
                         valueBox("Coverage Factor", uiOutput("display_coverageFactor_finalAnswer_dashboard"), width = 6, color = "teal", icon = icon("table")),
                         valueBox("Expanded Uncertainty", uiOutput("display_expandedUncertainty_finalAnswer_dashboard"), width = 6, color = "orange", icon = icon("arrows-alt")),
                         valueBox("% Expanded Uncertainty", uiOutput("display_expandedUncertainty_finalAnswerPercentage_dashboard"), width = 6, color = "orange", icon = icon("arrows-alt"))
                       )
)
