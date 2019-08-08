########################################
######### Start             ############
########################################

observeEvent(input$helpStart,
             introjs(session,
                     options = list("targetElm"=".testintrojs",
                                    "skipLabel"="<i class='fa fa-times'></i> Close",
                                    "nextLabel"="Next <i class='fa fa-angle-right'></i>",
                                    "prevLabel"="<i class='fa fa-angle-left'></i> Prev",
                                    "showBullets"=FALSE,
                                    "showProgress"=TRUE,
                                    "hidePrev"=TRUE,
                                    "hideNext"=TRUE))
)



########################################
######### Calibration Curve ############
########################################
helpStepsCalibrationCurve = reactive(
  data.frame(
    element = c(
      "#uploadedCalibrationDataStats",
      "#shiny-tab-calibrationCurve [data-value='Graph']",
      "#shiny-tab-calibrationCurve [data-value='Raw Data']",
      "#rearrangedCalibrationData",
      "#rearrangedCalibrationData thead tr th:nth-of-type(4)",
      "#shiny-tab-calibrationCurve .row .col-sm-6:first-of-type .info-box",
      "#shiny-tab-calibrationCurve .row .col-sm-6:last-of-type .info-box",
      "#shiny-tab-calibrationCurve .box-body .row:nth-of-type(3)",
      "#shiny-tab-calibrationCurve .box-body .row:nth-of-type(4) .col-sm-6:first-of-type .box",
      "#shiny-tab-calibrationCurve .box-body .row:nth-of-type(4) .col-sm-6:last-of-type .box",
      "#shiny-tab-calibrationCurve .box-body .row:nth-of-type(5) .box"
      
    ),
    intro = c(
      "At the top of the page you are shown basic stats about your stuff",
      "By default you are shown the graph that displays you data so you can quickly see if there are any obvious errors",
      "To double check the exact values you can view the raw data you uploaded by clicking here",
      "The step by step calculations first show how...",
      "Note how the squared deviation is done",
      "This box is first",
      "This box is second...",
      "This is a row I want to talk about",
      "Left box",
      "Right box",
      "Your results my lord"
    )
  )
)

observeEvent(input$helpCalibrationCurve,

             introjs(session,
                     options = list("skipLabel"="<i class='fa fa-times'></i> Close",
                                    "nextLabel"="Next <i class='fa fa-angle-right'></i>",
                                    "prevLabel"="<i class='fa fa-angle-left'></i> Prev",
                                    "showBullets"=FALSE,
                                    "showProgress"=TRUE,
                                    "hidePrev"=TRUE,
                                    "hideNext"=TRUE,
                                    steps=helpStepsCalibrationCurve()
                     )
             )
)



########################################
######### Results Dashboard ############
########################################
helpStepsResultsDashboard = reactive(
  data.frame(
    element = c(
      "#shiny-tab-dashboard .col-sm-6:nth-of-type(1) .small-box",
      "#shiny-tab-dashboard .col-sm-6:nth-of-type(2) .small-box",
      "#shiny-tab-dashboard .col-sm-6:nth-of-type(3) .small-box"
    ),
    intro = c(
      "At the top of the page you are shown basic stats about your stuff",
      "By default you are shown the graph that displays you data so you can quickly see if there are any obvious errors",
      "To double check the exact values you can view the raw data you uploaded by clicking here"
    )
  )
)

observeEvent(input$helpResultsDashboard,
             
             introjs(session,
                     options = list("skipLabel"="<i class='fa fa-times'></i> Close",
                                    "nextLabel"="Next <i class='fa fa-angle-right'></i>",
                                    "prevLabel"="<i class='fa fa-angle-left'></i> Prev",
                                    "showBullets"=FALSE,
                                    "showProgress"=TRUE,
                                    "hidePrev"=TRUE,
                                    "hideNext"=TRUE,
                                    steps=helpStepsResultsDashboard()
                     )
             )
)