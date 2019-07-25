numDecimalPlaces = 5

color1 = "#3FA5BE"
color2 = "#FCA311"
color3 = "#8E0554"
color4 = "#007A3D"
color5 = "#DD4B39"
color5 = "#DD4B39"
color6 = "#FF007F"

coverageFactorEffectiveDofTable = coverageFactorEffectiveDofReadCSV()

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

observe({
  #Using shinyjs to hide means that we see things flash on the screen on page load
  #Moved hiding process to /www/css/style.css
  # shinyjs::hide(selector = ".sidebar-menu li a[data-value=calibrationCurve]")
  # shinyjs::hide(selector = ".sidebar-menu li a[data-value=methodPrecision]")
  # shinyjs::hide(selector = ".sidebar-menu li a[data-value=standardSolution]")
  # shinyjs::hide(selector = ".sidebar-menu li a[data-value=sampleVolume]")
  # shinyjs::hide(selector = ".sidebar-menu li a[data-value=combinedUncertainty]")
  # shinyjs::hide(selector = ".sidebar-menu li a[data-value=coverageFactor]")
  # shinyjs::hide(selector = ".sidebar-menu li a[data-value=expandedUncertainty]")
  # shinyjs::hide(selector = ".sidebar-menu li a[data-value=dashboard]")
  # shinyjs::hide(selector = "#percentageExpandedUncertaintyStartPage")
})

observeEvent(input$intputCalibrationCurveFileUpload, {
  if(!is.null(input$intputCalibrationCurveFileUpload$datapath))
  {
    shinyjs::addClass(selector = ".sidebar-menu li a[data-value=calibrationCurve]", class="visible")
    checkIfShowResults()
  }
})

observeEvent(input$inputMethodPrecisionFileUpload, {
  if(!is.null(input$inputMethodPrecisionFileUpload$datapath))
  {
    shinyjs::addClass(selector = ".sidebar-menu li a[data-value=methodPrecision]", class="visible")
    checkIfShowResults()
  }
})

observeEvent(input$inputStandardSolutionStructureFileUpload, {
  if(!is.null(input$inputStandardSolutionStructureFileUpload$datapath) & !is.null(input$inputStandardSolutionEquipmentFileUpload$datapath))
  {
    shinyjs::addClass(selector = ".sidebar-menu li a[data-value=standardSolution]", class="visible")
    checkIfShowResults()
  }
})

observeEvent(input$inputStandardSolutionEquipmentFileUpload, {
  if(!is.null(input$inputStandardSolutionStructureFileUpload$datapath) & !is.null(input$inputStandardSolutionEquipmentFileUpload$datapath))
  {
    shinyjs::addClass(selector = ".sidebar-menu li a[data-value=standardSolution]", class="visible")
    checkIfShowResults()
  }
})

observeEvent(input$intputSampleVolumeFileUpload, {
  if(!is.null(input$intputSampleVolumeFileUpload$datapath))
  {
    shinyjs::addClass(selector = ".sidebar-menu li a[data-value=sampleVolume]", class="visible")
    checkIfShowResults()
  }
})

checkIfShowResults = function(){
  if(!is.null(input$intputCalibrationCurveFileUpload$datapath) ||
     !is.null(input$inputMethodPrecisionFileUpload$datapath) ||
     !is.null(input$inputStandardSolutionStructureFileUpload$datapath) ||
     !is.null(input$inputStandardSolutionEquipmentFileUpload$datapath) ||
     !is.null(input$intputSampleVolumeFileUpload$datapath))
  {
    shinyjs::addClass(selector = ".sidebar-menu li a[data-value=combinedUncertainty]", class="visible")
    shinyjs::addClass(selector = ".sidebar-menu li a[data-value=coverageFactor]", class="visible")
    shinyjs::addClass(selector = ".sidebar-menu li a[data-value=expandedUncertainty]", class="visible")
    shinyjs::addClass(selector = ".sidebar-menu li a[data-value=dashboard]", class="visible")
    
    #Add class to make it visible but also do a show to force rendering the display
    shinyjs::addClass(selector = "#percentageExpandedUncertaintyStartPage", class="visible")
    shinyjs::show(selector = "#percentageExpandedUncertaintyStartPage")
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