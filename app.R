library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(ggplot2)
library(reshape2)
library(scales)
library(dplyr)
library(plotly)
library(DT)
library(DiagrammeR)

source("dal/loadCoverageFactorEffectiveDofCSV.R")
source("dal/loadCalibrationCurveCSV.R")
source("dal/loadMethodPrecisionCSV.R")
source("dal/loadStandardSolutionCSV.R")
source("dal/loadSampleVolumeCSV.R")

source("views/viewDashboard.R")
source("views/viewRightSidebar.R")
source("views/viewCalibrationCurve.R")
source("views/viewMethodPrecision.R")
source("views/viewStandardSolution.R")
source("views/viewSampleVolume.R")
source("views/viewCombinedUncertainty.R")
source("views/viewEffectiveDof.R")
source("views/viewExpandedUncertainty.R")

`%ni%` = Negate(`%in%`)

ui <- dashboardPagePlus(title="METEOR v0.3",
                        dashboardHeaderPlus(title = tagList(
                          img(class = "logo-lg", src = "images/logo-large.png"), 
                          img(class = "logo-mini", src = "images/logo-small.png")),
                          enable_rightsidebar = TRUE,
                          rightSidebarIcon = "gears"
                        ),
                        dashboardSidebar(
                          sidebarMenu(
                            menuItem("Results Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                            menuItem("Calibration Curve", tabName = "calibrationCurve", icon = icon("chart-line")),
                            menuItem("Method Precision", tabName = "methodPrecision", icon = icon("bullseye")),
                            menuItem("Standard Solution", tabName = "standardSolution", icon = icon("vial")),
                            menuItem("Sample Volume", tabName = "sampleVolume", icon = icon("flask")),
                            menuItem("Combined Uncertainty", tabName = "combinedUncertainty", icon = icon("arrows-alt-v")),
                            menuItem("Effective DoF", tabName = "effectiveDof", icon = icon("exchange-alt")),
                            menuItem("Expanded Uncertainty", tabName = "expandedUncertainty", icon = icon("arrows-alt"))
                          )
                        ),
                        dashboardBody(
                          tags$head(tags$link(rel = "shortcut icon", href = "images/favicon.ico")),
                          tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css")),
                          #Use MathJax for rendering inline LaTeX functions
                          withMathJax(),
                          #Load tabs from view files (Properties can be found in /views/view...R)
                          tabItems(
                            tabDashboard,
                            tabCalibrationCurve,
                            tabMethodPrecision,
                            tabStandardSolution,
                            tabSampleVolume,
                            tabCombinedUncertainty,
                            tabEffectiveDof,
                            tabExpandedUncertainty
                          ) 
                        ),
                        rightsidebar = mouCalcRightSidebar,
                        footer = dashboardFooter(
                          left_text = "METEOR",
                          right_text = "Copyright LRCFS 2019"
                       )
)

server <- function(input, output) {
  source("models/modelApplication.R", local = TRUE)
  source("models/modelDashboard.R", local = TRUE)
  source("models/modelCalibrationCurve.R", local = TRUE)
  source("models/modelMethodPrecision.R", local = TRUE)
  source("models/modelStandardSolution.R", local = TRUE)
  source("models/modelSampleVolume.R", local = TRUE)
  source("models/modelCombinedUncertainty.R", local = TRUE)
  source("models/modelEffectiveDof.R", local = TRUE)
  source("models/modelExpandedUncertainty.R", local = TRUE)
}

shinyApp(ui, server)
