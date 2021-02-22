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

tabHomogeneity = tabItem(tabName = "homogeneity",
                 fluidRow(
                   valueBox("Uncertainty of Homogeneity", h2(uiOutput("display_Homogeneity_finalAnswer_top")), width = 12, color = "navy", icon = icon("mortar-pestle"))
                 ),
                 fluidRow(
                   box(title = "Overview", width=5,
                       p("The uncertainty of sample preparation quantifies the uncertainty associated with quantifying the preparation of case sample through the use of for example pipette.")
                   ),
                   box(title = "Method", width=7,
                       p("An", a(href = "https://en.wikipedia.org/wiki/Analysis_of_variance", "Analysis of variance (ANOVA)"), "test is carried out where the Mean Sum of Squares Between (\\(MSS_B\\)) is defined as:"),
                       p("$$MSS_B = \\frac{ \\sum\\limits_{j=1}^k n_j(\\overline{X}_{j}-\\overline{X}_T)^2 } { k-1 }$$"),
                       p("and the Mean Sum of Squares Within the groups (\\(MSS_W\\)) is defined as:"),
                       p("$$MSS_w = \\frac{ \\sum\\limits_{j=1}^k\\sum\\limits_{i=1}^n (X_{ij}-\\overline{X}_j)^2 } { n-k }$$"),
                       p("and the \\(F\\) value is given by:"),
                       p("$$F = \\frac{MSS_B}{MSS_w}$$"),
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
                   tabBox(width=12, side="right",
                          title = "Loaded Data",
                          tabPanel("Graph",
                                   plotlyOutput("display_homogeneity_rawDataGraph")
                          ),
                          tabPanel("Raw Homogeneity Data",
                                   DT::dataTableOutput("display_homogeneity_rawDataTable")
                          )
                   )
                 ),
                 fluidRow(
                   box(width=12, side="right",
                       title = "Mean Sum of Squares Between Calculations",
                       p("These are the means (\\(\\overline{X}_j\\))"),
                       DT::dataTableOutput("display_homogeneity_calcsTable3")
                   )
                 ),
                 fluidRow(
                   box(width=4, side="right",
                       title = "Grand Mean",
                       uiOutput("display_homogeneity_grandMean")
                   ),
                   box(width=4, side="right",
                       title = "Mean Sum of Squares Between (\\(MSS_B\\))",
                       uiOutput("display_homogeneity_meanSumOfSquaresBetween")
                   )
                 ),
                 fluidRow(
                   box(width=12, side="right",
                          title = "Mean Sum of Squares Within Calculations",
                          p("These are the \\((X_{ij}-\\overline{X}_j)^2\\) caculations for each vial."),
                          DT::dataTableOutput("display_homogeneity_calcsTable")
                   )
                 ),
                 fluidRow(
                   box(width=4, side="right",
                       title = "Values Needed",
                       uiOutput("display_homogeneity_valuedNeeded")
                   ),
                   box(width=4, side="right",
                       title = "Mean Sum of Squares Within (\\(MSS_W\\))",
                       uiOutput("display_homogeneity_meanSumOfSquaresWithin")
                   ),
                   box(width=4, side="right",
                       title = "\\(F\\) Value",
                       uiOutput("display_homogeneity_fValue")
                   )
                 ),
                 fluidRow(
                   box(width=4, side="right",
                       title = "Standard Uncertainty (\\(u\\))",
                       uiOutput("display_homogeneity_standardUncertainty")
                   ),
                   box(width=4, side="right",
                       title = "Relative Standard Uncertainty (\\(u_r\\))",
                       uiOutput("display_homogeneity_relativeStandardUncertainty")
                   )
                 ),
                 
                 # fluidRow(
                 #   box(width=12, side="right",
                 #       title = "Overall Relative Standard Uncertainty", background = "maroon", solidHeader = TRUE,
                 #       uiOutput("display_homogeneity_finalAnswer_bottom")
                 #   )
                 # )
)
