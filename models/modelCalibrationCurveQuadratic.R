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

output$display_calibrationCurveQuadratic_meanPeakAreaRatio = renderUI({
  string = paste(input$inputCaseSampleMeanPeakAreaRatio)
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
  
  interceptB0 = getCalibrationCurveQuadratic_intercept()
  slopeB1 = getCalibrationCurveQuadratic_slopeB1()
  slopeB2 = getCalibrationCurveQuadratic_slopeB2()
  regression = getCalibrationCurveQuadratic_regression()
  
  plot_ly(x = x, y = y, name='Peak Area Ratios', type = 'scatter', mode='markers') %>%
    add_lines(x = x, y = fitted(regression), name="Calibration Curve") %>%
    layout(xaxis = list(title="Concentration"), yaxis = list(title="Peak Area Ratio")) %>%
    add_annotations(x= 0.5,y= 0.8,xref="paper",yref="paper",text=paste0("y = ",interceptB0,"+",slopeB1,"x+",slopeB2,"x^2"),showarrow = F)   
})

output$display_calibrationcurveQuadratic_rearrangedData = DT::renderDataTable(
  sapply(getDataCalibrationCurveQuadratic_rearranged(), function(x) formatNumberForDisplay(x, input)),
  container = htmltools::withTags(table(
    tableHeader(colnames(getDataCalibrationCurveQuadratic_rearranged())),
    tfoot(
      tr(
        th(),
        th(paste("\\(\\sum{x} = ",getCalibrationCurveQuadratic_sumOfX(),"\\)")),
        th(paste("\\(\\sum{y} = ",getCalibrationCurveQuadratic_sumOfY(),"\\)")),
        th(paste("\\(\\sum{x^2} = ",getCalibrationCurveQuadratic_sumOfXSquared(),"\\)")),
        th(),
        th(paste("\\(\\sum{(y-\\hat{y})^2} = ",getCalibrationCurveQuadratic_sumOfResiduals(),"\\)"))
      ),
      tr(
        th(class="noBorderAbove"),
        th(class="noBorderAbove", paste("\\(\\overline{x} = \\frac{\\sum{x}}{",getCalibrationCurve_n(),"} = ",getCalibrationCurveQuadratic_meanOfX()," \\)")),
        th(class="noBorderAbove",paste("\\(\\overline{y} = \\frac{\\sum{y}}{",getCalibrationCurve_n(),"} = ",getCalibrationCurveQuadratic_meanOfY()," \\)")),
        th(class="noBorderAbove",paste("\\(\\overline{x^2} = \\frac{\\sum{x^2}}{",getCalibrationCurve_n(),"} = ",getCalibrationCurveQuadratic_meanOfXSquared()," \\)")),
        th(class="noBorderAbove"),
        th(class="noBorderAbove")
      )
    )
  )),
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

output$display_calibrationCurveQuadratic_standardErrorOfRegression  = renderUI({
  
  sumOfResiduals = getCalibrationCurveQuadratic_sumOfResiduals()
  n = getCalibrationCurve_n()
  answer = getCalibrationCurveQuadratic_standardErrorOfRegression()
  
  formulas = c(paste("S_{y/x} &= \\sqrt{\\frac{\\sum\\limits_{i=1}^n (y_i-\\hat{y}_i)^2}{n-3}}","[[break]]"))
  formulas = c(formulas, paste("S_{y/x} &= \\sqrt{\\frac{",sumOfResiduals,"}{",n,"-3}}"))
  formulas = c(formulas, paste("&=",answer))
  output = mathJaxAligned(formulas, 5, 20)
  return(withMathJax(HTML(output)))
  
})

output$display_calibrationCurveQuadratic_designMatrix = renderUI({
  return(withMathJax(getCalibrationCurveQuadratic_renderLatexDesignMatrix()))
})

output$display_calibrationCurveQuadratic_designMatrixTransposed = renderUI({
  return(withMathJax(getCalibrationCurveQuadratic_renderLatexDesignMatrixTransposed()))
})

output$display_calibrationCurveQuadratic_designMatrixMultiply = renderUI({
  return(withMathJax(getCalibrationCurveQuadratic_renderDesignMatrixMultiply()))
})

output$display_calibrationCurveQuadratic_designMatrixMultiplyInverse = renderUI({
  return(withMathJax(getCalibrationCurveQuadratic_renderDesignMatrixMultiplyInverse()))
})

output$display_calibrationCurveQuadratic_covarianceMatrix = renderUI({
  return(withMathJax(getCalibrationCurveQuadratic_renderCovarianceMatrix()))
})

output$display_calibrationCurveQuadratic_discriminant = renderUI({
  interceptB0 = getCalibrationCurveQuadratic_intercept()
  slopeB1 = getCalibrationCurveQuadratic_slopeB1()
  slopeB2 = getCalibrationCurveQuadratic_slopeB2()
  yS = input$inputCaseSampleMeanPeakAreaRatio
  meanX = getCalibrationCurveQuadratic_meanOfX()
  meanXs = getCalibrationCurveQuadratic_meanOfXSquared()
  meanY = getCalibrationCurveQuadratic_meanOfY()
  answer = getCalibrationCurveQuadratic_discriminant()
  
  formulas = c(paste("D &= b_1^2 - 4b_2(\\overline{y} - y_s - b_1\\overline{x}-b_2\\overline{x^2})"))
  formulas = c(formulas, paste("D &= ",slopeB1,"^2 - 4 \\times",slopeB2,"(",meanY," - ",yS," - ",slopeB1,"\\times",meanX,"-",slopeB2,"\\times",meanXs,")"))
  formulas = c(formulas, paste("&=",answer))
  output = mathJaxAligned(formulas, 5, 20)
  return(withMathJax(HTML(output)))
})