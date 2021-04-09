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


output$display_homogeneityTest_alphaValue = renderUI({
  return(paste(getHomogeneityTestAlphaValue_display()))
})

output$display_homogeneityTest_confidenceLevel = renderUI({
  return(paste(getHomogeneityTestConfidenceLevel()))
})

#Display values needed for calculations
output$display_homogeneityTest_parameters = renderUI({
  
  n = getHomogeneityNumOfValues()
  k = getHomogeneityNumCols()
  
  formulas = c(paste0("N &=", n))
  formulas = c(formulas, paste0("k &=", k))
  output = mathJaxAligned(formulas, 10)
  
  return(withMathJax(HTML(output)))
  
})

output$display_homogeneityTest_dof = renderUI({
  
  n = getHomogeneityNumOfValues()
  k = getHomogeneityNumCols()
  bdof = getHomogeneityTestBetweenDof()
  wdof = getHomogeneityTestWithinDof()
  
  formulas = c(paste0("{\\LARGE\\nu}_B &= k - 1"))
  formulas = c(formulas, paste0("&= ",k," - 1 = ", bdof))
  formulas = c(formulas, paste0("{\\LARGE\\nu}_W &= N - k"))
  formulas = c(formulas, paste0("&= ",n," - ",k," = ", wdof))
  output = mathJaxAligned(formulas, 10)
  
  return(withMathJax(HTML(output)))
  
})

output$display_homogeneityTest_fValue = renderUI({
  
  mssb = getHomogeneityMeanSumOfSquaresBetween()
  mssw = getHomogeneityMeanSumOfSquaresWithin()
  fValue = getHomogeneityFValue()
  
  formulas = c(paste0("F_{\\large s} &= \\frac{MSS_B}{MSS_W}"))
  formulas = c(formulas, paste0("&= \\frac{",mssb,"}{",mssw,"}"))
  formulas = c(formulas, paste0("&= ", fValue))
  
  output = mathJaxAligned(formulas, 10)
  return(withMathJax(HTML(output)))
  
})

output$display_homogeneity_fCritical = renderUI({
  
  alpha = getHomogeneityTestAlphaValue_display()
  bdof = getHomogeneityTestBetweenDof()
  wdof = getHomogeneityTestWithinDof()
  fCrit = getHomogeneityTestFCritical()
  
  formulas = c(paste0("F_{c} &= F_{{\\LARGE\\nu}_B,{\\LARGE\\nu}_W,\\alpha}"))
  formulas = c(formulas, paste0("&= F_{",bdof,",",wdof,",",alpha,"}"))
  formulas = c(formulas, paste0("&= ", fCrit))
  output = mathJaxAligned(formulas, 10)
  
  return(withMathJax(HTML(output)))
  
})

output$display_homogeneityTest_fDistribution = renderPlotly({

  #Get alpha value
  alpha = getHomogeneityTestAlphaValue_display()
  
  # Get degrees of freedom
  bDof = getHomogeneityTestBetweenDof()
  wDof = getHomogeneityTestWithinDof()
  
  # Get f values and get the max number to decide how far to show the graph
  fValue = getHomogeneityFValue_value()
  fCritical = getHomogeneityTestFCritical_value()
  maxNumber = max(fValue,fCritical)
  
  #Create the F Distribution curve from 0 to maxNumber length (+1/3 to look pretty)
  x = seq(0,maxNumber*1.33,length=200)
  y = df(x, df1 = bDof, df2 = wDof)
  data = data.frame(x, y)
  
  #Get the max height value as the second highest element in the array as sometimes it can be infinity
  maxHeight = unique(sort(data$y,decreasing = TRUE))[2]
  
  fCritHeight = maxHeight*0.75
  fValueHeight = maxHeight
  
  # initiate a line shape object
  lineObj <- list( type = "line", line = list(color = "red"), xref = "x", yref = "y")
  lineVal <- list( type = "line", line = list(color = "green"), xref = "x", yref = "y")
  lines <- list()
  
  #Create the F Critical value vertical line
  lineObj[["x0"]] = fCritical
  lineObj[["x1"]] = fCritical
  lineObj[c("y0", "y1")] = c(0,fCritHeight)
  lines = c(lines, list(lineObj))
  
  #Create the F Value vertical line
  lineVal[["x0"]] = fValue
  lineVal[["x1"]] = fValue
  lineVal[c("y0", "y1")] = c(0,fValueHeight)
  lines = c(lines, list(lineVal))
  
  #Create a dataframe for the shaded regions in the graph
  #Speically add the F Critical value to the data frame so the garphs line up correctly
  critVal = c(fCritical, df(fCritical, df1 = bDof, df2 = wDof))
  
  #only add values that are less thant the F Critical value for the acception regeion
  dataAccept = critVal
  dataAccept = rbind(data[x<fCritical,] , dataAccept)
  
  #only add values that are greater than the F Critical value for the requestion region
  dataCrit = data[x>fCritical,] 
  dataCrit = rbind(critVal, dataCrit)
  
  #Plot the F Distorbution
  fig = plot_ly(data)
  #Format the layout
  fig = layout(fig,
               title = '',
               shapes = lines,
               xaxis = list(title = "F Value"),
               yaxis = list(title = "Probability Density"))
  #Add the shaded Critical Region to the graph
  fig %>%
    add_trace(x=~dataAccept$x, y=~dataAccept$y, type = 'scatter', mode = 'lines', fill = 'tozeroy', line = list(color = "rgba(31, 119, 180,1)"), fillcolor='rgba(0, 0, 255,0.1)', name="Failed to Reject Region\n(\U2264 \U03B1)") %>% 
    add_trace(x=~dataCrit$x, y=~dataCrit$y, type = 'scatter', mode = 'lines', fill = 'tozeroy', line = list(color = "rgba(255, 0, 0,0.7)"), fillcolor='rgba(255, 0, 0,0.6)', name="Rejection Region\n(> \U03B1)") %>% 
    add_annotations(
      x= fCritical,
      y= fCritHeight-0.05,
      xref = "x",
      yref = "y",
      text = paste0("F critical (",formatNumberForDisplay(fCritical,input),")\n \U03B1 = ",alpha),
      showarrow = T,
      ax = 70,
      ay = -30
    ) %>% 
    add_annotations(
      x= fValue,
      y= fValueHeight-0.05,
      xref = "x",
      yref = "y",
      text = paste0("F statistic (",formatNumberForDisplay(fValue,input),")"),
      showarrow = T,
      ax = 80,
      ay = -30
    )
})

output$display_homogeneityTest_answerTop = renderUI({
  return(renderHomogeneityTestResult())
})

output$display_homogeneityTest_answerMiddle = renderUI({
  return(renderHomogeneityTestAnswer())
})

output$display_homogeneityTest_answerBottom = renderUI({
  return(renderHomogeneityTestAnswer())
})

output$display_homogeneityTest_answerDashboard = renderUI({
  return(renderHomogeneityTestResult())
})

renderHomogeneityTestAnswer = function()
{
  fValue = getHomogeneityFValue()
  fCritical = getHomogeneityTestFCritical()
  
  if(getHomogeneityTestPass())
  {
    return(valueBox("Result", HTML(paste0("<p>For the data supplied, the F statistic is less than or equal to the F critical, therefore we <strong>fail to reject the null hypothosis of equality</strong> and conclude that samples are homogeneous.</p>",renderHomogeneityTestResult(TRUE))), width = 12, color = "green", icon = icon("check-circle")))
  }
  else
  {
    return(valueBox("Result", HTML(paste0("<p>For the data supplied, the F statistic is greater than F critical, therefore we <strong>reject the null hypothosis of equality</strong> and conclude that samples are not homogeneous.</p>",renderHomogeneityTestResult(TRUE))), width = 12, color = "red", icon = icon("times-circle")))
  }
}

renderHomogeneityTestResult = function(displayWithColours = FALSE)
{
  alpha = getHomogeneityTestAlphaValue_display()
  bDof = getHomogeneityTestBetweenDof()
  wDof = getHomogeneityTestWithinDof()
  
  fValue = ""
  fCritical = ""
  if(displayWithColours)
  {
    fValue = getHomogeneityFValue()
    fCritical = getHomogeneityTestFCritical()
  } else {
    fValue = formatNumberForDisplay(getHomogeneityFValue_value(), input)
    fCritical = formatNumberForDisplay(getHomogeneityTestFCritical_value(), input)
  }
  result = getHomogeneityTestPass_text()
  
  equalitySign = ""
  hTestPass = getHomogeneityTestPass()
  if(is.na(hTestPass)){
    return(paste(NA))
  }else if(hTestPass) {
    equalitySign = "\\leq"
  } else {
    equalitySign = ">"
  }
    
  formula = paste0("\\(F_{\\large s} (",fValue,")",equalitySign," F_{",bDof,",",wDof,",",alpha,"} (",fCritical,")  \\implies \\) ", result)

  return(formula)
}