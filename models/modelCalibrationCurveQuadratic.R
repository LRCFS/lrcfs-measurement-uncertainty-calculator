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
  
  interceptB0 = formatNumberForDisplay(getCalibrationCurveQuadratic_intercept_value(),input)
  slopeB1 = formatNumberForDisplay(getCalibrationCurveQuadratic_slopeB1_value(),input)
  slopeB2 = formatNumberForDisplay(getCalibrationCurveQuadratic_slopeB2_value(),input)
  regression = getCalibrationCurveQuadratic_regression()
  
  caseSampleMeanConcentration = input$inputCaseSampleMeanConcentration
  caseSampleMeanPeakAreaRatio = input$inputCaseSampleMeanPeakAreaRatio
  
  plot_ly(x = x, y = y, name='Peak Area Ratios', type = 'scatter', mode='markers') %>%
    add_lines(x = x, y = fitted(regression), name="Calibration Curve", line=list(color="#00B080")) %>%
    add_trace(x = c(caseSampleMeanConcentration,caseSampleMeanConcentration), y = c(0,caseSampleMeanPeakAreaRatio), name="Case Sample Mean Concentration", mode = "lines", line=list(color=caseSampleMeanConcentrationColour)) %>%
    add_trace(x = c(0,caseSampleMeanConcentration), y = c(caseSampleMeanPeakAreaRatio,caseSampleMeanPeakAreaRatio), name="Case Sample Mean Peak Area Ratio", mode = "lines", line=list(color=caseSampleMeanParColour)) %>%
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
        th(class="noBorderAbove", paste("\\(\\overline{x} = \\frac{\\sum{x}}{",getCalibrationCurveQuadratic_n(),"} = ",getCalibrationCurveQuadratic_meanOfX()," \\)")),
        th(class="noBorderAbove",paste("\\(\\overline{y} = \\frac{\\sum{y}}{",getCalibrationCurveQuadratic_n(),"} = ",getCalibrationCurveQuadratic_meanOfY()," \\)")),
        th(class="noBorderAbove",paste("\\(\\overline{x^2} = \\frac{\\sum{x^2}}{",getCalibrationCurveQuadratic_n(),"} = ",getCalibrationCurveQuadratic_meanOfXSquared()," \\)")),
        th(class="noBorderAbove"),
        th(class="noBorderAbove")
      )
    )
  )),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip', columnDefs = list(list(className = 'dt-right', targets = 0:5)))
)

#_renderer functions typically are used by both the web application and the report.Rmd files
display_calibrationcurveQuadratic_quadraticRegression_renderer = function(removeColours = FALSE){
  
  if(is.null(getDataCalibrationCurve())) return(NA)
  
  interceptB0 = getCalibrationCurveQuadratic_intercept()
  slopeB1 = getCalibrationCurveQuadratic_slopeB1()
  slopeB2 = getCalibrationCurveQuadratic_slopeB2()
  rSquaredAdjusted = getCalibrationCurveQuadratic_rSquaredAdjusted()
  n = getCalibrationCurveQuadratic_n()
  
  formulas = c(paste0("\\text{Intercept}(b_0) &=",interceptB0))
  formulas = c(formulas, paste0("\\text{Slope}(b_1) &= ", slopeB1))
  formulas = c(formulas, paste0("\\text{Slope}(b_2) &= ", slopeB2))
  formulas = c(formulas, paste0("R^2_{\\text{adj}} &=",rSquaredAdjusted))
  formulas = c(formulas, paste0("n &= ",n))
  output = mathJaxAligned(formulas, 10, 50, removeColours)
  
  return(withMathJax(HTML(output)))
}

output$display_calibrationcurveQuadratic_quadraticRegression = renderUI({
  return(display_calibrationcurveQuadratic_quadraticRegression_renderer())
})

output$display_calibrationCurveQuadratic_standardErrorOfRegression = renderUI({
  
  sumOfResiduals = getCalibrationCurveQuadratic_sumOfResiduals()
  n = getCalibrationCurveQuadratic_n()
  answer = getCalibrationCurveQuadratic_standardErrorOfRegression()
  
  formulas = c("S_{y/x} &= \\sqrt{\\frac{\\sum\\limits_{i=1}^n (y_i-\\hat{y}_i)^2}{n-3}}","[[break]]")
  formulas = c(formulas, paste("S_{y/x} &= \\sqrt{\\frac{",sumOfResiduals,"}{",n,"-3}}"))
  formulas = c(formulas, paste("&=",answer))
  output = mathJaxAligned(formulas, 5, 20)
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurveQuadratic_variancePeakAreaRatio = renderUI({
  
  standardErrorOfRegression = getCalibrationCurveQuadratic_standardErrorOfRegression()
  r_s = ColourCaseSampleReplicates(input$inputCaseSampleReplicates,input$useColours)
  answer = getCalibrationCurveQuadratic_variancePeakAreaRatio()
  
  formulas = c("Var(y_s) &= \\frac{S_{y/x}^2}{r_s}")
  formulas = c(formulas, paste("&= \\frac{",standardErrorOfRegression,"^2}{",r_s,"}"))
  formulas = c(formulas, paste("&=",answer))
  output = mathJaxAligned(formulas, 5)
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurveQuadratic_varianceMeanOfY = renderUI({
  
  standardErrorOfRegression = getCalibrationCurveQuadratic_standardErrorOfRegression()
  n = getCalibrationCurveQuadratic_n()
  answer = getCalibrationCurveQuadratic_varianceMeanOfY()
  
  formulas = c("Var(\\overline{y}) &= \\frac{S_{y/x}^2}{n}")
  formulas = c(formulas, paste("&= \\frac{",standardErrorOfRegression,"^2}{",n,"}"))
  formulas = c(formulas, paste("&=",answer))
  output = mathJaxAligned(formulas, 5)
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

#Renderer function that can be used by both the web/shiny application and the report.Rmd renderer
display_calibrationCurveQuadratic_covarianceMatrix_renderer = function(removeColours = FALSE)
{
  covarianceMatrix = getCalibrationCurveQuadratic_covarianceMatrix()
  
  matrixMultipler = "\\sigma^2(\\underline{X}^T\\underline{X})^{-1} &= 
  \\begin{Bmatrix}
  Var(b_0) & Cov(b_0,b_1) & Cov(b_0,b_2) \\\\
  Cov(b_0,b_1) & Var(b_1) & Cov(b_1,b_2) \\\\
  Cov(b_0,b_2) & Cov(b_1,b_2) & Var(b_2) \\\\
  \\end{Bmatrix}[[break]]"
  
  formulas = c(matrixMultipler)
  formulas = c(formulas, paste("S_{y/x}^2 (\\underline{X}^T \\underline{X})^{-1} &= ", covarianceMatrix))
  output = mathJaxAligned(formulas, 5, 30, removeColours)
  
  return(withMathJax(HTML(output)))
}

output$display_calibrationCurveQuadratic_covarianceMatrix = renderUI({
  return(display_calibrationCurveQuadratic_covarianceMatrix_renderer())
})

output$display_calibrationCurveQuadratic_discriminant = renderUI({
  
  interceptB0 = getCalibrationCurveQuadratic_intercept()
  slopeB1 = getCalibrationCurveQuadratic_slopeB1()
  slopeB2 = getCalibrationCurveQuadratic_slopeB2()
  yS = ColourCaseSampleMeanPeakAreaRatio(input$inputCaseSampleMeanPeakAreaRatio,input$useColours)
  meanX = getCalibrationCurveQuadratic_meanOfX()
  meanXs = getCalibrationCurveQuadratic_meanOfXSquared()
  meanY = getCalibrationCurveQuadratic_meanOfY()
  discriminant = getCalibrationCurveQuadratic_discriminant()
  
  formulas = c("D &= b_1^2 - 4b_2(\\overline{y} - y_s - b_1\\overline{x}-b_2\\overline{x^2})")
  formulas = c(formulas, paste("D &= ",slopeB1,"^2 - 4 \\times",slopeB2,"(",meanY," - ",yS," - ",slopeB1,"\\times",meanX,"-",slopeB2,"\\times",meanXs,")"))
  formulas = c(formulas, paste("&=",discriminant))
  output = mathJaxAligned(formulas, 5, 20)
  return(withMathJax(HTML(output)))
})

output$display_calibrationCurveQuadratic_partialDerivativeSlope1 = renderUI({
  
  discriminant = getCalibrationCurveQuadratic_discriminant()
  slopeB1 = getCalibrationCurveQuadratic_slopeB1()
  slopeB2 = getCalibrationCurveQuadratic_slopeB2()
  meanX = getCalibrationCurveQuadratic_meanOfX()
  answer = getCalibrationCurveQuadratic_partialDerivativeSlope1()
  
  formulas = c("\\frac{\\partial \\hat{x_s}}{\\partial b_1} &= \\frac{-1 + \\frac{1}{2} D^{-1/2}(2b_1+4b_2\\overline{x})}{2b_2}")
  formulas = c(formulas, paste("&= \\frac{-1 + \\frac{1}{2} ",discriminant,"^{-1/2}(2 \\times",slopeB1,"+4\\times",slopeB2,"\\times",meanX,")}{2\\times",slopeB2,"}"))
  formulas = c(formulas, paste("&=",answer))
  output = mathJaxAligned(formulas, 5, 20)
  return(withMathJax(HTML(output)))
})


output$display_calibrationCurveQuadratic_partialDerivativeSlope2 = renderUI({
  
  discriminant = getCalibrationCurveQuadratic_discriminant()
  b_1 = getCalibrationCurveQuadratic_slopeB1()
  b_2 = getCalibrationCurveQuadratic_slopeB2()
  meanX = getCalibrationCurveQuadratic_meanOfX()
  meanY = getCalibrationCurveQuadratic_meanOfY()
  meanXs = getCalibrationCurveQuadratic_meanOfXSquared()
  y_s = ColourCaseSampleMeanPeakAreaRatio(input$inputCaseSampleMeanPeakAreaRatio,input$useColours)
  answer = getCalibrationCurveQuadratic_partialDerivativeSlope2()
  
  formulas = c("\\frac{\\partial \\hat{x_s}}{\\partial b_2} &= \\frac{b_1-D^{1/2}}{2b_2^2} + \\frac{\\frac{1}{2}D^{-1/2}(4y_s - 4\\overline{y} + 4b_1\\overline{x}+8b_2\\overline{x^2})}{2b_2}")
  formulas = c(formulas, paste("&= \\frac{",b_1,"-",discriminant,"^{1/2}}{2\\times",b_2,"^2} + \\frac{\\frac{1}{2}",discriminant,"^{-1/2}(4\\times",y_s," - 4\\times",meanY," + 4\\times",b_1,"\\times",meanX,"+8\\times",b_2,"\\times",meanXs,")}{2\\times",b_2,"}"))
  formulas = c(formulas, paste("&=",answer))
  output = mathJaxAligned(formulas, 5, 20)
  return(withMathJax(HTML(output)))
  
})

output$display_calibrationCurveQuadratic_partialDerivativeMeanOfY = renderUI({
  
  discriminant = getCalibrationCurveQuadratic_discriminant()
  answer = getCalibrationCurveQuadratic_partialDerivativeMeanOfY()
  
  formulas = c("\\frac{\\partial \\hat{x_s}}{\\partial \\overline{y}} &= -D^{-1/2}")
  formulas = c(formulas, paste("&= -",discriminant,"^{-1/2}"))
  formulas = c(formulas, paste("&=",answer))
  output = mathJaxAligned(formulas, 5, 20)
  return(withMathJax(HTML(output)))
  
})

output$display_calibrationCurveQuadratic_partialDerivativeCaseSampleMeanPeakAreaRatio = renderUI({
  
  discriminant = getCalibrationCurveQuadratic_discriminant()
  answer = getCalibrationCurveQuadratic_partialDerivativeCaseSampleMeanPeakAreaRatio()
  
  formulas = c(paste("\\frac{\\partial \\hat{x_s}}{\\partial y_s} &= D^{-1/2}"))
  formulas = c(formulas, paste("&= ",discriminant,"^{-1/2}"))
  formulas = c(formulas, paste("&=",answer))
  output = mathJaxAligned(formulas, 5, 20)
  return(withMathJax(HTML(output)))
  
})

#Renderer function that can be used by both the web/shiny application and the report.Rmd renderer
display_calibrationCurveQuadratic_uncertaintyOfCalibration_renderer = function(removeColours = FALSE)
{
  partialDerivativeSlope1 = getCalibrationCurveQuadratic_partialDerivativeSlope1()
  partialDerivativeSlope2 = getCalibrationCurveQuadratic_partialDerivativeSlope2()
  partialDerivativeMeanOfY = getCalibrationCurveQuadratic_partialDerivativeMeanOfY()
  partialDerivativeCaseSampleMeanPeakAreaRatio = getCalibrationCurveQuadratic_partialDerivativeCaseSampleMeanPeakAreaRatio()
  
  varianceOfSlope1 = getCalibrationCurveQuadratic_varianceOfSlope1()
  varianceOfSlope2 = getCalibrationCurveQuadratic_varianceOfSlope2()
  varianceMeanOfY = getCalibrationCurveQuadratic_varianceMeanOfY()
  variancePeakAreaRatio = getCalibrationCurveQuadratic_variancePeakAreaRatio()
  covarianceOfSlope1and2 = getCalibrationCurveQuadratic_covarianceOfSlope1and2()
  
  uncertaintyOfCalibrationSquared = getCalibrationCurveQuadratic_uncertaintyOfCalibrationSquared()
  uncertaintyOfCalibration = getCalibrationCurveQuadratic_uncertaintyOfCalibration()
  
  formulas = c("
               u\\text{(CalCurve)}^2 &=
               \\left(\\frac{\\partial \\hat{x_s}}{\\partial b_1}\\right)^2 Var(b_1) +
               \\left(\\frac{\\partial \\hat{x_s}}{\\partial b_2}\\right)^2 Var(b_2) +
               \\left(\\frac{\\partial \\hat{x_s}}{\\partial \\overline{y}}\\right)^2 Var(\\overline{y}) +
               \\left(\\frac{\\partial \\hat{x_s}}{\\partial y_s}\\right)^2 Var(y_s) +
               2\\left(\\frac{\\partial \\hat{x_s}}{\\partial b_1}\\right) \\left(\\frac{\\partial \\hat{x_s}}{\\partial b_2}\\right) Cov(b_1,b_2)
               ")
  formulas = c(formulas, paste("&=
                                 \\left(",partialDerivativeSlope1,"\\right)^2 \\times ",varianceOfSlope1," +
                                 \\left(",partialDerivativeSlope2,"\\right)^2 \\times ",varianceOfSlope2," +
                                 \\left(",partialDerivativeMeanOfY,"\\right)^2 \\times ",varianceMeanOfY," + \\\\ &
                                 \\hspace{1.5em}\\left(",partialDerivativeCaseSampleMeanPeakAreaRatio,"\\right)^2 \\times ",variancePeakAreaRatio," +
                                 2\\left(",partialDerivativeSlope1,"\\right) \\left(",partialDerivativeSlope2,"\\right) \\times ",covarianceOfSlope1and2
  ))
  formulas = c(formulas, paste("&=",uncertaintyOfCalibrationSquared,"[[break]]"))
  formulas = c(formulas, paste("u\\text{(CalCurve)} &= \\sqrt{",uncertaintyOfCalibrationSquared,"}"))
  formulas = c(formulas, paste("&= ",uncertaintyOfCalibration))
  output = mathJaxAligned(formulas, 10, 20, removeColours)
  return(withMathJax(HTML(output)))
}

output$display_calibrationCurveQuadratic_uncertaintyOfCalibration = renderUI({
  return(display_calibrationCurveQuadratic_uncertaintyOfCalibration_renderer())
})

output$display_calibrationCurveQuadratic_finalAnswer_top = renderText({
  answer = formatNumberForDisplay(getResultCalibrationCurve(), input)
  return(paste("\\(u_r\\text{(CalCurve)}=\\)",answer))
})

#Renderer function that can be used by both the web/shiny application and the report.Rmd renderer
display_calibrationCurveQuadratic_finalAnswer_bottom_renderer = function(removeColours = FALSE){
  
  uncertaintyOfCalibration = getCalibrationCurveQuadratic_uncertaintyOfCalibration()
  caseSampleMeanConcentration = ColourCaseSampleMeanConcentration(input$inputCaseSampleMeanConcentration,input$useColours)
  relativeStandardUncertaintyOfCalibration = getCalibrationCurveQuadratic_relativeStandardUncertaintyOfCalibration()
  
  formulas = c(paste("u_r\\text{(CalCurve)} &= \\frac{u\\text{(CalCurve)}}{x_s}"))
  formulas = c(formulas, paste("&= \\frac{",uncertaintyOfCalibration,"}{",caseSampleMeanConcentration,"}"))
  formulas = c(formulas, paste("&= ",relativeStandardUncertaintyOfCalibration))
  output = mathJaxAligned(formulas, 5, 20, removeColours)
  return(withMathJax(HTML(output)))
}

output$display_calibrationCurveQuadratic_finalAnswer_bottom = renderUI({
  return(display_calibrationCurveQuadratic_finalAnswer_bottom_renderer())
})

