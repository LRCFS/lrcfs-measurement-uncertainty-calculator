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
    layout(xaxis = list(title="Vial"), yaxis = list(title="Peak Area Ratio"))
  
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
    tableHeader(colnames(getDataHomogeneity())),
    tfoot(
      tr(
        lapply(paste("\\(n_{",rep(1:getHomogeneityNumCols_value()),"}=\\)",getHomogeneityNumWithin()), th)
      ),
      tr(
        lapply(paste("\\(\\overline{X}_{",rep(1:getHomogeneityNumCols_value()),"}=\\)",getDataHomogeneityMeansWithin()), th)
      ),
      tr(
        th(colspan = getHomogeneityNumCols_value(), class="tableFormula", paste("\\( n_j(\\overline{X}_{j}-\\overline{X}_T)^2 \\)"))
      ),
      tr(
        lapply(paste("\\(= \\)",getDataHomogeneityNumeratorBetween()), th)
      ),
      tr(
        th(colspan = getHomogeneityNumCols_value(), class="tableFormula", paste("\\( \\sum\\limits_{j=1}^k n_j(\\overline{X}_{j}-\\overline{X}_T)^2 = ", 999 , "\\)"))
      )
    )
  )),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip', columnDefs = list(list(className = 'dt-right', targets = 0:getHomogeneityNumCols_value()-1)))
)

#Display homogeneity calcs
output$display_homogeneity_calcsTable = DT::renderDataTable(
  sapply(getDataHomogeneityCalcs(), function(x) formatNumberForDisplay(x, input)),
  container = htmltools::withTags(table(
    tableHeader(colnames(getDataHomogeneityCalcs())),
    tfoot(
      tr(
        th(colspan = getHomogeneityNumCols_value(), class="result", paste("\\(\\sum\\limits_{j=1}^k\\sum\\limits_{i=1}^n (X_{ij}-\\overline{X}_j)^2 = ",getHomogeneitySumOfSquaresWithin(),"\\)"))
      )
    ),
    tableFooter(paste("\\(\\sum_{",rep(1:getHomogeneityNumCols_value()),"}=\\)",getDataHomogeneitySumOfSquaredDeviation()))
  )),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip', columnDefs = list(list(className = 'dt-right', targets = 0:ncol(getDataHomogeneityCalcs())-1)))
)

#Display values needed for calculations
output$display_homogeneity_valuedNeeded = renderUI({
  
  n = getHomogeneityNumOfValues()
  k = getHomogeneityNumCols()
  
  formulas = c(paste0("\\text{n} &=", n))
  formulas = c(formulas, paste0("\\text{k} &=", k))
  output = mathJaxAligned(formulas, 10)
  
  return(withMathJax(HTML(output)))
  
})

output$display_homogeneity_grandMean = renderUI({
  
  top = getHomogeneitySumOfAllValues()
  n = getHomogeneityNumOfValues()
  answer = getHomogeneityGrandMean()
  
  formulas = c(paste0("\\overline{X}_T &= \\frac{\\sum\\limits_{j=1}^k\\sum\\limits_{i=1}^n X_{ij}}{n}"))
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
  
  formulas = c(paste0("MSS_w &= \\frac{ \\sum\\limits_{j=1}^k\\sum\\limits_{i=1}^n (X_{ij}-\\overline{X}_j)^2 } { n-k }"))
  formulas = c(formulas, paste0("&= \\frac{",top,"}{",n," - ", k, "}"))
  formulas = c(formulas, paste0("&= ", answer))
  
  output = mathJaxAligned(formulas, 10)
  return(withMathJax(HTML(output)))
  
})













#Display calculations
output$display_homogeneity_standardUncertainty = renderUI({
  data = getDataHomogeneity()
  if(is.null(data)) return(NA)
})

output$display_homogeneity_relativeStandardUncertainty = renderUI({
  data = getDataHomogeneity()
  if(is.null(data)) return(NA)
})

#Display final answers
output$display_homogeneity_finalAnswer_top = renderUI({
  #return(paste("\\(u_r\\text{(Homogeneity)}=\\)",formatNumberForDisplay(getResultSamplePreparation(),input)))
})

output$display_Homogeneity_finalAnswer_bottom = renderUI({
  data = getDataHomogeneity()
  if(is.null(data)) return(NA)
  
  
})

output$display_homogeneity_finalAnswer_dashboard = renderUI({
  #return(paste("\\(u_r\\text{(Homogeneity)}=\\)",formatNumberForDisplay(1,input)))
})

output$display_homogeneity_finalAnswer_combinedUncertainty = renderUI({
  #return(paste(formatNumberForDisplay(getResultSamplePreparation(),input)))
})

output$display_homogeneity_finalAnswer_coverageFactor = renderUI({
  #return(paste(formatNumberForDisplay(getResultSamplePreparation(),input)))
})