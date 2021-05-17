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
output$display_calibrationCurve_replicates = renderUI({
  string = paste(input$inputCaseSampleReplicates)
  return(string)
})

output$display_calibrationCurve_meanConcentration = renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_calibrationCurve_meanPar <- renderUI({
  if(checkNeedPeakAreaRatio())
  {
    infoBox(withMathJax(HTML("Case Sample<br />Mean Peak Area Ratio\\((y_s)\\)")),input$inputCaseSampleMeanPeakAreaRatio, width=4, icon=icon("chart-bar"), color="orange")
  }
})

output$display_calibrationCurve_caseSampleWeight <- renderUI({
  if(checkUsingCustomWls())
  {
    infoBox(withMathJax(HTML("Case Sample<br />Weight\\((W_s)\\)")),formatNumberForDisplay(input$inputCaseSampleCustomWeight, input), width=4, icon=icon("weight"), color="red")
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
  options = list(scrollX = TRUE, dom = 'tip', columnDefs = list(list(className = 'dt-right', targets = 0:8)))
)

output$uploadedCalibrationDataStats = renderUI({
  numberOfRuns = getCalibrationCurve_numberOfRuns()
  numberOfReplicates = getCalibrationCurve_numberOfReplicates()
  numberOfConcentrations = getCalibrationCurve_numberOfConcentrations()
  numberOfPeakAreaRatios = getCalibrationCurve_numberOfPeakAreaRatios()
  
  return(HTML(sprintf("Uploaded Calibration Data<br />Runs: %d | Reps: %d | Concentration Levels: %d | Peak Area Ratios: %d",numberOfRuns, numberOfReplicates, numberOfConcentrations, numberOfPeakAreaRatios)))
})

calibrationCurve_linearRegression_renderer = function(removeColours = FALSE){
  if(is.null(getDataCalibrationCurve())) return(NA)
  
  intercept = formatNumberForDisplay(getCalibrationCurve_intercept(), input)
  slope = formatNumberForDisplay(getCalibrationCurve_slope(), input)
  rSquare = formatNumberForDisplay(getCalibrationCurve_rSquared(), input)
  n = getCalibrationCurve_n()
  
  formulas = c(paste0("\\text{Intercept}(b_0) &=",intercept))
  formulas = c(formulas, paste0("\\text{Slope}(b_1) &= ", colourNumber(slope, input$useColours, input$colour6)))
  formulas = c(formulas, paste0("R^2_{\\text{adj}} &=",rSquare))
  formulas = c(formulas, paste0("n &= ",colourNumber(n, input$useColours, input$colour5)))
  output = mathJaxAligned(formulas, 10, 50, removeColours)
  
  return(withMathJax(HTML(output)))
}

output$display_calibrationCurve_linearRegression = renderUI({
  return(calibrationCurve_linearRegression_renderer())
})

output$display_calibrationCurve_weightedMeanOfX = renderUI({
  sumOfWeightedX = formatNumberForDisplay(getCalibrationCurve_sumOfWeightedX(), input)
  n = getCalibrationCurve_n()
  answer = formatNumberForDisplay(getCalibrationCurve_meanOfX(), input)
  
  formulas = c("\\overline{x}_w &= \\frac{\\sum{w_ix_i}}{n}")
  formulas = c(formulas, paste("& = \\frac{",sumOfWeightedX,"}{",colourNumber(n, input$useColours, input$colour5),"}"))
  formulas = c(formulas, paste("&=",colourNumber(answer, input$useColours, input$colour1)))
  output = mathJaxAligned(formulas, 5)

  box(title = "Mean of Weighted \\(x\\)", width = 4, withMathJax(HTML(output)))
})

output$display_calibrationCurve_sumOfSquaredDeviationOfX = renderUI({
  answer = formatNumberForDisplay(getCalibrationCurve_sumWeightedSqDeviationX(), input)
  
  formulas = c("S_{{xx}_w} &= \\sum\\limits_{i=1}^nw_i(x_i - \\overline{x})^2")
  formulas = c(formulas, paste("&=",colourNumber(answer, input$useColours, input$colour2)))
  output = mathJaxAligned(formulas, 5)
  
  box(title = "Sum of Squared Deviation of \\(x\\)",
      width = 4,
      withMathJax(HTML(output))
      )
})

# output$display_calibrationCurve_sumOfWeightedXSquared = renderUI({
#   data = getDataCalibrationCurveReformatted()
#   y = data$calibrationDataPeakArea
#   x = data$calibrationDataConcentration
#   
#   answer = formatNumberForDisplay(getCalibrationCurve_sumOfWeightedXSquared(), input)
#   
#   formulas = c(paste("\\sum{w_ix_i^2} = ",colourNumber(answer, input$useColours, input$colour2)))
#   output = mathJaxAligned(formulas, 5)
#   
#   box(title = "Sum of \\(wx^2\\)",
#       width = 3,
#       withMathJax(HTML(output))
#   )
# })

output$display_calibrationCurve_errorSumSqY = renderUI({
  errorSqDeviationY = getCalibrationCurve_weightedErrorSqDeviationY()
  answer = formatNumberForDisplay(sum(errorSqDeviationY), input)

  formulas = c(paste("S_{y\\hat{y}} &=\\sum\\limits_{i=1}^n w_i(y_i-\\hat{y}_i)^2"))
  formulas = c(formulas, paste("&=",colourNumber(answer, input$useColours, input$colour3)))
  output = mathJaxAligned(formulas, 5)
  
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurve_standardErrorOfRegression = renderUI({
  n = getCalibrationCurve_n()

  errorSqDeviationY = getCalibrationCurve_weightedErrorSqDeviationY()
  sumErrorSqDeviationY = formatNumberForDisplay(sum(errorSqDeviationY), input)
  
  answer = formatNumberForDisplay(getCalibrationCurve_standardErrorOfRegression(), input)
  
  formulas = c(paste("S_{w} &= \\sqrt{\\frac{\\sum\\limits_{i=1}^n w_i(y_i-\\hat{y}_i)^2}{n-2}}","[[break]]"))
  formulas = c(formulas, paste("S_{w} &= \\sqrt{\\frac{",colourNumber(sumErrorSqDeviationY, input$useColours, input$colour3),"}{",colourNumber(n, input$useColours, input$colour5),"-2}}"))
  formulas = c(formulas, paste("&=",colourNumber(answer, input$useColours, input$colour4)))
  output = mathJaxAligned(formulas, 5, 20)
  
  box(width = 4,
      title=paste("Standard Error of Regression \\((S_{w})\\)"),
      output
  )
})

output$display_calibrationCurve_weightedCaseSample = renderUI({
  wlsSelectedOption = input$inputWeightLeastSquared
  n = getCalibrationCurve_n()
  
  caseSampleMeanConc = input$inputCaseSampleMeanConcentration
  peakAreaRatioOfCaseSample = input$inputCaseSampleMeanPeakAreaRatio
  caseSampleWeight = formatNumberForDisplay(input$inputCaseSampleCustomWeight, input)
  sumOfWeights = formatNumberForDisplay(getCalibrationCurve_sumOfWeightedLeastSquared(), input)
  answer = formatNumberForDisplay(getCalibrationCurve_weightedCaseSample(), input)
  
  formulas = c("w_s &= W_s(\\frac{n}{\\sum{W_i}})")
  
  if(wlsSelectedOption == 1)
  {
    formulas = c(formulas, paste("&= 1(\\frac{",colourNumber(n, input$useColours, input$colour5),"}{",sumOfWeights,"})"))
  }
  else if(wlsSelectedOption == 2)
  {
    formulas = c(formulas, paste("&= \\frac{1}{",ColourCaseSampleMeanConcentration(caseSampleMeanConc,input$useColours),"}(\\frac{",colourNumber(n, input$useColours, input$colour5),"}{",sumOfWeights,"})"))
  }
  else if(wlsSelectedOption == 3)
  {
    formulas = c(formulas, paste("&= \\frac{1}{",ColourCaseSampleMeanConcentration(caseSampleMeanConc,input$useColours),"^2}(\\frac{",colourNumber(n, input$useColours, input$colour5),"}{",sumOfWeights,"})"))
  }
  else if (wlsSelectedOption == 4)
  {
    formulas = c(formulas, paste("&= \\frac{1}{",ColourCaseSampleMeanPeakAreaRatio(peakAreaRatioOfCaseSample,input$useColours),"}(\\frac{",colourNumber(n, input$useColours, input$colour5),"}{",sumOfWeights,"})"))
  }
  else if (wlsSelectedOption == 5)
  {
    formulas = c(formulas, paste("&= \\frac{1}{",ColourCaseSampleMeanPeakAreaRatio(peakAreaRatioOfCaseSample,input$useColours),"^2}(\\frac{",colourNumber(n, input$useColours, input$colour5),"}{",sumOfWeights,"})"))
  }
  else if (wlsSelectedOption == 999)
  {
    formulas = c(formulas, paste("&= ",ColourCaseSampleWeight(caseSampleWeight,input$useColours),"(\\frac{",colourNumber(n, input$useColours, input$colour5),"}{",sumOfWeights,"})"))
  }
  
  formulas = c(formulas, paste("&=",colourNumber(answer, input$useColours, input$colour9)))

  output = mathJaxAligned(formulas, 5, 20)
  
  box(width=4,
      title = "Standardised Weight of Case Sample",
      output
  )
})

calibrationCurve_uncertaintyOfCalibration_renderer = function(removeColours = FALSE)
{
  data = getDataCalibrationCurveReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  standardisedWeights = getCalibrationCurve_standardisedWeight()
  
  exStdErrData = getDataExternalStandardError()
  
  stdErrorOfRegression = 0
  if(is.null(exStdErrData))
  {
    stdErrorOfRegression = getCalibrationCurve_standardErrorOfRegression()
  }
  else
  {
    stdErrorOfRegression = getCalibrationCurve_pooledStdErrorOfRegression()
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
  sumWeightedSqDeviationX = formatNumberForDisplay(getCalibrationCurve_sumWeightedSqDeviationX(), input)
  sumWeightedSqDeviationX = colourNumber(sumWeightedSqDeviationX, input$useColours, input$colour2)
  
  answer = formatNumberForDisplay(getCalibrationCurve_uncertaintyOfCalibration(), input)
  
  sw="S_{w}"
  if(!is.null(exStdErrData))
  {
    sw="S_{w_{p}}"
  }
  formulas = c(paste0("u\\text{(CalCurve)} &= \\frac{",sw,"}{b_1} \\sqrt{\\frac{1}{w_{s}(r_s)} + \\frac{1}{n} + \\frac{(x_s - \\overline{x}_w)^2}{S_{{xx}_w}} } [[break]]"))
  formulas = c(formulas, paste("u\\text{(CalCurve)}&=\\frac{",stdErrorOfRegression,"}{",slope,"} \\sqrt{\\frac{1}{",colourNumber(weightedCaseSample, input$useColours, input$colour9)," \\times ",ColourCaseSampleReplicates(caseSampleReps,input$useColours)," } + \\frac{1}{",n,"} + \\frac{(",ColourCaseSampleMeanConcentration(caseSampleMeanConc,input$useColours)," - ",meanX,")^2}{",sumWeightedSqDeviationX,"}}"))
  
  
  formulas = c(formulas, paste("&=",answer))
  output = mathJaxAligned(formulas, 5, 20, removeColours)
  
  return(withMathJax(HTML(output)))
}

output$display_calibrationCurve_uncertaintyOfCalibration = renderUI({
  return(calibrationCurve_uncertaintyOfCalibration_renderer())
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
    add_annotations(x= 0.5,y= 0.8,xref="paper",yref="paper",text=paste0("y = ",intercept,"+",slope,"x"),showarrow = F)    
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
         tabPanel("Pooled Standard Error Raw Data",
                  DT::renderDataTable(
                    getDataExternalStandardError(),
                    rownames = FALSE,
                    options = list(scrollX = TRUE, dom = 'tip')
                  )
         ),
         tabPanel("Pooled Standard Error Custom Weights",
                  DT::renderDataTable(
                    getDataCustomWlsPooled(),
                    rownames = FALSE,
                    options = list(scrollX = TRUE, dom = 'tip')
                  )
         ) 
  )
})

output$display_calibrationCurve_externalStandardErrorCalculations = renderUI({
  exStdErrorData = getDataExternalStandardError()
  if(is.null(exStdErrorData))
    return(NULL)
  
  data = getDataCalibrationCurveExternalStandardErrorRearranged()
  
  tabBox(width=12, side="right",
         title = "Step by Step Calculations for Pooled Standard Error",
         tabPanel("Calculations",
                  DT::renderDataTable(
                    sapply(data, function(x) formatNumberForDisplay(x, input)),
                    rownames = FALSE,
                    options = list(scrollX = TRUE, dom = 'tip', columnDefs = list(list(className = 'dt-right', targets = 0:ncol(data)-1)))
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

  customWlsPooled = getDataCustomWlsPooled()
  
  formulas = c(paste("S_{{w}_{(j)}} &= \\sqrt{\\frac{\\sum\\limits_{i=1}^n w_i(y_i-\\hat{y}_i)^2}{n_{(j)}-2}} [[break]]"))
  
  i = 1
  for(runName in runNames)
  {
    weightedLeastSquared = doGetCalibrationCurve_weightedLeastSquared(exStdErrorData$conc,exStdErrorRunData[,runName],input$inputWeightLeastSquared,data.frame(customWlsPooled[,runName]))
    n = doGetCalibrationCurve_n(exStdErrorRunData[,runName])
    standardisedWeights = doGetCalibrationCurve_standardisedWeight(weightedLeastSquared, n)
    seor = doGetCalibrationCurve_standardErrorOfRegression(exStdErrorData$conc,exStdErrorRunData[,runName],standardisedWeights)
    seorFromatted = formatNumberForDisplay(seor, input)
    seorColoured = colourNumber(seorFromatted, input$useColours, input$colour7)

    nColoured = colourNumber(lengths[i], input$useColours, input$colour5)
    formulas = c(formulas, paste0("S_{{w}_{(\\text{",runName,"})}}&=",seorColoured, " \\hspace{15pt} n_{(\\text{",runName,"})} = ", nColoured))
    i = i + 1
  }
  
  output = mathJaxAligned(formulas, 5, 20)
  
  box(title=paste("Standard Error of Regression \\((S_{{w}_{(j)}})\\)"), width = 5, withMathJax(HTML(output)))
})

output$display_calibrationCurve_externalStandardErrorOfRunsPooled = renderUI({
  exStdErrorData = getDataExternalStandardError()
  if(is.null(exStdErrorData))
    return(NULL)
  
  data = getDataCalibrationCurveReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea

  answer = formatNumberForDisplay(getCalibrationCurve_pooledStdErrorOfRegression(), input)
  
  formulas = c(paste("S_{w_{p}} &= \\sqrt{\\frac{\\sum{(n_{(k)}-1)S^2_{w_{(k)}}}}{\\sum{(n_{(k)}-1)}}} [[break]]"))
  formulas = c(formulas, paste("S_{w_{p}} &= \\sqrt{\\frac{(n-1)S^2_{w} + \\sum{(n_{(j)}-1)S^2_{w_{(j)}}}}{(n-1) + \\sum{(n_{(j)}-1)}}} [[break]]"))
  
  exStdErrorRunData = exStdErrorData
  exStdErrorRunData$conc = NULL
  customWlsPooled = getDataCustomWlsPooled()
  
  results = list()
  for(i in colnames(exStdErrorRunData))
  {
    weightedLeastSquared = doGetCalibrationCurve_weightedLeastSquared(exStdErrorData$conc,exStdErrorRunData[,i],input$inputWeightLeastSquared,data.frame(customWlsPooled[,i]))
    n = doGetCalibrationCurve_n(exStdErrorRunData[,i])
    standardisedWeights = doGetCalibrationCurve_standardisedWeight(weightedLeastSquared, n)
    seor = doGetCalibrationCurve_standardErrorOfRegression(exStdErrorData$conc,exStdErrorRunData[,i],standardisedWeights)
    
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
  
  s1 = formatNumberForDisplay(getCalibrationCurve_standardErrorOfRegression(), input)
  s1 = colourNumber(s1, input$useColours, input$colour4)
  
  s2 = formatNumberForDisplay(results[1], input)
  s2 = colourNumber(s2, input$useColours, input$colour7)
  
  s3 = formatNumberForDisplay(results[length(results)], input)
  s3 = colourNumber(s3, input$useColours, input$colour7)
  
  end = ""
  if(length(results) > 2)
  {
    endNumerator = paste(" + [\\ldots + (",n3,"-1) \\times ",s3,"^2]")
    endDemoninator = paste(" + \\ldots + (",n3,"-1)")
  }
  else if(length(results) == 2)
  {
    endNumerator = paste(" + [(",n3,"-1) \\times ",s3,"^2]")
    endDemoninator = paste(" + (",n3,"-1)")
  }
  else
  {
    endNumerator = ""
    endDemoninator = ""
  }
  
  formulas = c(formulas, paste0("&= \\sqrt{\\frac{(",n1,"-1) \\times ",s1,"^2 + [(",n2,"-1) \\times ",s2,"^2]",endNumerator,"}{(",n1,"-1) + (",n2,"-1)",endDemoninator,"}} [[break]]"))

  formulas = c(formulas, paste0("&=",colourNumber(answer, input$useColours, input$colour4)))
  
  output = mathJaxAligned(formulas, 5, 20)
 
  box(title=paste("Pooled Standard Error of Regression \\((S_{w_{p}})\\)"), width = 7,withMathJax(HTML(output)))
})
  
output$display_calibrationCurve_finalAnswer_top = renderText({
  answer = formatNumberForDisplay(getResultCalibrationCurve(), input)
  return(paste("\\(u_r\\text{(CalCurve)}=\\)",answer))
})

calibrationCurve_finalAnswer_bottom_renderer = function(removeColours = FALSE)
{
  answer = formatNumberForDisplay(getResultCalibrationCurve(), input)
  if(is.na(answer)) return(NA)
  
  uncertaintyOfCalibration = formatNumberForDisplay(getCalibrationCurve_uncertaintyOfCalibration(), input)
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  
  formulas = c("u_r\\text{(CalCurve)} &= \\frac{u\\text{(CalCurve)}}{x_s}")
  formulas = c(formulas, paste("&=\\frac{",uncertaintyOfCalibration,"}{",ColourCaseSampleMeanConcentration(caseSampleMeanConcentration,input$useColours),"}"))
  formulas = c(formulas, paste("&=",answer))
  
  output = mathJaxAligned(formulas, 5, 20, removeColours)
  
  return(withMathJax(HTML(output)))
}

output$display_calibrationCurve_finalAnswer_bottom = renderUI({
  return(calibrationCurve_finalAnswer_bottom_renderer())
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