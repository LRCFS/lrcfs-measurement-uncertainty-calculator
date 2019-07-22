tabStart = tabItem(tabName = "start",
                   fluidRow(
                     box(title="Welcome to METEOR", HTML("METEOR is the LRCFS <strong>ME</strong>asuremen<strong>T</strong> of Unc<strong>E</strong>rtaintly Calculat<strong>OR</strong>, which can used to calculator the Expanded Uncertatiny assocaited with drug testing given some calibration data."), width=12)                   ),
                   fluidRow(
                     column(width=6,
                            fluidRow(
                              box(title = "Case Sample Data", width = 12,
                                p("Specify below the number of replicates and mean concentration for the case sample."),
                                numericInput("inputCaseSampleReplicates",
                                             "Replicates \\((r_s)\\)",
                                             value = 2),
                                numericInput("inputCaseSampleMeanConcentration",
                                             "Mean Concentration\\((x_s)\\)",
                                             value = 2)
                              )
                            ),
                            fluidRow(
                              infoBox("Replicates \\((r_s)\\)",HTML(paste(uiOutput("display_start_replicates"))), width=6, icon=icon("vials"), color="aqua"),
                              infoBox("Mean Concentration\\((x_s)\\)",HTML(paste(uiOutput("display_start_meanConcentration"))), width=6, icon=icon("map-marker"), color="fuchsia")
                            ),
                            fluidRow(
                              hr()
                            ),
                            fluidRow(
                              box(title = "Confidence Interval",width = 12,
                                p("Specify the condifence interval used to calculate the Exapanded Uncertainty."),
                                selectInput("inputConfidenceInterval", "Confidence Interval\\((c_i)\\):",
                                            c("99.73%" = "99.73%",
                                              "99%" = "99%",
                                              "95.45%" = "95.45%",
                                              "95%" = "95%",
                                              "90%" = "90%",
                                              "68.27%" = "68.27%"))
                              )
                            ),
                            fluidRow(
                              infoBox("Confidence Interval\\((c_i)\\)",HTML(paste(uiOutput("display_start_confidenceInterval"))), width=12, icon=icon("percentage"), color="yellow")
                            )
                     ),
                     column(width=6,
                            fluidRow(
                              box(title="Upload Data Files", width=12, id="fileUploadBox",
                                  p("Using the Browse buttons below please upload the data required for each step for calculating the Expanded Uncertainty."),
                                  p("To make sure your data is in the correct format please download the example CSV files that specify the required format for each calculation."),
                                  hr(),
                                  a("Download Example Calibration Curve CSV", href="https://www.google.com/"),
                                  fileInput("intputCalibrationCurveFileUpload", "Calibration Curve (CSV)",
                                            multiple = FALSE,
                                            accept = c(".csv")),
                                  a("Download Example Method Precision CSV", href="https://www.google.com/"),
                                  fileInput("inputMethodPrecisionFileUpload", "Method Precision (CSV)",
                                            multiple = FALSE,
                                            accept = c(".csv")),
                                  a("Download Example Standard Solution Structure CSV", href="https://www.google.com/"),
                                  fileInput("inputStandardSolutionStructureFileUpload", "Standard Solution Structure (CSV)",
                                            multiple = FALSE,
                                            accept = c(".csv")),
                                  a("Download Example Standard Solution Equipment CSV", href="https://www.google.com/"),
                                  fileInput("inputStandardSolutionEquipmentFileUpload", "Standard Solution Equipment (CSV)",
                                            multiple = FALSE,
                                            accept = c(".csv")),
                                  a("Download Example Sample Volume CSV", href="https://www.google.com/"),
                                  fileInput("intputSampleVolumeFileUpload", "Sample Volume (CSV)",
                                            multiple = FALSE,
                                            accept = c(".csv"))
                              )
                            )
                     )
                   )
)
