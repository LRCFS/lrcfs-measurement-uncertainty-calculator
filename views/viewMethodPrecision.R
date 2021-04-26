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

tabMethodPrecision = tabItem(tabName = "methodPrecision",
                            fluidRow(
                              valueBox("Uncertainty of Method Precision", h2(textOutput("display_methodPrecision_finalAnswer_top")), width = 12, color = "red", icon = icon("bullseye")),
                              actionButton("helpMethodPrecision", "Help", icon=icon("question"), class="pageHelpTop")
                            ),
                            fluidRow(
                              box(title = "Overview", width=6,
                                  p("A step-by-step approach for estimating the uncertainty of method precision is outlined here. The main methodology used is the pooled standard deviation approach."),
                                  p("Where a precision experiment is carried out for different nominal values of concentration (e.g. low, medium and high), the uncertainty of method precision is calculated for each nominal value separately and the uncertainty used for the combined uncertainty is the value for which the specified case sample concentration is closest to the nominal value."),
                                  p(HTML("To derive the relative standard uncertainty, the standard uncertainty is divided by the number of case sample replicate as recommended by <a href='https://www.sciencedirect.com/science/article/abs/pii/S0021967317304909' target='_blank' title='Evaluation of the measurement uncertainty: Some common mistakes with a focus on the uncertainty from linear calibration'>Kadis (2017)</a>."))
                              ),
                              box(title = "Method", width=6,
                                  "The Relative Standard Uncertainty of method precision is given by:",
                                  "$$u_r(\\text{MethodPrec})_{\\text{(NV)}} = \\frac{S_{p\\text{(NV)}}}{\\overline{x}_{\\text{(NV)}}\\sqrt{r_s}} = \\frac{u(\\text{MethodPrec})_{\\text{(NV)}}}{\\overline{x}_{\\text{(NV)}}},$$",
                                  "where",
                                  "$$u(\\text{MethodPrec})_{\\text{(NV)}} = \\frac{S_{p\\text{(NV)}}}{\\sqrt{r_s}},$$",
                                  "and",
                                  "$$S_{p(\\text{NV})} = \\sqrt{\\frac{\\sum{(S^2 \\times {\\large\\nu})_{\\text{(NV)}}}}{\\sum {\\large\\nu}_{\\text{(NV)}}}}.$$",
                                  tags$ul(
                                    tags$li("\\(S\\) is the standard deviation for each run."),
                                    tags$li("\\({\\large\\nu}\\) is the individual degrees of freedom."),
                                    tags$li("\\(S_p\\) is the pooled standard deviation."),
                                    tags$li("\\(NV\\) is the nominal value of concentration."),
                                    tags$li("\\(\\overline{x}_{\\text{(NV)}}\\) is the mean concentration for the nominal value \\(\\text{NV}\\).")
                                  )
                              )
                            ),
                            fluidRow(
                              tabBox(width=12, side="right",
                                     title = uiOutput("uploadedMethodPrecisionDataStats"),
                                     tabPanel("Graph",
                                              plotlyOutput("methodPrecisionRawDataGraph")
                                     ),
                                     tabPanel("Raw Data",
                                              DT::dataTableOutput("methodPrecisionRawData")
                                     )
                              )
                            ),
                            fluidRow(
                              infoBox(HTML("Case Sample<br />Replicates \\((r_s)\\)"),HTML(paste(uiOutput("display_methodPrecision_replicates"))), width=6, icon=icon("vials"), color="aqua"),
                              infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_methodPrecision_meanConcentration"))), width=6, icon=icon("map-marker"), color="fuchsia")
                            ),
                            fluidRow(
                              box(width=12,
                                  title = "Step by Step Calculation",
                                  DT::dataTableOutput("methodPrecisionCalculations"),
                                  hr(),
                                  box(title="Sum of Degrees of Freedom \\(({\\large\\nu}_\\text{(NV)})\\)", width = 4,
                                      uiOutput("outputSumOfDof")),
                                  box(title="Mean Concentration of \\(\\text{NV}\\) \\((\\overline{x}_\\text{(NV)})\\)", width = 4,
                                      uiOutput("outputMeanConcForNv")),
                                  box(title="Sum of \\((S^2 \\times {\\large\\nu})_\\text{(NV)}\\)", width = 4,
                                      uiOutput("outputSumOfS2d")),
                                  box(title="Pooled Standard Deviation \\((S_p)\\)", width = 4,
                                      uiOutput("outputPooledStandardDeviation")),
                                  box(title="Standard Uncertainty \\((u)\\)", width = 4,
                                      uiOutput("outputStandardUncertainty")),
                                  box(title="Realtive Standard Uncertainty \\((u_r)\\)", width = 4,
                                      uiOutput("outputRealtiveStandardUncertainties")),
                                  box(title="Uncertainty of Method Precision", width = 12, background = "red", solidHeader = TRUE,
                                      uiOutput("display_methodPrecision_finalAnswer_bottom")
                                  )
                              )
                            )
)
