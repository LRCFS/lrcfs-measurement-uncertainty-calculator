myReactives = reactiveValues(uploadedCalibrationCurve=FALSE,
                             uploadedMethodPrecision=FALSE,
                             uploadedStandardSolutionStructure=FALSE,
                             uploadedStandardSolutionEquipment=FALSE,
                             uploadedSampleVolume=FALSE)


myReactiveErrors = reactiveValues(uploadedCalibrationCurve=NULL,
                             uploadedMethodPrecision=NULL,
                             uploadedStandardSolutionStructure=NULL,
                             uploadedStandardSolutionEquipment=NULL,
                             uploadedSampleVolume=NULL)

showError = function(elementSelector, errorMessage = NULL){
  logjs(errorMessage)
  shinyjs::html(elementSelector, errorMessage)
  shinyjs::addClass(selector = paste0("#",elementSelector), class="visible")
}

hideError = function(elementSelector)
{
  shinyjs::removeClass(selector = paste0("#",elementSelector), class="visible")
}

#Calibration Curve File upload and reset
observeEvent(input$inputCalibrationCurveFileUpload, {
  filePath = input$inputCalibrationCurveFileUpload$datapath
  myReactiveErrors$uploadedCalibrationCurve = calibrationCurveReadCSV(filePath, TRUE)
  if(is.null(myReactiveErrors$uploadedCalibrationCurve))
  {
    myReactives$uploadedCalibrationCurve = TRUE
    checkIfShowResults()
  }
  else{
    myReactives$uploadedCalibrationCurve = FALSE
    checkIfShowResults()
  }
})
observeEvent(input$reset_inputCalibrationCurveFileUpload, {
  myReactives$uploadedCalibrationCurve = FALSE
  myReactiveErrors$uploadedCalibrationCurve = NULL
  checkIfShowResults()
})

#Method Precision File upload and reset
observeEvent(input$inputMethodPrecisionFileUpload, {
  filePath = input$inputMethodPrecisionFileUpload$datapath
  if(!is.null(filePath) & str_detect(filePath,"(\\.csv|\\.CSV)$"))
  {
    myReactives$uploadedMethodPrecision = TRUE
    checkIfShowResults()
  }else{
    myReactives$uploadedMethodPrecision = FALSE
    checkIfShowResults()
  }
})
observeEvent(input$reset_inputMethodPrecisionFileUpload, {
  myReactives$uploadedMethodPrecision = FALSE
  checkIfShowResults()
})

#Standard Solution File upload and reset
observeEvent(input$inputStandardSolutionStructureFileUpload, {
  filePath = input$inputStandardSolutionStructureFileUpload$datapath
  if(!is.null(filePath) & str_detect(filePath,"(\\.csv|\\.CSV)$"))
  {
    myReactives$uploadedStandardSolutionStructure = TRUE
    checkIfShowResults()
  }else{
    myReactives$uploadedStandardSolutionStructure = FALSE
    checkIfShowResults()
  }
})
observeEvent(input$inputStandardSolutionEquipmentFileUpload, {
  filePath = input$inputStandardSolutionEquipmentFileUpload$datapath
  if(!is.null(filePath) & str_detect(filePath,"(\\.csv|\\.CSV)$"))
  {
    myReactives$uploadedStandardSolutionEquipment = TRUE
    checkIfShowResults()
  }else{
    myReactives$uploadedStandardSolutionEquipment = FALSE
    checkIfShowResults()
  }
})
observeEvent(input$reset_inputStandardSolutionFileUpload, {
  myReactives$uploadedStandardSolutionStructure = FALSE
  myReactives$uploadedStandardSolutionEquipment = FALSE
  checkIfShowResults()
})

#Sample Volume File upload and reset
observeEvent(input$inputSampleVolumeFileUpload, {
  filePath = input$inputSampleVolumeFileUpload$datapath
  if(!is.null(filePath) & str_detect(filePath,"(\\.csv|\\.CSV)$"))
  {
    myReactives$uploadedSampleVolume = TRUE
    checkIfShowResults()
  }else{
    myReactives$uploadedSampleVolume = FALSE
    checkIfShowResults()
  }
})
observeEvent(input$reset_inputSampleVolumeFileUpload, {
  myReactives$uploadedSampleVolume = FALSE
  checkIfShowResults()
})

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
  if(is.null(myReactiveErrors$uploadedCalibrationCurve))
  {
    hideError("display_start_error_calibrationCurveFileUpload")
  }else{
    showError("display_start_error_calibrationCurveFileUpload", myReactiveErrors$uploadedCalibrationCurve)
  }
  
  
  if(myReactives$uploadedCalibrationCurve) {
    shinyjs::addClass(selector = ".sidebar-menu li a[data-value=calibrationCurve]", class="visible")
  } else {
    shinyjs::removeClass(selector = ".sidebar-menu li a[data-value=calibrationCurve]", class="visible")
  }
  
  if(myReactives$uploadedMethodPrecision) {
    shinyjs::addClass(selector = ".sidebar-menu li a[data-value=methodPrecision]", class="visible")
  } else {
    shinyjs::removeClass(selector = ".sidebar-menu li a[data-value=methodPrecision]", class="visible")
  }
  
  if(myReactives$uploadedStandardSolutionStructure & myReactives$uploadedStandardSolutionEquipment) {
    shinyjs::addClass(selector = ".sidebar-menu li a[data-value=standardSolution]", class="visible")
  } else {
    shinyjs::removeClass(selector = ".sidebar-menu li a[data-value=standardSolution]", class="visible")
  }
  
  if(myReactives$uploadedSampleVolume) {
    shinyjs::addClass(selector = ".sidebar-menu li a[data-value=sampleVolume]", class="visible")
  } else {
    shinyjs::removeClass(selector = ".sidebar-menu li a[data-value=sampleVolume]", class="visible")
  }
  
  if(myReactives$uploadedCalibrationCurve ||
     myReactives$uploadedMethodPrecision ||
     (myReactives$uploadedStandardSolutionStructure & myReactives$uploadedStandardSolutionEquipment) ||
     myReactives$uploadedSampleVolume)
  {
    #Check that case sample replicates, mean concentration and confidence interval have been specified
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
      hideRsultTabs()
    }
  }
  else
  {
    hideRsultTabs()
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

hideRsultTabs = function(){
  shinyjs::removeClass(selector = ".sidebar-menu li a[data-value=combinedUncertainty]", class="visible")
  shinyjs::removeClass(selector = ".sidebar-menu li a[data-value=coverageFactor]", class="visible")
  shinyjs::removeClass(selector = ".sidebar-menu li a[data-value=expandedUncertainty]", class="visible")
  shinyjs::removeClass(selector = ".sidebar-menu li a[data-value=dashboard]", class="visible")
  
  shinyjs::removeClass(selector = "#percentageExpandedUncertaintyStartPage", class="visible")
}