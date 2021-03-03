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

getHomogeneityTestAlphaValue = reactive({
  value = input$inputHomogeneityTest_alphaValue
  if(is.na(as.numeric(value))) return(0.05)
  if(value > 0.999) return(0.999)
  if(value < 0.001) return(0.001)
  return(formatNumberForDisplay(value,input))
})

getHomogeneityTestWithinDof = reactive({
  return(doGetHomogeneityTestWithinDof(getDataHomogeneity()))
})

getHomogeneityTestBetweenDof = reactive({
  return(doGetHomogeneityTestBetweenDof(getDataHomogeneity()))
})

getHomogeneityTestFCritical = reactive({
  answer = getHomogeneityTestFCritical_value()
  answer = formatNumberForDisplay(answer, input)
  return(answer)
})

getHomogeneityTestFCritical_value = reactive({
  alpha = getHomogeneityTestAlphaValue()
  answer = doGetHomogeneityTestFCritical(getDataHomogeneity(), alpha)
  return(answer)
})

getHomogeneityTestPass = reactive({
  alpha = getHomogeneityTestAlphaValue()
  answer = doGetHomogeneityTestPass(getDataHomogeneity(), alpha)
  return(answer)
})

getHomogeneityTestPass_text = reactive({
  if(getHomogeneityTestPass())
     return("Homogeneous")
  return("Not Homogeneous")
})
