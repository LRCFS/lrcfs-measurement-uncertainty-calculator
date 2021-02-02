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

doGetSamplePreparation_standardUncerainty = function(data){
  numerator = data$equipmentCapacityTolerance
  denumerator = data$equipmentCoverage
  
  if(is.na(denumerator) | denumerator == "NA" | denumerator == "" | denumerator == 0)
  {
    denumerator = sqrt(3)
  }
  answer = numerator / denumerator
  
  return(answer)
}

doGetSamplePreparation_relativeStandardUncertainty = function(data)
{
  stdUnc = doGetSamplePreparation_standardUncerainty(data)
  
  answer = stdUnc / data$equipmentCapacity
  
  return(answer)
}


doGetSamplePreparation_result = function(data)
{
  if(is.null(data))
  {
    return(NA)
  }
  
  result = doGetSamplePreparation_relativeStandardUncertainty(data)
  answer = 0
  for(i in 1:nrow(data))
  {
    answer = answer + (result[i]^2 * data[i,]$equipmentTimesUsed)
  }
  answer = sqrt(answer)
  return(answer)
}