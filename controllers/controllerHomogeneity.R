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

doGetHomogeneityNumCols = function(data)
{
  return(ncol(data))
}

# Returns the number of values in each column excluding NA
doGetHomogeneityNumWithin = function(data)
{
  return(colSums(!is.na(data)))
}

doGetHomogeneityNumWithinMax = function(data)
{
  return(max(doGetHomogeneityNumWithin(data)))
}

doGetHomogeneityMeansWithin = function(data)
{
  return(apply(data, 2, mean, na.rm = TRUE ))
}

doGetHomogeneityCalcs = function(data)
{
  return(data.frame(apply(data, 2, calcHomogeneitySquares)))
}

doGetHomogeneitySumOfSquaredDeviation = function(data)
{
  data = doGetHomogeneityCalcs(data)
  return(apply(data, 2, sum, na.rm = TRUE))
}

doGetHomogeneitySumOfSquaresWithin = function(data)
{
  data = doGetHomogeneitySumOfSquaredDeviation(data)
  return(sum(data, na.rm = TRUE))
}

doGetHomogeneityMeanSumOfSquaresWithin = function(data)
{
  sumOfSquaresWithin = doGetHomogeneitySumOfSquaresWithin(data)
  numOfValues = doGetHomogeneityNumOfValues(data)
  numCols = doGetHomogeneityNumCols(data)
  
  answer = sumOfSquaresWithin / (numOfValues - numCols)
  return(answer)
}

doGetHomogeneitySumOfAllValues = function(data)
{
  return(sum(data, na.rm = TRUE))
}

doGetHomogeneityNumOfValues = function(data)
{
  dataAsVactor = unlist(data);
  countWithoutNas = length(which(!is.na(dataAsVactor)))
  return(countWithoutNas)
}

doGetHomogeneityGrandMean = function(data)
{
  answer = doGetHomogeneitySumOfAllValues(data) / doGetHomogeneityNumOfValues(data)
  return(answer)
}

doGetDataHomogeneityNumeratorBetween = function(data)
{
  nj = doGetHomogeneityNumWithin(data)
  xBar = doGetHomogeneityMeansWithin(data)
  grandMean = doGetHomogeneityGrandMean(data)
  
  answer = nj * (xBar - grandMean)^2
  
  return(answer)
}

doGetHomogeneitySumOfSquaresBetween = function(data)
{
  answer = sum(doGetDataHomogeneityNumeratorBetween(data))
  return(answer)
}

doGetHomogeneityMeanSumOfSquaresBetween = function(data)
{
  k = doGetHomogeneityNumCols(data)
  answer = doGetHomogeneitySumOfSquaresBetween(data) / (k -1)
  return(answer)
}

doGetHomogeneityFValue = function(data)
{
  mssb = doGetHomogeneityMeanSumOfSquaresBetween(data)
  mssw = doGetHomogeneityMeanSumOfSquaresWithin(data)
  answer = mssb / mssw
  return(answer)
}

doGetHomogeneity_standardUncertainty = function(data){
  mssb = doGetHomogeneityMeanSumOfSquaresBetween(data)
  mssw = doGetHomogeneityMeanSumOfSquaresWithin(data)
  njMax = getHomogeneityNumWithinMax()
  k = getHomogeneityNumCols()
  
  answer = 0;
  if(mssb >= mssw)
  {
    answer = sqrt((mssb - mssw) / njMax)
  }
  else
  {
    answer = sqrt(mssw / njMax) * (2 / (k(njMax-1)) )^(1/4)
  }
  
  return(answer)
}

doGetHomogeneity_relativeStandardUncertainty = function(data)
{
  u = doGetHomogeneity_standardUncertainty(data)
  xt = doGetHomogeneityGrandMean(data)
  answer = u/xt
  return(answer)
}



calcHomogeneitySquares = function(x)
{
  answer = (x - mean(x, na.rm = TRUE))^2
  return(answer)
}



























