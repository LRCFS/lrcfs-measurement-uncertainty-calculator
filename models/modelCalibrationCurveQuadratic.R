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
output$display_calibrationCurveQuadratic_replicates = renderUI({
  string = paste(input$inputCaseSampleReplicates)
  return(string)
})

output$display_calibrationCurveQuadratic_meanConcentration = renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_calibrationcurveQuadratic_rawData = DT::renderDataTable(
  getDataCalibrationCurve(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)

output$display_calibrationcurveQuadratic_rawDataGraph = renderPlotly({
  data = getDataCalibrationCurveReformatted()
  x = data$calibrationDataConcentration
  y = data$calibrationDataPeakArea
  
  plot_ly(x = x, y = y, name='Peak Area Ratios', type = 'scatter', mode='markers') %>%
    layout(xaxis = list(title="Concentration"), yaxis = list(title="Peak Area Ratio"))
})

output$display_calibrationcurveQuadratic_rearrangedData = DT::renderDataTable(
  sapply(getDataCalibrationCurveQuadratic_rearranged(), function(x) formatNumberForDisplay(x, input)),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip', columnDefs = list(list(className = 'dt-right', targets = 0:5)))
)

output$display_calibrationcurveQuadratic_quadraticRegression = renderUI({
  
  interceptB0 = getCalibrationCurveQuadratic_intercept()
  slopeB1 = getCalibrationCurveQuadratic_slopeB1()
  slopeB2 = getCalibrationCurveQuadratic_slopeB2()
  rSquaredAdjusted = getCalibrationCurveQuadratic_rSquaredAdjusted()
  n = getCalibrationCurve_n()
  
  formulas = c(paste0("\\text{Intercept}(b_0) &=",interceptB0))
  formulas = c(formulas, paste0("\\text{Slope}(b_1) &= ", slopeB1))
  formulas = c(formulas, paste0("\\text{Slope}(b_2) &= ", slopeB2))
  formulas = c(formulas, paste0("R^2_{\\text{adj}} &=",rSquaredAdjusted))
  formulas = c(formulas, paste0("n &= ",n))
  output = mathJaxAligned(formulas, 10, 50)
  
  return(withMathJax(HTML(output)))
  
})

