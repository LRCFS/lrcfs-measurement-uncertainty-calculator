###################################################################################
# Outputs
###################################################################################

output$display_start_replicates <- renderUI({
  string = paste(input$inputCaseSampleReplicates)
  return(string)
})

output$display_start_meanConcentration <- renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_start_confidenceInterval <- renderUI({
  string = paste(input$inputConfidenceInterval)
  return(string)
})

output$display_start_chooseConfidenceInterval = renderUI({
  columnNames = colnames(coverageFactorEffectiveDofTable[,-1]) #Get the columns but excluse the first column which is used for effective dof
  columnNames = sort(columnNames, decreasing = TRUE)
  
  selectInput("inputConfidenceInterval", "Confidence Interval \\( ( {\\small CI} \\% ) \\):",
              c("Please select..." = "",
                columnNames))
})

output$display_start_calibrationCurveFileUpload <- renderUI({
  input$reset_inputCalibrationCurveFileUpload #This line is here to attach the event to update when the button is clicked

  fileInput = fileInput("inputCalibrationCurveFileUpload", "Calibration Curve (CSV)",
                        multiple = FALSE,
                        accept = c(".csv"))
  
  return(fileInput)
})

output$display_start_externalStandardErrorFileUpload <- renderUI({
  input$reset_inputCalibrationCurveFileUpload #This line is here to attach the event to update when the button is clicked
  
  fileInput = fileInput("inputExternalStandardErrorFileUpload", "Pooled Standard Error (CSV)",
                        multiple = FALSE,
                        accept = c(".csv"))
  
  return(fileInput)
})

output$display_start_methodPrecisionFileUpload <- renderUI({
  input$reset_inputMethodPrecisionFileUpload #This line is here to attach the event to update when the button is clicked
  
  fileInput = fileInput("inputMethodPrecisionFileUpload", "Method Precision (CSV)",
                        multiple = FALSE,
                        accept = c(".csv"))
  
  return(fileInput)
})

output$display_start_standardSolutionStructureFileUpload <- renderUI({
  input$reset_inputStandardSolutionFileUpload #This line is here to attach the event to update when the button is clicked
  
  fileInput = fileInput("inputStandardSolutionStructureFileUpload", "Standard Solution Structure (CSV)",
                        multiple = FALSE,
                        accept = c(".csv"))
  
  return(fileInput)
})

output$display_start_standardSolutionEquipmentFileUpload <- renderUI({
  input$reset_inputStandardSolutionFileUpload #This line is here to attach the event to update when the button is clicked
  
  fileInput = fileInput("inputStandardSolutionEquipmentFileUpload", "Standard Solution Equipment (CSV)",
                        multiple = FALSE,
                        accept = c(".csv"))
  
  return(fileInput)
})

output$display_start_sampleVolumeFileUpload <- renderUI({
  input$reset_inputSampleVolumeFileUpload #This line is here to attach the event to update when the button is clicked
  
  fileInput = fileInput("inputSampleVolumeFileUpload", "Sample Volume (CSV)",
                        multiple = FALSE,
                        accept = c(".csv"))
  
  return(fileInput)
})

output$actionButton_start_downloadReport = downloadHandler(
  filename = paste0(APP_DEV_SHORT,"-",APP_NAME_SHORT,"-Report.html"),
  content = function(file) {
    # Copy the report file to a temporary directory before processing it, in
    # case we don't have write permissions to the current working dir (which
    # can happen when deployed).
    tempReport <- file.path(tempdir(), "temp_report.Rmd")
    file.copy("views/report.Rmd", tempReport, overwrite = TRUE)
    
    # Set up parameters to pass to Rmd document
    paramList = list(TIME = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
                    APP_DEV = APP_DEV,
                    APP_DEV_SHORT = APP_DEV_SHORT,
                    APP_NAME = APP_NAME,
                    APP_NAME_SHORT = APP_NAME_SHORT,
                    APP_VER = APP_VER,
                    APP_LINK = APP_LINK,
                    calibrationCurveData = getDataCalibrationCurve(),
                    calibrationCurveDataReformatted = getDataCalibrationCurveReformatted(),
                    externalStandardErrorData = getDataExternalStandardError(),
                    methodPrecisionData = methodPrecisionData(),
                    standardSolutionData = standardSolutionData(),
                    standardSolutionEquipmentData = standardSolutionMeasurementData(),
                    sampleVolumeData = getDataSampleVolume(),
                    inputWeightLeastSquared = doGetCalibrationCurve_wlsLatex(input$inputWeightLeastSquared),
                    inputCaseSampleReplicates = input$inputCaseSampleReplicates,
                    inputCaseSampleMeanConcentration = input$inputCaseSampleMeanConcentration,
                    inputConfidenceInterval = input$inputConfidenceInterval,
                    uncCalibrationCurve = getResultCalibrationCurve(),
                    uncMethodPrecision = methodPrecisionResult(),
                    uncStandardSolution = standardSolutionResult(),
                    uncSampleVolume = getResultSampleVolume(),
                    combinedUncertaintyResult = combinedUncertaintyResult(),
                    coverageFactorResult = coverageFactorResult(),
                    expandedUncertaintyResult = expandedUncertaintyResult(),
                    expandedUncertaintyResultPercentage = expandedUncertaintyResultPercentage())

    
    # Knit the document, passing in the `params` list, and eval it in a
    # child of the global environment (this isolates the code in the document
    # from the code in this app).
    rmarkdown::render(tempReport, output_file = file,
                      params = paramList,
                      envir = new.env(parent = globalenv())
    )
  }
)
