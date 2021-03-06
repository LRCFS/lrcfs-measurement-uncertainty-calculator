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

expandedUncertaintyResult = reactive({
  result = doGetExpandedUncertaintyResult(coverageFactorResult(),combinedUncertaintyResult())
  return(result)
})

expandedUncertaintyResultPercentage = reactive({
  result = doGetExpandedUncertaintyResultPercentage(input$inputCaseSampleMeanConcentration,coverageFactorResult(),combinedUncertaintyResult())
  return(result)
})

###################################################################################
# Outputs
###################################################################################

output$display_expandedUncertainty_coverageFactorText = renderUI({
  return(withMathJax(HTML(paste0("\\( \\text{CoverageFactor} (",coverageFactorSymbolDisplay(),")\\)"))))
})

output$display_expandedUncertainty_meanConcentration <- renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_expandedUncertainty_finalAnswer_top = renderUI({
  return(withMathJax(paste("\\(\\text{ExpUncertainty}=",formatNumberForDisplay(expandedUncertaintyResult(),input),"\\)")))
})

expandedUncertainty_finalAnswer_renderer = function(removeColours = FALSE)
{
  confidenceInterval = input$inputConfidenceInterval
  effectiveDof = effectiveDofResult()
  finalCoverageFactor = coverageFactorResult()
  
  formulas = c(paste0("\\text{ExpUncertainty} &=",coverageFactorSymbolDisplay()," \\times \\text{CombUncertainty}"))
  formulas = c(formulas, paste("&=",colourNumberBackground(formatNumberForDisplay(finalCoverageFactor,input),CoverageFactorColor,"#FFF",input$useColours)," \\times ", colourNumberBackground(formatNumberForDisplay(combinedUncertaintyResult(),input),CombinedUncertaintyColor,"#FFF",input$useColours)))
  formulas = c(formulas, paste("&=",formatNumberForDisplay(expandedUncertaintyResult(),input)))
  output = mathJaxAligned(formulas, 5,20, removeColours)
  
  return(withMathJax(output))
}

output$display_expandedUncertainty_finalAnswer_bottom = renderUI({
  return(expandedUncertainty_finalAnswer_renderer())
})

output$display_expandedUncertainty_finalAnswerPercentage_bottom = renderUI({
  
  expandedUncertainty = expandedUncertaintyResult()
  csMeanConcentration = input$inputCaseSampleMeanConcentration
  answer = expandedUncertaintyResultPercentage()
  
  formulas = c(paste0("\\text{%ExpUncertainty} &= \\frac{\\text{ExpUncertainty}}{x_s} \\times 100"))
  formulas = c(formulas, paste("&= \\frac{",formatNumberForDisplay(expandedUncertainty,input),"}{",ColourCaseSampleMeanConcentration(csMeanConcentration,input$useColours),"} \\times 100"))
  formulas = c(formulas, paste("&=",formatNumberForDisplay(answer,input),"\\%"))
  output = mathJaxAligned(formulas,5,20)
  
  return(withMathJax(output))
})

output$display_expandedUncertainty_finalAnswer_dashboard = renderUI({
  return(withMathJax(paste("\\(\\text{ExpUncertainty}=",formatNumberForDisplay(expandedUncertaintyResult(),input),"\\)")))
})

output$display_expandedUncertainty_finalAnswerPercentage_dashboard <- renderUI({
  return(withMathJax(paste("\\(\\text{%ExpUncertainty}=",formatNumberForDisplay(expandedUncertaintyResultPercentage(),input),"\\%\\)")))
})

output$display_expandedUncertainty_finalAnswer_start <- renderUI({
  return(withMathJax(paste("\\(\\huge{\\text{Concentration} =",input$inputCaseSampleMeanConcentration,"\\pm",formatNumberForDisplay(expandedUncertaintyResult(),input),"}\\)")))
})

output$display_expandedUncertainty_result_dashboard <- renderUI({
  return(withMathJax(paste("\\(\\huge{\\text{Concentration} =",input$inputCaseSampleMeanConcentration,"\\pm",formatNumberForDisplay(expandedUncertaintyResult(),input),"}\\)")))
})