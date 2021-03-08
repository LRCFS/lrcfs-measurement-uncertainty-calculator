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

tabHomogeneityTest = tabItem(tabName = "homogeneityTest",
                         fluidRow(
                           valueBox("Homogeneity Test", h2(uiOutput("display_homogeneityTest_answerTop")), width = 12, color = "navy", icon = icon("chart-area"))
                         ),
                         fluidRow(
                           column(width=6,
                             box(title = "Overview", width=12,
                                 p("This homogeneity test will determine if the sample data provided can be considered homogeneous. This is done by carrying out an ANOVA test of the data before comparing the calclated F statistic with the F critical value."),
                                 p("An assumption is made that the alpha value used for calculating is 0.05 (relating to a confidence level of 95%), however, this can be changed below."),
                                 numericInput("inputHomogeneityTest_alphaValue",
                                              "Alpha Value (\\(\\alpha\\))",
                                              value = 0.05,
                                              min = 0.001,
                                              max = 0.999,
                                              step = 0.001),
                             ),
                             infoBox(HTML("Alpha Value \\((\\alpha)\\)"),HTML(paste(uiOutput("display_homogeneityTest_alphaValue"))), width=6, icon=icon("font"), color="red"),
                             infoBox(HTML("Homogeneity Test<br />Confidence Level \\((CL_H\\%)\\)"),HTML(paste(uiOutput("display_homogeneityTest_confidenceLevel"))), width=6, icon=icon("percentage"), color="yellow"),
                             uiOutput("display_homogeneityTest_answerMiddle")
                           ),
                           column(width=6,
                             box(title = "Method", width=12,
                                 p("An", a(href = "https://en.wikipedia.org/wiki/Analysis_of_variance", "Analysis of variance (ANOVA)"), "test is carried out where the Mean Sum of Squares Between (\\(MSS_B\\)) is defined as:"),
                                 p("$$MSS_B = \\frac{ \\sum\\limits_{j=1}^k n_j(\\overline{X}_{j}-\\overline{X}_T)^2 } { k-1 }$$"),
                                 p("and the Mean Sum of Squares Within the groups (\\(MSS_W\\)) is defined as:"),
                                 p("$$MSS_W = \\frac{ \\sum\\limits_{j=1}^k\\sum\\limits_{i=1}^{n_j} (X_{ij}-\\overline{X}_j)^2 } { N-k }$$"),
                                 p("and the \\(F_{\\large s}\\) Statistic (or F Value)  is given by:"),
                                 p("$$F_{\\large s} = \\frac{MSS_B}{MSS_W}$$"),
                                 tags$ul(
                                   tags$li("\\(k\\) is the number of groups/vials."),
                                   tags$li("\\(n_j\\) is the number of measurements/replicates in the group/vial \\(j\\) where \\(j=1\\ldots k\\)."),
                                   tags$li("\\(N\\) total number of measurements (i.e. \\(N = \\sum\\limits_{j=1}^k n_j\\))"),
                                   tags$li("\\(X_{ij}\\) is the \\(i^{th}\\) measurement of the \\(j^{th}\\) group."),
                                   tags$li("\\(\\overline{X}_j\\) is the mean of measurement in group/vial \\(j\\)."),
                                   tags$li("\\(\\overline{X}_T\\) is the grand mean of all measurements.")
                                 )
                             )
                           )
                         ),
                         fluidRow(
                           box(width=3, side="right",
                               title = "Parameters",
                               uiOutput("display_homogeneityTest_parameters")
                           ),
                           box(width=3, side="right",
                               title = "Degrees of Freedom",
                               uiOutput("display_homogeneityTest_dof")
                           ),
                           box(width=3, side="right",
                               title = "F Statistic (\\(F_{\\large s}\\))",
                               uiOutput("display_homogeneityTest_fValue")
                           ),
                           box(width=3, side="right",
                               title = "F Critical (\\(F_c\\))",
                               p("The F Critical value is caclualted using blah blah"),
                               uiOutput("display_homogeneity_fCritical")
                           )
                         ),
                         fluidRow(
                           box(width=12,
                               title = "F Distribution",
                              plotlyOutput("display_homogeneityTest_fDistribution")
                           )
                         )
                         ,
                         fluidRow(
                           uiOutput("display_homogeneityTest_answerBottom")
                         )
)
