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

output$display_start_calibrationCurveFileUpload <- renderUI({
  input$reset_inputCalibrationCurveFileUpload #This line is here to attach the event to update when the button is clicked

  fileInput = fileInput("inputCalibrationCurveFileUpload", "Calibration Curve (CSV)",
                        multiple = FALSE,
                        accept = c(".csv"))
  
  return(fileInput)
})

output$display_start_externalStandardErrorFileUpload <- renderUI({
  input$reset_inputCalibrationCurveFileUpload #This line is here to attach the event to update when the button is clicked
  
  fileInput = fileInput("inputExternalStandardErrorFileUpload", "External Standard Error (CSV)",
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
  filename = paste0("moucalc-report_",format(Sys.time(), "%Y%m%d_%H%M%S"),".html"),
  content = function(file) {
    # Copy the report file to a temporary directory before processing it, in
    # case we don't have write permissions to the current working dir (which
    # can happen when deployed).
    tempReport <- file.path(tempdir(), "temp_report.Rmd")
    file.copy("data/report.Rmd", tempReport, overwrite = TRUE)
    
    # Set up parameters to pass to Rmd document
    params <- list(calibrationCurveData = calibrationCurveData(),
                   calibrationCurveDataReformatted = calibrationCurveDataReformatted(),
                   externalStandardErrorData = externalStandardErrorData(),
                   methodPrecisionData = methodPrecisionData(),
                   standardSolutionData = standardSolutionData(),
                   standardSolutionEquipmentData = standardSolutionMeasurementData(),
                   sampleVolumeData = sampleVolumeData(),
                   inputCaseSampleReplicates = input$inputCaseSampleReplicates,
                   inputCaseSampleMeanConcentration = input$inputCaseSampleMeanConcentration,
                   inputConfidenceInterval = input$inputConfidenceInterval,
                   uncCalibrationCurve = calibrationCurveResult(),
                   uncMethodPrecision = methodPrecisionResult(),
                   uncStandardSolution = standardSolutionResult(),
                   uncSampleVolume = sampleVolumeResult(),
                   combinedUncertaintyResult = combinedUncertaintyResult(),
                   expandedUncertaintyResult = expandedUncertaintyResult(),
                   expandedUncertaintyResultPercentage = expandedUncertaintyResultPercentage())

    
    # Knit the document, passing in the `params` list, and eval it in a
    # child of the global environment (this isolates the code in the document
    # from the code in this app).
    rmarkdown::render(tempReport, output_file = file,
                      params = params,
                      envir = new.env(parent = globalenv())
    )
  }
)
