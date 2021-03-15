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
  coverageFactor = coverageFactorResult()
  if(!is.null(coverageFactor) && !is.na(coverageFactor))
  {
    return(paste(coverageFactor))
  }
})

output$display_start_chooseConfidenceInterval = renderUI({
  columnNames = colnames(coverageFactorEffectiveDofTable[,-1]) #Get the columns but excluse the first column which is used for effective dof
  columnNames = sort(columnNames, decreasing = TRUE)
  
  selectInput("inputConfidenceInterval", "Confidence Level \\( ( {\\small CL} \\% ) \\):",
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
  
  fileInput = fileInput("inputStandardSolutionStructureFileUpload", "Calibration Standard Structure (CSV)",
                        multiple = FALSE,
                        accept = c(".csv"))
  
  return(fileInput)
})

output$display_start_standardSolutionEquipmentFileUpload <- renderUI({
  input$reset_inputStandardSolutionFileUpload #This line is here to attach the event to update when the button is clicked
  
  fileInput = fileInput("inputStandardSolutionEquipmentFileUpload", "Calibration Standard Equipment (CSV)",
                        multiple = FALSE,
                        accept = c(".csv"))
  
  return(fileInput)
})

output$display_start_samplePreparationFileUpload <- renderUI({
  input$reset_inputSamplePreparationFileUpload #This line is here to attach the event to update when the button is clicked
  
  fileInput = fileInput("inputSamplePreparationFileUpload", "Sample Preparation (CSV)",
                        multiple = FALSE,
                        accept = c(".csv"))
  
  return(fileInput)
})

output$display_start_homogeneityFileUpload <- renderUI({
  input$reset_inputHomogeneityFileUpload #This line is here to attach the event to update when the button is clicked
  
  fileInput = fileInput("inputHomogeneityFileUpload", "Homogeneity (CSV)",
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

output$actionButton_start_downloadReport = downloadReportHandler #defined in modelApplication.R
