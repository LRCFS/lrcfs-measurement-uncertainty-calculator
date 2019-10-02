########################################
######### Start Page        ############
########################################
observeEvent(input$help_start_start, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 1)
})

observeEvent(input$help_start_calcurve, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 2)
})

observeEvent(input$help_start_methodprec, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 3)
})

observeEvent(input$help_start_stdsol, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 4)
})

observeEvent(input$help_start_samplevol, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 5)
})

observeEvent(input$help_start_weightedLeastSquare, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 6)
})

observeEvent(input$help_start_caseSampleData, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 7)
})

observeEvent(input$help_start_confidenceInterval, {
  session$sendCustomMessage(type = 'runjs_help_start', message = 8)
})


########################################
######### Calibration Curve ############
########################################
observeEvent(input$helpCalibrationCurve, {
  session$sendCustomMessage(type = 'runjs_help_calibrationCurve', message = 1)
})