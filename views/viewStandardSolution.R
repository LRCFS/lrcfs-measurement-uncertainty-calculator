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

tabStandardSolution = tabItem(tabName = "standardSolution",
                              fluidRow(
                                valueBox("Uncertainty of Standard Solution", h2(uiOutput("display_standardSolution_finalAnswer_top")), width = 12, color = "green", icon = icon("flask"))
                              ),
                              fluidRow(
                                box(title = "Overview", width=5,
                                    p("Information provided on the structure of solution preparation and details of used equipment is displayed here, along with a step-by-step calculation of the uncertainty associated with spiking the calibration standards."),
                                    p("The solution structure is displayed using a network or tree diagram with the root assumed to be the reference compound and the final nodes are assumed to be the spiking range for calibrators used in generating the calibration curve."),
                                    p("If more than one spiking range exists (which may be due to splitting the range of the calibration curve), the uncertainty associated with standard solution is computed by pooling the relative standard uncertainties associated with preparing solutions and spiking the calibration curve.")
                                ),
                                box(title = "Method", width=7,
                                    "The RSU of each equipment is computed using:",
                                    "$$u_r(\\text{Equipment}) = \\frac{\\frac{\\text{Tolerance}}{\\text{Coverage Factor}}}{\\text{Volume}}$$",
                                    "The RSU of reference compound is calculated using:",
                                    "$$u_r(\\text{Reference Compound}) = \\frac{\\frac{\\text{Tolerance}}{\\text{Coverage Factor}}}{\\text{Purity}}$$",
                                    "The RSU of each solution is computed using:",
                                    "$$u_r\\text{(Solution)} = \\sqrt{u_r\\text{(Parent Solution)}^2 + \\sum{[u_r\\text{(Equipment)}^2_{\\text{(Vol,Tol)}} \\times N\\text{(Equipment)}_{\\text{(Vol,Tol)}}]}}$$",
                                    "The RSU of standard (spiking) solution is obtained by pooling the RSU's of the calibration curve spiking range.",
                                    "$$u_r(\\text{StdSolution}) = \\sqrt{\\sum{u_r\\text{(Calibration Curve Spiking Range)}^2}}$$",
                                    tags$ul(
                                      tags$li("\\(\\text{Parent Solution}\\) is the solution from which a given solution is made."),
                                      tags$li("\\(N\\text{(Equipment)}\\) is the number of times a piece of equipment is used in the preparation of a given solution.")
                                    )
                                )
                              ),
                              fluidRow(
                                tabBox(width=12, side="right",
                                       title = "Loaded Data",
                                       tabPanel("Solutions Network",
                                                grVizOutput("display_standardSolution_solutionsNetwork")
                                       ),
                                       tabPanel("Raw Structure Data",
                                                DT::dataTableOutput("display_standardSolution_solutionRawData")
                                       ),
                                       tabPanel("Raw Equipment Data",
                                                DT::dataTableOutput("display_standardSolution_measurementsRawData")
                                       )
                                )
                              ),
                              fluidRow(
                                box(width=6, side="right",
                                    title = "Standard Uncertainty \\((u)\\)",
                                    uiOutput("display_standardSolution_equipmentStandardUncertainty")
                                ),
                                box(width=6, side="right",
                                    title = "Relative Standard Uncertainty \\((u_r)\\)",
                                    uiOutput("display_standardSolution_equipmentRelativeStandardUncertainty")
                                )
                              ),
                              fluidRow(
                                box(width=12, side="right",
                                    title = "Relative Standard Uncertainty of Solutions",
                                    uiOutput("display_standardSolution_solutionRelativeStandardUncertainty")
                                )
                              ),
                              fluidRow(
                                box(title="Overall Relative Standard Uncertainty of Standard Solution", width = 12, background = "green", solidHeader = TRUE,
                                    uiOutput("display_standardSolution_finalAnswer_bottom")
                                )
                              )
)
