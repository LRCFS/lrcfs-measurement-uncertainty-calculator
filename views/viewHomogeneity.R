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
                   valueBox("Uncertainty of Homogeneity", h2(uiOutput("display_Homogeneity_finalAnswer_top")), width = 12, color = "maroon", icon = icon("vial"))
                 ),
                 fluidRow(
                   box(title = "Overview", width=5,
                       p("The uncertainty of sample preparation quantifies the uncertainty associated with quantifying the preparation of case sample through the use of for example pipette.")
                   ),
                   box(title = "Method", width=7,
                       tags$ul(
                         tags$li("\\(N\\) is the number of vials"),
                         tags$li("\\(n\\) is the number of replicates per vial"),
                         tags$li("\\(N_t\\) total number of measurements")
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
                   box(width=6, side="right",
                       title = "Values Needed",
                       uiOutput("display_homogeneity_valuedNeeded")
                   ),
                   box(width=6, side="right",
                       title = "Groud Mean",
                       uiOutput("display_homogeneity_groundMean")
                   )
                 )
                 # fluidRow(
                 #   box(width=12, side="right",
                 #       title = "Overall Relative Standard Uncertainty", background = "maroon", solidHeader = TRUE,
                 #       uiOutput("display_homogeneity_finalAnswer_bottom")
                 #   )
                 # )
)
