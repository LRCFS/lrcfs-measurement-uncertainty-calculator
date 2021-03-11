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

output$display_dashboard_replicates <- renderUI({
  string = paste(input$inputCaseSampleReplicates)
  return(string)
})

output$display_dashboard_meanConcentration <- renderUI({
  string = paste(input$inputCaseSampleMeanConcentration)
  return(string)
})

output$display_dashboard_caseSampleMeanPar <- renderUI({
  if(checkNeedPeakAreaRatio())
  {
    infoBox(withMathJax(HTML("Case Sample<br />Mean Peak Area Ratio\\((y_s)\\)")),input$inputCaseSampleMeanPeakAreaRatio, width=3, icon=icon("chart-bar"), color="orange")
  }
})

output$display_dashboard_caseSampleWeight <- renderUI({
  if(checkUsingCustomWls())
  {
    infoBox(withMathJax(HTML("Case Sample<br />Weight\\((W_s)\\)")),formatNumberForDisplay(input$inputCaseSampleCustomWeight, input), width=3, icon=icon("weight"), color="red")
  }
})

output$display_dashboard_confidenceInterval <- renderUI({
  string = paste(input$inputConfidenceInterval)
  return(string)
})

output$actionButton_dashboard_downloadReport = downloadReportHandler #defined in modelApplication.R
