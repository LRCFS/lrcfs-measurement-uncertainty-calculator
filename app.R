library(shiny)
library(shinydashboard)
library(ggplot2)
library(reshape2)
library(scales)
library(dplyr)
library(plotly)
library(DT)

source("dal/ingestData.R")

source("model/modelUncertaintyCalibrationCurve.R")

source("tabs/tabDashboard.R")
source("tabs/tabUncertaintyInCalibration.R")

ui <- dashboardPage(
  dashboardHeader(title = "LRCFS - MoU Calc"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Calibration Curve", tabName = "calibrationCurve", icon = icon("vial"))
    )
  ),
  dashboardBody(
    withMathJax(),
    tabItems(
      tabDashboard,
      tabCalibrationCurve
    )
  )
)

server <- function(input, output) {
  `%ni%` = Negate(`%in%`)
  

  #Calibration Cruve Calculations
  ##############################################
  
  data <- reactive({
    data = readExcel(input$fileUpload)
    return(data)
  })
  
  dataReformatted <- reactive({
    data = data();
    
    ## Set x = concentration and y = peack area ratios
    runNames = rep(colnames(data)[-1], each=10)
    calibrationDataConcentration <- rep(data$Concentration,6)
    calibrationDataPeakArea <- c(data$Run1,data$Run2,data$Run3,data$Run4,data$Run5,data$Run6)
    
    allData = data.frame(runNames, calibrationDataConcentration, calibrationDataPeakArea)
    colnames(allData) = c("runNames","calibrationDataConcentration","calibrationDataPeakArea")
    return(allData)
  })
  
  output$calibrationData <- DT::renderDataTable(
    data(),
    rownames = FALSE,
    options = list(scrollX = TRUE, dom = 'tip')
  )
  
  rearrangedCalibrationDataDT = function(){
    x = dataReformatted()$calibrationDataConcentration
    y = dataReformatted()$calibrationDataPeakArea
    
    ### Get Sum Squared of X
    sqDevationX = getSqDevation(x);
    
    ### Predicted Y value is the regression cofficient of Y compared to X
    predictedY = getPredicetedY(x,y);
    
    ### Get error Sum Squared of y
    errorSqDevationY = getErrorSqDevationY(x, y);
    
    ##Get data in dataframe
    rearrangedCalibrationDataFrame = data.frame(dataReformatted()$runNames,x,y,sqDevationX,predictedY,errorSqDevationY)
    rearrangedCalibrationDataFrame
    colnames(rearrangedCalibrationDataFrame) = c("Run","$$x$$","$$y$$","$$(x_i-\\overline{x})^2$$","$$\\hat{y}_i = b_0 + b_1x_i$$","$$(y_i - \\hat{y}_i)^2$$")
    
    return(rearrangedCalibrationDataFrame)
  }
  
  output$rearrangedCalibrationData <- DT::renderDataTable(
    rearrangedCalibrationDataDT(),
    rownames = FALSE,
    options = list(scrollX = TRUE, dom = 'tip')
  )
  
  output$uncertaintyOfCalibrationCurve <- renderText({
    x = dataReformatted()$calibrationDataConcentration
    y = dataReformatted()$calibrationDataPeakArea
    
    relativeStandardUncertainty = getRelativeStandardUncertainty(x,y,input)
    
    return(relativeStandardUncertainty)
  })

  output$xMean <- renderText({
    x = dataReformatted()$calibrationDataConcentration;
    xMean = mean(x)
    return(xMean)
  })

  output$sumSqDevationX <- renderText({
    x = dataReformatted()$calibrationDataConcentration

    sumSqDevationX = sum(getSqDevation(x))
    return(sumSqDevationX)
  })
  
  output$errorSumSqY <- renderText({
    y = dataReformatted()$calibrationDataPeakArea
    x = dataReformatted()$calibrationDataConcentration
    
    errorSqDevationY = sum(getErrorSqDevationY(x,y))
    return(errorSqDevationY)
  })
  
  output$standardErrorOfRegression <- renderUI({
    x = dataReformatted()$calibrationDataConcentration
    y = dataReformatted()$calibrationDataPeakArea
    
    degreesOfFreedom = getDegreesOfFreedom(x)
    errorSumSqY = sum(getErrorSqDevationY(x,y))
    stdErrorOfRegression = getStandardErrorOfRegerssion(x,y)

    withMathJax(HTML(paste("$$S_{y/x} = \\sqrt{\\frac{\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2}{n-2}}$$$$ = \\sqrt{\\frac{",errorSumSqY,"}{",degreesOfFreedom,"}}$$",h4(stdErrorOfRegression))))
  })

  output$uncertaintyOfCalibration <- renderUI({
    x = dataReformatted()$calibrationDataConcentration
    y = dataReformatted()$calibrationDataPeakArea
    
    uncertaintyOfCalibration = getUncertaintyOfCalibration(x,y,input)
    
    withMathJax(HTML(paste(getUncertaintyOfCalibrationLatex,
                   "$$=\\frac{",getStandardErrorOfRegerssion(x,y),"}{",getSlope(x,y),"} \\sqrt{\\frac{1}{",input$inputCaseSampleReplicates,"} + \\frac{1}{",length(x),"} + \\frac{(",input$inputCaseSampleMeanConcentration," - ",mean(x),")^2}{",sum(getSqDevation(x)),"} }$$", h4(uncertaintyOfCalibration))))
  })
  
  output$relativeStandardUncertainty <- renderUI({
    x = dataReformatted()$calibrationDataConcentration
    y = dataReformatted()$calibrationDataPeakArea
    
    relativeStandardUncertainty = getRelativeStandardUncertainty(x,y,input)
    
    withMathJax(HTML(paste(getRelativeStandardUncertaintyLatex,
                 "$$=\\frac{",getUncertaintyOfCalibration(x,y,input),"}{",input$inputCaseSampleMeanConcentration,"}$$",h4(relativeStandardUncertainty)))
    )
  })

  output$peakAreaRatios <- renderPlotly({
    x = dataReformatted()$calibrationDataConcentration
    y = dataReformatted()$calibrationDataPeakArea
    
    slope = round(getSlope(x,y),numDecimalPlaces)
    intercept = round(getIntercept(x,y),numDecimalPlaces)

    fit = lm(y~x)
    
    plot_ly(x = x, y = y, name='Peak Area Ratios', type = 'scatter', mode='markers') %>%
      add_lines(x = x, y = fitted(fit), name="Calibration Curve") %>%
      layout(xaxis = list(title="Concentration"), yaxis = list(title="Peak Area Ratio")) %>%
      add_annotations(x= 0.5,y= 0.8,xref="paper",yref="paper",text=paste0("$y = ",intercept,"+",slope,"x$"),showarrow = F)    
  })
  
  # observe()({
  #   intput$fileUpload
  # })

  
    # ui <- fluidPage(
    #   withMathJax(),
    #   selectInput("number", "Number:", 1:4),
    #   DT::dataTableOutput('table')
    # )
    #proxy = dataTableProxy('ARGDTTEST')
    # 
    # observe({
    #   replaceData(proxy, df(), rownames = FALSE)
    # })
    # 
    # df <- reactive({
    #   df = data.frame(index = 1)
    #   df['$$\\rho_1$$'] <- input$number[1]
    #   df['$$\\rho_2$$'] <- 2
    #   df['$$\\rho_3$$'] <- 3
    #   df['$$\\rho_4$$'] <- 4
    #   df['$$\\rho_5$$'] <- 5
    #   # workaround to get rid of first column
    # })
    # 
    # output$ARGDTTEST <- DT::renderDataTable(rownames = FALSE, {
    #   isolate(df())
    # })
  
  ##############################################
}

shinyApp(ui, server)
