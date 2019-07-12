numDecimalPlaces = 5

coverageFactorEffectiveDof = coverageFactorEffectiveDofReadCSV()

mathJaxAligned = function(formulas, lineSpacing = 20)
{
  # test = "$$\\begin{align}
  #   \\ x^2 &=  \\text{Chi-Squared} \\\\
  #   \\ sum &= \\text{summation} \\\\\\[100pt]
  #   \\ o &=  \\text{the observed values} \\\\
  #   \\ e &=  \\text{the expected values}
  #   \\end{align}$$"

  formulasOutput = ""
  for(element in formulas)
  {
    formulasOutput = paste("\\",formulasOutput, element,"\\\\[",lineSpacing,"pt]")
  }
  
  output = paste("$$\\begin{align}", formulasOutput, "\\end{align}$$")
  return(output)
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