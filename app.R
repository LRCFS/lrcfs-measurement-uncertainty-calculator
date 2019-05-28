library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(ggplot2)
library(reshape2)
library(scales)
library(dplyr)
library(plotly)
library(DT)

source("dal/loadCalibrationCurveExcel.R")
source("dal/loadMethodPrecisionCSV.R")
source("dal/loadStandardSolutionCSV.R")

source("models/modelDashboard.R")
source("models/modelCalibrationCurve.R")
source("models/modelMethodPrecision.R")
source("models/modelStandardSolution.R")

source("views/viewDashboard.R")
source("views/viewRightSidebar.R")
source("views/viewCalibrationCurve.R")
source("views/viewMethodPrecision.R")
source("views/viewStandardSolution.R")
source("views/viewCombinedUncertainty.R")
source("views/viewExpandedUncertainty.R")

`%ni%` = Negate(`%in%`)

ui <- dashboardPagePlus(title="LRCFS - MoU Calc v0.2",
  dashboardHeaderPlus(title = "LRCFS - MoU Calc v0.2",
                      enable_rightsidebar = TRUE,
                      rightSidebarIcon = "gears"
                     ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Calibration Curve", tabName = "calibrationCurve", icon = icon("chart-line")),
      menuItem("Method Precision", tabName = "methodPrecision", icon = icon("bullseye")),
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
      tabMethodPrecision,
      tabStandardSolution,
      tabCombinedUncertainty,
      tabExpandedUncertainty
    )
  ),
  rightsidebar = mouCalcRightSidebar,
  footer = dashboardFooter(
    left_text = "An LRCFS Creation",
    right_text = "Copyright 2019"
  )
)

server <- function(input, output) {
  
  serverDashboard(input, output)
  
  serverUncertaintyCalibrationCurve(input, output)
  
  serverUncertaintyMethodPrecision(input, output)
  
  serverUncertaintyStandardSolution(input, output)
  
}

shinyApp(ui, server)
