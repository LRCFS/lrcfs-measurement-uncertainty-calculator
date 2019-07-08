tabCombinedUncertainty = tabItem(tabName = "combinedUncertainty",
                 fluidRow(
                   valueBox("Combined Uncertainty", h2(textOutput("display_combinedUncertainty_finalAnswer_top")), width = 12, color = "purple", icon = icon("arrows-alt-v"))
                 ),
                 fluidRow(
                   tabBox(title="Analysis", width=12,
                          tabPanel(title="Overview",
                                   "Upload your Standard Solution data via the settings menu",
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
                   box(width=12, side="right",
                       title = "Combined Uncertainty", background = "purple", solidHeader = TRUE,
                       textOutput("display_combinedUncertainty_finalAnswer_bottom")
                   )
                 )
)
