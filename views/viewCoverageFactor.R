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

tabCoverageFactor = tabItem(tabName = "coverageFactor",
                 fluidRow(
                   valueBox("Coverage Factor", h2(uiOutput("display_coverageFactor_finalAnswer_top")), width = 12, color = "teal", icon = icon("table"))
                 ),
                 fluidRow(
                   box(title = "Overview", width=6,
                       p("Coverage factor \\((k)\\) is a number usually greater than one from which an expanded uncertainty is obtained when \\(k\\) is multiplied by a combined standard uncertainty. To determine a suitable coverage factor, a specified level of confidence is required along with knowledge about the degrees of freedom of all uncertainty components.  "),
                       p("An effective degrees of freedom is computed using the Welch-Satterthwaite equation with details given in the Method tab. The derived effective degrees of freedom along with the specified \\({\\small CI\\%}\\) is used to read a value (termed coverage factor) from the t-distribution table.")                   ),
                   box(title = "Method", width=6,
                       HTML("<p>The effective degrees of freedom \\(({\\LARGE\\nu}_{\\text{eff}})\\) using Welch-Satterthwaite approximation for <em>relative</em> standard uncertainty is given by:</p>"),
                       p("$${\\LARGE\\nu}_{\\text{eff}} =\\frac{(\\frac{\\text{CombUncertainty}}{x_s})^4}{\\sum{\\frac{u_r\\text{(Individual Uncertainty Component)}^4}{{\\LARGE\\nu}_{\\text{(Individual Uncertainty Component)}}}}}$$"),
                       p("The coverage factor \\((k_{{\\large\\nu}_{\\text{eff}}, {\\small CI\\%}})\\) is read from the t-distribution table using the calculated \\({\\Large\\nu}_{\\text{eff}}\\) and specified \\({\\small CI\\%}\\)."),
                       p(" "),
                       tags$ul(
                         tags$li("\\(x_s\\) is the Case Sample Mean Concentration."),
                         tags$li("\\(\\nu\\) is the Degrees of Freedom for each uncertainty component."),
                         tags$li("\\({\\small\\text{CombUncertainty}}\\) is the Combined Uncertainty of the individual uncertainty components.")
                       )
                   )
                 ),
                 fluidRow(
                   valueBox(uiOutput("display_homogeneity_finalAnswer_coverageFactor"),"\\(u_r\\text{(Homogeneity)}\\)", width = 4, color = "navy", icon = icon("mortar-pestle")),
                   valueBox(uiOutput("display_calibrationCurve_finalAnswer_coverageFactor"),"\\(u_r\\text{(CalCurve)}\\)", width = 4, color = "blue", icon = icon("chart-line")),
                   valueBox(uiOutput("display_methodPrecision_finalAnswer_coverageFactor"),"\\(u_r\\text{(MethodPrec)}\\)", width = 4, color = "red", icon = icon("bullseye"))
                 ),
                 fluidRow(
                   valueBox(uiOutput("display_standardSolution_finalAnswer_coverageFactor"),"\\(u_r\\text{(StdSolution)}\\)", width = 4, color = "green", icon = icon("vial")),
                   valueBox(uiOutput("display_samplePreparation_finalAnswer_coverageFactor"),"\\(u_r\\text{(SamplePreparation)}\\)", width = 4, color = "maroon", icon = icon("flask")),
                   valueBox(uiOutput("display_combinedUncertainty_finalAnswer_coverageFactor"),"\\(\\text{CombUncertainty}\\)", width = 4, color = "purple", icon = icon("arrows-alt-v"))
                 ),
                 fluidRow(
                   infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_coverageFactor_meanConcentration"))), width=3, icon=icon("map-marker"), color="fuchsia"),
                   infoBox("Confidence Interval\\(({\\small CI\\%})\\)",HTML(paste(uiOutput("display_coverageFactor_confidenceInterval"))), width=3, icon=icon("percentage"), color="yellow")
                 ),
                 fluidRow(
                   box(width=3, side="right",
                       title = "Degrees of Freedom of Homogeneity",
                       uiOutput("display_coverageFactor_dofHomogeneity")
                   ),
                   box(width=3, side="right",
                       title = "Degrees of Freedom of Calibration Curve",
                       uiOutput("display_coverageFactor_dofCalibrationCurve")
                   ),
                   box(width=3, side="right",
                       title = "Degrees of Freedom of Method Precision",
                       uiOutput("display_coverageFactor_dofMethodPrecision")
                   ),
                   box(width=3, side="right",
                       title = "Degrees of Freedom of Standard Solution",
                       uiOutput("display_coverageFactor_dofStandardSolution")
                   ),
                   box(width=3, side="right",
                       title = "Degrees of Freedom of Sample Preparation",
                       uiOutput("display_coverageFactor_dofSamplePreparation")
                   ),
                 ),
                 fluidRow(
                   box(width=12, side="right",
                       title = "Effective Degrees of Freedom",
                       uiOutput("display_coverageFactor_effectiveDegreesOfFreedom")
                   )
                 ),
                 fluidRow(
                   box(width=12, side="right",
                       title = "Lookup Coverage Factor \\((k)\\)",
                       DT::dataTableOutput('display_coverageFactor_table')
                   )
                 ),
                 fluidRow(
                   box(width=12, side="right",
                       title = "Coverage Factor", background = "teal", solidHeader = TRUE,
                       uiOutput("display_coverageFactor_finalAnswer_bottom")
                   )
                 )
)
