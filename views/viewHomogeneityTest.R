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
                           valueBox("Homogeneity Test", "value", width = 12, color = "navy", icon = icon("chart-area"))
                         ),
                         fluidRow(
                           box(title = "Overview", width=5,
                               p("The uncertainty of sample preparation quantifies the uncertainty associated with quantifying the preparation of case sample through the use of for example pipette.")
                           ),
                           box(title = "Method", width=7,
                               p("An", a(href = "https://en.wikipedia.org/wiki/Analysis_of_variance", "Analysis of variance (ANOVA)"), "test is carried out where the Mean Sum of Squares Between (\\(MSS_B\\)) is defined as:"),
                               p("$$MSS_B = \\frac{ \\sum\\limits_{j=1}^k n_j(\\overline{X}_{j}-\\overline{X}_T)^2 } { k-1 }$$"),
                               p("and the Mean Sum of Squares Within the groups (\\(MSS_W\\)) is defined as:"),
                               p("$$MSS_W = \\frac{ \\sum\\limits_{j=1}^k\\sum\\limits_{i=1}^{n_j} (X_{ij}-\\overline{X}_j)^2 } { n-k }$$"),
                               p("and the \\(F\\) value is given by:"),
                               p("$$F = \\frac{MSS_B}{MSS_W}$$"),
                               tags$ul(
                                 tags$li("\\(k\\) is the number of groups/vials."),
                                 tags$li("\\(n_j\\) is the number of measurements/replicates in the group/vial \\(j\\) where \\(j=1\\ldots k\\)."),
                                 tags$li("\\(n\\) total number of measurements."),
                                 tags$li("\\(X_{ij}\\) is the \\(i^{th}\\) measurement of the \\(j^{th}\\) group."),
                                 tags$li("\\(\\overline{X}_j\\) is the mean of measurement in group/vial \\(j\\)."),
                                 tags$li("\\(\\overline{X}_T\\) is the grand mean of all measurements.")
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
                               title = "F Value (\\(F_v\\))",
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
)
