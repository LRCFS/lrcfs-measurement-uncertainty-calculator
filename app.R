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
      menuItem("Combined Uncertainty", tabName = "combinedUncertainty", icon = icon("arrows-alt-v")),
      menuItem("Expanded Uncertainty", tabName = "expandedUncertainty", icon = icon("arrows-alt"))
    )
  ),
  dashboardBody(
    tags$head(tags$link(rel = "shortcut icon", href = "images/favicon.ico")),
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
    left_text = "METEOR",
    right_text = "Copyright LRCFS 2019"
  )
)

server <- function(input, output) {
  
  serverDashboard(input, output)
  
  serverUncertaintyCalibrationCurve(input, output)
  
  serverUncertaintyMethodPrecision(input, output)
  
  serverUncertaintyStandardSolution(input, output)
  
}

shinyApp(ui, server)
