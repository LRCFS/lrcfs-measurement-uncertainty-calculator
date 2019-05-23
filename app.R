library(shiny)
library(shinydashboard)
library(ggplot2)
library(reshape2)
library(scales)
library(dplyr)
library(plotly)
library(DT)

source("dal/ingestExcel.R")

source("models/modelDashboard.R")
source("models/modelUncertaintyCalibrationCurve.R")

source("views/viewDashboard.R")
source("views/viewUncertaintyInCalibration.R")
source("views/viewQualityControl.R")
source("views/viewStandardSolution.R")
source("views/viewCombinedUncertainty.R")
source("views/viewExpandedUncertainty.R")

`%ni%` = Negate(`%in%`)

ui <- dashboardPage(
  dashboardHeader(title = "LRCFS - MoU Calc v0.1"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Calibration Curve", tabName = "calibrationCurve", icon = icon("chart-line")),
      menuItem("Quality Control (Precision)", tabName = "qualityControl", icon = icon("dashboard")),
      menuItem("Standard Solution", tabName = "standardSolution", icon = icon("vial")),
      menuItem("Combined Uncertainty", tabName = "combinedUncertainty", icon = icon("gitter")),
      menuItem("Expanded Uncertainty", tabName = "expandedUncertainty", icon = icon("chart-area"))
    )
  ),
  dashboardBody(
    withMathJax(),
    tabItems(
      tabDashboard,
      tabCalibrationCurve,
      tabQualityControl,
      tabStandardSolution,
      tabCombinedUncertainty,
      tabExpandedUncertainty
    )
  )
)

server <- function(input, output) {
  
  serverUncertaintyCalibrationCurve(input, output)
  
}

shinyApp(ui, server)
