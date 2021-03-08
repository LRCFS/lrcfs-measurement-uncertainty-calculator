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
  if(is.null(data)) return(NA)
  
  return(ncol(data))
}

# Returns the number of values in each column excluding NA
doGetHomogeneityNumWithin = function(data)
{
  if(is.null(data)) return(NA)
  
  return(colSums(!is.na(data)))
}

doGetHomogeneityNZero = function(data)
{
  if(is.null(data)) return(NA)
  
  numReps = doGetHomogeneityNumWithin(data)
  numCols = doGetHomogeneityNumCols(data)
  
  answer = (1/(numCols-1))*(sum(numReps)-((sum(numReps^2))/(sum(numReps))))
  
  return(answer)
}

doGetHomogeneityMeansWithin = function(data)
{
  if(is.null(data)) return(NA)
  
  return(apply(data, 2, mean, na.rm = TRUE ))
}

doGetHomogeneityCalcs = function(data)
{
  if(is.null(data)) return(NA)
  
  return(data.frame(apply(data, 2, calcHomogeneitySquares)))
}

calcHomogeneitySquares = function(x)
{
  if(is.null(x)) return(NA)
  
  answer = (x - mean(x, na.rm = TRUE))^2
  return(answer)
}

doGetHomogeneitySumOfSquaredDeviation = function(data)
{
  if(is.null(data)) return(NA)
  
  data = doGetHomogeneityCalcs(data)
  return(apply(data, 2, sum, na.rm = TRUE))
}

doGetHomogeneitySumOfSquaresWithin = function(data)
{
  if(is.null(data)) return(NA)
  
  data = doGetHomogeneitySumOfSquaredDeviation(data)
  return(sum(data, na.rm = TRUE))
}

doGetHomogeneityMeanSumOfSquaresWithin = function(data)
{
  if(is.null(data)) return(NA)
  
  sumOfSquaresWithin = doGetHomogeneitySumOfSquaresWithin(data)
  numOfValues = doGetHomogeneityNumOfValues(data)
  numCols = doGetHomogeneityNumCols(data)
  
  answer = sumOfSquaresWithin / (numOfValues - numCols)
  return(answer)
}

doGetHomogeneitySumOfAllValues = function(data)
{
  if(is.null(data)) return(NA)
  
  return(sum(data, na.rm = TRUE))
}

doGetHomogeneityNumOfValues = function(data)
{
  if(is.null(data)) return(NA)
  
  dataAsVactor = unlist(data);
  countWithoutNas = length(which(!is.na(dataAsVactor)))
  return(countWithoutNas)
}

doGetHomogeneitySumOfNjSquared = function(data)
{
  if(is.null(data)) return(NA)
  
  return(sum(doGetHomogeneityNumWithin(data)^2))
}

doGetHomogeneityGrandMean = function(data)
{
  if(is.null(data)) return(NA)
  
  answer = doGetHomogeneitySumOfAllValues(data) / doGetHomogeneityNumOfValues(data)
  return(answer)
}

doGetDataHomogeneityNumeratorBetween = function(data)
{
  if(is.null(data)) return(NA)
  
  nj = doGetHomogeneityNumWithin(data)
  xBar = doGetHomogeneityMeansWithin(data)
  grandMean = doGetHomogeneityGrandMean(data)
  
  answer = nj * (xBar - grandMean)^2
  
  return(answer)
}

doGetHomogeneitySumOfSquaresBetween = function(data)
{
  if(is.null(data)) return(NA)
  
  answer = sum(doGetDataHomogeneityNumeratorBetween(data))
  return(answer)
}

doGetHomogeneityMeanSumOfSquaresBetween = function(data)
{
  if(is.null(data)) return(NA)
  
  k = doGetHomogeneityNumCols(data)
  answer = doGetHomogeneitySumOfSquaresBetween(data) / (k -1)
  return(answer)
}

doGetHomogeneityFValue = function(data)
{
  if(is.null(data)) return(NA)
  
  mssb = doGetHomogeneityMeanSumOfSquaresBetween(data)
  mssw = doGetHomogeneityMeanSumOfSquaresWithin(data)
  answer = mssb / mssw
  return(answer)
}

doGetHomogeneity_standardUncertainty = function(data)
{
  if(is.null(data)) return(NA)
  
  mssb = doGetHomogeneityMeanSumOfSquaresBetween(data)
  mssw = doGetHomogeneityMeanSumOfSquaresWithin(data)
  nZero = doGetHomogeneityNZero(data)
  k = doGetHomogeneityNumCols(data)
  
  answer = 0;
  if(mssb >= mssw)
  {
    answer = sqrt((mssb - mssw) / nZero)
  }
  else
  {
    answer = sqrt(mssw / nZero) * (2 / (k(nZero-1)) )^(1/4)
  }
  
  return(answer)
}

doGetHomogeneity_relativeStandardUncertainty = function(data)
{
  if(is.null(data)) return(NA)
  
  u = doGetHomogeneity_standardUncertainty(data)
  xt = doGetHomogeneityGrandMean(data)
  answer = u/xt
  return(answer)
}

doGetHomogeneity_degreesOfFreedom = function(data)
{
  return(doGetHomogeneityNumOfValues(data) - 1)
}


