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

getDataHomogeneity = reactive({
  if(myReactives$uploadedHomogeneity == TRUE)
  {
    data = homogeneityReadCSV(input$inputHomogeneityFileUpload$datapath)
    return(data)
  }
  else
  {
    return(NULL)
  }
})

# Returns a single number of columns in the dataset
getHomogeneityNumCols = reactive({
  data = getHomogeneityNumCols_value()
  data = formatNumberForDisplay(data, input)
  data = colourNumber(data, input$useColours, input$colour2)
  return(data)
})

# We use this value for rendering the right number of columns in datatables so need a direct value
getHomogeneityNumCols_value = reactive({
  data = doGetHomogeneityNumCols(getDataHomogeneity())
  return(data)
})

# Returns the number of values in each column excluding NAs
getHomogeneityNumWithin = reactive({
  data = doGetHomogeneityNumWithin(getDataHomogeneity())
  data = formatNumberForDisplay(data, input)
  return(data)
})

getHomogeneityNumWithinMax = reactive({
  data = doGetHomogeneityNumWithinMax(getDataHomogeneity())
  data = formatNumberForDisplay(data, input)
  return(data)
})

getDataHomogeneityMeansWithin = reactive({
  data = doGetHomogeneityMeansWithin(getDataHomogeneity())
  data = formatNumberForDisplay(data, input)
  return(data)
})

getDataHomogeneityCalcs = reactive({
  data = doGetHomogeneityCalcs(getDataHomogeneity())
  return(data)
})

getDataHomogeneitySumOfSquaredDeviation = reactive({
  data = doGetHomogeneitySumOfSquaredDeviation(getDataHomogeneity())
  data = formatNumberForDisplay(data, input)
  return(data)
})

getHomogeneitySumOfSquaresWithin = reactive({
  data = doGetHomogeneitySumOfSquaresWithin(getDataHomogeneity())
  data = formatNumberForDisplay(data, input)
  data = colourNumber(data, input$useColours, input$colour5)
  return(data)
})

getHomogeneityMeanSumOfSquaresWithin = reactive({
  data = doGetHomogeneityMeanSumOfSquaresWithin(getDataHomogeneity())
  data = formatNumberForDisplay(data, input)
  data = colourNumber(data, input$useColours, input$colour6)
  return(data)
})

getHomogeneitySumOfAllValues = reactive({
  data = doGetHomogeneitySumOfAllValues(getDataHomogeneity())
  data = formatNumberForDisplay(data, input)
  data = colourNumber(data, input$useColours, input$colour4)
  return(data)
})

#Returns the number of values within the datafame (excluding NAs)
getHomogeneityNumOfValues = reactive({
  data = doGetHomogeneityNumOfValues(getDataHomogeneity())
  data = formatNumberForDisplay(data, input)
  data = colourNumber(data, input$useColours, input$colour1)
  return(data)
})

getHomogeneityGrandMean = reactive({
  data = doGetHomogeneityGrandMean(getDataHomogeneity())
  data = formatNumberForDisplay(data, input)
  data = colourNumber(data, input$useColours, input$colour3)
  return(data)
})


getDataHomogeneityNumeratorBetween = reactive({
  data = doGetDataHomogeneityNumeratorBetween(getDataHomogeneity())
  data = formatNumberForDisplay(data, input)
  return(data)
})

getHomogeneitySumOfSquaresBetween = reactive({
  data = doGetHomogeneitySumOfSquaresBetween(getDataHomogeneity())
  data = formatNumberForDisplay(data, input)
  data = colourNumber(data, input$useColours, input$colour7)
  return(data)
})

getHomogeneityMeanSumOfSquaresBetween = reactive({
  data = doGetHomogeneityMeanSumOfSquaresBetween(getDataHomogeneity())
  data = formatNumberForDisplay(data, input)
  data = colourNumber(data, input$useColours, input$colour8)
  return(data)
})

getHomogeneityFValue = reactive({
  data = getHomogeneityFValue_value()
  data = formatNumberForDisplay(data, input)
  data = colourNumber(data, input$useColours, input$colour9)
  return(data)
})

getHomogeneityFValue_value = reactive({
  return(doGetHomogeneityFValue(getDataHomogeneity()))
})

getHomogeneity_degreesOfFreedom = reactive({
  return(doGetHomogeneity_degreesOfFreedom(getDataHomogeneity()))
})

isMssbGreaterOrEqualMssw = reactive({
  data = getDataHomogeneity()
  return(doGetHomogeneityMeanSumOfSquaresBetween(data) >= doGetHomogeneityMeanSumOfSquaresWithin(data))
})

getHomogeneity_standardUncertainty = reactive({
  data = doGetHomogeneity_standardUncertainty(getDataHomogeneity())
  data = formatNumberForDisplay(data, input)
  return(data)
})

getHomogeneity_relativeStandardUncertainty = reactive({
  data = formatNumberForDisplay(getHomogeneity_relativeStandardUncertainty_value(), input)
  return(data)
})

getHomogeneity_relativeStandardUncertainty_value = reactive({
  return(doGetHomogeneity_relativeStandardUncertainty(getDataHomogeneity()))
})


