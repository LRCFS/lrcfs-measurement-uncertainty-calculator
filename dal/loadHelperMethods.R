removeEmptyData = function(df)
{
  #Remove NA rows
  if(ncol(df) > 1)
  {
    df = df[!apply(is.na(df) | df == "", 1, all),]
  }
  #Remove NA columns
  df = df[colSums(!is.na(df)) > 0]
  return(df)
}

loadCsv = function(filePath, validate, columnsToCheck)
{
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
      #Missing a line ending on the last line is a pretty common error so lets clean up the error message
      if(grepl("incomplete final line found by readTableHeader", e))
      {
        loadError <<- "Incomplete final line found. Please ensure that the last line of your CSV file is an empty line. This ensures that MUCalc knows it has correctly loaded your entire file."
      }
      else{
        loadError <<- e
      }
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
  
  for(column in names(columnsToCheck))
  {
    if(!hasName(data,column))
    {
      if(validate)
      {
        return(paste0("The file uploaded is missing the '",column,"' column.<br />",columnsToCheck[column],"<br />Please reference the associated example CSV file for this upload."))
      }
      else
      {
        return(NULL)
      }
    }
  }
  
  #If we're just validating and got this far then we have a good file. Return null (i.e. no error)
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
