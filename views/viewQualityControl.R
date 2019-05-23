tabQualityControl = tabItem(tabName = "qualityControl",
                 fluidRow(
                   valueBox("Uncertainty of Quality Control", "\\(u_r\\text{(QulControl)}=\\)", width = 12, color = "red", icon = icon("dashboard")),
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
