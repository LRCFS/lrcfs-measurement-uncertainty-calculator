tabCombinedUncertainty = tabItem(tabName = "combinedUncertainty",
                 fluidRow(
                   valueBox("Combined Uncertainty", h2(uiOutput("display_combinedUncertainty_finalAnswer_top")), width = 12, color = "purple", icon = icon("arrows-alt-v"))
                 ),
                 fluidRow(
                   box(title = "Overview", width=6,
                       p("The combined uncertainty is obtained by combining all the individual uncertainty components."),
                       p("If data is uploaded for all the uncertainty components; Calibration curve, Method Precision, Standard Solution and Sample Volume, relative standard uncertainty is computed for each uncertainty component and are combined to obtain the Combined Uncertainty of the analytical process."),
                       p("If data is omitted for some uncertainty components, NA's will be displayed for those components and the Combined Uncertainty will only take into account components for which data is provided. ")
                   ),
                   box(title = "Method", width=6,
                       "The combined uncertainty is given by:",
                       "$$\\text{CombUncertainty} = x_s \\sqrt{\\sum{u_r\\text{(Individual Uncertainty Component)}^2}}$$",
                       tags$ul(
                         tags$li("\\(x_s\\) is the Case Sample Mean Concentration")
                       )
                   )
                 ),
                 fluidRow(
                   valueBox(uiOutput("display_calibrationCurve_finalAnswer_combinedUncertainty"),"\\(u_r\\text{(CalCurve)}\\)", width = 4, color = "blue", icon = icon("chart-line")),
                   valueBox(uiOutput("display_methodPrecision_finalAnswer_combinedUncertainty"),"\\(u_r\\text{(MethodPrec)}\\)", width = 4, color = "red", icon = icon("bullseye")),
                   valueBox(uiOutput("display_standardSolution_finalAnswer_combinedUncertainty"),"\\(u_r\\text{(StdSolution)}\\)", width = 4, color = "green", icon = icon("vial")),
                   valueBox(uiOutput("display_sampleVolume_finalAnswer_combinedUncertainty"),"\\(u_r\\text{(SampleVolume)}\\)", width = 4, color = "maroon", icon = icon("flask")),
                   infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_combinedUncertainty_meanConcentration"))), width=4, icon=icon("map-marker"), color="fuchsia")
                 ),
                 fluidRow(
                   box(width=12, side="right",
                       title = "Combined Uncertainty", background = "purple", solidHeader = TRUE,
                       uiOutput("display_combinedUncertainty_finalAnswer_bottom")
                   )
                 )
)
