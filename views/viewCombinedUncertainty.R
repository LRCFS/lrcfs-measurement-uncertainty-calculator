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

tabCombinedUncertainty = tabItem(tabName = "combinedUncertainty",
                 fluidRow(
                   valueBox("Combined Uncertainty", h2(textOutput("display_combinedUncertainty_finalAnswer_top")), width = 12, color = "purple", icon = icon("arrows-alt-v")),
                   actionButton("helpCombinedUncertainty", "Help", icon=icon("question"), class="pageHelpTop")
                 ),
                 fluidRow(
                   box(title = "Overview", width=6,
                       p("The combined uncertainty is obtained by combining all the individual uncertainty components."),
                       p("If data is uploaded for all the uncertainty components; Homogeneity, Calibration Curve, Method Precision, Calibration Standard and Sample Preparation, relative standard uncertainty is computed for each uncertainty component and are combined to obtain the Combined Uncertainty of the analytical process."),
                       p("If data is omitted for some uncertainty components, NA's will be displayed for those components and the Combined Uncertainty will only take into account components for which data is provided.")
                   ),
                   box(title = "Method", width=6,
                       "The combined uncertainty is given by:",
                       "$$\\text{CombUncertainty} = x_s \\sqrt{\\sum{u_r\\text{(Individual Uncertainty Component)}^2}}$$",
                       tags$ul(
                         tags$li("Where \\(x_s\\) is the Case Sample Mean Concentration.")
                       )
                   )
                 ),
                 fluidRow(
                   valueBox(uiOutput("display_homogeneity_finalAnswer_combinedUncertainty"),"\\(u_r\\text{(Homogeneity)}\\)", width = 4, color = "navy", icon = icon("mortar-pestle")),
                   valueBox(uiOutput("display_calibrationCurve_finalAnswer_combinedUncertainty"),"\\(u_r\\text{(CalCurve)}\\)", width = 4, color = "blue", icon = icon("chart-line")),
                   valueBox(uiOutput("display_methodPrecision_finalAnswer_combinedUncertainty"),"\\(u_r\\text{(MethodPrec)}\\)", width = 4, color = "red", icon = icon("bullseye")),
                   valueBox(uiOutput("display_standardSolution_finalAnswer_combinedUncertainty"),"\\(u_r\\text{(CalStandard)}\\)", width = 4, color = "green", icon = icon("flask")),
                   valueBox(uiOutput("display_samplePreparation_finalAnswer_combinedUncertainty"),"\\(u_r\\text{(SamplePreparation)}\\)", width = 4, color = "maroon", icon = icon("vial")),
                   infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_combinedUncertainty_meanConcentration"))), width=4, icon=icon("map-marker"), color="fuchsia")
                 ),
                 fluidRow(
                   box(width=12, side="right",
                       title = "Combined Uncertainty", background = "purple", solidHeader = TRUE,
                       uiOutput("display_combinedUncertainty_finalAnswer_bottom")
                   )
                 ),
                 fluidRow(
                   box(width=12, side="right",
                       title = "Uncertainty Budget",
                       plotlyOutput("display_combinedUncertainty_uncertaintyBudget")
                   )
                 )
)
