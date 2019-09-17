tabSampleVolume = tabItem(tabName = "sampleVolume",
                 fluidRow(
                   valueBox("Uncertainty of Sample Volume", h2(uiOutput("display_sampleVolume_finalAnswer_top")), width = 12, color = "maroon", icon = icon("flask"))
                 ),
                 fluidRow(
                   box(title = "Overview", width=6,
                       p("The uncertainty of sample volume quantifies the uncertainty associated with quantifying the volume of case sample through the use of for example pipette.")
                   ),
                   box(title = "Method", width=6,
                       "The RSU of each equipment is computed using:",
                       "$$u_r(\\text{Equipment}) = \\frac{\\frac{\\text{Tolerance}}{\\text{Coverage Factor}}}{\\text{Volume}}$$",
                       "For more than one equipment, the RSU of sample volume is obtained by pooling the individual uncertainties using",
                       "$$u_r\\text{(SampleVolume)} = \\sqrt{\\sum{[u_r(SampleVolume)_{\\text{(Equipment)}}^2 \\times N(\\text{Equipment})}]}$$",
                       
                       "$$u_r(\\text{Reference Compound}) = \\frac{\\frac{\\text{Tolerance}}{\\text{Coverage Factor}}}{\\text{Purity}}$$",
                       "The RSU of each solution is computed using",
                       "$$u_r\\text{(Solution)} = \\sqrt{u_r\\text{(Parent Solution)}^2 + \\sum{[u_r\\text{(Equipment)}^2_{\\text{(Vol,Tol)}} \\times N\\text{(Equipment)}_{\\text{(Vol,Tol)}}]}}$$",
                       "The overall RSU of standard solution is obtained by pooling the RSU's of the final set of solutions used for generating the calibration curve.",
                       "$$u_r(\\text{StdSolution}) = \\sqrt{\\sum{u_r\\text{(Final Calibration Solutions)}^2}}$$",
                       tags$ul(
                         tags$li("\\(N\\text{(Equipment)}\\) is the number of times an equipment is used in the preperation of a given solution")
                       )
                   )
                 ),
                 fluidRow(
                   tabBox(width=12, side="right",
                          title = "Loaded Data",
                          tabPanel("Raw Sample Volume Data",
                                   DT::dataTableOutput("display_sampleVolume_rawDataTable")
                          )
                   )
                 ),
                 fluidRow(
                   box(width=6, side="right",
                       title = "Standard Uncertainty",
                       uiOutput("display_sampleVolume_standardUncertainty")
                   ),
                   box(width=6, side="right",
                       title = "Relative Standard Uncertainty",
                       uiOutput("display_sampleVolume_relativeStandardUncertainty")
                   )
                 ),
                 fluidRow(
                   box(width=12, side="right",
                       title = "Overall Relative Standard Uncertainty", background = "maroon", solidHeader = TRUE,
                       uiOutput("display_sampleVolume_finalAnswer_bottom")
                   )
                 )
)
