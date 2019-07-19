tabMethodPrecision = tabItem(tabName = "methodPrecision",
                            fluidRow(
                              valueBox("Uncertainty of Method Precision", h2(uiOutput("display_methodPrecision_finalAnswer_top")), width = 12, color = "red", icon = icon("bullseye"))
                            ),
                            fluidRow(
                               tabBox(title="Analysis", width=12,
                                      tabPanel(title="Overview",
                                               "Upload your Method Precision data via the settings menu",
                                               HTML('<a href="#" data-toggle="control-sidebar"><i class="fa fa-gears"></i></a>'),
                                               "and see a whole bunch of cool number."
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
                            fluidRow(
                              tabBox(width=12, side="right",
                                     title = uiOutput("uploadedMethodPrecisionDataStats"),
                                     tabPanel("Graph",
                                              plotlyOutput("methodPrecisionRawDataGraph")
                                     ),
                                     tabPanel("Raw Data",
                                              DT::dataTableOutput("methodPrecisionRawData")
                                     )
                              )
                            ),
                            fluidRow(
                              box(width=12,
                                  title = "Step by Step Calculation",
                                  DT::dataTableOutput("methodPrecisionCalculations"),
                                  hr(),
                                  box(title="Sum of Degrees of Freedom \\((d_\\text{(NV)})\\)", width = 6,
                                      uiOutput("outputSumOfDof")),
                                  box(title="Sum of \\((S^2 \\times d)_\\text{(NV)}\\)", width = 6,
                                      uiOutput("outputSumOfS2d")),
                                  box(title="Pooled Standard Deviation", width = 4,
                                      uiOutput("outputPooledStandardDeviation")),
                                  box(title="Standard Uncertainty", width = 4,
                                      uiOutput("outputStandardUncertainty")),
                                  box(title="Realtive Standard Uncertainty", width = 4,
                                      uiOutput("outputRealtiveStandardUncertainties")),
                                  box(title="Uncertainty of Method Precision", width = 12, background = "red", solidHeader = TRUE,
                                      uiOutput("display_methodPrecision_finalAnswer_bottom")
                                  )
                              )
                            )
)
