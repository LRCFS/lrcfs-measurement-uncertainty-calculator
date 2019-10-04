#install.packages(c("shiny","shinyjs","shinydashboard","shinydashboardPlus","ggplot2","reshape2","scales","dplyr","plotly","DT","DiagrammeR","stringr","data.tree","rintrojs","textutils","tinytex","rmarkdown","knitr","webshot","shinyWidgets","colourpicker"))
#webshot::install_phantomjs() - on linux make sure you've got bzip2 installed for this to work
#tinytex::install_tinytex()

rm(list = ls())
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
library(utils)
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

ui <- dashboardPagePlus(title="MUCalc v0.5",
                        dashboardHeaderPlus(title = tagList(
                          img(class = "logo-lg", src = "images/logo-large.png"), 
                          img(class = "logo-mini", src = "images/logo-small.png")),
                          enable_rightsidebar = TRUE,
                          rightSidebarIcon = "gears"
                        ),
                        dashboardSidebar(
                          sidebarMenu(
                            menuItem("Start", tabName = "start", icon = icon("play")),
                            menuItem("Calibration Curve", tabName = "calibrationCurve", icon = icon("chart-line")),
                            menuItem("Method Precision", tabName = "methodPrecision", icon = icon("bullseye")),
                            menuItem("Standard Solution", tabName = "standardSolution", icon = icon("vial")),
                            menuItem("Sample Volume", tabName = "sampleVolume", icon = icon("flask")),
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
                          right_text = "Copyright LRCFS 2019"
                       )
)

server <- function(input, output, session) {
  
  
  #rmarkdown::render("test.Rmd", output_file = "test.pdf", params = list(testparam = "test123"), envir = new.env(parent = globalenv()))

  
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
