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
output$display_samplePreparation_rawDataTable = DT::renderDataTable(
  getDataSamplePreparation(),
  rownames = FALSE,
  options = list(scrollX = TRUE, dom = 'tip')
)



#Display calculations

#Renderer function for both html and pdf report
samplePreparation_standardUncertainty_renderer = function(removeColours = FALSE)
{
  data = getDataSamplePreparation()
  if(is.null(data)) return(NA)
  
  formulas = c("u\\text{(Equipment)}_{\\text{(Cap,Tol)}} &= \\frac{\\text{Tolerance}}{\\text{Coverage Factor}} [[break]]")
  
  for(samplePreparationItem in rownames(data))
  {
    samplePreparationItemData = data[samplePreparationItem,]
    
    equipment = samplePreparationItemData$equipment
    equipmentCapacity = samplePreparationItemData$equipmentCapacity
    equipmentCapacityTolerance = samplePreparationItemData$equipmentCapacityTolerance
    equipmentCoverage = samplePreparationItemData$equipmentCoverage
    answerValue = formatNumberForDisplay(doGetSamplePreparation_standardUncerainty(samplePreparationItemData), input);
    
    formulas = c(formulas, paste0("u\\text{(",equipment,")}_{\\text{(",equipmentCapacity,",",equipmentCapacityTolerance,")}} &= \\frac{",equipmentCapacityTolerance,"}{",equipmentCoverage,"} = ", colourNumber(answerValue, input$useColours, input$colour1)))
  }
  output = mathJaxAligned(formulas, 10, 20, removeColours)
  return(withMathJax(HTML(output)))
}

output$display_samplePreparation_standardUncertainty = renderUI({
  return(samplePreparation_standardUncertainty_renderer())
})

#Renderer function for both html and pdf report
samplePreparation_relativeStandardUncertainty_renderer = function(removeColours = FALSE)
{
  data = getDataSamplePreparation()
  if(is.null(data)) return(NA)
  
  formulas = c("u_r\\text{(Equipment)}_{\\text{(Cap,Tol)}} &= \\frac{u\\text{(Equipment)}_{\\text{(Cap,Tol)}}}{\\text{Capacity}} [[break]]")
  
  for(samplePreparationItem in rownames(data))
  {
    samplePreparationItemData = data[samplePreparationItem,]
    
    equipment = samplePreparationItemData$equipment
    stdUnc = formatNumberForDisplay(doGetSamplePreparation_standardUncerainty(samplePreparationItemData), input)
    equipmentCapacity = samplePreparationItemData$equipmentCapacity
    equipmentCapacityTolerance = samplePreparationItemData$equipmentCapacityTolerance
    answerValue = formatNumberForDisplay(doGetSamplePreparation_relativeStandardUncertainty(samplePreparationItemData), input)
    
    formulas = c(formulas, paste0("u_r\\text{(",equipment,")}_{\\text{(",equipmentCapacity,",",equipmentCapacityTolerance,")}} &= \\frac{",colourNumber(stdUnc, input$useColours, input$colour1),"}{",equipmentCapacity,"} = ", answerValue))
  }
  output = mathJaxAligned(formulas, 10, 20, removeColours)
  
  return(withMathJax(HTML(output)))
}

output$display_samplePreparation_relativeStandardUncertainty = renderUI({
  return(samplePreparation_relativeStandardUncertainty_renderer())
})

#Display final answers
output$display_samplePreparation_finalAnswer_top = renderUI({
  return(paste("\\(u_r\\text{(SamplePreparation)}=\\)",formatNumberForDisplay(getResultSamplePreparation(),input)))
})

#Renderer function for both html and pdf report
samplePreparation_finalAnswer_bottom_renderer = function(removeColours = FALSE)
{
  data = getDataSamplePreparation()
  if(is.null(data)) return(NA)
  
  formulas = c("u_r\\text{(SamplePreparation)} &= \\sqrt{\\sum{[u_r(\\text{Equipment})_{\\text{(Cap,Tol)}}^2 \\times N(\\text{Equipment})_{\\text{(Cap,Tol)}}}]}")
  
  formula = "&= \\sqrt{"
  for(samplePreparationItem in rownames(data))
  {
    
    samplePreparationItemData = data[samplePreparationItem,]
    
    relativeStandardUncertainty = formatNumberForDisplay(doGetSamplePreparation_relativeStandardUncertainty(samplePreparationItemData),input)
    
    if(samplePreparationItem == 1){
      string = paste("[",relativeStandardUncertainty,"^2")
    }
    else{
      string = paste("+ [",relativeStandardUncertainty,"^2")
    }
    
    formula = paste(formula, string, "\\times", samplePreparationItemData$equipmentTimesUsed, "]")
  }
  formula = paste(formula, "}")
  
  formulas = c(formulas,formula)
  
  formulas = c(formulas, paste("&= ", formatNumberForDisplay(getResultSamplePreparation(),input)))
  
  output = mathJaxAligned(formulas, 5, 20, removeColours)
  
  return(withMathJax(HTML(output)))
}

output$display_samplePreparation_finalAnswer_bottom = renderUI({
  return(samplePreparation_finalAnswer_bottom_renderer())
})

output$display_samplePreparation_finalAnswer_dashboard = renderUI({
  return(paste("\\(u_r\\text{(SamplePreparation)}=\\)",formatNumberForDisplay(getResultSamplePreparation(),input)))
})

output$display_samplePreparation_finalAnswer_combinedUncertainty = renderUI({
  return(paste(formatNumberForDisplay(getResultSamplePreparation(),input)))
})

output$display_samplePreparation_finalAnswer_coverageFactor = renderUI({
  return(paste(formatNumberForDisplay(getResultSamplePreparation(),input)))
})