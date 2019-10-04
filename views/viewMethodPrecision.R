tabMethodPrecision = tabItem(tabName = "methodPrecision",
                            fluidRow(
                              valueBox("Uncertainty of Method Precision", h2(uiOutput("display_methodPrecision_finalAnswer_top")), width = 12, color = "red", icon = icon("bullseye"))
                            ),
                            fluidRow(
                              box(title = "Overview", width=6,
                                  p("A step-by-step approach for estimating the uncertainty of method precision is out lined here. The main methodology used is the pooled standard deviation approach."),
                                  p("Where precision experiment is carried out for different nominal values of concentration such low, medium and high, the uncertainty of method precision is calculated for each nominal value separately and the uncertainty used for the combined uncertainty is the value for which the specified case sample concentration is closest to the nominal value.")
                              ),
                              box(title = "Method", width=6,
                                  "The relative standard uncertainty of method precision is given by:",
                                  "$$u_r(\\text{MethodPrec})_{\\text{(NV)}} = \\frac{u(\\text{MethodPrec})_{\\text{(NV)}}}{\\text{NV}},$$",
                                  "where",
                                  "$$u(\\text{MethodPrec})_{\\text{(NV)}} = \\frac{S_{p\\text{(NV)}}}{\\sqrt{r_s}},$$",
                                  "and",
                                  "$$S_{p(\\text{NV})} = \\sqrt{\\frac{\\sum{(S^2 \\times {\\large\\nu})_{\\text{(NV)}}}}{\\sum {\\large\\nu}_{\\text{(NV)}}}}.$$",
                                  tags$ul(
                                    tags$li("\\(S\\) is the individual runs standard deviation"),
                                    tags$li("\\({\\large\\nu}\\) is the individual degrees of freedom"),
                                    tags$li("\\(S_p\\) is the pooled standard deviation"),
                                    tags$li("\\(NV\\) is the nominal value of concentration")
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
                                  box(title="Sum of Degrees of Freedom \\(({\\large\\nu}_\\text{(NV)})\\)", width = 6,
                                      uiOutput("outputSumOfDof")),
                                  box(title="Sum of \\((S^2 \\times {\\large\\nu})_\\text{(NV)}\\)", width = 6,
                                      uiOutput("outputSumOfS2d")),
                                  box(title="Pooled Standard Deviation \\((S_p)\\)", width = 4,
                                      uiOutput("outputPooledStandardDeviation")),
                                  box(title="Standard Uncertainty \\((u)\\)", width = 4,
                                      uiOutput("outputStandardUncertainty")),
                                  box(title="Realtive Standard Uncertainty \\((u_r)\\)", width = 4,
                                      uiOutput("outputRealtiveStandardUncertainties")),
                                  box(title="Uncertainty of Method Precision", width = 12, background = "red", solidHeader = TRUE,
                                      uiOutput("display_methodPrecision_finalAnswer_bottom")
                                  )
                              )
                            )
)
