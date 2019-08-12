tabStart = tabItem(tabName = "start",
                   fluidRow(
                     box(title="Welcome to METEOR", width=12,
                         HTML("METEOR is the LRCFS <strong>ME</strong>asuremen<strong>T</strong> of Unc<strong>E</strong>rtaintly Calculat<strong>OR</strong>, which can used to calculator the Expanded Uncertatiny assocaited with drug testing given some calibration data."),
                         hr(),
                         actionButton("helpStartPage", "Help", icon=icon("question"))
                     )
                   ),
                   fluidRow(
                     column(width=6,
                            fluidRow(
                              box(title = "Case Sample Data", width = 12,
                                  actionButton("helpStartPage1", "", icon=icon("question")),
                                  p("Specify below the number of replicates and mean concentration for the case sample."),
                                  numericInput("inputCaseSampleReplicates",
                                               "Replicates \\((r_s)\\)",
                                               value = 0),
                                  numericInput("inputCaseSampleMeanConcentration",
                                               "Mean Concentration\\((x_s)\\)",
                                               value = 0)
                              ),
                              infoBox(HTML("Case Sample<br />Replicates \\((r_s)\\)"),HTML(paste(uiOutput("display_start_replicates"))), width=6, icon=icon("vials"), color="aqua"),
                              infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_start_meanConcentration"))), width=6, icon=icon("map-marker"), color="fuchsia")
                            ),
                            fluidRow(
                              hr()
                            ),
                            fluidRow(
                              box(title = "Confidence Interval",width = 12,
                                  actionButton("helpStartPage5", "", icon=icon("question")),
                                  p("Specify the condifence interval used to calculate the Exapanded Uncertainty."),
                                  selectInput("inputConfidenceInterval", "Confidence Interval\\((c_i)\\):",
                                              c("Please select..." = "",
                                                "99.73%" = "99.73%",
                                                "99%" = "99%",
                                                "95.45%" = "95.45%",
                                                "95%" = "95%",
                                                "90%" = "90%",
                                                "68.27%" = "68.27%"))
                              ),
                              infoBox("Confidence Interval\\((c_i)\\)",HTML(paste(uiOutput("display_start_confidenceInterval"))), width=12, icon=icon("percentage"), color="yellow")
                            ),
                            fluidRow(
                              hr()
                            ),
                            fluidRow(
                              div(id="percentageExpandedUncertaintyStartPage",
                                  valueBox("Results", uiOutput("display_expandedUncertainty_finalAnswer_start"), width = 12, color = "green", icon = icon("equals"))
                              )
                            )
                     ),
                     column(width=6,
                            fluidRow(
                                box(width=12, id="fileUploadBox",
                                    actionButton("helpStartPage6", "", icon=icon("question")),
                                    div(
                                      h4("Upload Data Files"),
                                      p("Using the Browse buttons below please upload the data required for each step for calculating the Expanded Uncertainty."),
                                      p("To make sure your data is in the correct format please download the example CSV files that specify the required format for each calculation.")
                                    ),
                                    hr(),

                                    div(
                                      h4("Calibration Curve"),
                                      a("Download Example Calibration Curve CSV", href="https://github.com/LRCFS/lrcfs-measurement-of-uncertainty/blob/master/data/calibrationCurve/calibrationCurveSampleData.csv"),
                                      uiOutput("display_start_calibrationCurveFileUpload"),
                                      div("There has been an error processing your uploaded file. Please ensure you have uploaded a correctly formatted .csv file", class="error", id="display_start_error_calibrationCurveFileUpload"),
                                      a("Download External Standard Error CSV", href="https://github.com/LRCFS/lrcfs-measurement-of-uncertainty/blob/master/data/calibrationCurve/calibrationCurveSampleData.csv"),
                                      uiOutput("display_start_externalStandardErrorFileUpload"),
                                      actionButton("reset_inputCalibrationCurveFileUpload", "Remove Calibration Curve Data", icon=icon("times")),
                                      div(class="clear")
                                    ),
                                    hr(),
                                    
                                    div(
                                      h4("Method Precsision"),
                                      a("Download Example Method Precision CSV", href="https://github.com/LRCFS/lrcfs-measurement-of-uncertainty/blob/master/data/methodPrecision/methodPrecisionSampleData.csv"),
                                      uiOutput("display_start_methodPrecisionFileUpload"),
                                      actionButton("reset_inputMethodPrecisionFileUpload", "Remove Method Precision Data", icon=icon("times")),
                                      div(class="clear")
                                    ),
                                    hr(),
                                    
                                    div(
                                      h4("Standard Solution"),
                                      a("Download Example Standard Solution Structure CSV", href="https://github.com/LRCFS/lrcfs-measurement-of-uncertainty/blob/master/data/standardSolution/standardSolutionSampleData-compoundAndSolutions.csv"),
                                      uiOutput("display_start_standardSolutionStructureFileUpload"),
                                      a("Download Example Standard Solution Equipment CSV", href="https://github.com/LRCFS/lrcfs-measurement-of-uncertainty/blob/master/data/standardSolution/standardSolutionSampleData-measurementInformation.csv"),
                                      uiOutput("display_start_standardSolutionEquipmentFileUpload"),
                                      actionButton("reset_inputStandardSolutionFileUpload", "Remove all Standard Solution Data", icon=icon("times")),
                                      div(class="clear")
                                    ),
                                    hr(),
                                    
                                    div(
                                      h4("Sample Volume"),
                                      a("Download Example Sample Volume CSV", href="https://github.com/LRCFS/lrcfs-measurement-of-uncertainty/blob/master/data/sampleVolume/sampleVolumeSampleData.csv"),
                                      uiOutput("display_start_sampleVolumeFileUpload"),
                                      actionButton("reset_inputSampleVolumeFileUpload", "Remove Sample Volume Data", icon=icon("times")),
                                      div(class="clear")
                                    ),
                                    hr()
                                )
                            )
                     )
                   )
)
