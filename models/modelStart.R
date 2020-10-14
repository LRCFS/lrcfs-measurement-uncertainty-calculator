###########################################################################
#
# Measurement Uncertainty Calculator - Copyright (C) 2019
# Leverhulme Research Centre for Forensic Science
# Roy Mudie, Joyce Klu, Niamh Nic Daeid
# Website: https://github.com/LRCFS/lrcfs-measurement-uncertainty-calculator/
# Contact: lrc@dundee.ac.uk
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
###########################################################################

###################################################################################
# Outputs
###################################################################################



output$display_start_caseSampleMeanPeakAreaRatio <- renderUI({
  input$inputWeightLeastSquared #This line is here to attach the event to update when the option is changed

  if(checkNeedPeakAreaRatio())
  {
    numericInput("inputCaseSampleMeanPeakAreaRatio",
                 withMathJax("Mean Peak Area Ratio\\((y_s)\\)"),
                 value = NULL)
  }
})

output$display_start_caseSampleCustomWeight <- renderUI({
  input$inputWeightLeastSquared #This line is here to attach the event to update when the option is changed
  
  if(checkUsingCustomWls())
  {
    numericInput("inputCaseSampleCustomWeight",
                 withMathJax("Weight \\((W_s)\\)"),
                 value = NULL)
  }
})

output$display_start_replicates <- renderUI({
  string = paste(input$inputCaseSampleReplicates)
  return(string)
})

output$display_start_meanConcentration <- renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_start_meanPar <- renderUI({
  if(checkNeedPeakAreaRatio())
  {
    infoBox(withMathJax(HTML("Case Sample<br />Mean Peak Area Ratio\\((y_s)\\)")),input$inputCaseSampleMeanPeakAreaRatio, width=12, icon=icon("chart-bar"), color="orange")
  }
})

output$display_start_customWeight <- renderUI({
  if(checkUsingCustomWls())
  {
    infoBox(withMathJax(HTML("Case Sample<br />Weight\\((W_s)\\)")),formatNumberForDisplay(input$inputCaseSampleCustomWeight, input), width=12, icon=icon("weight"), color="red")
  }
})

output$display_start_confidenceInterval <- renderUI({
  string = paste(input$inputConfidenceInterval)
  return(string)
})

output$display_start_coverageFactor <- renderUI({
  string = paste(coverageFactorResult())
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

#########
output$display_start_customWlsFileUploadExampleDownloadLink <- renderUI({
  input$reset_inputCustomWlsFileUpload #This line is here to attach the event to update when the button is clicked
  
  if(checkUsingCustomWls())
  {
    return(a("Download Example Calibration Curve Custom Weights CSV", href="exampleData/exampleData-calibrationCurve-customWeights.csv"))
  }
  return(NULL)
})


output$display_start_customWlsFileUpload <- renderUI({
  input$reset_inputCustomWlsFileUpload #This line is here to attach the event to update when the button is clicked
  
  fileInput = ""
  if(checkUsingCustomWls())
  {
    fileInput = fileInput("inputCustomWlsFileUpload", "Custom Weights (CSV)",
                          multiple = FALSE,
                          accept = c(".csv"))
  }
  
  return(fileInput)
})

output$display_start_customWlsFileUploadErrorDiv <- renderUI({
  input$reset_inputCustomWlsFileUpload #This line is here to attach the event to update when the button is clicked
  
  if(checkUsingCustomWls())
  {
    return(div("Error with uploaded file...", class="error", id="display_start_error_customWlsFileUpload"))
  }
})

output$display_start_customWlsFileUploadRemoveDataButton <- renderUI({
  input$reset_inputCustomWlsFileUpload #This line is here to attach the event to update when the button is clicked
  
  if(checkUsingCustomWls())
  {
    return(actionButton("reset_inputCustomWlsFileUpload", "Remove Custom Weights Data", icon=icon("times")))
  }
})

#########
output$display_start_customWlsPooledFileUploadExampleDownloadLink <- renderUI({
  input$reset_inputCustomWlsFileUpload #This line is here to attach the event to update when the button is clicked
  
  if(checkUsingCustomWls())
  {
    return(a("Download Example Pooled Custom Weights CSV", href="exampleData/exampleData-calibrationCurve-pooledStandardError-customWeights.csv"))
  }
  return(NULL)
})


output$display_start_customWlsPooledFileUpload <- renderUI({
  input$reset_inputCustomWlsFileUpload #This line is here to attach the event to update when the button is clicked
  
  fileInput = ""
  if(checkUsingCustomWls())
  {
    fileInput = fileInput("inputCustomWlsPooledFileUpload", HTML("Custom Pooled Weights (CSV)<br /><span id='customPooledWlsInfo'>(only required if Pooled Standard Error has been specified)</span>"),
                          multiple = FALSE,
                          accept = c(".csv"))
  }
  
  return(fileInput)
})

output$display_start_customWlsPooledFileUploadErrorDiv <- renderUI({
  input$reset_inputCustomWlsFileUpload #This line is here to attach the event to update when the button is clicked
  
  if(checkUsingCustomWls())
  {
    return(div("Error with uploaded file...", class="error", id="display_start_error_customWlsPooledFileUpload"))
  }
})

output$actionButton_start_downloadReport = downloadHandler(
  filename = paste0(APP_DEV_SHORT,"-",APP_NAME_SHORT,"-Report-",format(Sys.time(), "%Y-%m-%d"),".html"),
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
                    customWls = getDataCustomWls(),
                    customWlsPooled = getDataCustomWlsPooled(),
                    inputCaseSampleReplicates = input$inputCaseSampleReplicates,
                    inputCaseSampleMeanConcentration = input$inputCaseSampleMeanConcentration,
                    inputCaseSampleMeanPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio,
                    inputCaseSampleWeight = input$inputCaseSampleCustomWeight,
                    inputConfidenceInterval = input$inputConfidenceInterval,
                    inputManualCoverageFactor = input$inputManualCoverageFactor,
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
