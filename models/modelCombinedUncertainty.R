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

combinedUncertaintyResult = reactive({
  meanConcentration = input$inputCaseSampleMeanConcentration
  uncHomogeneity = getHomogeneity_relativeStandardUncertainty_value()
  uncCalibrationCurve = getResultCalibrationCurve()
  uncMethodPrecision = methodPrecisionResult()
  uncStandardSolution = standardSolutionResult()
  uncSamplePreparation = getResultSamplePreparation()
  
  result = doGetCombinedUncertaintyResult(meanConcentration, uncHomogeneity, uncCalibrationCurve, uncMethodPrecision, uncStandardSolution, uncSamplePreparation)
  return(result)
})

###################################################################################
# Outputs
###################################################################################

#Used for both web display and in the report
combinedUncertainty_uncertaintyBudget_graphData = function(){
  data = data.frame("Homogeneity" = getHomogeneity_relativeStandardUncertainty_value(),  "CalibrationCurve" = getResultCalibrationCurve(), "MethodPrecision" = methodPrecisionResult(), "CalibrationStandard" = standardSolutionResult(), "SamplePreparation" = getResultSamplePreparation())
  data = removeEmptyData(data)
  
  if(nrow(data) == 0)return(NA) #If there no values then return nothing
  
  percentages = data/sum(data) * 100
  percentagesMelt = melt(percentages)
  
  dataMelt = melt(data)
  dataGraphReady = data.frame(uncertaintyComponent = dataMelt$variable, rsu = formatNumberForDisplay(dataMelt$value,input), percentage = round(percentagesMelt$value))
  
  return(dataGraphReady)
}

output$display_combinedUncertainty_uncertaintyBudget = renderPlotly({
  dataGraphReady = combinedUncertainty_uncertaintyBudget_graphData()
  if(anyNA(dataGraphReady))return(NULL)
  
  #Doing this for the colours is messy as we've just got all this data previously, hacky fix.
  data = data.frame("Homogeneity" = getHomogeneity_relativeStandardUncertainty_value(),  "CalibrationCurve" = getResultCalibrationCurve(), "MethodPrecision" = methodPrecisionResult(), "CalibrationStandard" = standardSolutionResult(), "SamplePreparation" = getResultSamplePreparation())
  data = removeEmptyData(data)
  colors = vector()
  for(colname in colnames(data))
  {
    if(colname == "Homogeneity")
    {
      colors = c(colors, HomogeneityColor)
    }
    else if(colname == "CalibrationCurve")
    {
      colors = c(colors, CalibrationCurveColor)
    }
    else if(colname == "MethodPrecision")
    {
      colors = c(colors, MethodPrecisionColor)
    }
    else if(colname == "CalibrationStandard")
    {
      colors = c(colors, StandardSolutionColor)
    }
    else if(colname == "SamplePreparation")
    {
      colors = c(colors, SamplePreparationColor)
    }
  }
  
  plot_ly(dataGraphReady,
          x = ~percentage,
          y = ~uncertaintyComponent,
          text=paste0("RSU: ",dataGraphReady$rsu, " (",dataGraphReady$percentage,"%)"),
          textposition="auto",
          name='Uncertainty Budget',
          type = 'bar',
          orientation = 'h',
          marker = list(color = colors)) %>%
    layout(xaxis = list(title = "Percentage of Total Uncertainty", rangemode = "tozero"),
           yaxis = list(title = "", autorange="reversed"))
})

output$display_combinedUncertainty_meanConcentration = renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_combinedUncertainty_finalAnswer_top = renderText({
  answer = formatNumberForDisplay(combinedUncertaintyResult(), input)
  return(paste("\\(\\text{CombUncertainty}=\\)",answer))
})

combinedUncertainty_finalAnswer_renderer = function(removeColours = FALSE)
{
  ho = getHomogeneity_relativeStandardUncertainty()
  cc = formatNumberForDisplay(getResultCalibrationCurve(),input)
  mp = formatNumberForDisplay(methodPrecisionResult(),input)
  ss = formatNumberForDisplay(standardSolutionResult(),input)
  sv = formatNumberForDisplay(getResultSamplePreparation(),input)
  
  if(is.na(ho)){hoText = ""}else{hoText = "+u_r( \\text{Homogeneity})^2"}
  if(is.na(cc)){ccText = ""}else{ccText = "+u_r( \\text{CalCurve})^2"}
  if(is.na(mp)){mpText = ""}else{mpText = "+u_r( \\text{MethodPrec})^2"}
  if(is.na(ss)){ssText = ""}else{ssText = "+u_r( \\text{CalStandard})^2"}
  if(is.na(sv)){svText = ""}else{svText = "+u_r( \\text{SamplePreparation})^2"}
  componentTexts = paste0(hoText,ccText,mpText,ssText,svText) #Combine all the text values
  componentTexts = sub('.', '', componentTexts)#Remove the first character (which is going to be a plus symbol +)
  
  if(is.na(ho)){hoValue = ""}else{hoValue = paste0("+",colourNumberBackground(ho, HomogeneityColor, "#FFF",input$useColours),"^2")}
  if(is.na(cc)){ccValue = ""}else{ccValue = paste0("+",colourNumberBackground(cc, CalibrationCurveColor, "#FFF",input$useColours),"^2")}
  if(is.na(mp)){mpValue = ""}else{mpValue = paste0("+",colourNumberBackground(mp, MethodPrecisionColor, "#FFF",input$useColours),"^2")}
  if(is.na(ss)){ssValue = ""}else{ssValue = paste0("+",colourNumberBackground(ss, StandardSolutionColor, "#FFF",input$useColours),"^2")}
  if(is.na(sv)){svValue = ""}else{svValue = paste0("+",colourNumberBackground(sv, SamplePreparationColor, "#FFF",input$useColours),"^2")}
  componentValues = paste0(hoValue,ccValue,mpValue,ssValue,svValue) #Combine all the values
  componentValues = sub('.', '', componentValues)#Remove the first character (which is going to be a plus symbol +)
  
  formula = c("\\text{CombUncertainty} &= x_s \\sqrt{\\sum{u_r\\text{(Individual Uncertainty Component)}^2}} [[break]]")
  formula = c(formula, paste("\\text{CombUncertainty} &= x_s \\sqrt{",componentTexts,"}"))
  formula = c(formula, paste("&= ",ColourCaseSampleMeanConcentration(input$inputCaseSampleMeanConcentration,input$useColours),"\\sqrt{",componentValues,"}"))
  formula = c(formula, paste("&= ",formatNumberForDisplay(combinedUncertaintyResult(),input)))
  output = mathJaxAligned(formula, 5, 20, removeColours)
  
  return(withMathJax(HTML(output)))
}
  
output$display_combinedUncertainty_finalAnswer_bottom = renderUI({
  return(combinedUncertainty_finalAnswer_renderer())
})

output$display_combinedUncertainty_finalAnswer_dashboard = renderUI({
  return(paste("\\(u_r\\text{(CombUncertainty)}=\\)",formatNumberForDisplay(combinedUncertaintyResult(),input)))
})

output$display_combinedUncertainty_finalAnswer_coverageFactor = renderUI({
  return(paste(formatNumberForDisplay(combinedUncertaintyResult(),input)))
})

output$display_combinedUncertainty_finalAnswer_expandedUncertainty = renderUI({
  return(paste(formatNumberForDisplay(combinedUncertaintyResult(),input)))
})