tabDashboard = tabItem(tabName = "dashboard",
                       fluidRow(
                         valueBox("Uncertainty of Calibration Curve", uiOutput("dashboardUncertaintyOfCalibrationCurve"), width = 12, color = "blue", icon = icon("chart-line")),
                         valueBox("Uncertainty of Quality Control", "\\(u_r\\text{(QulControl)}=\\)", width = 6, color = "red", icon = icon("dashboard")),
                         valueBox("Uncertainty of Standard Solution", "\\(u_r\\text{(StdSolution)}=\\)", width = 6, color = "green", icon = icon("vial")),
                         valueBox("Combined Uncertainty", "\\(u_r\\text{(CombUncertainty)}=\\)", width = 6, color = "purple", icon = icon("gitter")),
                         valueBox("Expanded Uncertainty", "\\(u_r\\text{(ExpanUncertainty)}=\\)", width = 6, color = "orange", icon = icon("chart-area"))
                       )
)
