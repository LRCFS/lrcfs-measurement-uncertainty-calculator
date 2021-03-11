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
                   valueBox("Uncertainty of Homogeneity", h2(uiOutput("display_homogeneity_finalAnswer_top")), width = 12, color = "navy", icon = icon("mortar-pestle"))
                 ),
                 fluidRow(
                   box(title = "Overview", width=5,
                       p("The uncertainty of sample preparation quantifies the uncertainty associated with quantifying the preparation of case sample through the use of for example pipette.")
                   ),
                   box(title = "Method", width=7,
                       p("The Relative Standard Uncertainty of homogeneity is given by the following calculation:"),
                       p("$$u_r(\\text{Homogeneity}) = \\frac{ \\text{Standard Uncertainty} }{ \\text{Grand Mean} } = \\frac{ u(\\text{Homogeneity}) }{ \\overline{X}_T } $$"),
                       p("where \\(\\displaystyle u(\\text{Homogeneity}) = \\text{max}\\{u_a,u_b\\}\\),"),
                       p(HTML("\\(\\displaystyle u_a(\\text{Homogeneity}) = \\sqrt{\\frac{ MSS_B - MSS_W }{ n_0 }}\\)<span class='textSpacer'>and</span>\\(\\displaystyle u_b(\\text{Homogeneity}) = \\sqrt{ \\frac{ MSS_W }{ n_0 } } \\times \\sqrt{ \\frac{ 2 }{ k(n_0-1) } }\\)")),
                       p(HTML("&nbsp;")),
                       p("An", a(href = "https://en.wikipedia.org/wiki/Analysis_of_variance", "Analysis of Variance (ANOVA)"), "test is carried out to calculate the Mean Sum of Squares Between groups (\\(MSS_B\\)) and the Mean Sum of Squares Within groups (\\(MSS_W\\)) given by:"),
                       p(HTML("\\(\\displaystyle MSS_B = \\frac{ \\sum\\limits_{j=1}^k n_j(\\overline{X}_{j}-\\overline{X}_T)^2 } { k-1 } \\) <span class='textSpacer'>and</span> \\(\\displaystyle MSS_W = \\frac{ \\sum\\limits_{j=1}^k\\sum\\limits_{i=1}^{n_j} (X_{ij}-\\overline{X}_j)^2 } { N-k }\\)")),
                       p(HTML("&nbsp;")),
                       tags$ul(
                         tags$li("\\(k\\) is the number of groups/vials."),
                         tags$li("\\(n_j\\) is the number of measurements/replicates in the group/vial \\(j\\) where \\(j=1\\ldots k\\)."),
                         tags$li(HTML("\\(\\displaystyle n_0 = \\frac{1}{k-1} \\left[\\sum\\limits_{j=1}^k n_j - \\frac{ \\sum\\limits_{j=1}^k n_j^2 } { \\sum\\limits_{j=1}^k n_j }\\right] \\) <br />Where all \\(n_j\\)'s are the same (i.e. \\(n_1=n_2=\\ldots=n_k=n\\)) then this simplifies to \\(n_0 = n\\).")),
                         tags$li("\\(N\\) is the total number of measurements (i.e. \\(N = \\sum\\limits_{j=1}^k n_j\\))"),
                         tags$li("\\(X_{ij}\\) is the \\(i^{th}\\) measurement of the \\(j^{th}\\) group."),
                         tags$li("\\(\\overline{X}_j\\) is the mean of measurement in group/vial \\(j\\)."),
                         tags$li("\\(\\overline{X}_T\\) is the grand mean, calculated as the sum of all measurements \\(\\left(\\sum\\limits_{j=1}^k\\sum\\limits_{i=1}^{n_j} X_{ij}\\right)\\) divided by the number of measurements \\((N)\\) ")
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
                       title = "Calculations for Sum of Squares Between",
                       DT::dataTableOutput("display_homogeneity_calcsTable3")
                   )
                 ),
                 fluidRow(
                   box(width=4, side="right",
                       title = "Parameters",
                       uiOutput("display_homogeneity_valuedNeeded")
                   ),
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
                          title = "Calculations for Sum of Squares Within",
                          p("The values in the table below are calculated using \\((X_{ij}-\\overline{X}_j)^2\\), which are summed to give the Sum of Squares Within."),
                          DT::dataTableOutput("display_homogeneity_calcsTable")
                   )
                 ),
                 fluidRow(
                   box(width=4, side="right",
                       title = "Mean Sum of Squares Within (\\(MSS_W\\))",
                       uiOutput("display_homogeneity_meanSumOfSquaresWithin")
                   ),
                   box(width=8, side="right",
                       title = "Standard Uncertainty (\\(u\\))",
                       uiOutput("display_homogeneity_standardUncertainty")
                   )
                 ),
                 fluidRow(
                   box(width=12, side="right", background = "navy", solidHeader = TRUE,
                       title = "Relative Standard Uncertainty (\\(u_r\\))",
                       uiOutput("display_homogeneity_relativeStandardUncertainty")
                   )
                 )
)
