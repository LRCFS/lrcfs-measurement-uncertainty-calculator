tabDashboard = tabItem(tabName = "dashboard",
                       fluidRow(
                         infoBox("Replicates \\((r_s)\\)",HTML(paste(uiOutput("dashboardReplicates"),'<a href="#" data-toggle="control-sidebar">Modify <i class="fa fa-gears"></i></a>')), width=6),
                         infoBox("Mean Concentration\\((x_s)\\)",HTML(paste(uiOutput("dashboardMeanConcentration"),'<a href="#" data-toggle="control-sidebar">Modify <i class="fa fa-gears"></i></a>')), width=6)
                       ),
                       fluidRow(
                         valueBox("Uncertainty of Calibration Curve", uiOutput("display_calibrationCurve_finalAnswer_dashboard"), width = 6, color = "blue", icon = icon("chart-line")),
                         valueBox("Uncertainty of Method Precision", uiOutput("display_methodPrecision_finalAnswer_dashboard"), width = 6, color = "red", icon = icon("bullseye")),
                         valueBox("Uncertainty of Standard Solution", uiOutput("display_standardSolution_finalAnswer_dashboard"), width = 6, color = "green", icon = icon("vial")),
                         valueBox("Uncertainty of Sample Volume", uiOutput("display_sampleVolume_finalAnswer_dashboard"), width = 6, color = "maroon", icon = icon("flask")),
                         valueBox("Combined Uncertainty", uiOutput("display_combinedUncertainty_finalAnswer_dashboard"), width = 6, color = "purple", icon = icon("arrows-alt-v")),
                         valueBox("Effective Degrees of Freedom", uiOutput("display_effectiveDof_finalAnswer_dashboard"), width = 6, color = "teal", icon = icon("exchange-alt")),
                         valueBox("Expanded Uncertainty", uiOutput("display_expandedUncertainty_finalAnswer_dashboard"), width = 12, color = "orange", icon = icon("arrows-alt"))
                       )
)
