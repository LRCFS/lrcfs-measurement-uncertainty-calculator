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
  ),
  rightSidebarTabContent(
    id = 2,
    title = "Case Sample Information",
    p("Specify below the number of replicates and mean concentration for the sample that the calibration data was tested against."),
    hr(),
    numericInput("inputCaseSampleReplicates",
                 "Replicates \\((r_s)\\)",
                 value = 2),
    numericInput("inputCaseSampleMeanConcentration",
                 "Mean Concentration\\((x_s)\\)",
                 value = 2)
  )
)