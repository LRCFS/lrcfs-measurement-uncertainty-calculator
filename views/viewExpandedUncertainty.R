tabExpandedUncertainty = tabItem(tabName = "expandedUncertainty",
                 fluidRow(
                   valueBox("Expanded Uncertainty", h2(uiOutput("display_expandedUncertainty_finalAnswer_top")), width = 12, color = "orange", icon = icon("arrows-alt"))
                 ),
                 fluidRow(
                   box(title = "Overview", width=6,
                       p("The expanded uncertainty  is the final step of measurement uncertainty computation. It is computed by multiplying the combined uncertainty with the coverage factor.")
                   ),
                   box(title = "Method", width=6,
                       p("The expanded uncertainty \\(\\text{(ExpUncertainty)}\\) is given by:"),
                       p("$$\\text{ExpUncertainty} = k_{{\\large\\nu}_{\\text{eff}}, {\\small CI\\%}} \\times \\text{CombUncertainty}$$"),
                       p("with percentage expanded uncertainty given by:"),
                       p("$$\\text{%ExpUncertainty} = \\frac{\\text{ExpUncertainty}}{x_s} \\times 100$$"),
                       p("where:"),
                       tags$ul(
                         tags$li("\\(k_{{\\large\\nu}_{\\text{eff}}, {\\small CI\\%}}\\) is the coverage factor based on effective degrees of freedom and specified confidence interval percentage."),
                         tags$li("\\({\\small\\text{CombUncertainty}}\\) is the combined uncertainty."),
                         tags$li("\\(x_s\\) case sample mean concentration.")
                       )
                   )
                 ),
                 fluidRow(
                   valueBox(uiOutput("display_coverageFactor_finalAnswer_expandedUncertainty"),uiOutput("display_expandedUncertainty_coverageFactorText"), width = 4, color = "teal", icon = icon("table")),
                   valueBox(uiOutput("display_combinedUncertainty_finalAnswer_expandedUncertainty"),"\\(\\text{CombUncertainty}\\)", width = 4, color = "purple", icon = icon("arrows-alt-v")),
                   infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_expandedUncertainty_meanConcentration"))), width=4, icon=icon("map-marker"), color="fuchsia")
                 ),
                 fluidRow(
                   box(width=6, side="right",
                       title = "Expanded Uncertainty", background = "orange", solidHeader = TRUE,
                       uiOutput("display_expandedUncertainty_finalAnswer_bottom")
                   ),
                   box(width=6, side="right",
                       title = "Percentage Expanded Uncertainty", background = "orange", solidHeader = TRUE,
                       uiOutput("display_expandedUncertainty_finalAnswerPercentage_bottom")
                   )
                 )
)
