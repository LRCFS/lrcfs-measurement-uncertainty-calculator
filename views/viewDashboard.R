tabDashboard = tabItem(tabName = "dashboard", 
                       fluidRow(
                         infoBox(HTML("Case Sample<br />Replicates \\((r_s)\\)"),HTML(paste(uiOutput("display_dashboard_replicates"))), width=4, icon=icon("vials"), color="aqua"),
                         infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_dashboard_meanConcentration"))), width=4, icon=icon("map-marker"), color="fuchsia"),
                         infoBox("Confidence Interval\\(({\\small CI\\%})\\)",HTML(paste(uiOutput("display_dashboard_confidenceInterval"))), width=4, icon=icon("percentage"), color="yellow")
                       ),
                       fluidRow(
                         valueBox("Uncertainty of Calibration Curve", uiOutput("display_calibrationCurve_finalAnswer_dashboard"), width = 6, color = "blue", icon = icon("chart-line")),
                         valueBox("Uncertainty of Method Precision", uiOutput("display_methodPrecision_finalAnswer_dashboard"), width = 6, color = "red", icon = icon("bullseye")),
                         valueBox("Uncertainty of Standard Solution", uiOutput("display_standardSolution_finalAnswer_dashboard"), width = 6, color = "green", icon = icon("vial")),
                         valueBox("Uncertainty of Sample Volume", uiOutput("display_sampleVolume_finalAnswer_dashboard"), width = 6, color = "maroon", icon = icon("flask")),
                         valueBox("Combined Uncertainty", uiOutput("display_combinedUncertainty_finalAnswer_dashboard"), width = 6, color = "purple", icon = icon("arrows-alt-v")),
                         valueBox("Coverage Factor", uiOutput("display_coverageFactor_finalAnswer_dashboard"), width = 6, color = "teal", icon = icon("table")),
                         valueBox("Expanded Uncertainty", uiOutput("display_expandedUncertainty_finalAnswer_dashboard"), width = 6, color = "orange", icon = icon("arrows-alt")),
                         valueBox("% Expanded Uncertainty", uiOutput("display_expandedUncertainty_finalAnswerPercentage_dashboard"), width = 6, color = "orange", icon = icon("arrows-alt"))
                       )
)
