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

#Display input data
output$display_homogeneity_rawDataTable = DT::renderDataTable(
  getDataHomogeneity(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)

#Display a graph of the raw data as a box plot
output$display_homogeneity_rawDataGraph <- renderPlotly({
  data = getDataHomogeneity()
  if(is.null(data)) return(NA)
  
  replicateNames = colnames(data);
  
  plotlyPlot = plot_ly(data, name='Peak Area Ratios', type = 'box') %>%
    layout(xaxis = list(title="Group"), yaxis = list(title="Value"))
  
  for(replicateName in replicateNames)
  {
    plotlyPlot = plotlyPlot %>% add_trace(y = as.formula(paste0("~", replicateName)), name=sprintf("%s", replicateName))
  }
  
  return(plotlyPlot)
})

#Display homogeneity calcs
output$display_homogeneity_calcsTable3 = DT::renderDataTable(
  sapply(getDataHomogeneity(), function(x) formatNumberForDisplay(x, input)),
  container = htmltools::withTags(table(
    #tableHeader(colnames(getDataHomogeneity())),
    tableHeader(paste0(colnames(getDataHomogeneity()),"\\((X_{i",rep(1:getHomogeneityNumCols_value()),"})\\)")),
    tableFooter(NULL),
    tfoot(
      tr(
        lapply(paste("\\(n_{",rep(1:getHomogeneityNumCols_value()),"}=\\)",getHomogeneityNumWithin()), th)
      ),
      tr(
        lapply(paste("\\(\\overline{X}_{",rep(1:getHomogeneityNumCols_value()),"}=\\)",getDataHomogeneityMeansWithin()), th)
      ),
      tr(
        th(colspan = getHomogeneityNumCols_value(), class="tableFormula", paste("\\( n_j(\\overline{X}_{j}-\\overline{X}_T)^2 = \\)"))
      ),
      tr(
        lapply(paste(getDataHomogeneityNumeratorBetween()), th, class="noBorderAbove")
      ),
      tr(
        th(colspan = getHomogeneityNumCols_value(), class="tableFormula", paste("\\( \\sum\\limits_{j=1}^k n_j(\\overline{X}_{j}-\\overline{X}_T)^2 = ", getHomogeneitySumOfSquaresBetween() , "\\)"))
      )
    )
  )),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip', columnDefs = list(list(className = 'dt-right', targets = 0:getHomogeneityNumCols_value()-1)))
)

output$display_homogeneity_meanSumOfSquaresBetween = renderUI({
  
  top = getHomogeneitySumOfSquaresBetween()
  k = getHomogeneityNumCols()
  answer = getHomogeneityMeanSumOfSquaresBetween()
  
  formulas = c(paste0("MSS_B &= \\frac{ \\sum\\limits_{j=1}^k n_j(\\overline{X}_{j}-\\overline{X}_T)^2 } { k-1 }"))
  formulas = c(formulas, paste0("&= \\frac{",top,"}{",k," - 1}"))
  formulas = c(formulas, paste0("&= ", answer))
  
  output = mathJaxAligned(formulas, 10)
  return(withMathJax(HTML(output)))
  
})

#Display homogeneity calcs
output$display_homogeneity_calcsTable = DT::renderDataTable(
  sapply(getDataHomogeneityCalcs(), function(x) formatNumberForDisplay(x, input)),
  container = htmltools::withTags(table(
    #tableHeader(colnames(getDataHomogeneityCalcs())),
    tableHeader(paste0("\\((X_{i",rep(1:getHomogeneityNumCols_value()),"} - \\overline{X}_{",rep(1:getHomogeneityNumCols_value()),"})^2\\)")),
    tfoot(
      tr(
        th(colspan = getHomogeneityNumCols_value(), class="result", paste("\\(\\sum\\limits_{j=1}^k\\sum\\limits_{i=1}^{n_j} (X_{ij}-\\overline{X}_j)^2 = ",getHomogeneitySumOfSquaresWithin(),"\\)"))
      )
    ),
    tableFooter(paste("\\(\\sum\\limits^{n_j}_1 =\\)",getDataHomogeneitySumOfSquaredDeviation()))
  )),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip', columnDefs = list(list(className = 'dt-right', targets = 0:ncol(getDataHomogeneityCalcs())-1)))
)

#Display values needed for calculations
output$display_homogeneity_parameters = renderUI({
  
  n = getHomogeneityNumOfValues()
  k = getHomogeneityNumCols()
  a = getHomogeneitySumOfNjSquared()
  nZero = getHomogeneityNZero()
  
  formulas = c(paste0("N &=", n))
  formulas = c(formulas, paste0("k &=", k))
  formulas = c(formulas, paste0("A &= n_1^2 + \\ldots + n_k^2 = ", a))
  formulas = c(formulas, paste0("n_0 &= \\frac{1}{",k,"-1} \\times \\left[",n," - \\frac{ ",a," } { ",n," }\\right] = ", nZero))
  output = mathJaxAligned(formulas, 10)
  
  return(withMathJax(HTML(output)))
  
})

output$display_homogeneity_grandMean = renderUI({
  
  top = getHomogeneitySumOfAllValues()
  n = getHomogeneityNumOfValues()
  answer = getHomogeneityGrandMean()
  
  formulas = c(paste0("\\overline{X}_T &= \\frac{\\sum\\limits_{j=1}^k\\sum\\limits_{i=1}^{n_j} X_{ij}}{N}"))
  formulas = c(formulas, paste0("&= \\frac{",top,"}{",n,"}"))
  formulas = c(formulas, paste0("&= ", answer))
  
  output = mathJaxAligned(formulas, 10)
  return(withMathJax(HTML(output)))
})


output$display_homogeneity_meanSumOfSquaresWithin = renderUI({

  top = getHomogeneitySumOfSquaresWithin()
  n = getHomogeneityNumOfValues()
  k = getHomogeneityNumCols()
  answer = getHomogeneityMeanSumOfSquaresWithin()
  
  formulas = c(paste0("MSS_W &= \\frac{ \\sum\\limits_{j=1}^k\\sum\\limits_{i=1}^{n_j} (X_{ij}-\\overline{X}_j)^2 } { N-k }"))
  formulas = c(formulas, paste0("&= \\frac{",top,"}{",n," - ", k, "}"))
  formulas = c(formulas, paste0("&= ", answer))
  
  output = mathJaxAligned(formulas, 10)
  return(withMathJax(HTML(output)))
  
})

#Display calculations
homogeneity_standardUncertainty_left_renderer = function(removeColours = FALSE)
{
  suA = getHomogeneity_standardUncertaintyA()
  if(is.na(suA)) return(NA)
  
  mssb = getHomogeneityMeanSumOfSquaresBetween()
  mssw = getHomogeneityMeanSumOfSquaresWithin()
  nZero = getHomogeneityNZero()
  
  formulas = c(paste0("\\displaystyle u_a(\\text{Homogeneity}) &= \\sqrt{\\frac{ MSS_B - MSS_W }{ n_0 }}"))
  formulas = c(formulas, paste0("&= \\sqrt{\\frac{ ",mssb," - ",mssw," }{ ",nZero," }}"))
  formulas = c(formulas, paste0("&= ", suA))
  return(withMathJax(HTML(mathJaxAligned(formulas, 10, 50, removeColours))))
}

homogeneity_standardUncertainty_right_renderer = function(removeColours = FALSE)
{
  suB = getHomogeneity_standardUncertaintyB()
  if(is.na(suB)) return(NA)
  
  mssw = getHomogeneityMeanSumOfSquaresWithin()
  nZero = getHomogeneityNZero()
  k = getHomogeneityNumCols()
  
  formulas = c(paste0("\\displaystyle u_b(\\text{Homogeneity}) &= \\sqrt{ \\frac{ MSS_W }{ max(n_j) } } \\times \\sqrt{ \\frac{ 2 }{ k(n_0-1) } }"))
  formulas = c(formulas, paste0("&= \\sqrt{ \\frac{ ",mssw," }{ ",nZero," } } \\times \\sqrt{ \\frac{ 2 }{ ",k,"(",nZero,"-1) } }"))
  formulas = c(formulas, paste0("&= ", suB))
  return(withMathJax(HTML(mathJaxAligned(formulas, 10, 50, removeColours))))
}

homogeneity_standardUncertainty_max_renderer = function(removeColours = FALSE)
{
  suA = getHomogeneity_standardUncertaintyA()
  suB = getHomogeneity_standardUncertaintyB()
  su = getHomogeneity_standardUncertainty()
  
  if(is.na(suA) && is.na(suB) ) return(NA)
  
  formulas = c(paste0("\\displaystyle u(\\text{Homogeneity}) &= \\text{max}\\{u_a,u_b\\}"))
  formulas = c(formulas, paste0("&= \\text{max}\\{",suA,",",suB,"\\}"))
  formulas = c(formulas, paste0("&= ", su))
  return(withMathJax(HTML(mathJaxAligned(formulas, 10, 50, removeColours))))
}

output$display_homogeneity_standardUncertainty = renderUI({
  display = fluidRow(
              fluidRow(
                column(6, homogeneity_standardUncertainty_left_renderer()),
                column(6, homogeneity_standardUncertainty_right_renderer())
              ),
              fluidRow(
                column(4, ""),
                column(4, homogeneity_standardUncertainty_max_renderer()),
                column(4, "")
              )
            )
  return(display)
})

homogeneity_relativeStandardUncertainty_renderer = function(removeColours = FALSE)
{
  answer = getHomogeneity_relativeStandardUncertainty()
  if(is.na(answer)) return(NA)
  
  standardUncerainty = getHomogeneity_standardUncertainty()
  xt = getHomogeneityGrandMean()
  
  formulas = c(paste0("u_r(\\text{Homogeneity}) &= \\frac{ u(\\text{Homogeneity}) }{ \\overline{X}_T }"))
  formulas = c(formulas, paste0("&= \\frac{ ",standardUncerainty," }{ ",xt," }"))
  formulas = c(formulas, paste0("&= ", answer))
  output = mathJaxAligned(formulas, 10, 50, removeColours)
  return(withMathJax(HTML(output)))
}

output$display_homogeneity_relativeStandardUncertainty = renderUI({
  return(homogeneity_relativeStandardUncertainty_renderer())
})

#Display final answers
output$display_homogeneity_finalAnswer_top = renderUI({
  return(paste("\\(u_r\\text{(Homogeneity)}=\\)",getHomogeneity_relativeStandardUncertainty()))
})

output$display_homogeneity_finalAnswer_dashboard = renderUI({
  return(paste("\\(u_r\\text{(Homogeneity)}=\\)",getHomogeneity_relativeStandardUncertainty()))
})

output$display_homogeneity_finalAnswer_combinedUncertainty = renderUI({
  return(paste(getHomogeneity_relativeStandardUncertainty()))
})

output$display_homogeneity_finalAnswer_coverageFactor = renderUI({
  return(paste(getHomogeneity_relativeStandardUncertainty()))
})