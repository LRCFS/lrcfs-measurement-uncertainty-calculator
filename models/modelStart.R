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