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

#Calculate standard uncertainty and relative standard uncertainty of base solution
doGetStandardSolutionDataWithCalculations = function(solutionData, instrumentDataWithCalculations){
  if(is.null(solutionData))
  {
    return(NULL)
  }

  standardUncertainty = mapply(doGetStandardUncertaintySS, solutionData$compoundTolerance, solutionData$compoundCoverage)
  relativeStandardUncertainty = doGetRelativeStandardUncertaintySS(standardUncertainty, solutionData$compoundPurity)
  calculationResults = data.frame("standardUncertainty" = standardUncertainty, "relativeStandardUncertainty" = relativeStandardUncertainty)
  solutionDataWithCalculations = cbind(solutionData, calculationResults)
  
  #calculate realtive Standard Uncertainty For each Solution
  #Probably want to make this recursive to cope with any data order
  for(i in rownames(solutionDataWithCalculations))
  {
    if(is.na(solutionDataWithCalculations[i, "relativeStandardUncertainty"]))
    {
      realtiveStandardUncertaintyForSolution = doGetRealtiveStandardUncertaintyForSolution(solutionData[i, "solution"], solutionDataWithCalculations, instrumentDataWithCalculations)
      solutionDataWithCalculations[i, "relativeStandardUncertainty"] = realtiveStandardUncertaintyForSolution
    }
  }

  return(solutionDataWithCalculations)
}

doGetstandardSolutionInstrumentDataWithCalculations = function(measurementData){
  if(is.null(measurementData))
  {
    return(NULL)
  }
  
  standardUncertainty = mapply(doGetStandardUncertaintySS, measurementData$equipmentTolerance, measurementData$equipmentCoverage)
  relativeStandardUncertainty = doGetRelativeStandardUncertaintySS(standardUncertainty, measurementData$equipmentVolume)
  calculationResults = data.frame("standardUncertainty" = standardUncertainty, "relativeStandardUncertainty" = relativeStandardUncertainty)
  instrumentDataWithCalculations = cbind(measurementData, calculationResults)
  
  #Calculate the usage uncertainty
  usageUncertainty = doGetUsageUncertainty(instrumentDataWithCalculations)
  calculationResults = data.frame("usageUncertainty" = usageUncertainty)
  instrumentDataWithCalculations = cbind(instrumentDataWithCalculations, calculationResults)
  
  return(instrumentDataWithCalculations)
}

doGetBaseSolution = function(solutionDataWithCalculation)
{
  baseSolution = solutionDataWithCalculation[solutionDataWithCalculation$madeFrom == "",]
  return(baseSolution)
}

doGetFinalSolutions = function(solutionDataWithCalculations)
{
  finalSolutions = data.frame()
  
  for(i in rownames(solutionDataWithCalculations))
  {
    solutionName = solutionDataWithCalculations[i,"solution"]
    numRows = nrow(solutionDataWithCalculations[solutionDataWithCalculations$madeFrom == solutionName,])
    if(numRows == 0)
    {
      finalSolutions = rbind(finalSolutions, solutionDataWithCalculations[i,])
    }
  }
  return(finalSolutions)
}

doGetRelativeStandardUncertaintyOfCalibrationSolutions = function(calibrationSolutionsData)
{
  answer = sqrt(sum((calibrationSolutionsData$relativeStandardUncertainty)^2))
  return(answer)
}

doGetUsageUncertainty = function(instrumentDataWithCalculations)
{
  return((instrumentDataWithCalculations$relativeStandardUncertainty)^2 * instrumentDataWithCalculations$equipmentTimesUsed)
}

doGetRealtiveStandardUncertaintyForSolution = function(solutionName, solutionData, measurementData){

  madeFrom = solutionData[solutionData$solution == solutionName,]$madeFrom
  parentRelativeStandardUncertainty = solutionData[solutionData$solution == madeFrom,]$relativeStandardUncertainty

  instrumentData = measurementData[measurementData$solution == solutionName,]

  number = (parentRelativeStandardUncertainty)^2 + sum(instrumentData$usageUncertainty)
  number = sqrt(number)
  if(length(number) > 0)
  {
    return(number)
  }
  else
  {
    return(NA)
  }
}

doGetStandardUncertaintySS = function(numerator, denumerator = NA){
  if(is.na(denumerator) | denumerator == "NA" | denumerator == "" | denumerator == 0)
  {
    denumerator = sqrt(3)
  }
  stdUncertainty = numerator / denumerator
  return(stdUncertainty)
}

doGetRelativeStandardUncertaintySS = function(standardUncertainty, denumerator){
  relStdUncertainty = standardUncertainty / denumerator
  return(relStdUncertainty)
}