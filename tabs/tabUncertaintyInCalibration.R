tabCalibrationCurve = tabItem(tabName = "calibrationCurve",
                 fluidRow(
                   valueBox("Calculating the Uncertainty of Calibration Curve", h2(textOutput("uncertaintyOfCalibrationCurve")), width = 12, color = "blue", icon = icon("chart-line"))
                 ),
                 
                 fluidRow(
                   column(width = 6,
                          tabBox(title="Analysis", width=12,
                                tabPanel(title="Overview",
                                         "Upload your calibration data and see a whole bunch of cool number."
                                ),
                                tabPanel(title="Method",
                                         "For the analysis of these reports we use the following function:",
                                         getUncertaintyOfCalibrationLatex,
                                         "where \\(S_{y/x}\\) is the standard error of regression given by",
                                         "$$S_{y/x} = \\sqrt{\\frac{\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2}{n-2}}$$"
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
                                           tags$li( "\\(S_{xx}\\) is the sum of squares deviation of \\(x\\) given by \\(\\sum\\limits_{i=1}^n (x_i - \\overline{x})^2\\)")
                                         )
                                )
                          )
                   ),
                   
                   column(width = 6,
                          box(title="Case Sample Properties", width=12,
                              h5("Specify below the number of replicates and mean concentration for the sample that the calibration data was tested against."),
                              fluidRow(
                                column(6,
                                       numericInput("inputCaseSampleReplicates",
                                                    h5("Replicates \\((r_s)\\)"),
                                                    value = 2)
                                ),
                                column(6,
                                       numericInput("inputCaseSampleMeanConcentration",
                                                    h5("Mean Concentration\\((x_s)\\)"),
                                                    value = 2)
                                )
                              )
                          ),
                          box(title="Upload Calibration Data (XLSX)", width=12,
                              h5("Select the file to upload your calibration data for calculating the uncertainty."),
                              fileInput("fileUpload", "",
                                        multiple = FALSE,
                                        accept = c(".xlsx"))
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
                   tabBox(width=12,
                     title = "Computations",
                     id = "tabsetCalibrationData",
                     tabPanel("Step by Step Calculation",
                              DT::dataTableOutput('rearrangedCalibrationData'),
                              hr(),
                              fluidRow(
                                box(title = "Mean of X", width = 4, height=150,"\\(\\overline{x} = \\frac{\\sum{x_i}}{n}\\)", h4(textOutput("xMean"))),
                                box(title = "Sum of Squared Deviation of X", width = 4, height=150,"\\(S_{xx} = \\sum\\limits_{i=1}^n(x_i - \\overline{x})^2\\)", h4(textOutput("sumSqDevationX"))),
                                box(title = "Error Sum of Squares of Y", width = 4, height=150,"\\(\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2\\)", h4(textOutput("errorSumSqY")))
                              ),
                              fluidRow(
                                box(title="Standard Error of Regression", width = 6, height=240,
                                    uiOutput("standardErrorOfRegression")
                                ),
                                box(title="Uncertainty of Calibration", width = 6, height=240,
                                    uiOutput("uncertaintyOfCalibration")
                                )
                              ),
                              fluidRow(
                                box(title="Relative Standard Uncertainty", width = 12, background = "blue", solidHeader = TRUE,
                                    uiOutput("relativeStandardUncertainty")
                                )
                              )
                     )
                     )
                   )
)
