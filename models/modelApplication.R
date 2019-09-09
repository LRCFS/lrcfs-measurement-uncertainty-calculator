myReactives = reactiveValues(uploadedCalibrationCurve=FALSE,
                             uploadedExternalStandardError=FALSE,
                             uploadedMethodPrecision=FALSE,
                             uploadedStandardSolutionStructure=FALSE,
                             uploadedStandardSolutionEquipment=FALSE,
                             uploadedSampleVolume=FALSE)


myReactiveErrors = reactiveValues(uploadedCalibrationCurve=NULL,
                             uploadedExternalStandardError=NULL,
                             uploadedMethodPrecision=NULL,
                             uploadedStandardSolutionStructure=NULL,
                             uploadedStandardSolutionEquipment=NULL,
                             uploadedSampleVolume=NULL)

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

#Sample Volume File upload and reset
observeEvent(input$inputSampleVolumeFileUpload, {
  filePath = input$inputSampleVolumeFileUpload$datapath
  myReactiveErrors$uploadedSampleVolume = sampleVolumeReadCSV(filePath, TRUE)
  myReactives$uploadedSampleVolume = is.null(myReactiveErrors$uploadedSampleVolume)
  checkIfShowResults()
})
observeEvent(input$reset_inputSampleVolumeFileUpload, {
  myReactives$uploadedSampleVolume = FALSE
  myReactiveErrors$uploadedSampleVolume = NULL
  checkIfShowResults()
})

#Additional homepage inputs
observeEvent(input$inputConfidenceInterval, {
  checkIfShowResults()
})

observeEvent(input$inputCaseSampleReplicates, {
  checkIfShowResults()
})

observeEvent(input$inputCaseSampleMeanConcentration, {
  checkIfShowResults()
})

checkIfShowResults = function(){

  #Show/hide errors
  showHideError("display_start_error_calibrationCurveFileUpload", myReactiveErrors$uploadedCalibrationCurve)
  showHideError("display_start_error_externalStandardErrorFileUpload", myReactiveErrors$uploadedExternalStandardError)
  showHideError("display_start_error_methodPrecisionFileUpload", myReactiveErrors$uploadedMethodPrecision)
  showHideError("display_start_error_standardSolutionStructureFileUpload", myReactiveErrors$uploadedStandardSolutionStructure)
  showHideError("display_start_error_standardSolutionEquipmentFileUpload", myReactiveErrors$uploadedStandardSolutionEquipment)
  showHideError("display_start_error_sampleVolumeFileUpload", myReactiveErrors$uploadedSampleVolume)
  
  #show/hide menu items
  showHideMenuItem(".sidebar-menu li a[data-value=calibrationCurve]", myReactives$uploadedCalibrationCurve)
  showHideMenuItem(".sidebar-menu li a[data-value=methodPrecision]", myReactives$uploadedMethodPrecision)
  showHideMenuItem(".sidebar-menu li a[data-value=standardSolution]", myReactives$uploadedStandardSolutionStructure & myReactives$uploadedStandardSolutionEquipment)
  showHideMenuItem(".sidebar-menu li a[data-value=sampleVolume]", myReactives$uploadedSampleVolume)
  
  #check if we've uploaded any one type of data
  if(myReactives$uploadedCalibrationCurve ||
     myReactives$uploadedMethodPrecision ||
     (myReactives$uploadedStandardSolutionStructure & myReactives$uploadedStandardSolutionEquipment) ||
     myReactives$uploadedSampleVolume)
  {
    #Check that case sample replicates, mean concentration and confidence interval have been specified correctly
    inputCaseSampleReplicates = input$inputCaseSampleReplicates
    if(is.null(inputCaseSampleReplicates) | !is.numeric(inputCaseSampleReplicates))
    {
      inputCaseSampleReplicates = 0;
    }
    inputCaseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
    if(is.null(inputCaseSampleMeanConcentration) | !is.numeric(inputCaseSampleMeanConcentration))
    {
      inputCaseSampleMeanConcentration = 0;
    }
    
    if(input$inputConfidenceInterval != "" &
       inputCaseSampleReplicates > 0 &
       inputCaseSampleMeanConcentration > 0)
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
  shinyjs::addClass(selector = ".sidebar-menu li a[data-value=coverageFactor]", class="visible")
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