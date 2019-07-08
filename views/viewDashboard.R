tabDashboard = tabItem(tabName = "dashboard",
                       fluidRow(
                         infoBox("Replicates \\((r_s)\\)",HTML(paste(uiOutput("dashboardReplicates"),'<a href="#" data-toggle="control-sidebar">Modify <i class="fa fa-gears"></i></a>')), width=6),
                         infoBox("Mean Concentration\\((x_s)\\)",HTML(paste(uiOutput("dashboardMeanConcentration"),'<a href="#" data-toggle="control-sidebar">Modify <i class="fa fa-gears"></i></a>')), width=6)
                       ),
                       fluidRow(
                         valueBox("Uncertainty of Calibration Curve", uiOutput("dashboardUncertaintyOfCalibrationCurve"), width = 6, color = "blue", icon = icon("chart-line")),
                         valueBox("Uncertainty of Method Precision", "\\(u_r\\text{(MethodPrec)}=\\)", width = 6, color = "red", icon = icon("bullseye")),
                         valueBox("Uncertainty of Standard Solution", "\\(u_r\\text{(StdSolution)}=\\)", width = 6, color = "green", icon = icon("vial")),
                         valueBox("Uncertainty of Sample Volume", "\\(u_r\\text{(SampleVolume)}=\\)", width = 6, color = "maroon", icon = icon("flask")),
                         valueBox("Combined Uncertainty", "\\(\\text{CombUncertainty}=\\)", width = 6, color = "purple", icon = icon("arrows-alt-v")),
                         valueBox("Effective Degrees of Freedom", "\\(\\text{EffectiveDoF}=\\)", width = 6, color = "teal", icon = icon("exchange-alt")),
                         valueBox("Expanded Uncertainty", "\\(\\text{ExpanUncertainty}=\\)", width = 12, color = "orange", icon = icon("arrows-alt"))
                       )
)
