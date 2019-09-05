tabCalibrationCurve = tabItem(tabName = "calibrationCurve",
                 fluidRow(
                   valueBox("Uncertainty of Calibration Curve", h2(textOutput("display_calibrationCurve_finalAnswer_top")), width = 12, color = "blue", icon = icon("chart-line")),
                   actionButton("helpCalibrationCurve", "Help", icon=icon("question"))
                 ),
                 fluidRow(
                   box(title = "Overview", width=6,
                       p("Lorem ipsum Suspendisse ultrices, lorem eget pellentesque eleifend, lectus ipsum tincidunt metus, venenatis accumsan libero diam eu velit. Cras et porttitor nisi. Ut blandit egestas lectus, eget suscipit elit efficitur eget. Quisque erat velit, interdum sit amet cursus at, auctor in quam. Integer vestibulum dolor quam, non scelerisque mi aliquet non. Aliquam erat volutpat."),
                       p("Sed posuere ligula metus, ac placerat tortor tincidunt quis. Nam aliquam faucibus viverra. Duis imperdiet blandit massa, quis malesuada neque malesuada vel. Nam eget sodales libero, sed hendrerit est. Duis et magna sit amet lacus pellentesque placerat vitae a nunc. Integer quis placerat dolor. Donec at laoreet quam. Fusce ut lacus eget lacus dictum fermentum. Duis vel faucibus turpis. Vivamus placerat finibus congue. Nullam quis viverra lectus. Phasellus hendrerit ac est vitae euismod. Praesent a sodales justo.")
                   ),
                   box(title = "Method", width=6,
                       "For the analysis of these reports we use the following function:",
                       "$$u\\text{(CalCurve)} = \\frac{S_{y/x}}{b_1} \\sqrt{\\frac{1}{r_s} + \\frac{1}{n} + \\frac{(x_s - \\overline{x})^2}{S_{xx}}}$$",
                       "where \\(S_{y/x}\\) is the standard error of regression given by",
                       "$$S_{x/y} = \\sqrt{\\frac{\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2}{n-2}}$$",
                       tags$ul(
                         tags$li("\\(S_{y/x}\\) is the standard error of regressing \\(y\\) on \\(x\\)"),
                         tags$li("\\(b_1\\) is the slope of the of regression line"),
                         tags$li("\\(r_s\\) is the number of replicates made on test sample to determine \\(x_s\\)"),
                         tags$li("\\(n\\) is the number of measurements used to generate the calibration curve"),
                         tags$li("\\(x_s\\) is the the amount of THC in test sample"),
                         tags$li("\\(\\overline{x}\\) is the mean values of the different calibration standards"),
                         tags$li("\\(x_i\\) is the target calibrator concentration at the \\(i\\) level"),
                         tags$li("\\(S_{xx}\\) is the sum of squares deviation of \\(x\\) given by \\(\\sum\\limits_{i=1}^n (x_i - \\overline{x})^2\\)")
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
                       uiOutput("display_calibrationCurve_peakAreaRatioOfCaseSample"),
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