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

#Takes any number and formats it in either scientific notation or rounded to a specified number of decimal places
#Can also handle a vector
formatNumberForDisplay = function(number, input = NULL)
{
  #If it's got a length then lets apply the whole function again to the vector
  if(length(number) > 1)
  {
    numbers = lapply(number, function(x) formatNumberForDisplay(x,input))
    numbers = unlist(numbers) #Unlist because datatable has problem with sorting lists
    return(numbers)
  }
  
  numberOfDecimalPlaces = 6
  useScientificNotationIfLessThan = 0.001
  numberOfScientificNotationDigits = 2
  
  if(!is.null(input))
  {
    numberOfDecimalPlaces = input$inputNumberOfDecimalPlaces
    useScientificNotationIfLessThan = input$inputUseScientificNotationIfLessThan
    numberOfScientificNotationDigits = input$intputNumberOfScientificNotationDigits
  }
    
  
  #Check if number is a factor (possibly a string) and just return as character
  if(is.factor(number))
    return(as.character(number))
  
  #If it's NULL, NA or not numeric then just return it
  if(is.null(number) | any(is.na(number)) | !is.numeric(number))
  {
     return(number)
  }

  #If it's 0 then just return 0
  if(number == 0)
  {
    formattedNumber = 0;
  }
  #If it's less than some value (e.g. 0.0001) then use scientific notation
  else if(abs(number) < useScientificNotationIfLessThan)
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



ColourCaseSampleReplicates = function(value,useColours)
{
  return(colourNumberBackground(value,caseSampleReplicatesColour,"#FFF", useColours))
}

ColourCaseSampleMeanConcentration = function(value,useColours)
{
  return(colourNumberBackground(value,caseSampleMeanConcentrationColour,"#FFF",useColours))
}

ColourCaseSampleMeanPeakAreaRatio = function(value,useColours)
{
  return(colourNumberBackground(value,caseSampleMeanParColour,"#FFF",useColours))
}

ColourCaseSampleWeight = function(value,useColours)
{
  return(colourNumberBackground(value,caseSampleWeightColour,"#FFF",useColours))
}

colourNumberBackground = function(value,colourBackgroundHex,colourForegroundHex,useColours)
{
  if(useColours)
  {
    return(paste0("\\bbox[",colourBackgroundHex,",2pt]{\\color{",colourForegroundHex,"}{",value,"}}"))
  }
  else
  {
    return(paste0(value))
  }
  
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