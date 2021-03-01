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

getEffectiveDegreesOfFreedom = function(uncHomogeneity,dofHomogeneity,uncCalibrationCurve,dofCalibrationCurve,uncMethodPrecision,dofMethodPrecision,uncStandardSolution,dofStandardSolution,uncSamplePreparation,dofSamplePreparation,combinedUncertainty, meanCaseSampleConcentration)
{
  dofCu = (combinedUncertainty / meanCaseSampleConcentration)^4
  
  dofHo = uncHomogeneity^4 / dofHomogeneity
  dofCc = uncCalibrationCurve^4 / dofCalibrationCurve
  dofMp = uncMethodPrecision^4 / dofMethodPrecision
  dofSs = uncStandardSolution^4 / dofStandardSolution
  dofSv = uncSamplePreparation^4 / dofSamplePreparation
  dofSum = sum(dofHo, dofCc, dofMp, dofSs, dofSv, na.rm = TRUE)
  
  calc = dofCu / dofSum
  
  return(calc)
}


getHighestPossibleDofInCoverageFactorEffectiveDof = function(coverageFactorEffectiveDof)
{
  possibleDofs = coverageFactorEffectiveDof$EffectiveDoF
  maxPossibleDof = sort(possibleDofs, decreasing = TRUE)[2] #Sort the numbers then take the second highest value (as the highest is going to be the infinite value)
  return(maxPossibleDof)
}

getClosestCoverageFactorEffectiveDof = function(coverageFactorEffectiveDof, effectiveDof){
  
  highestPossibleDof = getHighestPossibleDofInCoverageFactorEffectiveDof(coverageFactorEffectiveDof)
  
  closestDof = 0
  if(is.na(effectiveDof))
  {
    closestDof = NA
  }
  else if(effectiveDof < 1)
  {
    closestDof = 1
  }
  else if(effectiveDof > highestPossibleDof)
  {
    closestDof = Inf
  }
  else
  {
    for(dof in rownames(coverageFactorEffectiveDof))
    {
      if(abs(as.numeric(dof) - effectiveDof) < abs(closestDof - effectiveDof))
      {
        closestDof = as.numeric(dof)
      }
    }
  }
  
  return(as.character(closestDof))
}

getCoverageFactor = function(coverageFactorEffectiveDof, effectiveDof, confidenceInterval, manualCoverageFactor){
  if(usingManualCoverageFactor()) return(manualCoverageFactor)
  
  closestDof = getClosestCoverageFactorEffectiveDof(coverageFactorEffectiveDof, effectiveDof)
  
  if(is.na(closestDof))
  {
    return(NA)
  }
  else
  {
    result = coverageFactorEffectiveDof[as.character(closestDof),confidenceInterval]
    return(result)
  }
}