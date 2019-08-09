########################################
######### Start Page        ############
########################################

observeEvent(input$helpStartPage, {
  session$sendCustomMessage(type = 'helpStartPage', message = 1)
})

observeEvent(input$helpStartPage1, {
  session$sendCustomMessage(type = 'helpStartPage', message = 1)
})

observeEvent(input$helpStartPage5, {
  session$sendCustomMessage(type = 'helpStartPage', message = 5)
})

observeEvent(input$helpStartPage6, {
  session$sendCustomMessage(type = 'helpStartPage', message = 6)
})



observeEvent(input$helpCalibrationCurve, {
  session$sendCustomMessage(type = 'helpCalibrationCurve', message = 1)
})

observeEvent(input$helpResultsDashboard, {
  session$sendCustomMessage(type = 'helpResultsDashboard', message = 1)
})