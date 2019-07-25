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
  input$reset_intputCalibrationCurveFileUpload

  fileInput = fileInput("intputCalibrationCurveFileUpload", "Calibration Curve (CSV)",
                        multiple = FALSE,
                        accept = c(".csv"))
  
  return(fileInput)
})

output$display_start_methodPrecisionFileUpload <- renderUI({
  input$reset_intputMethodPrecisionFileUpload
  
  fileInput = fileInput("inputMethodPrecisionFileUpload", "Method Precision (CSV)",
                        multiple = FALSE,
                        accept = c(".csv"))
  
  return(fileInput)
})

output$display_start_standardSolutionStructureFileUpload <- renderUI({
  input$reset_intputStandardSolutionFileUpload
  
  fileInput = fileInput("inputStandardSolutionStructureFileUpload", "Standard Solution Structure (CSV)",
                        multiple = FALSE,
                        accept = c(".csv"))
  
  return(fileInput)
})

output$display_start_standardSolutionEquipmentFileUpload <- renderUI({
  input$reset_intputStandardSolutionFileUpload
  
  fileInput = fileInput("inputStandardSolutionEquipmentFileUpload", "Standard Solution Equipment (CSV)",
                        multiple = FALSE,
                        accept = c(".csv"))
  
  return(fileInput)
})

output$display_start_sampleVolumeFileUpload <- renderUI({
  input$reset_intputSampleVolumeFileUpload
  
  fileInput = fileInput("intputSampleVolumeFileUpload", "Sample Volume (CSV)",
                        multiple = FALSE,
                        accept = c(".csv"))
  
  return(fileInput)
})