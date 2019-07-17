coverageFactorEffectiveDofReadCSV = function() {
  filePath = "data/coverageFactorEffectiveDofTable.csv"
  
  data = read.csv(filePath, header = TRUE, sep=",", fill = TRUE, stringsAsFactors = FALSE, check.names=FALSE)
  rownames(data) = data[,1]

  return(data)
}
