mouCalcRightSidebar = rightSidebar(
  background = "dark",
  rightSidebarTabContent(
    id = 1,
    active = TRUE,
    title = "File Upload",
    icon = "folder",
    p("Upload the data for each calculation below."),
    hr(),
    fileInput("intputCalibrationCurveFileUpload", "Calibration Curve (XLSX)",
              multiple = FALSE,
              accept = c(".xlsx")),
    fileInput("inputMethodPrecisionFileUpload", "Method Precision (CSV)",
              multiple = FALSE,
              accept = c(".csv")),
    fileInput("inputStandardSolutionFileUpload", "Standard Solution (CSV)",
              multiple = FALSE,
              accept = c(".csv"))
    ,
    fileInput("intputSampleVolumeFileUpload", "Sample Volume (CSV)",
              multiple = FALSE,
              accept = c(".csv"))
  ),
  rightSidebarTabContent(
    id = 2,
    title = "Case Sample Information",
    p("Specify below the number of replicates and mean concentration for the sample that the calibration data was tested against."),
    numericInput("inputCaseSampleReplicates",
                 "Replicates \\((r_s)\\)",
                 value = 2),
    numericInput("inputCaseSampleMeanConcentration",
                 "Mean Concentration\\((x_s)\\)",
                 value = 2),
    hr(),
    h3("Confidence Interval"),
    p("The confidence interval you specify below does something..."),
    
    
    selectInput("inputConfidenceInterval", "Confidence Interval\\((c_i)\\):",
                c("99.73%" = "99.73%",
                  "99%" = "99%",
                  "95.45%" = "95.45%",
                  "95%" = "95%",
                  "90%" = "90%",
                  "68.27%" = "68.27%"))
  )
)