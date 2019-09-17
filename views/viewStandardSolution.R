tabStandardSolution = tabItem(tabName = "standardSolution",
                              fluidRow(
                                valueBox("Uncertainty of Standard Solution", h2(uiOutput("display_standardSolution_finalAnswer_top")), width = 12, color = "green", icon = icon("vial"))
                              ),
                              fluidRow(
                                box(title = "Overview", width=6,
                                    p("Information provided on the structure of solution preparation and details of used equipment is displayed here, along with a step-by-step calculation of uncertainty associated with standard solution."),
                                    p("The solution structure is displayed using a network or tree diagram with the root assumed to be the reference compound and the final nodes are assumed to be the main final solutions used for the calibration curve."),
                                    p("If more than one final solution exist (which may be due to splitting the calibration range), the uncertainty associated with standard solution is computed by pooling the relative standard uncertainty (RSU) of the final set of solutions used for the calibration curve")
                                ),
                                box(title = "Method", width=6,
                                    "The RSU of each equipment is computed using:",
                                    "$$u_r(\\text{Equipment}) = \\frac{\\frac{\\text{Tolerance}}{\\text{Coverage Factor}}}{\\text{Volume}}$$",
                                    "The RSU of reference compound is calculated using",
                                    "$$u_r(\\text{Reference Compound}) = \\frac{\\frac{\\text{Tolerance}}{\\text{Coverage Factor}}}{\\text{Purity}}$$",
                                    "The RSU of each solution is computed using",
                                    "$$u_r\\text{(Solution)} = \\sqrt{u_r\\text{(Parent Solution)}^2 + \\sum{[u_r\\text{(Equipment)}^2_{\\text{(Vol,Tol)}} \\times N\\text{(Equipment)}_{\\text{(Vol,Tol)}}]}}$$",
                                    "The overall RSU of standard solution is obtained by pooling the RSU's of the final set of solutions used for generating the calibration curve.",
                                    "$$u_r(\\text{StdSolution}) = \\sqrt{\\sum{u_r\\text{(Final Calibration Solutions)}^2}}$$",
                                    tags$ul(
                                      tags$li("\\(\\text{Parent Solution}\\) is the solution from which a given is solution is made"),
                                      tags$li("\\(N\\text{(Equipment)}\\) is the number of times an equipment is used in the preperation of a given solution")
                                    )
                                )
                              ),
                              fluidRow(
                                tabBox(width=12, side="right",
                                       title = "Loaded Data",
                                       tabPanel("Solutions Network",
                                                grVizOutput("display_standardSolution_solutionsNetwork")
                                       ),
                                       tabPanel("Raw Solution Data",
                                                DT::dataTableOutput("display_standardSolution_solutionRawData")
                                       ),
                                       tabPanel("Raw Measurement Data",
                                                DT::dataTableOutput("display_standardSolution_measurementsRawData")
                                       )
                                )
                              ),
                              fluidRow(
                                box(width=6, side="right",
                                    title = "Standard Uncertainty \\((u)\\)",
                                    uiOutput("display_standardSolution_equipmentStandardUncertainty")
                                ),
                                box(width=6, side="right",
                                    title = "Relative Standard Uncertainty \\((u_r)\\)",
                                    uiOutput("display_standardSolution_equipmentRelativeStandardUncertainty")
                                )
                              ),
                              fluidRow(
                                box(width=12, side="right",
                                    title = "Relative Standard Uncertainty of Solutions",
                                    uiOutput("display_standardSolution_solutionRelativeStandardUncertainty")
                                )
                              ),
                              fluidRow(
                                box(title="Overall Relative Standard Uncertainty of Standard Solution", width = 12, background = "green", solidHeader = TRUE,
                                    uiOutput("display_standardSolution_finalAnswer_bottom")
                                )
                              )
)
