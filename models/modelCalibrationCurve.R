###################################################################################
# Outputs
###################################################################################
output$display_calibrationCurve_replicates = renderUI({
  string = paste(input$inputCaseSampleReplicates)
  return(string)
})

output$display_calibrationCurve_meanConcentration = renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_calibrationCurve_meanPar <- renderUI({
  if(checkUsingWls())
  {
    infoBox(withMathJax(HTML("Case Sample<br />Mean Peak Area Ratio\\((y_s)\\)")),input$inputCaseSampleMeanPeakAreaRatio, width=4, icon=icon("chart-bar"), color="orange")
  }
})

output$calibrationData = DT::renderDataTable(
  getDataCalibrationCurve(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)

output$rearrangedCalibrationData = DT::renderDataTable(
  sapply(getDataCalibrationCurveRearranged(), function(x) formatNumberForDisplay(x, input)),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip', columnDefs = list(list(className = 'dt-right', targets = 0:5)))
)

output$uploadedCalibrationDataStats = renderUI({
  numberOfRuns = getCalibrationCurve_numberOfRuns()
  numberOfReplicates = getCalibrationCurve_numberOfReplicates()
  numberOfConcentrations = getCalibrationCurve_numberOfConcentrations()
  numberOfPeakAreaRatios = getCalibrationCurve_numberOfPeakAreaRatios()
  
  return(HTML(sprintf("Uploaded Calibration Data<br />Runs: %d | Reps: %d | Concentration Levels: %d | Peak Area Ratios: %d",numberOfRuns, numberOfReplicates, numberOfConcentrations, numberOfPeakAreaRatios)))
})

output$display_calibrationCurve_linearRegression = renderUI({
  intercept = formatNumberForDisplay(getCalibrationCurve_intercept(), input)
  slope = formatNumberForDisplay(getCalibrationCurve_slope(), input)
  rSquare = formatNumberForDisplay(getCalibrationCurve_rSquared(), input)
  n = getCalibrationCurve_n()
  
  formulas = c(paste0("\\text{Intercept}(b_0) &=",intercept))
  formulas = c(formulas, paste0("\\text{Slope}(b_1) &= ", colourNumber(slope, input$useColours, input$colour6)))
  formulas = c(formulas, paste0("R^2 &=",rSquare))
  formulas = c(formulas, paste0("n &= ",colourNumber(n, input$useColours, input$colour5)))
  output = mathJaxAligned(formulas, 10)
  
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurve_meanOfX = renderUI({
  if(checkUsingWls()) return(NULL) #Don't display if we're using Weighted Least Square

  sumOfX = formatNumberForDisplay(getCalibrationCurve_sumOfX(), input)
  n = getCalibrationCurve_n()
  answer = formatNumberForDisplay(getCalibrationCurve_meanOfX(), input)
  
  formulas = c("\\overline{x} &= \\frac{\\sum{x_i}}{n}")
  formulas = c(formulas, paste("& = \\frac{",sumOfX,"}{",colourNumber(n, input$useColours, input$colour5),"}"))
  formulas = c(formulas, paste("&=",colourNumber(answer, input$useColours, input$colour1)))
  output = mathJaxAligned(formulas, 5)
  
  box(title = "Mean of \\(x\\)", width = 3, withMathJax(HTML(output)))
})

output$display_calibrationCurve_weightedMeanOfX = renderUI({
  if(!checkUsingWls()) return(NULL) #Only display if we're using Weighted Least Square

  sumOfWeightedX = formatNumberForDisplay(getCalibrationCurve_sumOfWeightedX(), input)
  n = getCalibrationCurve_n()
  answer = formatNumberForDisplay(getCalibrationCurve_meanOfX(), input)
  
  formulas = c("\\overline{x}_w &= \\frac{\\sum{w_ix_i}}{n}")
  formulas = c(formulas, paste("& = \\frac{",sumOfWeightedX,"}{",colourNumber(n, input$useColours, input$colour5),"}"))
  formulas = c(formulas, paste("&=",colourNumber(answer, input$useColours, input$colour1)))
  output = mathJaxAligned(formulas, 5)

  box(title = "Mean of Weighted \\(x\\)", width = 3, withMathJax(HTML(output)))
})

output$display_calibrationCurve_meanOfY = renderUI({
  if(checkUsingWls()) return(NULL) #Don't display if we're using Weighted Least Square
  
  sumOfY = formatNumberForDisplay(getCalibrationCurve_sumOfY(), input)
  n = getCalibrationCurve_n()
  answer = formatNumberForDisplay(getCalibrationCurve_meanOfY(), input)
  
  formulas = c("\\overline{y} &= \\frac{\\sum{y_i}}{n}")
  formulas = c(formulas, paste("& = \\frac{",sumOfY,"}{",colourNumber(n, input$useColours, input$colour5),"}"))
  formulas = c(formulas, paste("&=",colourNumber(answer, input$useColours, input$colour1)))
  output = mathJaxAligned(formulas, 5)
  
  box(title = "Mean of \\(y\\)", width = 3, withMathJax(HTML(output)))
})

output$display_calibrationCurve_weightedMeanOfY = renderUI({
  if(!checkUsingWls()) return(NULL) #Only display if we're using Weighted Least Square

  sumOfWeightedY = formatNumberForDisplay(getCalibrationCurve_sumOfWeightedY(), input)
  n = getCalibrationCurve_n()
  answer = formatNumberForDisplay(getCalibrationCurve_meanOfY(), input)
  
  formulas = c("\\overline{y}_w &= \\frac{\\sum{w_iy_i}}{n}")
  formulas = c(formulas, paste("& = \\frac{",sumOfWeightedY,"}{",colourNumber(n, input$useColours, input$colour5),"}"))
  formulas = c(formulas, paste("&=",colourNumber(answer, input$useColours, input$colour1)))
  output = mathJaxAligned(formulas, 5)
  
  box(title = "Mean of Weighted \\(y\\)", width = 3, withMathJax(HTML(output)))
})

output$display_calibrationCurve_sumOfSquaredDeviationOfX = renderUI({
  if(checkUsingWls()) return(NULL) #Don't display if we're using Weighted Least Square
    
  answer = formatNumberForDisplay(getCalibrationCurve_sumSqDeviationX(), input)
  
  formulas = c("S_{xx} &= \\sum\\limits_{i=1}^n(x_i - \\overline{x})^2")
  formulas = c(formulas, paste("&=",colourNumber(answer, input$useColours, input$colour2)))
  output = mathJaxAligned(formulas, 5)
  
  box(title = "Sum of Squared Deviation of \\(x\\)",
      width = 3,
      withMathJax(HTML(output))
      )
})

output$display_calibrationCurve_sumOfWeightedXSquared = renderUI({
  if(!checkUsingWls()) return(NULL) #Only display if we're using Weighted Least Square
    
  data = getDataCalibrationCurveReformatted()
  y = data$calibrationDataPeakArea
  x = data$calibrationDataConcentration
  
  answer = formatNumberForDisplay(getCalibrationCurve_sumOfWeightedXSquared(), input)
  
  formulas = c(paste("\\sum{w_ix_i^2} = ",colourNumber(answer, input$useColours, input$colour2)))
  output = mathJaxAligned(formulas, 5)
  
  box(title = "Sum of \\(wx^2\\)",
      width = 3,
      withMathJax(HTML(output))
  )
})

output$display_calibrationCurve_errorSumSqY = renderUI({
  errorSqDeviationY = getCalibrationCurve_errorSqDeviationY()
  if(checkUsingWls())
  {
    errorSqDeviationY = getCalibrationCurve_weightedErrorSqDeviationY()
  }
  answer = formatNumberForDisplay(sum(errorSqDeviationY), input)

  
  formulas = c(paste("S_{y\\hat{y}} &=\\sum\\limits_{i=1}^n",if(checkUsingWls())"w_i","(y_i-\\hat{y}_i)^2"))
  formulas = c(formulas, paste("&=",colourNumber(answer, input$useColours, input$colour3)))
  output = mathJaxAligned(formulas, 5)
  
  return(withMathJax(HTML(output)))
})

output$standardErrorOfRegression = renderUI({
  n = getCalibrationCurve_n()

  errorSqDeviationY = getCalibrationCurve_errorSqDeviationY()
  if(checkUsingWls())
  {
    errorSqDeviationY = getCalibrationCurve_weightedErrorSqDeviationY()
  }
  sumErrorSqDeviationY = formatNumberForDisplay(sum(errorSqDeviationY), input)
  
  answer = formatNumberForDisplay(getCalibrationCurve_standardErrorOfRegression(), input)
  
  formulas = c(paste("S_{",if(checkUsingWls())"w"else"y/x","} &= \\sqrt{\\frac{\\sum\\limits_{i=1}^n",if(checkUsingWls())"w_i","(y_i-\\hat{y}_i)^2}{n-2}}","[[break]]"))
  formulas = c(formulas, paste("S_{",if(checkUsingWls())"w"else"y/x","} &= \\sqrt{\\frac{",colourNumber(sumErrorSqDeviationY, input$useColours, input$colour3),"}{",colourNumber(n, input$useColours, input$colour5),"-2}}"))
  formulas = c(formulas, paste("&=",colourNumber(answer, input$useColours, input$colour4)))
  output = mathJaxAligned(formulas, 5, 20)
  
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurve_weightedCaseSample = renderUI({
  if(!checkUsingWls()) return(NULL)
    
  wlsSelectedOption = input$inputWeightLeastSquared
  
  weightedCaseSampleDenominator = formatNumberForDisplay(getCalibrationCurve_weightedCaseSampleDenominator(), input)
  
  #If we're using case sample mean or case sample peak area ratio then lets color it correctly
  if(wlsSelectedOption == 2 | wlsSelectedOption == 3)
  {
    weightedCaseSampleDenominator = ColourCaseSampleMeanConcentration(weightedCaseSampleDenominator)
  }
  else if (wlsSelectedOption == 4 | wlsSelectedOption == 5)
  {
    weightedCaseSampleDenominator = ColourCaseSampleMeanPeakAreaRatio(weightedCaseSampleDenominator)
  }
    
  
  answer = formatNumberForDisplay(getCalibrationCurve_weightedCaseSample(), input)
  
  formulas = c(paste("w_s &=", getCalibrationCurve_wlsLatex()))
  
  #If we're using a squared demoniator then add a squared sign
  if(wlsSelectedOption == 3 | wlsSelectedOption == 5)
    formulas = c(formulas, paste("&= \\frac{1}{",weightedCaseSampleDenominator,"^2}"))
  else
    formulas = c(formulas, paste("&= \\frac{1}{",weightedCaseSampleDenominator,"}"))
  
  formulas = c(formulas, paste("&=",colourNumber(answer, input$useColours, input$colour9)))
  output = mathJaxAligned(formulas, 5, 20)
  
  box(width=3,
      title = "Weight used for Case Sample",
      output
  )
})

output$display_calibrationCurve_uncertaintyOfCalibration = renderUI({
  data = getDataCalibrationCurveReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  weightedLeastSquared = getCalibrationCurve_weightedLeastSquared()
  
  exStdErrData = getDataExternalStandardError()

  stdErrorOfRegression = 0
  if(is.null(exStdErrData))
  {
    stdErrorOfRegression = doGetCalibrationCurve_standardErrorOfRegression(x,y,weightedLeastSquared)
  }
  else
  {
    stdErrorOfRegression = doGetCalibrationCurve_pooledStdErrorOfRegression(x,y,weightedLeastSquared,exStdErrData)
  }
  stdErrorOfRegression = formatNumberForDisplay(stdErrorOfRegression, input)
  stdErrorOfRegression = colourNumber(stdErrorOfRegression, input$useColours, input$colour4)
  
  slope = formatNumberForDisplay(getCalibrationCurve_slope(), input)
  slope = colourNumber(slope, input$useColours, input$colour6)
  caseSampleReps = input$inputCaseSampleReplicates
  n = getCalibrationCurve_n()
  n = colourNumber(n, input$useColours, input$colour5)
  caseSampleMeanConc = input$inputCaseSampleMeanConcentration
  meanX = formatNumberForDisplay(getCalibrationCurve_meanOfX(), input)
  meanX = colourNumber(meanX, input$useColours, input$colour1)
  sumSqDevationX = formatNumberForDisplay(getCalibrationCurve_sumSqDeviationX(), input)
  sumSqDevationX = colourNumber(sumSqDevationX, input$useColours, input$colour2)
  
  weightedCaseSample = formatNumberForDisplay(getCalibrationCurve_weightedCaseSample(), input)
  peakAreaRatioOfCaseSample = input$inputCaseSampleMeanPeakAreaRatio
  calCurveMeanOfY = formatNumberForDisplay(getCalibrationCurve_meanOfY(), input)
  calCurveMeanOfY = colourNumber(calCurveMeanOfY, input$useColours, input$colour1)
  sumOfWeightedXSquared = formatNumberForDisplay(getCalibrationCurve_sumOfWeightedXSquared(), input)
  sumOfWeightedXSquared = colourNumber(sumOfWeightedXSquared, input$useColours, input$colour2)

  answer = formatNumberForDisplay(getCalibrationCurve_uncertaintyOfCalibration(), input)
  
  if(is.null(exStdErrData))
  {
    if(checkUsingWls())
      formulas = c("u\\text{(CalCurve)} &= \\frac{S_{w}}{b_1} \\sqrt{\\frac{1}{w_{s}(r_s)} + \\frac{1}{n} + \\frac{(y_s - \\overline{y}_w)^2}{b_1^2[\\sum{wx^2-n(\\overline{x}_w)^2}]} } [[break]]")
    else
      formulas = c("u\\text{(CalCurve)} &= \\frac{S_{y/x}}{b_1} \\sqrt{\\frac{1}{r_s} + \\frac{1}{n} + \\frac{(x_s - \\overline{x})^2}{S_{xx}} } [[break]]")
  }
  else
  {
    if(checkUsingWls())
      formulas = c("u\\text{(CalCurve)} &= \\frac{S_{w_{p}}}{b_1} \\sqrt{\\frac{1}{w_{s}(r_s)} + \\frac{1}{n} + \\frac{(y_s - \\overline{y}_w)^2}{b_1^2[\\sum{wx^2-n(\\overline{x}_w)^2}]} } [[break]]")
    else
      formulas = c("u\\text{(CalCurve)} &= \\frac{S_{p_{(y/x)}}}{b_1} \\sqrt{\\frac{1}{r_s} + \\frac{1}{n} + \\frac{(x_s - \\overline{x})^2}{S_{xx}} } [[break]]")
  }
  
  if(!checkUsingWls())
  {
    formulas = c(formulas, paste("u\\text{(CalCurve)}&=\\frac{",stdErrorOfRegression,"}{",slope,"} \\sqrt{\\frac{1}{",colourCaseSampleReplicates(caseSampleReps),"} + \\frac{1}{",n,"} + \\frac{(",ColourCaseSampleMeanConcentration(caseSampleMeanConc)," - ",meanX,")^2}{",sumSqDevationX,"} }"))
  }
  else
  {
    formulas = c(formulas, paste("u\\text{(CalCurve)}&=\\frac{",stdErrorOfRegression,"}{",slope,"} \\sqrt{\\frac{1}{",colourNumber(weightedCaseSample, input$useColours, input$colour9)," \\times ",colourCaseSampleReplicates(caseSampleReps)," } + \\frac{1}{",n,"} + \\frac{(",ColourCaseSampleMeanPeakAreaRatio(peakAreaRatioOfCaseSample)," - ",calCurveMeanOfY,")^2}{",slope,"^2[",sumOfWeightedXSquared,"-",n,"\\times",meanX,"^2]}}"))
  }
  
  
  formulas = c(formulas, paste("&=",answer))
  output = mathJaxAligned(formulas, 5, 20)
  
  return(withMathJax(HTML(output)))
})


output$peakAreaRatios = renderPlotly({
  data = getDataCalibrationCurveReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea

  slope = formatNumberForDisplay(getCalibrationCurve_slope(), input)
  intercept = formatNumberForDisplay(getCalibrationCurve_intercept(), input)

  linearRegression = getCalibrationCurve_linearRegression()
  
  plot_ly(x = x, y = y, name='Peak Area Ratios', type = 'scatter', mode='markers') %>%
    add_lines(x = x, y = fitted(linearRegression), name="Calibration Curve") %>%
    layout(xaxis = list(title="Concentration"), yaxis = list(title="Peak Area Ratio")) %>%
    add_annotations(x= 0.5,y= 0.8,xref="paper",yref="paper",text=paste0("$y = ",intercept,"+",slope,"x$"),showarrow = F)    
})

output$display_calibrationCurve_externalStandardErrorUploadedData = renderUI({
  exStdErrorData = getDataExternalStandardError()
  if(is.null(exStdErrorData))
    return(NULL)
  
  numberOfRuns = dim(exStdErrorData)[2]-1 #get the number of columns and minus 1 (because one column in the concentration)
  numberOfReplicates = max(table(exStdErrorData["conc"])) #count the number of occurances of each value in the concentration column, then get the max value (because some might be missing some)
  concentrationLevels = length(table(exStdErrorData["conc"])) #table the concentration column and count the length
  
  #To get the total number of peak areas we want to get just the runs
  exStdErrorRunData = exStdErrorData
  exStdErrorRunData$conc = NULL #so remove the conc column
  lengths = apply(exStdErrorRunData, 2, doGetCalibrationCurve_n) #then count all the runs lengths
  numberOfPeakAreaRatios = sum(lengths) #and add them together
                   
  boxTitle = HTML(sprintf("Calibration Curve Data for Pooled Standard Error<br />Runs: %d | Reps: %d | Concentration Levels: %d | Peak Area Ratios: %d",numberOfRuns,numberOfReplicates,concentrationLevels,numberOfPeakAreaRatios))
  
  tabBox(width=12, side="right",
         title = boxTitle,
         tabPanel("Raw Data",
                  DT::renderDataTable(
                    getDataExternalStandardError(),
                    rownames = FALSE,
                    options = list(scrollX = TRUE, dom = 'tip')
                  )
         )
  )
})

output$display_calibrationCurve_externalStandardErrorOfRuns = renderUI({
  exStdErrorData = getDataExternalStandardError()
  if(is.null(exStdErrorData))
    return(NULL)
  
  exStdErrorRunData = exStdErrorData
  exStdErrorRunData$conc = NULL
  
  runNames = colnames(exStdErrorRunData)
  lengths = apply(exStdErrorRunData, 2, doGetCalibrationCurve_n)
  results = c()

  for(i in runNames)
  {
    weightedLeastSquared = doGetCalibrationCurve_weightedLeastSquared(exStdErrorData$conc,exStdErrorRunData[,i],input$inputWeightLeastSquared)
    seor = doGetCalibrationCurve_standardErrorOfRegression(exStdErrorData$conc,exStdErrorRunData[,i],weightedLeastSquared)
    seorFromatted = formatNumberForDisplay(seor, input)
    seorColoured = colourNumber(seorFromatted, input$useColours, input$colour7)
    results = c(results, seorColoured)
  }

  formulas = c(paste("S_{{",if(checkUsingWls())"w"else"y/x","}_{(j)}} &= \\sqrt{\\frac{\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2}{n_{(j)}-2}} [[break]]"))

  for(i in 1:length(results))
  {
    n = colourNumber(lengths[i], input$useColours, input$colour5)
    
    formulas = c(formulas, paste0("S_{{",if(checkUsingWls())"w"else"y/x","}_{(\\text{",runNames[i],"})}}&=", results[i], " \\hspace{15pt} n_{(\\text{",runNames[i],"})} = ", n))
  }
  
  output = mathJaxAligned(formulas, 5, 20)
  
  box(title=paste("Standard Error of Regression \\((S_{{",if(checkUsingWls())"w"else"y/x","}_{(j)}})\\)"), width = 5, withMathJax(HTML(output)))
})

output$display_calibrationCurve_externalStandardErrorOfRunsPooled = renderUI({
  exStdErrorData = getDataExternalStandardError()
  if(is.null(exStdErrorData))
    return(NULL)
  
  data = getDataCalibrationCurveReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  weightedLeastSquared = getCalibrationCurve_weightedLeastSquared()
  
  answer = formatNumberForDisplay(doGetCalibrationCurve_pooledStdErrorOfRegression(x,y,weightedLeastSquared,exStdErrorData), input)
  
  formulas = c(paste("S_{",if(checkUsingWls())"w_{(p)}"else"p_{(y/x)}","} &= \\sqrt{\\frac{\\sum{(n-1)S^2_{",if(checkUsingWls())"w"else"y/x","}}}{\\sum{(n-1)}}} [[break]]"))
  formulas = c(formulas, paste("S_{",if(checkUsingWls())"w_{(p)}"else"p_{(y/x)}","} &= \\sqrt{\\frac{(n-1)S^2_{",if(checkUsingWls())"w"else"y/x","} + \\sum{(n_{(j)}-1)S^2_{",if(checkUsingWls())"w"else"y/x","_{(j)}}}}{(n-1) + \\sum{(n_{(j)}-1)}}} [[break]]"))
  
  exStdErrorRunData = exStdErrorData
  exStdErrorRunData$conc = NULL
  
  results = list()
  for(i in colnames(exStdErrorRunData))
  {
    weightedLeastSquared = doGetCalibrationCurve_weightedLeastSquared(exStdErrorData$conc,exStdErrorRunData[,i],input$inputWeightLeastSquared)
    seor = doGetCalibrationCurve_standardErrorOfRegression(exStdErrorData$conc,exStdErrorRunData[,i],weightedLeastSquared)
    
    df = data.frame(seor)
    names(df) = i
    results = c(results, df)
  }
  
  results = unlist(results)
  lengths = unlist(apply(exStdErrorRunData, 2, doGetCalibrationCurve_n), use.names = FALSE)
  
  n1 = doGetCalibrationCurve_n(y)
  n1 = colourNumber(n1, input$useColours, input$colour5)
  
  n2 = lengths[1]
  n2 = colourNumber(n2, input$useColours, input$colour5)
  
  n3 = lengths[length(results)]
  n3 = colourNumber(n3, input$useColours, input$colour5)
  
  s1 = formatNumberForDisplay(doGetCalibrationCurve_standardErrorOfRegression(x,y,weightedLeastSquared), input)
  s1 = colourNumber(s1, input$useColours, input$colour4)
  
  s2 = formatNumberForDisplay(results[1], input)
  s2 = colourNumber(s2, input$useColours, input$colour7)
  
  s3 = formatNumberForDisplay(results[length(results)], input)
  s3 = colourNumber(s3, input$useColours, input$colour7)
  
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

  formulas = c(formulas, paste0("&=",colourNumber(answer, input$useColours, input$colour4)))
  
  output = mathJaxAligned(formulas, 5, 20)
 
  box(title=paste("Pooled Standard Error of Regression \\((S_{",if(checkUsingWls())"w_{(p)}"else"p_{(y/x)}","})\\)"), width = 7,withMathJax(HTML(output)))
})
  
output$display_calibrationCurve_finalAnswer_top = renderText({
  answer = formatNumberForDisplay(getResultCalibrationCurve(), input)
  return(paste("\\(u_r\\text{(CalCurve)}=\\)",answer))
})

output$display_calibrationCurve_finalAnswer_bottom = renderUI({
  uncertaintyOfCalibration = formatNumberForDisplay(getCalibrationCurve_uncertaintyOfCalibration(), input)
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  answer = formatNumberForDisplay(getResultCalibrationCurve(), input)
  
  formulas = c("u_r\\text{(CalCurve)} &= \\frac{\\text{Uncertatiny of Calibration}}{\\text{Case Sample Mean Concentration}} [[break]]")
  formulas = c(formulas, "u_r\\text{(CalCurve)} &= \\frac{u\\text{(CalCurve)}}{x_s}")
  formulas = c(formulas, paste("&=\\frac{",uncertaintyOfCalibration,"}{",ColourCaseSampleMeanConcentration(caseSampleMeanConcentration),"}"))
  formulas = c(formulas, paste("&=",answer))
  
  output = mathJaxAligned(formulas, 5, 20)
  
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurve_finalAnswer_dashboard = renderUI({
  answer = formatNumberForDisplay(getResultCalibrationCurve(), input)
  return(paste("\\(u_r\\text{(CalCurve)}=\\)",answer))
})

output$display_calibrationCurve_finalAnswer_combinedUncertainty = renderUI({
  answer = formatNumberForDisplay(getResultCalibrationCurve(), input)
  return(paste(answer))
})

output$display_calibrationCurve_finalAnswer_coverageFactor = renderUI({
  answer = formatNumberForDisplay(getResultCalibrationCurve(), input)
  return(paste(answer))
})