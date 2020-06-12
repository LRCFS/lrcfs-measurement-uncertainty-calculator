tabSampleVolume = tabItem(tabName = "sampleVolume",
                 fluidRow(
                   valueBox("Uncertainty of Sample Volume", h2(uiOutput("display_sampleVolume_finalAnswer_top")), width = 12, color = "maroon", icon = icon("vial"))
                 ),
                 fluidRow(
                   box(title = "Overview", width=5,
                       p("The uncertainty of sample volume quantifies the uncertainty associated with quantifying the volume of case sample through the use of for example pipette.")
                   ),
                   box(title = "Method", width=7,
                       "The RSU of each equipment is computed using:",
                       "$$u_r(\\text{Equipment}) = \\frac{\\frac{\\text{Tolerance}}{\\text{Coverage Factor}}}{\\text{Volume}}$$",
                       "The RSU of sample volume is given by:",
                       "$$u_r\\text{(SampleVolume)} = \\sqrt{\\sum{[u_r(\\text{Equipment})_{\\text{(Vol,Tol)}}^2 \\times N(\\text{Equipment})_{\\text{(Vol,Tol)}}}]}$$",
                       tags$ul(
                         tags$li("\\(N\\text{(Equipment)}\\) is the number of times a piece of equipment is used taking the volume of a given sample.")
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
