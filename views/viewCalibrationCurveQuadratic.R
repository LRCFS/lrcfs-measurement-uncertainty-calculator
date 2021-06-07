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

tabCalibrationCurveQuadratic = tabItem(tabName = "calibrationCurveQuadratic",
                                       fluidRow(
                                         valueBox("Uncertainty of Calibration Curve (Quadratic Fit)", h2(textOutput("display_calibrationCurveQuadratic_finalAnswer_top")), width = 12, color = "blue", icon = icon("chart-line")),
                                         actionButton("helpCalibrationCurveQuadratic", "Help", icon=icon("question"), class="pageHelpTop")
                                       ),
                                       fluidRow(
                                         box(title = "Overview", width=6,
                                             p("Overview description")
                                         ),
                                         box(title = "Method", width=6,
                                             p("Method description")
                                         )
                                       ),
                                       fluidRow(
                                         tabBox(width=12, side="right",
                                                title = uiOutput("display_calibrationcurveQuadratic_rawDataStats"),
                                                tabPanel("Graph",
                                                         plotlyOutput("display_calibrationcurveQuadratic_rawDataGraph")
                                                ),
                                                tabPanel("Raw Data",
                                                         DT::dataTableOutput("display_calibrationcurveQuadratic_rawData")
                                                )
                                         )
                                       ),
                                       fluidRow(
                                         infoBox(HTML("Case Sample<br />Replicates \\((r_s)\\)"),HTML(paste(uiOutput("display_calibrationCurveQuadratic_replicates"))), width=4, icon=icon("vials"), color="aqua"),
                                         infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_calibrationCurveQuadratic_meanConcentration"))), width=4, icon=icon("map-marker"), color="fuchsia"),
                                       ),
                                       fluidRow(
                                         box(title = "Step by Step Calculations", width=12,
                                             DT::dataTableOutput('display_calibrationcurveQuadratic_rearrangedData'),
                                             fluidRow(
                                               uiOutput("display_calibrationcurveQuadratic_quadraticRegression"),
                                               uiOutput("display_calibrationcurveQuadratic_meanOfX"),
                                               uiOutput("display_calibrationcurveQuadratic_meanOfY")
                                             ),
                                             fluidRow(
                                               uiOutput("display_calibrationCurveQuadratic_errorSumSqY")),
                                             uiOutput("display_calibrationCurveQuadratic_standardErrorOfRegression")
                                         )
                                       ),
                                       fluidRow(
                                         box(title="Uncertainty of Calibration \\((u)\\)", width = 12,
                                             uiOutput("display_calibrationCurveQuadratic_uncertaintyOfCalibration")
                                         )
                                       ),
                                       fluidRow(
                                         box(title="Relative Standard Uncertainty \\((u_r)\\)", width = 12, background = "blue", solidHeader = TRUE,
                                             uiOutput("display_calibrationCurveQuadratic_finalAnswer_bottom")
                                         )
                                       )
                                       
)