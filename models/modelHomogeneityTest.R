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

#Display values needed for calculations
output$display_homogeneityTest_parameters = renderUI({
  
  n = getHomogeneityNumOfValues()
  k = getHomogeneityNumCols()
  
  formulas = c(paste0("\\text{n} &=", n))
  formulas = c(formulas, paste0("\\text{k} &=", k))
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
  formulas = c(formulas, paste0("{\\LARGE\\nu}_W &= n - k"))
  formulas = c(formulas, paste0("&= ",n," - ",k," = ", wdof))
  output = mathJaxAligned(formulas, 10)
  
  return(withMathJax(HTML(output)))
  
})

output$display_homogeneityTest_fValue = renderUI({
  
  mssb = getHomogeneityMeanSumOfSquaresBetween()
  mssw = getHomogeneityMeanSumOfSquaresWithin()
  fValue = getHomogeneityFValue()
  
  formulas = c(paste0("F_v &= \\frac{MSS_B}{MSS_W}"))
  formulas = c(formulas, paste0("&= \\frac{",mssb,"}{",mssw,"}"))
  formulas = c(formulas, paste0("&= ", fValue))
  
  output = mathJaxAligned(formulas, 10)
  return(withMathJax(HTML(output)))
  
})


output$display_homogeneity_fCritical = renderUI({
  
  bdof = getHomogeneityTestBetweenDof()
  wdof = getHomogeneityTestWithinDof()
  fCrit = getHomogeneityTestFCritical()
  
  formulas = c(paste0("\\text{F}_{c} &= \\text{F}_{{\\LARGE\\nu}_B,{\\LARGE\\nu}_W,\\alpha}"))
  formulas = c(formulas, paste0("&= \\text{F}_{",bdof,",",wdof,",\\alpha}"))
  formulas = c(formulas, paste0("&= ", fCrit))
  output = mathJaxAligned(formulas, 10)
  
  return(withMathJax(HTML(output)))
  
})


output$display_homogeneityTest_fDistribution = renderPlotly({
  
  bDof = getHomogeneityTestBetweenDof()
  wDof = getHomogeneityTestWithinDof()
  
  fValue = getHomogeneityFValue_value()
  fCritical = getHomogeneityTestFCritical_value()
  maxNumber = max(fValue,fCritical)
  
  # initiate a line shape object
  lineObj <- list(
    type = "line",
    line = list(color = "red"),
    xref = "x",
    yref = "y"
  )
  lineVal <- list(
    type = "line",
    line = list(color = "green"),
    xref = "x",
    yref = "y"
  )
  lines <- list()
  
  lineObj[["x0"]] = fCritical
  lineObj[["x1"]] = fCritical
  lineObj[c("y0", "y1")] = c(0,0.5)
  lines = c(lines, list(lineObj))
  
  lineVal[["x0"]] = fValue
  lineVal[["x1"]] = fValue
  lineVal[c("y0", "y1")] = c(0,0.25)
  lines = c(lines, list(lineVal))
  
  x = seq(0,maxNumber+0.5,length=100)
  y = df(x, df1 = bDof, df2 = wDof)
  data = data.frame(x, y)
  
  critVal = c(fCritical, df(fCritical, df1 = bDof, df2 = wDof))
  dataCrit = data[x>fCritical,]
  dataCrit = rbind(critVal, dataCrit)

  fig = plot_ly(data, x=~x, y=~y, type = 'scatter', mode = 'lines')
  fig = layout(fig, title = 'F Critical', shapes = lines)
  fig %>% add_trace(x=~dataCrit$x, y=~dataCrit$y, type = 'scatter', mode = 'none', fill = 'tozeroy')
})