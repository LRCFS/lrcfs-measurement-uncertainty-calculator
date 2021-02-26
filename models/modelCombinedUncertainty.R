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
  
  result = get_combinedUncertainty_finalAnswer(meanConcentration, uncHomogeneity, uncCalibrationCurve, uncMethodPrecision, uncStandardSolution, uncSamplePreparation)
  return(result)
})

###################################################################################
# Outputs
###################################################################################

output$display_combinedUncertainty_uncertaintyBudget <- renderPlotly({
  data = data.frame("Homogeneity" = getHomogeneity_relativeStandardUncertainty_value(),  "CalibrationCurve" = getResultCalibrationCurve(), "MethodPrecision" = methodPrecisionResult(), "StandardSolution" = standardSolutionResult(), "SamplePreparation" = getResultSamplePreparation())
  data = removeEmptyData(data)
  
  percentages = data/sum(data) * 100
  percentagesMelt = melt(percentages)
  
  dataMelt = melt(data)
  dataGraphReady = data.frame(uncertaintyComponent = dataMelt$variable, rsu = formatNumberForDisplay(dataMelt$value,input), percentage = round(percentagesMelt$value))
  
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
    else if(colname == "StandardSolution")
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
  
  
  # data = data.frame("CombinedUncertainty" = combinedUncertaintyResult(), "Homogeneity" = getHomogeneity_relativeStandardUncertainty_value(),  "CalibrationCurve" = getResultCalibrationCurve(), "MethodPrecision" = methodPrecisionResult(), "StandardSolution" = standardSolutionResult(), "SamplePreparation" = getResultSamplePreparation())
  # data = removeEmptyData(data)
  # 
  # percentages = data/sum(data) * 100
  # percentagesMelt = melt(percentages)
  # 
  # dataMelt = melt(data)
  # dataGraphReady = data.frame(uncertaintyComponent = dataMelt$variable, rsu = formatNumberForDisplay(dataMelt$value,input), percent = paste(round(percentagesMelt$value),"%"))
  # 
  # colors = c(CombinedUncertaintyColor)
  # for(colname in colnames(data))
  # {
  #   if(colname == "Homogeneity")
  #   {
  #     colors = c(colors, HomogeneityColor)
  #   }
  #   else if(colname == "CalibrationCurve")
  #   {
  #     colors = c(colors, CalibrationCurveColor)
  #   }
  #   else if(colname == "MethodPrecision")
  #   {
  #     colors = c(colors, MethodPrecisionColor)
  #   }
  #   else if(colname == "StandardSolution")
  #   {
  #     colors = c(colors, StandardSolutionColor)
  #   }
  #   else if(colname == "SamplePreparation")
  #   {
  #     colors = c(colors, SamplePreparationColor)
  #   }
  # }
  # 
  # plot_ly(dataGraphReady, x = ~rsu, y = ~uncertaintyComponent, text = ~rsu, textposition="auto", name='Uncertainty Budget', type = 'bar', orientation = 'h',
  #         marker = list(color = colors)) %>%
  #   layout(xaxis = list(title = "RSU"), yaxis = list(title = "", autorange="reversed"))
})

output$display_combinedUncertainty_meanConcentration <- renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_combinedUncertainty_finalAnswer_top = renderText({
  answer = formatNumberForDisplay(combinedUncertaintyResult(), input)
  return(paste("\\(\\text{CombUncertainty}=\\)",answer))
})
  
output$display_combinedUncertainty_finalAnswer_bottom = renderUI({
  ho = getHomogeneity_relativeStandardUncertainty()
  cc = formatNumberForDisplay(getResultCalibrationCurve(),input)
  mp = formatNumberForDisplay(methodPrecisionResult(),input)
  ss = formatNumberForDisplay(standardSolutionResult(),input)
  sv = formatNumberForDisplay(getResultSamplePreparation(),input)
  
  formula = c("\\text{CombUncertainty} &= x_s \\sqrt{\\sum{u_r\\text{(Individual Uncertainty Component)}^2}} [[break]]")
  formula = c(formula, "\\text{CombUncertainty} &= x_s \\sqrt{u_r(\\text{Homogeneity})^2 + u_r(\\text{CalCurve})^2 + u_r(\\text{MethodPrec})^2 + u_r(\\text{StdSolution})^2 + u_r(\\text{SamplePreparation})^2}")
  formula = c(formula, paste("&= ",ColourCaseSampleMeanConcentration(input$inputCaseSampleMeanConcentration),"\\sqrt{",colourNumberBackground(ho, HomogeneityColor, "#FFF"),"^2+",colourNumberBackground(cc, CalibrationCurveColor, "#FFF"),"^2+",colourNumberBackground(mp, MethodPrecisionColor, "#FFF"),"^2+",colourNumberBackground(ss, StandardSolutionColor, "#FFF"),"^2+",colourNumberBackground(sv, SamplePreparationColor, "#FFF"),"^2}"))
  formula = c(formula, paste("&= ",formatNumberForDisplay(combinedUncertaintyResult(),input)))
  output = mathJaxAligned(formula, 5, 20)
  
  return(withMathJax(HTML(output)))
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

###################################################################################
# Helper Methods
###################################################################################
get_combinedUncertainty_finalAnswer = function(meanConcentration, uncHomogeneity, uncCalibrationCurve, uncMethodPrecision, uncStandardSolution, uncSamplePreparation)
{
  sumUncertainties = sum(uncHomogeneity^2, uncCalibrationCurve^2,uncMethodPrecision^2,uncStandardSolution^2,uncSamplePreparation^2, na.rm = TRUE)
  answer = meanConcentration * sqrt(sumUncertainties)
  return(answer)
}