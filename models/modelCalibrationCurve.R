################################
## Fixed properties
################################
getUncertaintyOfCalibrationLatex = "u\\text{(CalCurve)} &= \\frac{S_{y/x}}{b_1} \\sqrt{\\frac{1}{r_s} + \\frac{1}{n} + \\frac{(x_s - \\overline{x})^2}{S_{xx}} }"
getRelativeStandardUncertaintyLatex = "u_r\\text{(CalCurve)} &= \\frac{u\\text{(CalCurve)}}{x_s}"

usingWls = reactive({
  if(input$inputWeightLeastSquared == 1)
  {
    return(FALSE)
  }
  return(TRUE)
})


calibrationCurveData <- reactive({
  if(myReactives$uploadedCalibrationCurve == TRUE)
  {
    data = calibrationCurveReadCSV(input$inputCalibrationCurveFileUpload$datapath)
    return(data)
  }
  else
  {
    return(NULL)
  }
})

externalStandardErrorData <- reactive({
  if(myReactives$uploadedExternalStandardError == TRUE)
  {
    data = calibrationCurvePooledDataReadCSV(input$inputExternalStandardErrorFileUpload$datapath)
    return(data)
  }
  else
  {
    return(NULL)
  }
})



calibrationCurveResult = reactive({
  data = calibrationCurveDataReformatted()
  extStdErrorData = externalStandardErrorData()
  if(is.null(data))
  {
    return(NA)
  }
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  weightedLeastSquared = getWeightedLeastSquared(x,y,input$inputWeightLeastSquared)
  
  return(getRelativeStandardUncertainty(x,y,weightedLeastSquared,extStdErrorData,input$inputCaseSampleReplicates,input$inputCaseSampleMeanConcentration))
})

calibrationCurveDataReformatted <- reactive({
  data = calibrationCurveData();
  
  if(is.null(data))
  {
    return(NULL)
  }
  
  numConc = nrow(data)
  numRuns = ncol(data)-1

  ## Set x = concentration and y = peack area ratios
  runNames = rep(colnames(data)[-1], each=numConc)
  calibrationDataConcentration <- rep(data$conc,numRuns)

  data = data[,-1]
  calibrationDataPeakArea <- unlist(c(data), use.names = FALSE)
  
  allData = data.frame(runNames, calibrationDataConcentration, calibrationDataPeakArea)
  colnames(allData) = c("runNames","calibrationDataConcentration","calibrationDataPeakArea")

  #Remove any data with NA enteries
  allDataNaRemoved = allData[!is.na(allData$calibrationDataPeakArea),]
  
  return(allDataNaRemoved)
})

rearrangedCalibrationDataDT = function(){
  data = calibrationCurveDataReformatted()
  if(is.null(data))
  {
    return(NULL)
  }
  
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  ### Get Squared Devation of X
  sqDevationX = getSqDevation(x);
  
  #Get Weight
  weightedLeastSquared = getWeightedLeastSquared(x,y,input$inputWeightLeastSquared)
  
  #Get Weight
  wx = round(weightedLeastSquared * x,numDecimalPlaces)
  wy = round(weightedLeastSquared * y,numDecimalPlaces)
  
  ### Predicted Y value is the regression cofficient of Y compared to X
  predictedY = getPredicetedY(x,y, weightedLeastSquared);
  
  ### Get error Sum Squared of y
  errorSqDevationY = getErrorSqDevationY(x,y,weightedLeastSquared);
  
  ##Get data in dataframe
  rearrangedCalibrationDataFrame = data.frame(calibrationCurveDataReformatted()$runNames,x,y,weightedLeastSquared,wx,wy,sqDevationX,predictedY,errorSqDevationY)
  colnames(rearrangedCalibrationDataFrame) = c("$$\\text{Run}$$","$$\\text{Concentration} (x)$$","$$\\text{Peak Area} (y)$$",paste("$$\\text{Weight}(",getWlsLatex(input$inputWeightLeastSquared),")$$"),"$$w_ix_i$$","$$w_iy_i$$","$$\\text{Squared Deviation} (x_i-\\overline{x})^2$$","$$\\hat{y}_i = b_0 + b_1x_i$$","$$(y_i - \\hat{y}_i)^2$$")
  
  return(rearrangedCalibrationDataFrame)
}

getWeightedLeastSquared = function(x,y,wlsChoice){
  
  wlsFunction = getWlsFunction(wlsChoice)
  
  if(wlsChoice == 1)
  {
    return(rep(1,length(x)))
  }
  
  if(wlsChoice == 2 | wlsChoice == 3)
  {
    return(round(wlsFunction(x),numDecimalPlaces))
  }
  
  if(wlsChoice == 4 | wlsChoice == 5)
  {
    return(round(wlsFunction(y),numDecimalPlaces))
  }
}

getWlsFunction = function(wlsChoice){
  if(wlsChoice == 1)
  {
    wlsFunc = function(value){
      return(value)
    }
    return(wlsFunc)
  }
  
  if(wlsChoice == 2 | wlsChoice == 4 | wlsChoice == 6)
  {
    wlsFunc = function(value){
      return(1/(value))
    }
    return(wlsFunc)
  }
  
  if(wlsChoice == 3 | wlsChoice == 5 | wlsChoice == 7)
  {
    wlsFunc = function(value){
      return(1/value^2)
    }
    return(wlsFunc)
  }
}

getWlsLatex = function(wlsChoice){
  if(wlsChoice == 1)
    return("w=1")
  
  if(wlsChoice == 2)
    return("w=\\frac{1}{x}")
  
  if(wlsChoice == 3)
    return("w=\\frac{1}{x^2}")
  
  if(wlsChoice == 4)
    return("w=\\frac{1}{y}")
  
  if(wlsChoice == 5)
    return("w=\\frac{1}{y^2}")
  
  return("")
}


###################################################################################
# Outputs
###################################################################################

output$display_calibrationCurve_replicates <- renderUI({
  string = paste(input$inputCaseSampleReplicates)
  return(string)
})

output$display_calibrationCurve_meanConcentration <- renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_calibrationCurve_uncertaintyOfCalibrationLatex = renderUI({
  formula = gsub("&=", "=", getUncertaintyOfCalibrationLatex)
  formula = paste0("$$",formula,"$$")
  return(withMathJax(HTML(formula)))
})

output$display_calibrationCurve_standardErrorOfRegressionLatex = renderUI({
  return(withMathJax(HTML(paste("$$S_{",if(usingWls())"w"else"y/x","} = \\sqrt{\\frac{\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2}{n-2}}$$"))))
})

#Calibration Cruve Calculations
output$calibrationData <- DT::renderDataTable(
  calibrationCurveData(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)

output$rearrangedCalibrationData <- DT::renderDataTable(
  rearrangedCalibrationDataDT(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip', columnDefs = list(list(className = 'dt-right', targets = 0:5)))
)

output$uploadedCalibrationDataStats <- renderUI({
  data = calibrationCurveData()
  reps = max(table(data["conc"]))
  
  dataReformatted = calibrationCurveDataReformatted()
  y = dataReformatted$calibrationDataPeakArea

  par = getCalibrationCurve_n(y)
  
  return(HTML(sprintf("Uploaded Calibration Data<br />Runs: %d | Reps: %d | Concentration Levels: %d | Peak Area Ratios: %d", dim(data)[2]-1, reps, length(table(data["conc"])), par)))
})

output$display_calibrationCurve_linearRegression <- renderUI({
  data = calibrationCurveDataReformatted()
  y = data$calibrationDataPeakArea
  x = data$calibrationDataConcentration
  weightedLeastSquared = getWeightedLeastSquared(x,y,input$inputWeightLeastSquared)
  
  intercept = round(getIntercept(x,y,weightedLeastSquared),numDecimalPlaces)
  slope = round(getSlope(x,y,weightedLeastSquared),numDecimalPlaces)
  n = getCalibrationCurve_n(y)
  linearRegression = getLinearRegression(x,y,weightedLeastSquared)
  rSquare = round(summary.lm(linearRegression)$r.squared,numDecimalPlaces)
  
  formulas = c(paste0("\\text{Intercept}(b_0) &=",intercept))
  formulas = c(formulas, paste0("\\text{Slope}(b_1) &= \\color{",color6,"}{",slope,"}"))
  formulas = c(formulas, paste0("R^2 &=",rSquare))
  formulas = c(formulas, paste0("n &= \\color{",color5,"}{",n,"}"))
  output = mathJaxAligned(formulas, 10)
  
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurve_meanOfX <- renderUI({
  data = calibrationCurveDataReformatted()
  meanOfX = getCalibrationCurveMeanOfX(data)

  formulas = c("\\overline{x} &= \\frac{\\sum{x_i}}{n}")
  formulas = c(formulas, paste("&=\\color{",color1,"}{",meanOfX),"}")
  output = mathJaxAligned(formulas, 5)
  
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurve_sumSqDevationX <- renderUI({
  x = calibrationCurveDataReformatted()$calibrationDataConcentration
  sumSqDevationX = sum(getSqDevation(x))
  
  formulas = c("S_{xx} &= \\sum\\limits_{i=1}^n(x_i - \\overline{x})^2")
  formulas = c(formulas, paste("&=\\color{",color2,"}{",sumSqDevationX,"}"))
  output = mathJaxAligned(formulas, 5)
  
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurve_errorSumSqY <- renderUI({
  data = calibrationCurveDataReformatted()
  y = data$calibrationDataPeakArea
  x = data$calibrationDataConcentration
  weightedLeastSquared = getWeightedLeastSquared(x,y,input$inputWeightLeastSquared)
  
  errorSqDevationY = sum(getErrorSqDevationY(x,y,weightedLeastSquared))
  
  formulas = c("S_{y\\hat{y}} &=\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2")
  formulas = c(formulas, paste("&=\\color{",color3,"}{",errorSqDevationY,"}"))
  output = mathJaxAligned(formulas, 5)
  
  return(withMathJax(HTML(output)))
})

output$standardErrorOfRegression <- renderUI({
  data = calibrationCurveDataReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  weightedLeastSquared = getWeightedLeastSquared(x,y,input$inputWeightLeastSquared)
  
  n = getCalibrationCurve_n(y)
  errorSumSqY = sum(getErrorSqDevationY(x,y,weightedLeastSquared))
  stdErrorOfRegression = getStandardErrorOfRegerssion(x,y,weightedLeastSquared)
  
  formulas = c(paste("S_{",if(usingWls())"w"else"y/x","} &= \\sqrt{\\frac{\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2}{n-2}}","[[break]]"))
  formulas = c(formulas, paste("S_{",if(usingWls())"w"else"y/x","} &= \\sqrt{\\frac{\\color{",color3,"}{",errorSumSqY,"}}{\\color{",color5,"}{",n,"}-2}}"))
  formulas = c(formulas, paste("&=\\color{",color4,"}{",stdErrorOfRegression,"}"))
  output = mathJaxAligned(formulas, 5, 20)
  
  return(withMathJax(HTML(output)))
})

output$uncertaintyOfCalibration <- renderUI({

  data = calibrationCurveDataReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  weightedLeastSquared = getWeightedLeastSquared(x,y,input$inputWeightLeastSquared)
  
  exStdErrData = externalStandardErrorData()

  stdErrorOfRegression = 0
  if(is.null(exStdErrData))
  {
    stdErrorOfRegression = getStandardErrorOfRegerssion(x,y,weightedLeastSquared)
  }
  else
  {
    stdErrorOfRegression = getPooledStdErrorOfRegression(x,y,weightedLeastSquared,exStdErrData)
  }
  
  slope = getSlope(x,y,weightedLeastSquared)
  caseSampleReps = input$inputCaseSampleReplicates
  n = getCalibrationCurve_n(y)
  caseSampleMeanConc = input$inputCaseSampleMeanConcentration
  meanX = getCalibrationCurveMeanOfX(data)
  sumSqDevationX = sum(getSqDevation(x))
  uncertaintyOfCalibration = getUncertaintyOfCalibration(x,y,weightedLeastSquared,exStdErrData,caseSampleReps,caseSampleMeanConc)
  
  if(is.null(exStdErrData))
  {
    if(usingWls())
      formulas = c("u\\text{(CalCurve)} &= \\frac{S_{w}}{b_1} \\sqrt{\\frac{1}{w_{s}} + \\frac{1}{n} + \\frac{(y_s - \\overline{y_w})^2}{b_1^2[\\sum{wx^2-n(\\overline{x}_w)^2}]} } [[break]]")
    else
      formulas = c("u\\text{(CalCurve)} &= \\frac{S_{y/x}}{b_1} \\sqrt{\\frac{1}{r_s} + \\frac{1}{n} + \\frac{(x_s - \\overline{x})^2}{S_{xx}} } [[break]]")
  }
  else
  {
    if(usingWls())
      formulas = c("u\\text{(CalCurve)} &= \\frac{S_{w_{p}}}{b_1} \\sqrt{\\frac{1}{w_{s}} + \\frac{1}{n} + \\frac{(y_s - \\overline{y_w})^2}{b_1^2[\\sum{wx^2-n(\\overline{x}_w)^2}]} } [[break]]")
    else
      formulas = c("u\\text{(CalCurve)} &= \\frac{S_{p_{y/x}}}{b_1} \\sqrt{\\frac{1}{r_s} + \\frac{1}{n} + \\frac{(x_s - \\overline{x})^2}{S_{xx}} } [[break]]")
  }
  
  formulas = c(formulas, paste("u\\text{(CalCurve)}&=\\frac{\\color{",color4,"}{",stdErrorOfRegression,"}}{\\color{",color6,"}{",slope,"}} \\sqrt{\\frac{1}{\\bbox[#00C0EF,2pt]{\\color{#FFF}{",caseSampleReps,"}}} + \\frac{1}{\\color{",color5,"}{",n,"}} + \\frac{(\\bbox[#F012BE,2pt]{\\color{#FFF}{",caseSampleMeanConc,"}} - \\color{",color1,"}{",meanX,"})^2}{\\color{",color2,"}{",sumSqDevationX,"}} }"))
  formulas = c(formulas, paste("&=",uncertaintyOfCalibration))
  output = mathJaxAligned(formulas, 5, 20)
  
  return(withMathJax(HTML(output)))
})


output$peakAreaRatios <- renderPlotly({
  data = calibrationCurveDataReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  weightedLeastSquared = getWeightedLeastSquared(x,y,input$inputWeightLeastSquared)
  
  slope = getSlope(x,y,weightedLeastSquared)
  intercept = getIntercept(x,y, weightedLeastSquared)
  
  # royTestErrorBarThing_relativeStandardUncertainty = getRelativeStandardUncertainty(x,y,input$inputCaseSampleReplicates,input$inputCaseSampleMeanConcentration)
  # royTestErrorBarThing = expandedUncertaintyResult()
  
  fit = getLinearRegression(x,y,weightedLeastSquared)
  
  plot_ly(x = x, y = y, name='Peak Area Ratios', type = 'scatter', mode='markers') %>%
    add_lines(x = x, y = fitted(fit), name="Calibration Curve") %>%
    # add_ribbons(x = x,
    #             ymin = fitted(fit) - royTestErrorBarThing,
    #             ymax = fitted(fit) + royTestErrorBarThing,
    #             line = list(color = 'rgba(7, 164, 181, 0.05)'),
    #             fillcolor = 'rgba(7, 164, 181, 0.2)',
    #             name = "Relative Standard Uncertainty") %>%
    layout(xaxis = list(title="Concentration"), yaxis = list(title="Peak Area Ratio")) %>%
    add_annotations(x= 0.5,y= 0.8,xref="paper",yref="paper",text=paste0("$y = ",intercept,"+",slope,"x$"),showarrow = F)    
})

output$display_calibrationCurve_externalStandardErrorUploadedData = renderUI({
  exStdErrorData = externalStandardErrorData()
  if(is.null(exStdErrorData))
    return(NULL)
  
  numberOfRuns = dim(exStdErrorData)[2]-1 #get the number of columns and minus 1 (because one column in the concentration)
  numberOfReplicates = max(table(exStdErrorData["conc"])) #count the number of occurances of each value in the concentration column, then get the max value (because some might be missing some)
  concentrationLevels = length(table(exStdErrorData["conc"])) #table the concentration column and count the length
  
  #To get the total number of peak areas we want to get just the runs
  exStdErrorRunData = exStdErrorData
  exStdErrorRunData$conc = NULL #so remove the conc column
  lengths = apply(exStdErrorRunData, 2, getCalibrationCurve_n) #then count all the runs lengths
  numberOfPeakAreaRatios = sum(lengths) #and add them together
                   
  boxTitle = HTML(sprintf("External Calibration Curve Data<br />Runs: %d | Reps: %d | Concentration Levels: %d | Peak Area Ratios: %d",numberOfRuns,numberOfReplicates,concentrationLevels,numberOfPeakAreaRatios))
  
  tabBox(width=12, side="right",
         title = boxTitle,
         tabPanel("Raw Data",
                  DT::renderDataTable(
                    externalStandardErrorData(),
                    rownames = FALSE,
                    options = list(scrollX = TRUE, dom = 'tip')
                  )
         )
  )
})

output$display_calibrationCurve_externalStandardErrorOfRuns = renderUI({
  exStdErrorData = externalStandardErrorData()
  if(is.null(exStdErrorData))
    return(NULL)
  
  exStdErrorRunData = exStdErrorData
  exStdErrorRunData$conc = NULL

  results = list()
  for(i in colnames(exStdErrorRunData))
  {
    weightedLeastSquared = getWeightedLeastSquared(exStdErrorData$conc,exStdErrorRunData[,i],input$inputWeightLeastSquared)
    seor = getStandardErrorOfRegerssion(exStdErrorData$conc,exStdErrorRunData[,i],weightedLeastSquared)

    answer = data.frame(seor)
    names(answer) = i
    results = c(results, answer)
  }

  #results = apply(exStdErrorRunData, 2, getStandardErrorOfRegerssion, x = exStdErrorData$conc)
  lengths = apply(exStdErrorRunData, 2, getCalibrationCurve_n)
  
  formulas = c(paste("S_{{",if(usingWls())"w"else"y/x","}_{(j)}} &= \\sqrt{\\frac{\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2}{n_{(j)}-2}} [[break]]"))

  for(i in 1:length(results))
  {
    formulas = c(formulas, paste0("S_{{",if(usingWls())"w"else"y/x","}_{(\\text{",names(results)[i],"})}}&=", results[i], " \\hspace{15pt} n_{(\\text{",names(results)[i],"})} = ", lengths[i]))
  }
  
  output = mathJaxAligned(formulas, 5, 20)
  
  box(title=paste("Standard Error of Regression (External Calibration Data) \\((S_{{",if(usingWls())"w"else"y/x","}_{(j)}})\\)"), width = 5, withMathJax(HTML(output)))
})

output$display_calibrationCurve_externalStandardErrorOfRunsPooled = renderUI({
  exStdErrorData = externalStandardErrorData()
  if(is.null(exStdErrorData))
    return(NULL)
  
  data = calibrationCurveDataReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  weightedLeastSquared = getWeightedLeastSquared(x,y,input$inputWeightLeastSquared)
  
  answer = getPooledStdErrorOfRegression(x,y,weightedLeastSquared,exStdErrorData)
  
  formulas = c(paste("S_{",if(usingWls())"w_{(p)}"else"p_{(x/y)}","} &= \\sqrt{\\frac{\\sum{(n-1)S^2_{",if(usingWls())"w"else"y/x","}}}{\\sum{(n-1)}}} [[break]]"))
  formulas = c(formulas, paste("S_{",if(usingWls())"w_{(p)}"else"p_{(x/y)}","} &= \\sqrt{\\frac{(n-1)S^2_{",if(usingWls())"w"else"y/x","} + \\sum{(n_{(j)}-1)S^2_{",if(usingWls())"w"else"y/x","_{(j)}}}}{(n-1) + \\sum{(n_{(j)}-1)}}} [[break]]"))
  
  exStdErrorRunData = exStdErrorData
  exStdErrorRunData$conc = NULL
  
  results = list()
  for(i in colnames(exStdErrorRunData))
  {
    weightedLeastSquared = getWeightedLeastSquared(exStdErrorData$conc,exStdErrorRunData[,i],input$inputWeightLeastSquared)
    seor = getStandardErrorOfRegerssion(exStdErrorData$conc,exStdErrorRunData[,i],weightedLeastSquared)
    
    df = data.frame(seor)
    names(df) = i
    results = c(results, df)
  }
  
  results = unlist(results)
  lengths = unlist(apply(exStdErrorRunData, 2, getCalibrationCurve_n), use.names = FALSE)
  
  n1 = getCalibrationCurve_n(y)
  n2 = lengths[1]
  n3 = lengths[length(results)]
  
  s1 = getStandardErrorOfRegerssion(x,y,weightedLeastSquared)
  s2 = results[1]
  s3 = results[length(results)]
  
  end = ""
  if(length(results) > 2)
  {
    endNumerator = paste(" + \\ldots + (",n3,"-1) \\times ",s3,"^2")
    endDemoninator = paste(" + \\ldots + (",n3,"-1)")
  }
  else if(length(results) == 2)
  {
    endNumerator = paste(" + (",n3,"-1) \\times ",s3,"^2")
    endDemoninator = paste(" + (",n3,"-1)")
  }
  else
  {
    endNumerator = ""
    endDemoninator = ""
  }
  
  formulas = c(formulas, paste0("&= \\sqrt{\\frac{(",n1,"-1) \\times ",s1,"^2 + (",n2,"-1) \\times ",s2,"^2",endNumerator,"}{(",n1,"-1) + (",n2,"-1)",endDemoninator,"}} [[break]]"))

  formulas = c(formulas, paste0("&=\\color{",color4,"}{", answer, "}"))
  
  output = mathJaxAligned(formulas, 5, 20)
 
  box(title=paste("Pooled Standard Error of Regression (External Calibration Data) \\((S_{",if(usingWls())"w_{(p)}"else"p_{(x/y)}","})\\)"), width = 7,withMathJax(HTML(output)))
})
  
  
  
  
output$display_calibrationCurve_finalAnswer_top <- renderText({
  return(paste("\\(u_r\\text{(CalCurve)}=\\)",calibrationCurveResult()))
})

output$display_calibrationCurve_finalAnswer_bottom <- renderUI({
  data = calibrationCurveDataReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  weightedLeastSquared = getWeightedLeastSquared(x,y,input$inputWeightLeastSquared)
  
  extStdErrorData = externalStandardErrorData()
  
  uncertaintyOfCalibration = getUncertaintyOfCalibration(x,y,weightedLeastSquared,extStdErrorData,input$inputCaseSampleReplicates,input$inputCaseSampleMeanConcentration)
  relativeStandardUncertainty = calibrationCurveResult()
  
  formulas = c("u_r\\text{(CalCurve)} &= \\frac{\\text{Uncertatiny of Calibration}}{\\text{Case Sample Mean Concentration}} [[break]]")
  formulas = c(formulas, getRelativeStandardUncertaintyLatex)
  formulas = c(formulas, paste("&=\\frac{",uncertaintyOfCalibration,"}{\\bbox[#F012BE,2pt]{",input$inputCaseSampleMeanConcentration,"}}"))
  formulas = c(formulas, paste("&=",relativeStandardUncertainty))
  
  output = mathJaxAligned(formulas, 5, 20)
  
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurve_finalAnswer_dashboard <- renderUI({
  return(paste("\\(u_r\\text{(CalCurve)}=\\)",calibrationCurveResult()))
})

output$display_calibrationCurve_finalAnswer_combinedUncertainty <- renderUI({
  return(paste(calibrationCurveResult()))
})

output$display_calibrationCurve_finalAnswer_coverageFactor <- renderUI({
  return(paste(calibrationCurveResult()))
})
  
  

###################################################################################
# Helper Methods
###################################################################################

getCalibrationCurveMeanOfX = function(calibrationCurveDataReformatted){
  data = calibrationCurveDataReformatted()
  if(is.null(data))
  {
    return(NA)
  }
  meanOfX = mean(data$calibrationDataConcentration)
  return(round(meanOfX, numDecimalPlaces))
}
getSqDevation = function(values){
  sqDevation = (values - mean(values))^2
  sqDevation = round(sqDevation, numDecimalPlaces)
  return(sqDevation)
}

getLinearRegression = function(x,y,wls)
{
  linearRegerssion = lm(y~x, na.action = na.omit, weights = wls)
  return(linearRegerssion)
}

getPredicetedY = function(x, y, wls){
  calCurve = getLinearRegression(x,y,wls) # Regression Cofficients
  predictedY = fitted(calCurve)
  predictedY = round(predictedY, numDecimalPlaces)
  #remove naming for vector of numbers
  predictedY = unname(predictedY)
  return(predictedY)
}

getSlope = function(x,y,wls){
  linearRegerssion = getLinearRegression(x,y,wls)
  slope <- coef(linearRegerssion)[2];
  slope = round(slope, numDecimalPlaces)
  #remove naming to get single number
  slope = unname(slope)
  return(slope)
}

getIntercept = function(x,y,wls){
  linearRegerssion = getLinearRegression(x,y,wls)
  intercept = coef(linearRegerssion)[1]
  intercept = round(intercept, numDecimalPlaces)
  #remove naming to get single number
  intercept = unname(intercept)
  return(intercept)
}

getErrorSqDevationY = function(x,y,wls){
  errorSqDevationY = (na.omit(y) - getPredicetedY(x,y,wls))^2
  errorSqDevationY= round(errorSqDevationY, numDecimalPlaces)
  return (errorSqDevationY)
}

getDegreesOfFreedom = function(values){
  degressOfFreedom = getCalibrationCurve_n(values)-2
  degressOfFreedom = round(degressOfFreedom, numDecimalPlaces)
  return(degressOfFreedom)
}

getStandardErrorOfRegerssion = function(x,y,wls){
  linearRegerssion = getLinearRegression(x,y,wls)
  standardErrorOfRegerssion = summary.lm(linearRegerssion)$sigma
  standardErrorOfRegerssion= round(standardErrorOfRegerssion, numDecimalPlaces)
  return(standardErrorOfRegerssion)
}

getUncertaintyOfCalibration = function(x,y,wls,extStdErrorData, caseSampleReplicates, caseSampleMeanConcentration)
{
  syx = 0
  if(is.null(extStdErrorData))
  {
    syx = getStandardErrorOfRegerssion(x,y,wls)
  }
  else
  {
    syx = getPooledStdErrorOfRegression(x,y,wls,extStdErrorData)
  }
  
  uncertaintyOfCalibration = (syx / getSlope(x,y,wls)) * (sqrt((1/caseSampleReplicates)+(1/getCalibrationCurve_n(x))+(caseSampleMeanConcentration-mean(x))^2 / sum(getSqDevation(x))))
  uncertaintyOfCalibration = round(uncertaintyOfCalibration, numDecimalPlaces)
  
  return(uncertaintyOfCalibration)
}

getPooledStdErrorOfRegression = function(x,y,wls,exStdErrData){
  exStdErrRunData = exStdErrData
  exStdErrRunData$conc = NULL
  
  results = list()
  for(i in colnames(exStdErrRunData))
  {
    weightedLeastSquared = getWeightedLeastSquared(exStdErrData$conc,exStdErrRunData[,i],input$inputWeightLeastSquared)
    seor = getStandardErrorOfRegerssion(exStdErrData$conc,exStdErrRunData[,i],weightedLeastSquared)
    
    answer = data.frame(seor)
    names(answer) = i
    results = c(results, answer)
  }
  
  results = unlist(results)
  lengths = unlist(apply(exStdErrRunData, 2, getCalibrationCurve_n), use.names = FALSE)
  
  numeratorExternalDataSum = sum((results ^ 2) * (lengths -1))
  numeratorSum = (getStandardErrorOfRegerssion(x,y,wls)^2) * (getCalibrationCurve_n(y) - 1)
  numerator = numeratorExternalDataSum + numeratorSum 
  
  demoninatorExternalDataSum = sum(lengths - 1)
  demoninatorSum = getCalibrationCurve_n(y) - 1
  demoninator = demoninatorExternalDataSum + demoninatorSum
  
  answer = sqrt(numerator/demoninator)
  
  return(round(answer,numDecimalPlaces))
}

getRelativeStandardUncertainty = function(x,y,wls,extStdErrorData,caseSampleReplicates,caseSampleMeanConcentration){
  uncertaintyOfCalibration = getUncertaintyOfCalibration(x,y,wls,extStdErrorData,caseSampleReplicates,caseSampleMeanConcentration)
  
  relativeStandardUncertainty = uncertaintyOfCalibration / caseSampleMeanConcentration
  relativeStandardUncertainty = round(relativeStandardUncertainty, numDecimalPlaces)
  
  return(relativeStandardUncertainty)
}

getCalibrationCurve_n = function(values)
{
  n = length(values[!is.na(values)])
  return(n)
}