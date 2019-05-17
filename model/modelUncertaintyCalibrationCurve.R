getSqDevation = function(val){
  sqDevation = (val - mean(val))^2
  sqDevation = round(sqDevation, numDecimalPlaces)
  return(sqDevation)
}

getPredicetedY = function(x, y){
  calCurve = lm(y~x) # Regression Cofficients
  predictedY =  fitted(calCurve)
  predictedY = round(predictedY, numDecimalPlaces)
  return(predictedY)
}

getSlope = function(x,y){
  linearRegerssion = lm(y~x)
  slope <- coef(linearRegerssion)[2];
  slope = round(slope, numDecimalPlaces)
  return(slope)
}

getIntercept = function(x,y){
  linearRegerssion = lm(y~x)
  intercept = coef(linearRegerssion)[1]
  intercept = round(intercept, numDecimalPlaces)
  return(intercept)
}


getErrorSqDevationY = function(x, y){
  errorSqDevationY = (y - getPredicetedY(x, y))^2
  errorSqDevationY= round(errorSqDevationY, numDecimalPlaces)
  return (errorSqDevationY)
}

getDegreesOfFreedom = function(x){
  degressOfFreedom = length(x)-2
  degressOfFreedom = round(degressOfFreedom, numDecimalPlaces)
  return(degressOfFreedom)
}

getStandardErrorOfRegerssion = function(x, y){
  degreesOfFreedom = getDegreesOfFreedom(x);
  errorSumSqY = sum(getErrorSqDevationY(x,y))
  standardErrorOfRegerssion = sqrt(errorSumSqY/degreesOfFreedom)
  standardErrorOfRegerssion= round(standardErrorOfRegerssion, numDecimalPlaces)
  return(standardErrorOfRegerssion)
}

getUncertaintyOfCalibration = function(x, y, input)
{
  uncertaintyOfCalibration = (getStandardErrorOfRegerssion(x,y) / getSlope(x,y)) * (sqrt((1/input$inputCaseSampleReplicates)+(1/length(x))+(input$inputCaseSampleMeanConcentration-mean(x))^2 / sum(getSqDevation(x))))
  uncertaintyOfCalibration = round(uncertaintyOfCalibration, numDecimalPlaces)
  return(uncertaintyOfCalibration)
}

getRelativeStandardUncertainty = function(x,y,input){
  relativeStandardUncertainty = getUncertaintyOfCalibration(x,y,input) / input$inputCaseSampleMeanConcentration
  relativeStandardUncertainty = round(relativeStandardUncertainty, numDecimalPlaces)
  return(relativeStandardUncertainty)
}

numDecimalPlaces = 5
getUncertaintyOfCalibrationLatex = "$$u\\text{(CalCurve)} = \\frac{S_{y/x}}{b_1} \\sqrt{\\frac{1}{r_s} + \\frac{1}{n} + \\frac{(x_s - \\overline{x})^2}{S_{xx}} }$$"
getRelativeStandardUncertaintyLatex = "$$u_r\\text{(CalCurve)} = \\frac{u\\text{(CalCurve)}}{x_s}$$"

