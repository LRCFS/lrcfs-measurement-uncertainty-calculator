standardSolutionReadCSV = function(filePathCompoundAndSolutionData = NULL) {
  
  if(is.null(filePathCompoundAndSolutionData))
  {
    filePathCompoundAndSolutionData = "data/standardSolution/standardSolutionSampleData-compoundAndSolutions.csv"
  }else{
    filePathCompoundAndSolutionData = filePathCompoundAndSolutionData #use filePathCompoundAndSolutionData$datapath (note add $DATAPATH no the end) if loading from file upload dialouge)
  }

  compoundAndSolutionData = read.csv(filePathCompoundAndSolutionData, header = TRUE, sep=",", fill = TRUE, stringsAsFactors = FALSE)

  return(compoundAndSolutionData)
}

standardSolutionMeasurementsReadCSV = function(filePathMeasurementInformation = NULL) {

  if(is.null(filePathMeasurementInformation))
  {
    filePathMeasurementInformation = "data/standardSolution/standardSolutionSampleData-measurementInformation.csv"
  }else{
    filePathMeasurementInformation = filePathMeasurementInformation #use filePathMeasurementInformation$datapath (note add $DATAPATH no the end) if loading from file upload dialouge)
  }
  
  measurementData = read.csv(filePathMeasurementInformation, header = TRUE, sep=",", fill = TRUE, stringsAsFactors = FALSE)

  return(measurementData)
}

standardSolutionMergeData = function(compoundAndSolutionData, measurementData) {
  
  mergedData = merge(x = compoundAndSolutionData, y = measurementData, by = "solution", all = TRUE, stringAsFactors = FALSE)
  #mergedData = mergedData[order(mergedData$sId),]

  return(mergedData)
}

standardSolutionBuildNetwork = function(compoundAndSolutionData) {
  
  solutionsRootNode = Node$new("Solutions")
  solutionsTree = buildTree(compoundAndSolutionData, solutionsRootNode)

  SetGraphStyle(solutionsTree, rankdir = "TB")
  SetEdgeStyle(solutionsTree, arrowhead = "vee", color = "black", penwidth = 2)
  SetNodeStyle(solutionsTree, style = "filled,rounded", shape = "box", fillcolor = "LightBlue", fontname = "helvetica", tooltip = GetDefaultTooltip)
  
  return(solutionsTree)
}

buildTree = function(compoundAndSolutionData, parentNode) 
{
  madeFrom = ""
  if(parentNode$name != "Solutions")
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