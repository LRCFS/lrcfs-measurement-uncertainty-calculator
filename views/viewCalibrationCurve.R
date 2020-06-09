tabCalibrationCurve = tabItem(tabName = "calibrationCurve",
                 fluidRow(
                   valueBox("Uncertainty of Calibration Curve", h2(textOutput("display_calibrationCurve_finalAnswer_top")), width = 12, color = "blue", icon = icon("chart-line")),
                   actionButton("helpCalibrationCurve", "Help", icon=icon("question"))
                 ),
                 fluidRow(
                   box(title = "Overview", width=6,
                       p("All computations and details of formulas used for computing the uncertainty of the calibration curve are displayed here. This version of the software assumes a linear calibration curve with the option to specify weights if weighted least square regression is required."),
                       p("The Method tab shows the main formulas used to compute the uncertainty of the calibration curve for both weighted and unweighted least square regression.")
                   ),
                   tabBox(title = "Method", width=6,
                          tabPanel("Non-Weighted",
                                   "The uncertainty of calibration curve is given by:",
                                   "$$u\\text{(CalCurve)} = \\frac{S_{y/x}}{b_1} \\sqrt{\\frac{1}{r_s} + \\frac{1}{n} + \\frac{(x_s - \\overline{x})^2}{S_{xx}}}$$",
                                   "where \\(S_{y/x}\\) is the standard error of regression given by",
                                   "$$S_{y/x} = \\sqrt{\\frac{\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2}{n-2}}$$",
                                   tags$ul(
                                     tags$li("\\(x_i\\) concentration at level \\(i\\) "),
                                     tags$li("\\(y_i\\) observed peak area ratio for a given concentration \\(x_i\\)"),
                                     tags$li("\\(\\hat{y}_i\\) predicted value of \\(y\\) for a given value \\(x_i\\)"),
                                     tags$li("\\(b_1\\) is the Slope of the of regression line"),
                                     tags$li("\\(x_s\\) is the mean concentration of the Case Sample"),
                                     tags$li("\\(r_s\\) is the number of replicates made on test sample to determine \\(x_s\\)"),
                                     tags$li("\\(n\\) is the number of measurements used to generate the Calibration Curve"),
                                     tags$li("\\(\\overline{x}\\) is the mean values of the different calibration standards"),
                                     tags$li("\\(S_{xx}\\) is the sum of squares deviation of \\(x\\) given by \\(\\sum\\limits_{i=1}^n (x_i - \\overline{x})^2\\)")
                                   )
                          ),
                          tabPanel("Weighted",
                                   "Where weight is specified the uncertainty of calibration curve is given by:",
                                   "$$u\\text{(CalCurve)} = \\frac{S_{w}}{b_1} \\sqrt{\\frac{1}{w_{s}} + \\frac{1}{n} + \\frac{(y_s - \\overline{y}_w)^2}{b_1^2[\\sum{wx^2-n(\\overline{x}_w)^2}]} }$$",
                                   "where \\(S_w\\) is the standard error of regression given by",
                                   "$$S_w = \\sqrt{\\frac{\\sum\\limits_{i=1}^n w_i(y_i-\\hat{y}_i)^2}{n-2}}$$",
                                   tags$ul(
                                     tags$li("\\(x_i\\) concentration at level \\(i\\) "),
                                     tags$li("\\(y_i\\) observed peak area ratio for a given concentration \\(x_i\\)"),
                                     tags$li("\\(\\hat{y}_i\\) predicted value of \\(y\\) for a given value \\(x_i\\)"),
                                     tags$li("\\(b_1\\) is the Slope of the of the weighted regression line"),
                                     tags$li("\\(y_s\\) is the mean of Peak Area Ratio of the Case Sample"),
                                     tags$li("\\(\\overline{y}_w\\) is the weighted mean of peak area ratios"),
                                     tags$li("\\(n\\) is the number of measurements used to generate the Calibration Curve"),
                                     tags$li("\\(\\overline{x}_w\\) is the mean values of the different calibration standards"),
                                     tags$li("\\(w\\) is the specified Weight"),
                                     tags$li("\\(w_s\\) is the Weight of Case Sample")
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
                   infoBox(HTML("Case Sample<br />Replicates \\((r_s)\\)"),HTML(paste(uiOutput("display_calibrationCurve_replicates"))), width=4, icon=icon("vials"), color="aqua"),
                   infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_calibrationCurve_meanConcentration"))), width=4, icon=icon("map-marker"), color="fuchsia"),
                   uiOutput("display_calibrationCurve_meanPar")
                 ),
                 fluidRow(
                   box(title = "Step by Step Calculations", width=12,
                     DT::dataTableOutput('rearrangedCalibrationData'),
                     fluidRow(
                       box(title = "Linear Regression", width = 3, uiOutput("display_calibrationCurve_linearRegression")),
                       uiOutput("display_calibrationCurve_meanOfX"),
                       uiOutput("display_calibrationCurve_weightedMeanOfX"),
                       uiOutput("display_calibrationCurve_meanOfY"),
                       uiOutput("display_calibrationCurve_weightedMeanOfY"),
                       uiOutput("display_calibrationCurve_sumOfSquaredDeviationOfX"),
                       uiOutput("display_calibrationCurve_sumOfWeightedXSquared")
                     ),
                     fluidRow(
                       box(title = "Error Sum of Squares of \\(y\\)", width = 3, uiOutput("display_calibrationCurve_errorSumSqY")),
                       box(title="Standard Error of Regression \\((S_{y/x})\\)", width = 3,
                           uiOutput("standardErrorOfRegression")
                       ),
                       uiOutput("display_calibrationCurve_weightedCaseSample")
                     ),
                     fluidRow(
                       uiOutput("display_calibrationCurve_externalStandardErrorUploadedData")
                     ),
                     fluidRow(
                       uiOutput("display_calibrationCurve_externalStandardErrorOfRuns"),
                       uiOutput("display_calibrationCurve_externalStandardErrorOfRunsPooled")
                     ),
                     fluidRow(
                       box(title="Uncertainty of Calibration \\((u)\\)", width = 12,
                           uiOutput("display_calibrationCurve_uncertaintyOfCalibration")
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