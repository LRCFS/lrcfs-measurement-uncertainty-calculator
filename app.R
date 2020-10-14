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

#Clear all lists from memory to avoid unintentional errors
rm(list = ls())

#Load required libraries
library(shiny)
library(shinyjs)
library(shinydashboard)
library(shinydashboardPlus)
library(ggplot2)
library(reshape2)
library(scales) 
library(dplyr)
library(plotly)
library(DT)
library(DiagrammeR)
library(stringr)
library(data.tree)
library(rintrojs)
library(textutils)
library(tinytex)
library(rmarkdown)
library(knitr)
library(webshot)
library(shinyWidgets)
library(colourpicker)

source("models/modelHelperFunctions.R")

source("dal/loadHelperMethods.R")
source("dal/loadCoverageFactorEffectiveDofCSV.R")
source("dal/loadCalibrationCurveCSV.R")
source("dal/loadCalibrationCurvePooledDataCSV.R")
source("dal/loadCalibrationCurveCustomWlsCSV.R")
source("dal/loadMethodPrecisionCSV.R")
source("dal/loadStandardSolutionCSV.R")
source("dal/loadSampleVolumeCSV.R")

source("models/modelStaticProperties.R")

source("views/viewStart.R")
source("views/viewRightSidebar.R")
source("views/viewCalibrationCurve.R")
source("views/viewMethodPrecision.R")
source("views/viewStandardSolution.R")
source("views/viewSampleVolume.R")
source("views/viewCombinedUncertainty.R")
source("views/viewCoverageFactor.R")
source("views/viewExpandedUncertainty.R")
source("views/viewDashboard.R")

`%ni%` = Negate(`%in%`)

ui <- dashboardPagePlus(title=paste0(APP_DEV_SHORT," - ",APP_NAME_SHORT," - v",APP_VER),
                        dashboardHeaderPlus(title = tagList(img(class = "logo-lg", src = "images/logo-large.png"), 
                                                            img(class = "logo-mini", src = "images/logo-small.png")),
                                            enable_rightsidebar = TRUE,
                                            rightSidebarIcon = "gears"
                        ),
                        dashboardSidebar(
                          sidebarMenu(
                            menuItem("Start", tabName = "start", icon = icon("play")),
                            menuItem("Calibration Curve", tabName = "calibrationCurve", icon = icon("chart-line")),
                            menuItem("Method Precision", tabName = "methodPrecision", icon = icon("bullseye")),
                            menuItem("Standard Solution", tabName = "standardSolution", icon = icon("flask")),
                            menuItem("Sample Volume", tabName = "sampleVolume", icon = icon("vial")),
                            menuItem("Combined Uncertainty", tabName = "combinedUncertainty", icon = icon("arrows-alt-v")),
                            menuItem("Coverage Factor", tabName = "coverageFactor", icon = icon("table")),
                            menuItem("Expanded Uncertainty", tabName = "expandedUncertainty", icon = icon("arrows-alt")),
                            menuItem("Results Dashboard", tabName = "dashboard", icon = icon("dashboard"))
                          )
                        ),
                        dashboardBody(
                          introjsUI(),
                          useShinyjs(),
                          tags$head(tags$link(rel = "shortcut icon", href = "images/favicon.ico")),
                          tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css")),
                          tags$head(tags$script(src="js/staticProperties.js")),
                          tags$head(tags$script(src="js/help.js")),
                          #Use MathJax for rendering inline LaTeX functions
                          withMathJax(),
                          #Load tabs from view files (Properties can be found in /views/view...R)
                          tabItems(
                            tabStart,
                            tabCalibrationCurve,
                            tabMethodPrecision,
                            tabStandardSolution,
                            tabSampleVolume,
                            tabCombinedUncertainty,
                            tabCoverageFactor,
                            tabExpandedUncertainty,
                            tabDashboard
                          ) 
                        ),
                        rightsidebar = mouCalcRightSidebar,
                        footer = dashboardFooter(
                          left_text = HTML(paste0("<div class='footerItem'><a href='",APP_LINK,"'>",APP_NAME,"</a> (v",APP_VER,") &copy;",format(Sys.time(), "%Y"),"</div>
                                           <div class='footerItem'>",APP_DOI_HTML,"</div>
                                           <div class='footerItem'><a href='https://www.dundee.ac.uk/leverhulme/'>Developed by LRCFS</a></div>
                                           <div class='footerItem'><a href='https://www.leverhulme.ac.uk/'>Funded by The Leverhulme Trust</a></div>")),
                          right_text = HTML("<div class='footerLogo'><a href='https://www.dundee.ac.uk/leverhulme/'><img src='images/lrcfs-logo-colour.png'  alt='Visit LRCFS website' /></a></div>
                                            <div class='footerLogo'><a href='https://www.leverhulme.ac.uk'><img src='images/lt-logo-colour.png' alt='Visit The Leverhulme Trust website' /></a></div>")
                       )
)

server <- function(input, output, session) {
  source("models/modelApplication.R", local = TRUE)
  source("models/modelStart.R", local = TRUE)
  
  source("controllers/controllerCalibrationCurve.R", local = TRUE)
  source("models/modelCalibrationCurve.R", local = TRUE)
  source("reactives/reactiveCalibrationCurve.R", local = TRUE)
  
  source("models/modelMethodPrecision.R", local = TRUE)
  source("models/modelStandardSolution.R", local = TRUE)
  
  source("controllers/controllerSampleVolume.R", local = TRUE)
  source("models/modelSampleVolume.R", local = TRUE)
  source("reactives/reactiveSampleVolume.R", local = TRUE)
  
  source("models/modelCombinedUncertainty.R", local = TRUE)
  source("models/modelCoverageFactor.R", local = TRUE)
  source("models/modelExpandedUncertainty.R", local = TRUE)
  source("models/modelDashboard.R", local = TRUE)
  source("models/modelHelpButtons.R", local = TRUE)
}

shinyApp(ui, server)
