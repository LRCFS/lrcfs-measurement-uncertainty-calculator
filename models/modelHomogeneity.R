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
output$display_homogeneity_calcsTable = DT::renderDataTable(
  getDataHomogeneityCalcs(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)





#Display values needed for calculations
output$display_homogeneity_valuedNeeded = renderUI({
  
  formulas = c(paste0("\\text{N} &=", 1))
  formulas = c(formulas, paste0("\\text{n} &=", 1))
  formulas = c(formulas, paste0("\\text{N_t} &=", 1))
  output = mathJaxAligned(formulas, 10)
  
  return(withMathJax(HTML(output)))
  
})

output$display_homogeneity_groundMean = renderUI({
  
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