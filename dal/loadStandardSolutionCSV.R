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

standardSolutionReadCSV = function(filePath = NULL, validate = FALSE) {
  
  #The columns that the data should have
  columnsToCheck = list("solution" = "Your data must contain...",
                        "madeFrom" = "Your data must contain...",
                        "compoundPurity" = "Your data must contain...",
                        "compoundTolerance" = "Your data must contain...",
                        "compoundCoverage" = "Your data must contain...")
  
  return(loadCsv(filePath, validate, columnsToCheck))
}

standardSolutionMeasurementsReadCSV = function(filePath = NULL, validate = FALSE) {
  
  #The columns that the data should have
  columnsToCheck = list("solution" = "Your data must contain...",
                        "equipment" = "Your data must contain...",
                        "equipmentVolume" = "Your data must contain...",
                        "equipmentTolerance" = "Your data must contain...",
                        "equipmentCoverage" = "Your data must contain...",
                        "equipmentTimesUsed" = "Your data must contain...")
  
  return(loadCsv(filePath, validate, columnsToCheck))
}

standardSolutionMergeData = function(compoundAndSolutionData, measurementData) {
  
  mergedData = merge(x = compoundAndSolutionData, y = measurementData, by = "solution", all = TRUE, stringAsFactors = FALSE)

  return(mergedData)
}

standardSolutionBuildNetwork = function(compoundAndSolutionData) {
  
  solutionsRootNode = Node$new("Spiking Solution")
  solutionsTree = buildTree(compoundAndSolutionData, solutionsRootNode)

  SetGraphStyle(solutionsTree, rankdir = "TB")
  SetEdgeStyle(solutionsTree, arrowhead = "vee", color = "black", penwidth = 2)
  SetNodeStyle(solutionsTree, style = "filled,rounded", shape = "box", fillcolor = StandardSolutionColor, fontname = "helvetica", tooltip = GetDefaultTooltip)
  
  return(solutionsTree)
}

buildTree = function(compoundAndSolutionData, parentNode) 
{
  madeFrom = ""
  if(parentNode$name != "Spiking Solution")
  {
    madeFrom = parentNode$name
  }

  solutions = compoundAndSolutionData[compoundAndSolutionData$madeFrom == madeFrom,]
  if(nrow(solutions)>0)
  {
    for(i in 1:nrow(solutions))
    {
      thisNode = parentNode$AddChild(solutions[i,"solution"])
      buildTree(compoundAndSolutionData, thisNode)
      i = i + 1
    }
    return(parentNode)
  }
}
