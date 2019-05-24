tabQualityControl = tabItem(tabName = "qualityControl",
                            fluidRow(
                              valueBox("Uncertainty of Quality Control", "\\(u_r\\text{(QulControl)}=\\)", width = 12, color = "red", icon = icon("dashboard"))
                            ),
                            fluidRow(
                              column(width = 6,
                                     tabBox(title="Analysis", width=12,
                                            tabPanel(title="Overview",
                                                     "Upload your quality control data and see a whole bunch of cool number."
                                            ),
                                            tabPanel(title="Method",
                                                     "For the analysis of these reports we use the following function:..."
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
                                         h5("Specify below the number of replicates and mean concentration for the sample that the quality control data was tested against."),
                                         fluidRow(
                                           column(6,
                                                  numericInput("inputQualityControlCaseSampleReplicates",
                                                               h5("Replicates \\((r_s)\\)"),
                                                               value = 2)
                                           ),
                                           column(6,
                                                  numericInput("inputQualityControlCaseSampleMeanConcentration",
                                                               h5("Mean Concentration\\((x_s)\\)"),
                                                               value = 2)
                                           )
                                         )
                                     ),
                                     box(title="Upload Quality Control Data (CSV)", width=12,
                                         h5("Select the file to upload your calibration data for calculating the uncertainty."),
                                         fileInput("inputQualityControlfileUpload", "",
                                                   multiple = FALSE,
                                                   accept = c(".csv"))
                                     )          
                              ) 
                            ),
                            fluidRow(
                              tabBox(width=12, side="right",
                                     title = uiOutput("uploadedQualityControlDataStats"),
                                     tabPanel("Graph",
                                              plotlyOutput("qualityControlRawDataGraph")
                                     ),
                                     tabPanel("Raw Data",
                                              DT::dataTableOutput("qualityControlRawData")
                                     )
                              )
                            ),
                            fluidRow(
                              box(width=12,
                                  title = "Step by Step Calculation",
                                  DT::dataTableOutput("qualityControlCalculations"),
                                  hr(),
                                  box(title="Pooled Standard Deviation", width = 6, height=240,
                                      uiOutput("outputPooledStandardDeviation")),
                                  box(title="Standard Uncertainty", width = 6, height=240,
                                      uiOutput("outputStandardUncertainty")),
                                  box(title="Realtive Standard Uncertainty", width = 12, background = "red", solidHeader = TRUE,
                                      uiOutput("outputRealtiveStandardUncertainties"),
                                      box(title="Pooled Realtive Standard Uncertainty", width=12,
                                          uiOutput("outputQualityControlAnswer")
                                      )
                                  )
                              )
                            )
)
