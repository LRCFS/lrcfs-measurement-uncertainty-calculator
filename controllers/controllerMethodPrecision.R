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

doGetMethodPrecisionDataWithCalculations = function(allData, caseSampleReplicate, caseSampleMean){
  if(is.null(allData))
  {
    return(NULL)
  }
  
  uniqeConcentrations = getConcentrations(allData);

  #Create empty dataframe to return results
  calculationsData = data.frame(conc= numeric(0), run=character(0), mean=numeric(0), concMean=numeric(0), stdDev = numeric(0), dof = numeric(0), pooledVariance = numeric(0), pooledStdDeviation = numeric(0), stdUncertainty = numeric(0), relativeStdUncertainty = numeric(0))
  
  #For each concentration in the unique concentrations loaded from our data
  for(concentration in uniqeConcentrations)
  {
    ################################
    # Load the runs and get some basic info
    ################################
    
    #Get the data for just the one concentration
    dataForConcentration = allData[allData$conc == concentration,]
    
    #Remove "conc" (concentration column) for making calculations easier
    dataForConcentration$conc = NULL
    
    #Get the names of the runs (e.g. run1, run2, run3 etc)
    dataRuns = colnames(dataForConcentration)
    
    ################################
    # Do the calculations
    ################################
    
    #Calculate the means for each run
    dataMeans = colMeans(dataForConcentration, na.rm = TRUE)
    
    #Calculate the mean concentration for the nominal value (using the whole table for the conc to avoid issues with empty feilds)
    meanConcForNv = mean(as.matrix(allData[allData$conc==concentration,-1]),na.rm = TRUE)
    
    #Calculate the standard deveation for each concentration (using SD function and removing NA values)
    dataStdDev = apply(dataForConcentration, 2, function(x) sd(x, na.rm = TRUE))
    
    #Calculate the Degrees of Freedom for each concentration (using length function but removing NA values then removing 1 (this is how you get DOF))
    dataDof = apply(dataForConcentration, 2, calcMethodPrecisionDof)
    
    #pooledStandardDeviationNumerator
    dataPooledStandardDeviationNumerator = dataStdDev^2 * dataDof
    
    #Calculate the Pooled Variance
    dataPooledVariance = sum(dataStdDev^2 * dataDof, na.rm = TRUE)/sum(dataDof, na.rm = TRUE)
    
    #Calculate the Pooled Standard Deviation
    dataPooledStdDeviation = sqrt(dataPooledVariance)
    
    #Calculate the Standard Uncertainty
    dataStdUncertainty = dataPooledStdDeviation/sqrt(caseSampleReplicate)
    
    #Calculate the relative Standard Uncertainty
    dataRelativeStdUncertainty = dataStdUncertainty / meanConcForNv
    
    ################################
    # Append the data for return
    ################################
    
    #Full all the data in a dataframe
    calculationResults = data.frame("conc"= concentration, "run" = dataRuns, "mean" = dataMeans, "concMean" = meanConcForNv, "stdDev" = dataStdDev, "dof" = dataDof, "pooledStandardDeviationNumerator" = dataPooledStandardDeviationNumerator, "pooledVariance" = dataPooledVariance, "pooledStdDeviation" = dataPooledStdDeviation, "stdUncertainty" = dataStdUncertainty, "relativeStdUncertainty" =dataRelativeStdUncertainty)
    #Appened the result dataframe with the results from this concentrations calculations
    calculationsData = rbind(calculationsData, calculationResults)
  }
  
  return(calculationsData)
}

calcMethodPrecisionDof = function(value)
{
  result = length(which(!is.na(value)))
  if(result == 0)
  {
    return(NA)
  }
  else
  {
    return(result - 1)
  }
}

getMethodPrecisionFinalAnswerClosestConcentration = function(data, caseSampleMeanConcentration)
{
  if(is.na(caseSampleMeanConcentration))
  {
    return(NA)
  }
  
  #http://adomingues.github.io/2015/09/24/finding-closest-element-to-a-number-in-a-list/
  possibleConcentrations = getConcentrations(data)
  closestConc = which.min(abs(possibleConcentrations-caseSampleMeanConcentration))
  return(possibleConcentrations[closestConc])
}

getMethodPrecisionFinalAnswer = function(data, closestConcentration)
{
  getRealtiveStandardUncertainty(data,closestConcentration)
}

getMethodPrecisionDof = function(data, closestConcentration)
{
  answer = sum(data[data$conc==closestConcentration,]$dof)
  return(answer)
}

getPooledStandardDeviation = function(data, concentration){
  answer = data[data$conc==concentration,]$pooledStdDeviation[1]
  return(answer)
}

getStandardUncertainty = function(data, concentration){
  answer = data[data$conc==concentration,]$stdUncertainty[1]
  return(answer)
}

getRealtiveStandardUncertainty = function(data, concentration){
  answer = data[data$conc==concentration,]$relativeStdUncertainty[1]
  return(answer)
}

getConcentrations = function(data){
  return(unique(data$conc))
}

getNumberOfConcentrations = function(data){
  return(length(unique(data$conc)))
}

getNumberOfRuns = function(data){
  return(dim(data)[2]-1)
}

getSumDofForConcentration = function(data, concentration)
{
  answer = sum(data[data$conc==concentration,]$dof)
  return(answer)
}

#expects raw data rather than datacalc data.frame
getMeanConcForNv = function(data, concentration)
{
  answer = data[data$conc==concentration,-1]$concMean[1]
  return(answer)
}

getSumPooledStandardDeviationNumeratorForConcentration = function(data, concentration)
{
  answer = sum(data[data$conc==concentration,]$pooledStandardDeviationNumerator)
  return(answer)
}