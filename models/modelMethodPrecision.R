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

#Load raw data from CSV file
methodPrecisionData = reactive({
  if(myReactives$uploadedMethodPrecision == TRUE)
  {
    data = methodPrecisionReadCSV(input$inputMethodPrecisionFileUpload$datapath)
    return(data)
  }
  else
  {
    return(NULL)
  }
})

#Get data and run calculations and store in data.frame for easy access
methodPrecisionDataWithCalculations = reactive({
  #Get all the data and unique concentraions
  allData = methodPrecisionData();
  caseSampleReplicate = input$inputCaseSampleReplicates
  caseSampleMean = input$inputCaseSampleMeanConcentration
  return(doGetMethodPrecisionDataWithCalculations(allData,caseSampleReplicate,caseSampleMean))
})

methodPrecisionDataWithCalculationsNeatHeaders = reactive({
  data = data.frame(methodPrecisionDataWithCalculations()$conc,methodPrecisionDataWithCalculations()$run,methodPrecisionDataWithCalculations()$mean,methodPrecisionDataWithCalculations()$stdDev,methodPrecisionDataWithCalculations()$dof,methodPrecisionDataWithCalculations()$pooledStandardDeviationNumerator)
  colnames(data) = c("$$\\text{Nominal Value (NV)}$$","$$\\text{Run}$$","$$\\text{Mean (} \\overline{x})$$","$$\\text{Standard Deviation (} S)$$","$$\\text{Degrees of Freedom (} {\\large\\nu})$$","$$S^2 \\times {\\large\\nu}$$")
  return(data)
})


methodPrecisionResult = reactive({
  data = methodPrecisionDataWithCalculations()
  if(is.null(data))
  {
    return(NA)
  }
  inputCaseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  if(is.null(inputCaseSampleMeanConcentration) | !is.numeric(inputCaseSampleMeanConcentration))
  {
    return(NA)
  }
  closetConcentration = getMethodPrecisionFinalAnswerClosestConcentration(data, inputCaseSampleMeanConcentration)
  return(getMethodPrecisionFinalAnswer(data, closetConcentration))
})

methodPrecisionDof = reactive({
  data =  methodPrecisionDataWithCalculations()
  if(is.null(data))
  {
    return(NA)
  }
  inputCaseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  if(is.null(inputCaseSampleMeanConcentration) | !is.numeric(inputCaseSampleMeanConcentration))
  {
    return(NA)
  }
  closetConcentration = getMethodPrecisionFinalAnswerClosestConcentration(data, inputCaseSampleMeanConcentration)
  return(getMethodPrecisionDof(data, closetConcentration))
})

###################################################################################
# Outputs
###################################################################################

#Output the title while showing the number of runs and number of concentrations in the data
output$uploadedMethodPrecisionDataStats = renderUI({
  data = methodPrecisionData()
  string = sprintf("Uploaded Quality Control Data | Runs: %d | No. Concentrations: %d", getNumberOfRuns(data), getNumberOfConcentrations(data))
  return(string)
})

#Show a datatable with the RAW data loaded (hides searching with dom attribute)
output$methodPrecisionRawData = DT::renderDataTable(
  sapply(methodPrecisionData(), function(x) formatNumberForDisplay(x, input)),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)

output$display_methodPrecision_replicates = renderUI({
  string = paste(input$inputCaseSampleReplicates)
  return(string)
})

output$display_methodPrecision_meanConcentration = renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

#Show a datatable with all the calculations in it
#Get the number of runs and use that as the page size to make navigation a little more straight forward
output$methodPrecisionCalculations = DT::renderDataTable(
  sapply(methodPrecisionDataWithCalculationsNeatHeaders(), function(x) formatNumberForDisplay(x, input)),
  rownames = FALSE,
  options = list(pageLength = getNumberOfRuns(methodPrecisionData()), scrollX = TRUE, dom = 'tip', columnDefs = list(list(className = 'dt-right', targets = 0:5)))
)

#Display a graph of the raw data as a box plot
output$methodPrecisionRawDataGraph = renderPlotly({
  data = methodPrecisionData()
  runNames = colnames(data)[-1]
  concentrations = getConcentrations(data)
  
  plotlyPlot = plot_ly(data, name='Peak Area Ratios', type = 'box') %>%
                       layout(boxmode = "group", xaxis = list(title="Concentration"), yaxis = list(title="Peak Area Ratio"))

  #Add plots for each concentration row
  # rowConcRun = 1
  # oldRowConc = 0
  # for(i in 1:nrow(data)) {
  #   row = data[i,]
  #   rowConc = row$conc
  # 
  #   if(rowConc != oldRowConc)
  #   {
  #     oldRowConc = rowConc
  #     rowConcRun = 1
  #   }
  # 
  #   #Remove concentration column and return rotate table to get list of values
  #   row$conc = NULL
  #   row = melt(row)
  # 
  #   #print(row)
  #   plotlyPlot = plotlyPlot %>% add_trace(x = rowConc, y = row$value, name=sprintf("Conc%d-Rep%d",rowConc,rowConcRun))
  # 
  #   rowConcRun = rowConcRun + 1
  # }

  #Add plots for each run
  for(trace in runNames)
  {
   plotlyPlot = plotlyPlot %>% add_trace(x = ~conc, y = as.formula(paste0("~", trace)), name=sprintf("%s",trace))
  }
  
  
  return(plotlyPlot)
})

output$outputSumOfDof = renderUI({

  data = methodPrecisionDataWithCalculations()

  formula = character()
  for(conc in getConcentrations(data))
  {
    formula = c(formula, paste0("\\sum{{\\large\\nu}}_{(",conc,")} &= ", colourNumber(getSumDofForConcentration(data, conc), input$useColours, input$colour1)))
  }
  results = mathJaxAligned(formula)

  return(withMathJax(results))
})

output$outputMeanConcForNv = renderUI({
  data = methodPrecisionDataWithCalculations()
  
  formula = character()
  for(conc in getConcentrations(data))
  {
    answer = formatNumberForDisplay(getMeanConcForNv(data, conc),input)
    formula = c(formula, paste0("\\overline{x}_{(",conc,")} &= ", colourNumber(answer, input$useColours, input$colour6)))
  }
  results = mathJaxAligned(formula)
  
  return(withMathJax(results))
})

output$outputSumOfS2d = renderUI({
  
  data = methodPrecisionDataWithCalculations()
  
  formula = character()
  for(conc in getConcentrations(data))
  {
    answer = formatNumberForDisplay(getSumPooledStandardDeviationNumeratorForConcentration(data,conc),input)
    formula = c(formula, paste0("\\sum{(S^2 \\times {\\large\\nu})_{(",conc,")}} &= ",colourNumber(answer, input$useColours, input$colour2)))
  }
  results = mathJaxAligned(formula)
  
  return(withMathJax(results))
  
})


outputPooledStandardDeviation_renderer = function(removeColours = FALSE)
{
  data = methodPrecisionDataWithCalculations()
  if(is.null(data)) return(NA)
  
  formula = c("S_{p(\\text{NV})} &= \\sqrt{\\frac{\\sum{(S^2 \\times {\\large\\nu})_{\\text{(NV)}}}}{\\sum {\\large\\nu}_{\\text{(NV)}}}} [[break]]")
  
  for(conc in getConcentrations(data))
  {
    psdnfc = formatNumberForDisplay(getSumPooledStandardDeviationNumeratorForConcentration(data,conc),input)
    sdoffc = getSumDofForConcentration(data, conc)
    answer = formatNumberForDisplay(getPooledStandardDeviation(data, conc),input)
    
    formula = c(formula, paste0("S_{p(",conc,")} &= \\sqrt{\\frac{",colourNumber(psdnfc, input$useColours, input$colour2),"}{",colourNumber(sdoffc, input$useColours, input$colour1),"}} = ",colourNumber(answer, input$useColours, input$colour3)))
  }
  
  results = mathJaxAligned(formula, 10, 20, removeColours)
  
  return(withMathJax(HTML(results)))
}

#Display the Pooled Standard Deviation for each concentration in the data
output$outputPooledStandardDeviation = renderUI({
  return(outputPooledStandardDeviation_renderer())
})

outputStandardUncertainty_renderer = function(removeColours = FALSE)
{
  data =  methodPrecisionDataWithCalculations()
  if(is.null(data)) return(NA)
  
  formula = c("u(\\text{MethodPrec})_{\\text{(NV)}} &= \\frac{S_{p\\text{(NV)}}}{\\sqrt{r_s}} [[break]]")
  
  for(conc in getConcentrations(data))
  {
    psd = formatNumberForDisplay(getPooledStandardDeviation(data, conc),input)
    csr = input$inputCaseSampleReplicates
    answer = formatNumberForDisplay(getStandardUncertainty(data, conc),input)
    formula = c(formula, paste0("u(\\text{MethodPrec})_{(",conc,")} &= \\frac{",colourNumber(psd, input$useColours, input$colour3),"}{\\sqrt{",ColourCaseSampleReplicates(csr,input$useColours),"}} = ", colourNumber(answer, input$useColours, input$colour4)))
  }
  
  results = mathJaxAligned(formula, 10, 20, removeColours)
  
  return(withMathJax(HTML(results)))
}

#Display the Standard Uncertainty for each concentration in the data
output$outputStandardUncertainty = renderUI({
  return(outputStandardUncertainty_renderer())
}) 

outputRealtiveStandardUncertainties_renderer = function(removeColours = FALSE)
{
  data = methodPrecisionDataWithCalculations()
  if(is.null(data)) return(NA)
  
  formula = c("u_r(\\text{MethodPrec})_{\\text{(NV)}} &= \\frac{u(\\text{MethodPrec})_{\\text{(NV)}}}{\\overline{x}_{\\text{(NV)}}} [[break]]")
  
  for(conc in getConcentrations(data))
  {
    su = formatNumberForDisplay(getStandardUncertainty(data, conc),input)
    meanConcForNv = formatNumberForDisplay(getMeanConcForNv(data, conc),input)
    rsu = formatNumberForDisplay(getRealtiveStandardUncertainty(data, conc),input)
    formula = c(formula, paste0("u_r(\\text{MethodPrec})_{(",conc,")} &= \\frac{",colourNumber(su, input$useColours, input$colour4),"}{",colourNumber(meanConcForNv, input$useColours, input$colour6),"} = ",colourNumber(rsu, input$useColours, input$colour5)))
  }
  
  results = mathJaxAligned(formula, 10, 20, removeColours)
  
  return(withMathJax(HTML(results)))
}

#Display the Realtive Standard Uncertainties for each concentration in the data
output$outputRealtiveStandardUncertainties = renderUI({
  return(outputRealtiveStandardUncertainties_renderer())
})

output$display_methodPrecision_finalAnswer_top = renderText({
  answer = formatNumberForDisplay(methodPrecisionResult(), input)
  return(paste("\\(u_r\\text{(MethodPrec)}=\\)",answer))
})

methodPrecision_finalAnswer_bottom_renderer = function(removeColours = FALSE){
  data =  methodPrecisionDataWithCalculations()
  if(is.null(data)) return(NA)
  
  closetConcentration = getMethodPrecisionFinalAnswerClosestConcentration(data, input$inputCaseSampleMeanConcentration)
  
  concs = ""
  for(i in getConcentrations(data))
  {
    concs = paste0(concs,i,",")
  }
  
  output = paste("Of concentrations ", concs, " the closet to Case Sample Mean \\((x_s)\\) of \\(",ColourCaseSampleMeanConcentration(input$inputCaseSampleMeanConcentration,input$useColours),"\\) is ",closetConcentration,"<br /><br />")
  
  if(is.na(closetConcentration))
  {
    output = "The closest concentration from your method precision data cannot be found.<br />This is usually because a Case Sample Mean Concentration has not been specified on the start page.<br /><br />"
  }
  
  output = paste(output, "\\(u_r(\\text{MethodPrec})_{(", closetConcentration, ")}=", formatNumberForDisplay(methodPrecisionResult(),input), "\\)")
  
  if(removeColours)
  {
    output = removeMathJaxColours(output)
  }
  
  return(withMathJax(HTML(output)))
}

output$display_methodPrecision_finalAnswer_bottom = renderUI({
  return(methodPrecision_finalAnswer_bottom_renderer())
})

output$display_methodPrecision_finalAnswer_dashboard = renderUI({
  return(paste("\\(u_r\\text{(MethodPrec)}=\\)",formatNumberForDisplay(methodPrecisionResult(),input)))
})

output$display_methodPrecision_finalAnswer_combinedUncertainty = renderUI({
  return(paste(formatNumberForDisplay(methodPrecisionResult(),input)))
})

output$display_methodPrecision_finalAnswer_coverageFactor = renderUI({
  return(paste(formatNumberForDisplay(methodPrecisionResult(),input)))
})
  