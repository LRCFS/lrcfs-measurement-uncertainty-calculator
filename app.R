library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(ggplot2)
library(reshape2)
library(scales)
library(dplyr)
library(plotly)
library(DT)

source("dal/ingestExcel.R")
source("dal/ingestQualityControlCSV.R")

source("models/modelDashboard.R")
source("models/modelUncertaintyCalibrationCurve.R")
source("models/modelUncertaintyQualityControl.R")

source("views/viewDashboard.R")
source("views/viewUncertaintyInCalibration.R")
source("views/viewQualityControl.R")
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
      menuItem("Method Precision", tabName = "qualityControl", icon = icon("bullseye")),
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
  ),
  rightsidebar = rightSidebar(
    background = "dark",
    rightSidebarTabContent(
      id = 1,
      active = TRUE,
      title = "File Upload",
      icon = "folder",
      p("Upload the data for each calculation below."),
      hr(),
      fileInput("fileUpload", "Calibration Data (XLSX)",
                multiple = FALSE,
                accept = c(".xlsx")),
      fileInput("inputQualityControlfileUpload", "Quality Control (CSV)",
                multiple = FALSE,
                accept = c(".csv"))
    ),
    rightSidebarTabContent(
      id = 2,
      title = "Case Sample Information",
      p("Specify below the number of replicates and mean concentration for the sample that the calibration data was tested against."),
      hr(),
      numericInput("inputCaseSampleReplicates",
                   "Replicates \\((r_s)\\)",
                   value = 2),
      numericInput("inputCaseSampleMeanConcentration",
                   "Mean Concentration\\((x_s)\\)",
                   value = 2)
    )
  ),
  footer = dashboardFooter(
    left_text = "An LRCFS Creation",
    right_text = "Copyright 2019"
  )
)

server <- function(input, output) {
  
  serverDashboard(input, output)
  
  serverUncertaintyCalibrationCurve(input, output)
  
  serverUncertaintyQualityControl(input, output)
  
}

shinyApp(ui, server)
