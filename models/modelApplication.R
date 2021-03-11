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

myReactives = reactiveValues(uploadedCalibrationCurve=FALSE,
                             uploadedExternalStandardError=FALSE,
                             uploadedCustomWls=FALSE,
                             uploadedCustomWlsPooled=FALSE,
                             uploadedMethodPrecision=FALSE,
                             uploadedStandardSolutionStructure=FALSE,
                             uploadedStandardSolutionEquipment=FALSE,
                             uploadedSamplePreparation=FALSE,
                             uploadedHomogeneity=FALSE)




myReactiveErrors = reactiveValues(uploadedCalibrationCurve=NULL,
                             uploadedExternalStandardError=NULL,
                             uploadedCustomWls=NULL,
                             uploadedCustomWlsPooled=NULL,
                             uploadedMethodPrecision=NULL,
                             uploadedStandardSolutionStructure=NULL,
                             uploadedStandardSolutionEquipment=NULL,
                             uploadedSamplePreparation=NULL,
                             uploadedHomogeneity=NULL)

#Calibration Curve File upload and reset
observeEvent(input$inputCalibrationCurveFileUpload, {
  #Get the file path from the input
  filePath = input$inputCalibrationCurveFileUpload$datapath
  #Validate the file specified
  myReactiveErrors$uploadedCalibrationCurve = calibrationCurveReadCSV(filePath, TRUE)
  
  #We can set the value of our validation element by doing an is.null check on our error.
  #If it's null, then we have no error (set to TRUE because we're happy with the file)
  #If it's not null then there is an error (set to FALSE because we don't want to do anything with it)
  myReactives$uploadedCalibrationCurve = is.null(myReactiveErrors$uploadedCalibrationCurve)
  checkIfShowResults()
})
observeEvent(input$inputExternalStandardErrorFileUpload, {
  filePath = input$inputExternalStandardErrorFileUpload$datapath
  myReactiveErrors$uploadedExternalStandardError = calibrationCurvePooledDataReadCSV(filePath, TRUE)
  myReactives$uploadedExternalStandardError = is.null(myReactiveErrors$uploadedExternalStandardError)
  checkIfShowResults()
})
observeEvent(input$reset_inputCalibrationCurveFileUpload, {
  myReactives$uploadedCalibrationCurve = FALSE
  myReactiveErrors$uploadedCalibrationCurve = NULL
  myReactives$uploadedExternalStandardError = FALSE
  myReactiveErrors$uploadedExternalStandardError = NULL
  checkIfShowResults()
})

#Custom Weights file upload and reset
observeEvent(input$inputCustomWlsFileUpload, {
  filePath = input$inputCustomWlsFileUpload$datapath
  myReactiveErrors$uploadedCustomWls = calibrationCurveCustomWlsReadCSV(filePath, TRUE)
  myReactives$uploadedCustomWls = is.null(myReactiveErrors$uploadedCustomWls)
  checkIfShowResults()
})
observeEvent(input$reset_inputCustomWlsFileUpload, {
  myReactives$uploadedCustomWls = FALSE
  myReactiveErrors$uploadedCustomWls = NULL
  
  myReactives$uploadedCustomWlsPooled = FALSE
  myReactiveErrors$uploadedCustomWlsPooled = NULL

  checkIfShowResults()
})
observeEvent(input$inputCustomWlsPooledFileUpload, {
  filePath = input$inputCustomWlsPooledFileUpload$datapath
  myReactiveErrors$uploadedCustomWlsPooled = calibrationCurveCustomWlsPooledReadCSV(filePath, TRUE)
  myReactives$uploadedCustomWlsPooled = is.null(myReactiveErrors$uploadedCustomWlsPooled)
  checkIfShowResults()
})

#Method Precision File upload and reset
observeEvent(input$inputMethodPrecisionFileUpload, {
  filePath = input$inputMethodPrecisionFileUpload$datapath
  myReactiveErrors$uploadedMethodPrecision = methodPrecisionReadCSV(filePath, TRUE)
  myReactives$uploadedMethodPrecision = is.null(myReactiveErrors$uploadedMethodPrecision)
  checkIfShowResults()
})
observeEvent(input$reset_inputMethodPrecisionFileUpload, {
  myReactives$uploadedMethodPrecision = FALSE
  myReactiveErrors$uploadedMethodPrecision = NULL
  checkIfShowResults()
})

#Standard Solution File upload and reset
observeEvent(input$inputStandardSolutionStructureFileUpload, {
  filePath = input$inputStandardSolutionStructureFileUpload$datapath
  myReactiveErrors$uploadedStandardSolutionStructure = standardSolutionReadCSV(filePath, TRUE)
  myReactives$uploadedStandardSolutionStructure = is.null(myReactiveErrors$uploadedStandardSolutionStructure)
  checkIfShowResults()
})
observeEvent(input$inputStandardSolutionEquipmentFileUpload, {
  filePath = input$inputStandardSolutionEquipmentFileUpload$datapath
  myReactiveErrors$uploadedStandardSolutionEquipment = standardSolutionMeasurementsReadCSV(filePath, TRUE)
  myReactives$uploadedStandardSolutionEquipment = is.null(myReactiveErrors$uploadedStandardSolutionEquipment)
  checkIfShowResults()
  
})
observeEvent(input$reset_inputStandardSolutionFileUpload, {
  myReactives$uploadedStandardSolutionStructure = FALSE
  myReactiveErrors$uploadedStandardSolutionStructure = NULL
  myReactives$uploadedStandardSolutionEquipment = FALSE
  myReactiveErrors$uploadedStandardSolutionEquipment = NULL
  checkIfShowResults()
})

#Sample Preparation File upload and reset
observeEvent(input$inputSamplePreparationFileUpload, {
  filePath = input$inputSamplePreparationFileUpload$datapath
  myReactiveErrors$uploadedSamplePreparation = samplePreparationReadCSV(filePath, TRUE)
  myReactives$uploadedSamplePreparation = is.null(myReactiveErrors$uploadedSamplePreparation)
  checkIfShowResults()
})
observeEvent(input$reset_inputSamplePreparationFileUpload, {
  myReactives$uploadedSamplePreparation = FALSE
  myReactiveErrors$uploadedSamplePreparation = NULL
  checkIfShowResults()
})

#Homogeneity File upload and reset
observeEvent(input$inputHomogeneityFileUpload, {
  filePath = input$inputHomogeneityFileUpload$datapath
  myReactiveErrors$uploadedHomogeneity = homogeneityReadCSV(filePath, TRUE)
  myReactives$uploadedHomogeneity = is.null(myReactiveErrors$uploadedHomogeneity)
  checkIfShowResults()
})
observeEvent(input$reset_inputHomogeneityFileUpload, {
  myReactives$uploadedHomogeneity = FALSE
  myReactiveErrors$uploadedHomogeneity = NULL
  checkIfShowResults()
})

#Additional homepage inputs
observeEvent(input$inputWeightLeastSquared, {
  checkIfShowResults()
})

observeEvent(input$inputCaseSampleReplicates, {
  checkIfShowResults()
})

observeEvent(input$inputCaseSampleMeanConcentration, {
  checkIfShowResults()
})

observeEvent(input$inputCaseSampleMeanPeakAreaRatio, {
  checkIfShowResults()
})

observeEvent(input$inputCaseSampleCustomWeight, {
  checkIfShowResults()
})

observeEvent(input$inputConfidenceInterval, {
  checkIfShowResults()
})

observeEvent(input$inputManualCoverageFactor, {
  checkIfShowResults()
})


checkIfShowResults = function(){

  #Show/hide errors
  showHideError("display_start_error_calibrationCurveFileUpload", myReactiveErrors$uploadedCalibrationCurve)
  showHideError("display_start_error_externalStandardErrorFileUpload", myReactiveErrors$uploadedExternalStandardError)
  showHideError("display_start_error_customWlsFileUpload", myReactiveErrors$uploadedCustomWls)
  showHideError("display_start_error_customWlsPooledFileUpload", myReactiveErrors$uploadedCustomWlsPooled)
  showHideError("display_start_error_methodPrecisionFileUpload", myReactiveErrors$uploadedMethodPrecision)
  showHideError("display_start_error_standardSolutionStructureFileUpload", myReactiveErrors$uploadedStandardSolutionStructure)
  showHideError("display_start_error_standardSolutionEquipmentFileUpload", myReactiveErrors$uploadedStandardSolutionEquipment)
  showHideError("display_start_error_samplePreparationFileUpload", myReactiveErrors$uploadedSamplePreparation)
  showHideError("display_start_error_homogeneityFileUpload", myReactiveErrors$uploadedHomogeneity)
  
  #show/hide menu items
  if(checkUsingCustomWls())
  {
    if(myReactives$uploadedCalibrationCurve && !myReactives$uploadedExternalStandardError && myReactives$uploadedCustomWls)
    {
      showHideMenuItem(".sidebar-menu li a[data-value=calibrationCurve]", TRUE)
    }
    else if(myReactives$uploadedCalibrationCurve && myReactives$uploadedExternalStandardError && myReactives$uploadedCustomWls && myReactives$uploadedCustomWlsPooled)
    {
      showHideMenuItem(".sidebar-menu li a[data-value=calibrationCurve]", TRUE)
    }
    else
    {
      showHideMenuItem(".sidebar-menu li a[data-value=calibrationCurve]", FALSE)
    }

  }
  else
  {
    showHideMenuItem(".sidebar-menu li a[data-value=calibrationCurve]", myReactives$uploadedCalibrationCurve)
  }
  showHideMenuItem(".sidebar-menu li a[data-value=methodPrecision]", myReactives$uploadedMethodPrecision)
  showHideMenuItem(".sidebar-menu li a[data-value=standardSolution]", myReactives$uploadedStandardSolutionStructure & myReactives$uploadedStandardSolutionEquipment)
  showHideMenuItem(".sidebar-menu li a[data-value=samplePreparation]", myReactives$uploadedSamplePreparation)
  showHideMenuItem(".sidebar-menu li.treeview", myReactives$uploadedHomogeneity)
  
  
  #Determine if we should show the results tabs
  #check if we've uploaded any one type of data
  if(myReactives$uploadedCalibrationCurve ||
     myReactives$uploadedMethodPrecision ||
     (myReactives$uploadedStandardSolutionStructure & myReactives$uploadedStandardSolutionEquipment) ||
     myReactives$uploadedSamplePreparation ||
     myReactives$uploadedHomogeneity)
  {
    #Check that we have valid inputs
    
    #Check custom weights uploaded if needed
    checkCustomWls = FALSE
    checkCaseSampleWeight = FALSE
    if(checkUsingCustomWls())
    {
      if(myReactives$uploadedCalibrationCurve && !myReactives$uploadedExternalStandardError && myReactives$uploadedCustomWls)
      {
        checkCustomWls = TRUE
      }
      else if(myReactives$uploadedCalibrationCurve && myReactives$uploadedExternalStandardError && myReactives$uploadedCustomWls && myReactives$uploadedCustomWlsPooled)
      {
        checkCustomWls = TRUE
      }
      else
      {
        checkCustomWls = FALSE
      }
      
      inputCaseSampleCustomWeight = input$inputCaseSampleCustomWeight
      if(is.null(inputCaseSampleCustomWeight) | !is.numeric(inputCaseSampleCustomWeight)){
        checkCaseSampleWeight = FALSE
      }
      else{
        checkCaseSampleWeight = TRUE
      }
    }
    else
    {
      checkCustomWls = TRUE
      checkCaseSampleWeight = TRUE
    }
    
    
    #Check case sample replicates
    inputCaseSampleReplicates = input$inputCaseSampleReplicates
    if(is.null(inputCaseSampleReplicates) | !is.numeric(inputCaseSampleReplicates))
    {
      inputCaseSampleReplicates = 0;
    }
    
    #check mean concentration
    inputCaseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
    if(is.null(inputCaseSampleMeanConcentration) | !is.numeric(inputCaseSampleMeanConcentration))
    {
      inputCaseSampleMeanConcentration = 0;
    }
    
    #check peak area ratio
    inputCaseSampleMeanPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
    if(checkNeedPeakAreaRatio())
    {
      if(is.null(inputCaseSampleMeanPeakAreaRatio) | !is.numeric(inputCaseSampleMeanPeakAreaRatio))
      {
        inputCaseSampleMeanPeakAreaRatio = 0;
      }
    }else{
      inputCaseSampleMeanPeakAreaRatio = 1
    }
    
    #check confidence interval
    inputConfidenceInterval = input$inputConfidenceInterval
    if(input$inputConfidenceInterval != "")
    {
      inputConfidenceInterval = TRUE
    }
    else{
      inputConfidenceInterval = FALSE
    }
    
    
    if(checkCustomWls == TRUE &
       checkCaseSampleWeight == TRUE &
       (inputConfidenceInterval == TRUE || usingManualCoverageFactor() == TRUE) &
       inputCaseSampleReplicates > 0 &
       inputCaseSampleMeanConcentration > 0 &
       inputCaseSampleMeanPeakAreaRatio > 0)
    {
      showResultTabs()
    }
    else{
      hideResultTabs()
    }
  }
  else
  {
    hideResultTabs()
  }
}

showHideError = function(elementId, errorMessage = NULL)
{
  if(is.null(errorMessage))
  {
    #If the error message is null then hide the error message element
    shinyjs::removeClass(selector = paste0("#",elementId), class="visible")
  }
  else
  {
    #Else, lets show the error message
    shinyjs::html(elementId, errorMessage)
    shinyjs::addClass(selector = paste0("#",elementId), class="visible")
  }
}

showHideMenuItem = function(elementSelector, show)
{
  if(show) {
    shinyjs::addClass(selector = elementSelector, class="visible")
  } else {
    shinyjs::removeClass(selector = elementSelector, class="visible")
  }
}

showResultTabs = function(){
  shinyjs::addClass(selector = ".sidebar-menu li a[data-value=combinedUncertainty]", class="visible")
  
  #only show the coverage factor calculations if we aren't using a manually specified coverage factor
  if(!usingManualCoverageFactor())
  {
    shinyjs::addClass(selector = ".sidebar-menu li a[data-value=coverageFactor]", class="visible")
  }
  else
  {
    shinyjs::removeClass(selector = ".sidebar-menu li a[data-value=coverageFactor]", class="visible")
  }
  
  shinyjs::addClass(selector = ".sidebar-menu li a[data-value=expandedUncertainty]", class="visible")
  shinyjs::addClass(selector = ".sidebar-menu li a[data-value=dashboard]", class="visible")
  
  #Add class to make it visible but also do a show to force rendering the display
  shinyjs::addClass(selector = "#percentageExpandedUncertaintyStartPage", class="visible")
  shinyjs::show(selector = "#percentageExpandedUncertaintyStartPage")
}

hideResultTabs = function(){
  shinyjs::removeClass(selector = ".sidebar-menu li a[data-value=combinedUncertainty]", class="visible")
  shinyjs::removeClass(selector = ".sidebar-menu li a[data-value=coverageFactor]", class="visible")
  shinyjs::removeClass(selector = ".sidebar-menu li a[data-value=expandedUncertainty]", class="visible")
  shinyjs::removeClass(selector = ".sidebar-menu li a[data-value=dashboard]", class="visible")
  
  shinyjs::removeClass(selector = "#percentageExpandedUncertaintyStartPage", class="visible")
}

#Right side bar inputs
observeEvent(input$useColours, {
  if(input$useColours == FALSE)
  {
    shinyjs::addClass(selector = "#colourPickers", class="hidden")
  }
  else
  {
    shinyjs::removeClass(selector = "#colourPickers", class="hidden")
  }
})

downloadReportHandler = downloadHandler(
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
                     samplePreparationData = getDataSamplePreparation(),
                     homogeneityData = getDataHomogeneity(),
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
                     uncSamplePreparation = getResultSamplePreparation(),
                     uncHomogeneity = getHomogeneity_relativeStandardUncertainty_value(),
                     homogeneityTestResult = getHomogeneityTestPass_text(),
                     homogeneityTestAlphaValue = getHomogeneityTestAlphaValue(),
                     homogeneityTestDofW = getHomogeneityTestWithinDof(),
                     homogeneityTestDofB = getHomogeneityTestBetweenDof(),
                     homogeneityTestFStat = getHomogeneityFValue_value(),
                     homogeneityTestFCrit = getHomogeneityTestFCritical_value(),
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