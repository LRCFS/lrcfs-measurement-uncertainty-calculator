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
                           valueBox("Homogeneity Test", h2(uiOutput("display_homogeneityTest_answerTop")), width = 12, color = "navy", icon = icon("chart-area")),
                           actionButton("helpHomogeneityTest", "Help", icon=icon("question"), class="pageHelpTop")
                         ),
                         fluidRow(
                           column(width=6,
                             box(title = "Overview", width=12,
                                 p("A one-way analysis of variance (ANOVA) is used to test the null hypotheses \\((H_0)\\) of equality of means among sample groups against the alternative hypothesis \\((H_1)\\) that at least two of the group means differ, on the assumption that samples are normally distributed, have equal variance and are independent. For \\(k\\) independent groups with means \\(m_1 \\ldots m_k\\), the hypothesis of interest is given by:"),
                                 p("\\(H_0\\): \\(m_1 = m_2 = m_3= \\ldots = m_k\\)"),
                                 p("\\(H_1\\): \\(m_l \\neq m_j\\) for some \\(l,j\\)"),
                                 p("The F statistic \\((F_{\\large s})\\) under \\(H_0\\) follows an F-distribution given by the ratio of mean sum of squares between \\((MSS_B)\\) and mean sum of squares within \\((MSS_W)\\), as shown in the Method tab."),
                                 p(HTML("The \\(H_0\\) is rejected if the F statistic \\((F_{\\large s})\\) is greater than the F critical (\\(F_c\\)) value for a given alpha level and conclude that at least two group means differ. For more information see <a href='https://www.researchgate.net/publication/226708564_Uncertainty_calculations_in_the_certification_of_reference_materials_1_Principles_of_analysis_of_variance' target='_blank'>Veen et al: Principles of analysis of variance (2000)</a> and <a href='https://www.researchgate.net/publication/226313972_Uncertainty_calculations_in_the_certification_of_reference_materials_2_Homogeneity_study' target='_blank'>Veen et al: Homogeneity study (2001)</a>")),
                                 p("An alph value \\((\\alpha)\\) of 0.05 (relating to a confidence level \\((CL_H)\\) of 95%) is used by default, however, this can be changed below."),
                                 numericInput("inputHomogeneityTest_alphaValue",
                                              "Alpha Value (\\(\\alpha\\)) - Min: 0.001, Max: 0.999",
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
                                 p(HTML("A <a href='https://en.wikipedia.org/wiki/Analysis_of_variance' target='_blank'>one-way analysis of variance (ANOVA)</a> test is carried out where the Mean Sum of Squares Between (\\(MSS_B\\)) is defined as:")),
                                 p("$$MSS_B = \\frac{ \\sum\\limits_{j=1}^k n_j(\\overline{X}_{j}-\\overline{X}_T)^2 } { k-1 },$$"),
                                 p("the Mean Sum of Squares Within (\\(MSS_W\\)) is defined as:"),
                                 p("$$MSS_W = \\frac{ \\sum\\limits_{j=1}^k\\sum\\limits_{i=1}^{n_j} (X_{ij}-\\overline{X}_j)^2 } { N-k }$$"),
                                 p("and the F statistic (or F value)  is given by:"),
                                 p("$$F_{\\large s} = \\frac{MSS_B}{MSS_W}$$"),
                                 p("Finally, \\(H_0\\) is rejected if \\(F_{\\large s} > F_c\\)"),
                                 tags$ul(
                                     tags$li("\\(H_0\\) is the null hypotheses of equal group means."),
                                     tags$li("\\(k\\) is the number of groups."),
                                     tags$li("\\(n_j\\) is the number of measurements/replicates in the group \\(j\\) where \\(j=1\\ldots k\\)."),
                                     tags$li("\\(N\\) total number of measurements, i.e. \\(N = \\sum\\limits_{j=1}^k n_j\\)"),
                                     tags$li("\\(F_{\\large s}\\) is the F statistic calculated from the supplied data."),
                                     tags$li(HTML("\\(F_c\\) is the critical value from <a href='https://www.statisticshowto.com/tables/f-table/' target='_blank'>F-Distribution Table</a> at a given alpha level, i.e. \\(F_{{\\LARGE\\nu}_B,{\\LARGE\\nu}_W,\\alpha}\\)")),
                                     tags$li("\\({\\LARGE\\nu}_B\\) is the degrees of freedom for the between-group, calculated as \\(k-1\\)."),
                                     tags$li("\\({\\LARGE\\nu}_W\\) is the degrees of freedom for the within-group, calculated as \\(N-k\\)."),
                                     tags$li("\\(X_{ij}\\) is the \\(i^{th}\\) measurement of the \\(j^{th}\\) group."),
                                     tags$li("\\(\\overline{X}_j\\) is the mean of measurement in group \\(j\\)."),
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
                               p(HTML("Using the degrees of freedom and alpha value the F critical value is read from a <a href='https://www.statisticshowto.com/tables/f-table/' target='_blank'>F-Distribution Table</a>.")),
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
