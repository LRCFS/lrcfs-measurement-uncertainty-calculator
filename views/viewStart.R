tabStart = tabItem(tabName = "start",
                   fluidRow(
                     box(title="Welcome to METEOR", width=12,
                         HTML("METEOR is the LRCFS <strong>ME</strong>asuremen<strong>T</strong> of Unc<strong>E</strong>rtaintly Calculat<strong>OR</strong>, which can used to calculator the Expanded Uncertatiny assocaited with drug testing given some calibration data."),
                         hr(),
                         actionButton("helpStart", "Help", icon=icon("question"))
                     )
                   ),
                   fluidRow(
                     column(width=6,
                            fluidRow(
                              box(title = "Case Sample Data", width = 12,
                                p("Specify below the number of replicates and mean concentration for the case sample."),
                                introBox(class="testintrojs",
                                  numericInput("inputCaseSampleReplicates",
                                               "Replicates \\((r_s)\\)",
                                               value = 0),
                                  data.step = 1,
                                  data.intro = "To get started, first enter the number of replicates that you have for your case sample data that you want to compare.",
                                  data.position = "top"
                                ),
                                introBox(class="testintrojs",
                                  numericInput("inputCaseSampleMeanConcentration",
                                               "Mean Concentration\\((x_s)\\)",
                                               value = 0),
                                  data.step = 2,
                                  data.intro = "Of those replicates, enter the mean concentration."
                                )
                              )
                            ),
                            fluidRow(
                              infoBox(HTML("Case Sample<br />Replicates \\((r_s)\\)"),HTML(paste(uiOutput("display_start_replicates"))), width=6, icon=icon("vials"), color="aqua"),
                              infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_start_meanConcentration"))), width=6, icon=icon("map-marker"), color="fuchsia")
                            ),
                            fluidRow(
                              hr()
                            ),
                            fluidRow(
                              box(title = "Confidence Interval",width = 12,
                                p("Specify the condifence interval used to calculate the Exapanded Uncertainty."),
                                introBox(
                                  selectInput("inputConfidenceInterval", "Confidence Interval\\((c_i)\\):",
                                              c("Please select..." = "",
                                                "99.73%" = "99.73%",
                                                "99%" = "99%",
                                                "95.45%" = "95.45%",
                                                "95%" = "95%",
                                                "90%" = "90%",
                                                "68.27%" = "68.27%")),
                                  data.step = 3,
                                  data.intro = "To generate the correct results, specifiy the confidence interval that you test your data against.",
                                  data.position = "top"
                                )
                              )
                            ),
                            fluidRow(
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
                                    introBox(
                                      h4("Upload Data Files"),
                                      p("Using the Browse buttons below please upload the data required for each step for calculating the Expanded Uncertainty."),
                                      p("To make sure your data is in the correct format please download the example CSV files that specify the required format for each calculation."),
                                      data.step = 4,
                                      data.intro = "Finally, upload all relevant files. You only need to upload one type of data but if you upload more then you'll get more accurate results.",
                                      data.position = "left"
                                    ),
                                    hr(),

                                    introBox(
                                      h4("Calibration Curve"),
                                      a("Download Example Calibration Curve CSV", href="https://github.com/LRCFS/lrcfs-measurement-of-uncertainty/blob/master/data/calibrationCurve/calibrationCurveSampleData.csv"),
                                      uiOutput("display_start_calibrationCurveFileUpload"),
                                      a("Download External Standard Error CSV", href="https://github.com/LRCFS/lrcfs-measurement-of-uncertainty/blob/master/data/calibrationCurve/calibrationCurveSampleData.csv"),
                                      uiOutput("display_start_externalStandardErrorFileUpload"),
                                      actionButton("reset_intputCalibrationCurveFileUpload", "Remove Calibration Curve Data", icon=icon("times")),
                                      div(class="clear"),
                                      data.step = 5,
                                      data.intro = "Calibration curve data can be done in one or two parts",
                                      data.position = "left"
                                    ),
                                    hr(),
                                    
                                    introBox(
                                      h4("Method Precsision"),
                                      a("Download Example Method Precision CSV", href="https://github.com/LRCFS/lrcfs-measurement-of-uncertainty/blob/master/data/methodPrecision/methodPrecisionSampleData.csv"),
                                      uiOutput("display_start_methodPrecisionFileUpload"),
                                      actionButton("reset_intputMethodPrecisionFileUpload", "Remove Method Precision Data", icon=icon("times")),
                                      div(class="clear"),
                                      data.step = 6,
                                      data.intro = "Method precision...",
                                      data.position = "left"
                                    ),
                                    hr(),
                                    
                                    introBox(
                                      h4("Standard Solution"),
                                      a("Download Example Standard Solution Structure CSV", href="https://github.com/LRCFS/lrcfs-measurement-of-uncertainty/blob/master/data/standardSolution/standardSolutionSampleData-compoundAndSolutions.csv"),
                                      uiOutput("display_start_standardSolutionStructureFileUpload"),
                                      a("Download Example Standard Solution Equipment CSV", href="https://github.com/LRCFS/lrcfs-measurement-of-uncertainty/blob/master/data/standardSolution/standardSolutionSampleData-measurementInformation.csv"),
                                      uiOutput("display_start_standardSolutionEquipmentFileUpload"),
                                      actionButton("reset_intputStandardSolutionFileUpload", "Remove all Standard Solution Data", icon=icon("times")),
                                      div(class="clear"),
                                      data.step = 7,
                                      data.intro = "Standard Solution...",
                                      data.position = "left"
                                    ),
                                    hr(),
                                    
                                    introBox(
                                      h4("Sample Volume"),
                                      a("Download Example Sample Volume CSV", href="https://github.com/LRCFS/lrcfs-measurement-of-uncertainty/blob/master/data/sampleVolume/sampleVolumeSampleData.csv"),
                                      uiOutput("display_start_sampleVolumeFileUpload"),
                                      actionButton("reset_intputSampleVolumeFileUpload", "Remove Sample Volume Data", icon=icon("times")),
                                      data.step = 8,
                                      data.intro = "Sample Volume...",
                                      data.position = "left"
                                    )
                                )
                            )
                     )
                   )
)
