tabCalibrationCurve = tabItem(tabName = "calibrationCurve",
                 fluidRow(
                   valueBox("Uncertainty of Calibration Curve", h2(textOutput("display_calibrationCurve_finalAnswer_top")), width = 12, color = "blue", icon = icon("chart-line"))
                 ),
                 fluidRow(
                   tabBox(title="Analysis", width=12,
                          tabPanel(title="Overview",
                                   "Upload your calibration data via the settings menu",
                                   HTML('<a href="#" data-toggle="control-sidebar"><i class="fa fa-gears"></i></a>'),
                                   "and see a whole bunch of cool number."
                          ),
                          tabPanel(title="Method",
                                   "For the analysis of these reports we use the following function:",
                                   uiOutput("display_calibrationCurve_uncertaintyOfCalibrationLatex"),
                                   "where \\(S_{y/x}\\) is the standard error of regression given by",
                                   uiOutput("display_calibrationCurve_standardErrorOfRegressionLatex")
                          ),
                          tabPanel(title="Properties",
                                   tags$ul(
                                     tags$li("\\(S_{y/x}\\) is the standard error of regressing \\(y\\) on \\(x\\)"),
                                     tags$li("\\(b_1\\) is the slop of the of regression line"),
                                     tags$li("\\(r_s\\) is the number of replicates made on test sample to determine \\(x_s\\)"),
                                     tags$li("\\(n\\) is the number of measurements used to generate the calibration curve"),
                                     tags$li("\\(x_s\\) is the the amount of THC in test sample"),
                                     tags$li("\\(\\overline{x}\\) is the mean values of the different calibration standards"),
                                     tags$li("\\(x_i\\) is the target calibrator concentration at the \\(i\\) level"),
                                     tags$li("\\(S_{xx}\\) is the sum of squares deviation of \\(x\\) given by \\(\\sum\\limits_{i=1}^n (x_i - \\overline{x})^2\\)")
                                   )
                          )  
                   )
                 ),
                 fluidRow(
                   tabBox(width=12, side="right",
                          title = uiOutput("uploadedCalibrationDataStats"),
                           tabPanel("Graph",
                                    plotlyOutput("peakAreaRatios")
                           ),
                           tabPanel("Raw Data",
                                    DT::dataTableOutput("calibrationData")
                           )
                   )
                 ),
                 fluidRow(
                   box(title = "Step by Step Calculations", width=12,
                     DT::dataTableOutput('rearrangedCalibrationData'),
                     hr(),
                     fluidRow(
                       infoBox(HTML("Case Sample<br />Replicates \\((r_s)\\)"),HTML(paste(uiOutput("display_calibrationCurve_replicates"))), width=6, icon=icon("vials"), color="aqua"),
                       infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_calibrationCurve_meanConcentration"))), width=6, icon=icon("map-marker"), color="fuchsia")
                     ),
                     fluidRow(
                       box(title = "Linear Regression", width = 3, uiOutput("display_calibrationCurve_linearRegression")),
                       box(title = "Mean of \\(x\\)", width = 3, uiOutput("display_calibrationCurve_meanOfX")),
                       box(title = "Sum of Squared Deviation of \\(x\\)", width = 3, uiOutput("display_calibrationCurve_sumSqDevationX")),
                       box(title = "Error Sum of Squares of \\(y\\)", width = 3, uiOutput("display_calibrationCurve_errorSumSqY"))
                     ),
                     fluidRow(
                       box(title="Standard Error of Regression \\((S_{y/x})\\)", width = 6,
                           uiOutput("standardErrorOfRegression")
                       ),
                       box(title="Uncertainty of Calibration \\((u)\\)", width = 6,
                           uiOutput("uncertaintyOfCalibration")
                       )
                     ),
                     fluidRow(
                       box(title="Relative Standard Uncertainty \\((u_r)\\)", width = 12, background = "blue", solidHeader = TRUE,
                           uiOutput("display_calibrationCurve_finalAnswer_bottom")
                       )
                     )
                     
                   )
                 )
)
