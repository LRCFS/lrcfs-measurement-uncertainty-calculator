standardSolutionReadCSV = function(filePath = NULL, validate = FALSE) {
  
  #The columns that the data should have
  columnsToCheck = list("solution" = "Your data must contain...",
                        "madeFrom" = "Your data must contain...",
                        "compoundPurity" = "Your data must contain...",
                        "compoundTolerance" = "Your data must contain...",
                        "compoundCoverage" = "Your data must contain...")
  
  return(loadCsv(filePath, validate, columnsToCheck))
}
#data = standardSolutionReadCSV("D:\\Git\\lrcfs-measurement-of-uncertainty\\data\\standardSolution\\standardSolutionSampleData-compoundAndSolutions.csv", TRUE);data

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
#data = standardSolutionMeasurementsReadCSV("D:\\Git\\lrcfs-measurement-of-uncertainty\\data\\standardSolution\\standardSolutionSampleData-measurementInformation.csv");data






standardSolutionMergeData = function(compoundAndSolutionData, measurementData) {
  
  mergedData = merge(x = compoundAndSolutionData, y = measurementData, by = "solution", all = TRUE, stringAsFactors = FALSE)
  #mergedData = mergedData[order(mergedData$sId),]

  return(mergedData)
}

standardSolutionBuildNetwork = function(compoundAndSolutionData) {
  
  solutionsRootNode = Node$new("Spiking Solution")
  solutionsTree = buildTree(compoundAndSolutionData, solutionsRootNode)

  SetGraphStyle(solutionsTree, rankdir = "TB")
  SetEdgeStyle(solutionsTree, arrowhead = "vee", color = "black", penwidth = 2)
  SetNodeStyle(solutionsTree, style = "filled,rounded", shape = "box", fillcolor = "LightBlue", fontname = "helvetica", tooltip = GetDefaultTooltip)
  
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