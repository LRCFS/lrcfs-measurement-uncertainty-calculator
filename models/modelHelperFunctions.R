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

removeEmptyData = function(df)
{
  #Remove NA rows
  df = df[!apply(is.na(df) | df == "", 1, all),]
  #Remove NA columns
  df = df[colSums(!is.na(df)) > 0]
  return(df)
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