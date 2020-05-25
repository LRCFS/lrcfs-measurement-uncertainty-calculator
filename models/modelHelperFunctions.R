#Allows building of mathJax formulas that are aligned by creatign a vector of formulas
mathJaxAligned = function(formulas, lineSpacing = 20, breakingSpace = 50)
{
  formulasOutput = ""
  for(element in formulas)
  {
    if(endsWith(element, "[[break]]"))
    {
      element = str_remove(element,"\\[\\[break\\]\\]")
      formulasOutput = paste("\\",formulasOutput, element,"\\\\[",breakingSpace,"pt]")
    }
    else
    {
      formulasOutput = paste("\\",formulasOutput, element,"\\\\[",lineSpacing,"pt]")
    }
    
  }
  
  output = paste("$$\\begin{align}", formulasOutput, "\\end{align}$$")
  return(output)
}

#Takes any number and formats it in either scientific notation or rounded to a specififed number of decimal places
#Can also handle a vector
formatNumberForDisplay = function(number, input)
{
  #If it's got a length then lets apply the whole function again to the vector
  if(length(number) > 1)
  {
    numbers = lapply(number, function(x) formatNumberForDisplay(x,input))
    numbers = unlist(numbers) #Unlist because datatable has problem with sorting lists
    return(numbers)
  }
  
  numberOfDecimalPlaces = input$inputNumberOfDecimalPlaces
  useScientificNotationIfLessThan = input$inputUseScientificNotationIfLessThan
  numberOfScientificNotationDigits = input$intputNumberOfScientificNotationDigits
  
  #Check if number is a factor (possibly a string) and just return as character
  if(is.factor(number))
    return(as.character(number))
  
  #If it's NULL, NA or not numeric then just return it
  if(is.null(number) | is.na(number) | !is.numeric(number))
  {
     return(number)
  }

  #If it's 0 then just return 0
  if(number == 0)
  {
    formattedNumber = 0;
  }
  #If it's less thant some value (e.g. 0.0001) then use scientific notation
  else if(number < useScientificNotationIfLessThan)
  {
    formattedNumber = formatC(number, format = "e", digits = numberOfScientificNotationDigits)
  }
  #Else, lets round the number
  else
  {
    formattedNumber = round(number, numberOfDecimalPlaces)
  }
  
  return(formattedNumber)
}

colourNumber = function(value, useColour, colour)
{
  if(useColour)
  {
    return(paste0("\\color{",colour,"}{",value, "}"))
  }
  else
  {
    return(value)
  }
}



colourCaseSampleReplicates = function(value)
{
  return(colourNumberBackground(value,caseSampleReplicatesColour,"#FFF"))
}

ColourCaseSampleMeanConcentration = function(value)
{
  return(colourNumberBackground(value,caseSampleMeanConcentrationColour,"#FFF"))
}

colourNumberBackground = function(value,colourBackgroundHex,colourForegroundHex)
{
  return(paste0("\\bbox[",colourBackgroundHex,",2pt]{\\color{",colourForegroundHex,"}{",value,"}}"))
}

# library(latex2exp)
# library(stringr)
# printLatexFormula = function(latex, calc, variables){
#   
#   # latex = "z = $$x$$ * $$y$$"
#   # calc = "$$x$$ * $$y$$";
#   # variables = data.frame("\\sum\\limits_{i=1}^n(y_i-\\hat{y}_i)^2" = 5, "$$n-2$$" = 3)
#   
#   latexOutput = latex
#   for(colName in names(variables))
#   {
#     regexString = paste0("(\\$\\$",colName,"\\$\\$)");
#     latexOutput = str_replace_all(latexOutput, regexString, colName)
#   }
#   latexOutput = paste0("$$",latexOutput,"$$")
#   
#   latexWithSubs = latex
#   for(colName in names(variables))
#   {
#     regexString = paste0("(\\$\\$",colName,"\\$\\$)");
#     latexWithSubs = str_replace_all(latexWithSubs, regexString, as.character(variables[,colName]))
#     print(colName)
#   }
#   latexWithSubs = paste0("$$",latexWithSubs,"$$")
#   
#   calcSubs = calc
#   for(colName in names(variables))
#   {
#     regexString = paste0("(\\$\\$",colName,"\\$\\$)");
#     calcSubs = str_replace_all(calcSubs, regexString, as.character(variables[,colName]))
#   }
#   calcSubs
# 
#   answer = eval(parse(text=calcSubs))
#   answer
#   
#   output = data.frame("latex" = latexOutput, "latexWithSubs" = latexWithSubs, "answer" = answer)
#     
#   return(output)
# }