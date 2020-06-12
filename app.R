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
                          left_text = "Measurement Uncertainty Calculator",
                          right_text = paste0("Copyright LRCFS ",format(Sys.time(), "%Y"))
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
