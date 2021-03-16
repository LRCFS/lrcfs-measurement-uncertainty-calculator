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

tabSamplePreparation = tabItem(tabName = "samplePreparation",
                 fluidRow(
                   valueBox("Uncertainty of Sample Preparation", h2(uiOutput("display_samplePreparation_finalAnswer_top")), width = 12, color = "maroon", icon = icon("vial")),
                   actionButton("helpSamplePreparation", "Help", icon=icon("question"), class="pageHelpTop")
                 ),
                 fluidRow(
                   box(title = "Overview", width=5,
                       p("The uncertainty of sample preparation quantifies the uncertainty associated with quantifying the preparation of case sample through the use of for example pipette.")
                   ),
                   box(title = "Method", width=7,
                       "The Relative Standard Uncertainty (RSU) of each equipment is computed using:",
                       "$$u_r(\\text{Equipment}) = \\frac{\\frac{\\text{Tolerance}}{\\text{Coverage Factor}}}{\\text{Capacity}}$$",
                       "The RSU of sample preparation is given by:",
                       "$$u_r\\text{(SamplePreparation)} = \\sqrt{\\sum{[u_r(\\text{Equipment})_{\\text{(Cap,Tol)}}^2 \\times N(\\text{Equipment})_{\\text{(Cap,Tol)}}}]}$$",
                       tags$ul(
                         tags$li("\\(N\\text{(Equipment)}\\) is the number of times a piece of equipment is used in taking the preparation of a given sample.")
                       )
                   )
                 ),
                 fluidRow(
                   tabBox(width=12, side="right",
                          title = "Loaded Data",
                          tabPanel("Raw Sample Preparation Data",
                                   DT::dataTableOutput("display_samplePreparation_rawDataTable")
                          )
                   )
                 ),
                 fluidRow(
                   box(width=6, side="right",
                       title = "Standard Uncertainty",
                       uiOutput("display_samplePreparation_standardUncertainty")
                   ),
                   box(width=6, side="right",
                       title = "Relative Standard Uncertainty",
                       uiOutput("display_samplePreparation_relativeStandardUncertainty")
                   )
                 ),
                 fluidRow(
                   box(width=12, side="right",
                       title = "Overall Relative Standard Uncertainty", background = "maroon", solidHeader = TRUE,
                       uiOutput("display_samplePreparation_finalAnswer_bottom")
                   )
                 )
)
