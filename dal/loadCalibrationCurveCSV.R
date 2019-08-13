calibrationCurveReadCSV = function(filePath = NULL, validate = FALSE) {

  #Check the file being loaded isn't null
  if(is.null(filePath))
  {
    if(validate)
    {
      return("The file path specified was NULL. For this to happen something has gone massively wrong... Please contact the application author.")
    }
    else
    {
      return(NULL)
    }
  }
    
  #Check the file extension is CSV
  if(!str_detect(filePath,"(\\.csv|\\.CSV)$"))
  {
    if(validate)
    {
      return("The file specififed was not a .csv (comma seperated values) file.<br />Please ensure that the file you upload is a correctly named .csv file.")
    }
    else
    {
      return(NULL)
    }
  }
    
  #Check we can load the file specified
  loadError = NULL
  data = tryCatch(
    {
      data = read.csv(filePath, header = TRUE, sep=",", fill = TRUE, stringsAsFactors = FALSE)
      data = removeEmptyData(data)
    },
    error = function(e) {
      loadError <<- e
      return(NULL)
    },
    warning = function(e) {
      loadError <<- e
      return(NULL)
    }
  )
  if(!is.null(loadError))
  {
    if(validate)
    {
      startErrorMessage = "There was a problem loading or pasing your uploaded file:<strong><br />"
      endErrorMessage = "</strong><br />Please reference the associated example CSV file for this upload."
      loadError = paste(startErrorMessage,HTMLencode(loadError),endErrorMessage)
      return(loadError)
    }
    else
    {
      return(NULL)
    }
  }

  #Check data headers
  if(!hasName(data,"conc"))
  {
    if(validate)
    {
      return("The file uploaded is missing the 'conc' column.<br />Your data must contain information about the concentrations of each run.<br />Please reference the associated example CSV file for this upload.")
    }
    else
    {
      return(NULL)
    }
  }
  
  #if(!hasName(data,"run1"))
  #{
  #  if(validate)
  #  {
  #    return("The file uploaded is missing the 'run1' column.<br />Your data must contain at least one run.<br />Please reference the associated example CSV file for this upload.")
  #  }
  #  else
  #  {
  #    return(NULL)
  #  }
  #}
  
  #If we're just validating and got this far then we have a good file. Return null
  #Otherwise we return the data because it's good
  if(validate)
  {
    return(NULL)
  }
  else
  {
    return(data)
  }
}

#data = calibrationCurveReadCSV("D:\\Git\\lrcfs-measurement-of-uncertainty\\data\\calibrationCurve\\calibrationCurveSampleData.csv", TRUE);data


