tabStart = tabItem(tabName = "start",
                   fluidRow(
                     box(title="Welcome to MUCalc", width=12,
                         p("Measurement Uncertainty Calculator (MUCalc) is a software for calculating measurement uncertainty in accordance with the standards of International Organization for Standardization ISO/IEC 17025."),
                         p("This version of the software computes uncertainty components for Method Precision, Standard Solution, Sample Volume and Calibration Curve with the Calibration Curve assumed to be linear. If data is uploaded for all four components, the Combined Uncertainty is computed using all four components. An uncertainty component can be excluded from the Combined Uncertainty by simply not uploading any data for that component."),
                         p("Once data is uploaded, a step by step computation and details of all formulas used can be accessed by clicking on the respective uncertainty component tab displayed at the left hand size of screen. Each uncertainty component tab have three main tabs; Overview, Method and Step by step calculation tab, which together give detailed information on the approached used."),
                         hr(),
                         actionButton("help_start_start", "Help", icon=icon("question"))
                     )
                   ),
                   fluidRow(
                     column(width=6,
                            fluidRow(
                              box(width=12, id="fileUploadBox",
                                  div(
                                    h4("Upload Data Files"),
                                    p("All data should be saved as a CSV file before uploading to MUCalc. The exact format of data required can be accessed by downloading the Example Data file for each uncertainty component. The example data files can be edited to include lab specific data.")
                                  ),
                                  hr(),
                                  
                                  div(id="calcurve",
                                    actionButton("help_start_calcurve", "", icon=icon("question"), class="smallRightHelp"),
                                    h4("Calibration Curve"),
                                    a("Download Example Calibration Curve CSV", href="exampleData/exampleData-calibrationCurve.csv"),
                                    uiOutput("display_start_calibrationCurveFileUpload"),
                                    div("Error with uploaded file...", class="error", id="display_start_error_calibrationCurveFileUpload"),
                                    a("Download External Standard Error CSV", href="exampleData/exampleData-calibrationCurve-externalStandardError.csv"),
                                    uiOutput("display_start_externalStandardErrorFileUpload"),
                                    div("Error with uploaded file...", class="error", id="display_start_error_externalStandardErrorFileUpload"),
                                    actionButton("reset_inputCalibrationCurveFileUpload", "Remove Calibration Curve Data", icon=icon("times")),
                                    div(class="clear")
                                  ),
                                  hr(),
                                  
                                  div(id="methodprec",
                                    actionButton("help_start_methodprec", "", icon=icon("question"), class="smallRightHelp"),
                                    h4("Method Precision"),
                                    a("Download Example Method Precision CSV", href="exampleData/exampleData-methodPrecision.csv"),
                                    uiOutput("display_start_methodPrecisionFileUpload"),
                                    div("Error with uploaded file...", class="error", id="display_start_error_methodPrecisionFileUpload"),
                                    actionButton("reset_inputMethodPrecisionFileUpload", "Remove Method Precision Data", icon=icon("times")),
                                    div(class="clear")
                                  ),
                                  hr(),
                                  
                                  div(id="stdsol",
                                    actionButton("help_start_stdsol", "", icon=icon("question"), class="smallRightHelp"),
                                    h4("Standard Solution"),
                                    a("Download Example Standard Solution Structure CSV", href="exampleData/exampleData-standardSolution-structure.csv"),
                                    uiOutput("display_start_standardSolutionStructureFileUpload"),
                                    div("Error with uploaded file...", class="error", id="display_start_error_standardSolutionStructureFileUpload"),
                                    a("Download Example Standard Solution Equipment CSV", href="exampleData/exampleData-standardSolution-equipment.csv"),
                                    uiOutput("display_start_standardSolutionEquipmentFileUpload"),
                                    div("Error with uploaded file...", class="error", id="display_start_error_standardSolutionEquipmentFileUpload"),
                                    actionButton("reset_inputStandardSolutionFileUpload", "Remove all Standard Solution Data", icon=icon("times")),
                                    div(class="clear")
                                  ),
                                  hr(),
                                  
                                  div(id="samplevol",
                                    actionButton("help_start_samplevol", "", icon=icon("question"), class="smallRightHelp"),
                                    h4("Sample Volume"),
                                    a("Download Example Sample Volume CSV", href="exampleData/exampleData-sampleVolume.csv"),
                                    uiOutput("display_start_sampleVolumeFileUpload"),
                                    div("Error with uploaded file...", class="error", id="display_start_error_sampleVolumeFileUpload"),
                                    actionButton("reset_inputSampleVolumeFileUpload", "Remove Sample Volume Data", icon=icon("times")),
                                    div(class="clear")
                                  ),
                                  hr()
                              )
                            )
                     ),
                     column(width=6,
                            fluidRow(
                              box(title = "Weighted Least Square Regression", width = 12,
                                  actionButton("help_start_weightedLeastSquare", "", icon=icon("question"), class="smallRightHelpInHeader"),
                                  p("To fit a weighted least square regression, the default weight of $w = 1$ must be changed. A weight of $w = 1$ implies an ordinary regression with no weights applied. The following weight options {1/x, 1/x^2,1/y, 1/y^2} are currently available."),
                                  p("Select a weight option to be applied to the model if weighted regression is required. Note that a default weight of '1' results in a simple linear regression with no weighting."),
                                  selectInput("inputWeightLeastSquared", "Weight \\((w)\\):",
                                              c("Default (1)" = 1,
                                                "Concentraion (1/x)" = 2,
                                                "Concentraion Squared (1/x^2)" = 3,
                                                "Peak Area (1/y)" = 4,
                                                "Peak Area Squared (1/y^2)" = 5))
                              )
                            ),
                            fluidRow(
                              box(title = "Case Sample Data", width = 12,
                                  actionButton("help_start_caseSampleData", "", icon=icon("question"), class="smallRightHelpInHeader"),
                                  p("Specify below the number of replicates and mean concentration for the case sample."),
                                  numericInput("inputCaseSampleReplicates",
                                               "Replicates \\((r_s)\\)",
                                               value = NA),
                                  numericInput("inputCaseSampleMeanConcentration",
                                               "Mean Concentration\\((x_s)\\)",
                                               value = NA)
                              ),
                              infoBox(HTML("Case Sample<br />Replicates \\((r_s)\\)"),HTML(paste(uiOutput("display_start_replicates"))), width=6, icon=icon("vials"), color="aqua"),
                              infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_start_meanConcentration"))), width=6, icon=icon("map-marker"), color="fuchsia")
                            ),
                            fluidRow(
                              hr()
                            ),
                            fluidRow(
                              box(title = "Confidence Interval",width = 12,
                                  actionButton("help_start_confidenceInterval", "", icon=icon("question"), class="smallRightHelpInHeader"),
                                  p("The specified Confidence Interval will be used to read the appropriate Coverage Factor from a t- distribution table."),
                                  p("This coverage factor is multiplied by the Combined Uncertainty to obtain the Expanded Uncertainty."),
                                  uiOutput("display_start_chooseConfidenceInterval")
                              ),
                              infoBox("Confidence Interval\\((c_i)\\)",HTML(paste(uiOutput("display_start_confidenceInterval"))), width=12, icon=icon("percentage"), color="yellow")
                            ),
                            fluidRow(
                              hr()
                            ),
                            fluidRow(
                              div(id="percentageExpandedUncertaintyStartPage",
                                  valueBox("Results", uiOutput("display_expandedUncertainty_finalAnswer_start"), width = 12, color = "green", icon = icon("equals")),
                                  box(title="Download Report", width = 12,
                                    p("For reporting purposes and report can be downloaded and stored for all the results uploaded."),
                                    downloadButton("actionButton_start_downloadReport", "Download Report", icon=icon("download"))
                                  )
                              )
                            )
                     )
                   )
)
