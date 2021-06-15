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

tabCalibrationCurveQuadratic = tabItem(tabName = "calibrationCurveQuadratic",
                                       fluidRow(
                                         valueBox("Uncertainty of Calibration Curve (Quadratic Fit)", h2(textOutput("display_calibrationCurveQuadratic_finalAnswer_top")), width = 12, color = "blue", icon = icon("chart-line")),
                                         actionButton("helpCalibrationCurveQuadratic", "Help", icon=icon("question"), class="pageHelpTop")
                                       ),
                                       fluidRow(
                                         box(title = "Overview", width=6, class="calcOverflow",
                                             p("All computations and details of formulas used for computing the uncertainty of the calibration curve are displayed here. A quadratic fit has been applied on the uploaded data."),
                                             p("The Method tab shows the main formulas used to compute the quadratic uncertainty of the calibration curve."),
                                             p("When using a quadratic fit currently it is not possible to specify weights for the regression model."),
                                             p("Where a linear fit is required, please return to the start page and upload your data in the \"Linear Fit\" tab."),
                                             h4("Background"),
                                             p(HTML("For a general function \\(X=f(x_1,x_2,\\ldots,x_n)\\), the variance \\(Var(X)\\) by <a href=\"https://en.wikipedia.org/wiki/Taylor's_theorem\" target='_blank' title=\"Taylor's theorem\">Taylor's theorem</a> (first-order expansion) is given by:")),
                                             ("\\(\\displaystyle Var(X) =
                                                 \\left(\\frac{\\partial X}{\\partial x_1}\\right)^2 Var(x_1) +
                                                 \\left(\\frac{\\partial X}{\\partial x_2}\\right)^2 Var(x_2) + \\ldots +
                                                 \\left(\\frac{\\partial X}{\\partial x_n}\\right)^2 Var(x_n) + \\\\
                                                 \\displaystyle \\hspace{3em} 
                                                 2\\left(\\frac{\\partial X}{\\partial x_1}\\right) \\left(\\frac{\\partial X}{\\partial x_2}\\right) Cov(x_1,x_2) +
                                                 2\\left(\\frac{\\partial X}{\\partial x_1}\\right) \\left(\\frac{\\partial X}{\\partial x_3}\\right) Cov(x_1,x_3) +
                                                 \\ldots
                                               \\)"),
                                             p(HTML("&nbsp;")),
                                             p(HTML("Using the approach described by <a href='https://doi.org/10.1039/B615398D' title='The uncertainty of a result from a linear calibration' target='_blank'>D. Brynn Hibbert: The uncertainty of a result from a linear calibration (2006)</a>, a quadratic  model of the form \\(y=b_0 + b_1x + b_2x^2\\) can be rewritten as \\(y - \\overline{y} = b_1(x-\\overline{x}) + b_2(x^2 - \\overline{x^2})\\) to make the curve start from the origin. Doing this removes the covariance dependence of \\(b_0\\) with \\(b_1\\) and \\(b_2\\).")),
                                             p("Given an instrument response of case sample peak area ratio \\(y_s\\), the level of concentration \\(x_s\\) is estimated by solving for \\(x\\) as:"),
                                             p("\\( \\displaystyle \\hat{x_s} = \\frac{ -b_1 \\sqrt{ b_1^2-4b_2( \\overline{y}-y_s-b_1 \\overline{x}-b_2 \\overline{x^2}) } } {2b_2} \\)"),
                                             p("The standard uncertainty \\(u\\text{(CalCurve)}\\) is then obtained by apply Taylor's theorem to the variance of \\(\\hat{x}_s\\)."),
                                         ),
                                         box(title = "Method", width=6, class="calcOverflow",
                                             p(HTML("Using the approach described in <a href='https://doi.org/10.1039/B615398D' title='The uncertainty of a result from a linear calibration' target='_blank'>D. Brynn Hibbert: The uncertainty of a result from a linear calibration (2006)</a> the uncertainty of the quadratic curve is given by:")),
                                             p("\\(\\displaystyle u\\text{(CalCurve)}^2 =
                                                 \\left(\\frac{\\partial \\hat{x_s}}{\\partial b_1}\\right)^2 Var(b_1) +
                                                 \\left(\\frac{\\partial \\hat{x_s}}{\\partial b_2}\\right)^2 Var(b_2) +
                                                 \\left(\\frac{\\partial \\hat{x_s}}{\\partial \\overline{y}}\\right)^2 Var(\\overline{y}) + \\\\
                                                 \\displaystyle \\hspace{3em}\\left(\\frac{\\partial \\hat{x_s}}{\\partial y_s}\\right)^2 Var(y_s) +
                                                 2\\left(\\frac{\\partial \\hat{x_s}}{\\partial b_1}\\right) \\left(\\frac{\\partial \\hat{x_s}}{\\partial b_2}\\right) Cov(b_1,b_2)\\)"),
                                             p(HTML("<strong>Note:</strong> As described in the overview, this formula removes the covariance dependency of \\(b_0\\) with the other parameters \\(b_1\\) and \\(b_2\\) by making the model start from the origin <a href='https://doi.org/10.1039/B615398D' title='The uncertainty of a result from a linear calibration' target='_blank'>[Pg. 4/5 - D. Brynn Hibbert (2006)]</a>.")),
                                             p("The Relative Standard Uncertainty is then given by:"),
                                             p("\\(\\displaystyle u_r\\text{(CalCurve)} = \\frac{u\\text{(CalCurve)}}{x_s}\\)"),
                                             p("The partial derivatives is obtained by differentiating the equation below with respect to \\(b_1, b_2, \\overline{y}, y_0\\)"),
                                             p("\\(\\displaystyle\\hat{x_s} = \\frac{-b_1\\sqrt{b_1^2-4b_2(\\overline{y}-y_s-b_1\\overline{x}-b_2\\overline{x^2})}}{2b_2}\\)"),
                                             p(HTML("<strong>Note:</strong> It is assumed that the regression parameters are independent and that \\(Var(\\overline{x}) = 0\\) and \\(Var(\\overline{x^2}) = 0\\).")),
                                             p("The Covariance Matrix for \\(Var(b_1)\\), \\(Var(b_2)\\) and \\(Cov(b_1,b_2)\\) can be estimated as:"),
                                             p("\\(\\sigma^2(\\underline{X}^T\\underline{X})^{-1} = 
                                                \\begin{Bmatrix}
                                                Var(b_0) & Cov(b_0,b_1) & Cov(b_0,b_2) \\\\
                                                Cov(b_0,b_1) & Var(b_1) & Cov(b_1,b_2) \\\\
                                                Cov(b_0,b_2) & Cov(b_1,b_2) & Var(b_2) \\\\
                                                \\end{Bmatrix}\\)"),
                                             p("where \\(\\sigma^2\\) is the variance of \\(y\\) estimated by the Standard Error of Regression squared \\(S_{y/x}^2\\):"),
                                             p("\\(\\displaystyle S_{y/x} = \\sqrt{\\frac{\\sum\\limits_{i=1}^n (y_i-\\hat{y}_i)^2}{n-3}}\\)"),
                                             tags$ul(
                                               tags$li("\\(x_i\\) concentration at level \\(i\\)."),
                                               tags$li("\\(x_s\\) is the mean concentration of the Case Sample."),
                                               tags$li("\\(r_s\\) is the number of replicates made on test sample to determine \\(x_s\\)."),
                                               tags$li("\\(y_i\\) observed peak area ratio for a given concentration \\(x_i\\)."),
                                               tags$li("\\(\\hat{y}_i\\) predicted value of \\(y\\) for a given value \\(x_i\\)."),
                                               tags$li("\\(b_1\\) is the Slope of the of regression line."),
                                               tags$li("\\(y_s\\) is the mean of Peak Area Ratio of the Case Sample."),
                                               tags$li("\\(n\\) is the number of measurements used to generate the Calibration Curve."),
                                               tags$li("\\(\\overline{x}\\) is the mean values of the different calibration standards."),
                                               tags$li("\\(Var(\\overline{y})\\) is the variance of the mean of \\(y\\), given as: \\(\\frac{S_{y/x}^2}{n}\\)."),
                                               tags$li("\\(Var(y_s)\\) is the variance of the mean of Case Sample Peak Area Ratios \\((y_s)\\), given as:  \\(\\frac{S_{y/x}^2}{r_s}\\)"),
                                             )
                                         )
                                       ),
                                       fluidRow(
                                         tabBox(width=12, side="right",
                                                title = uiOutput("display_calibrationcurveQuadratic_rawDataStats"),
                                                tabPanel("Graph",
                                                         plotlyOutput("display_calibrationcurveQuadratic_rawDataGraph")
                                                ),
                                                tabPanel("Raw Data",
                                                         DT::dataTableOutput("display_calibrationcurveQuadratic_rawData")
                                                )
                                         )
                                       ),
                                       fluidRow(
                                         infoBox(HTML("Case Sample<br />Replicates \\((r_s)\\)"),HTML(paste(uiOutput("display_calibrationCurveQuadratic_replicates"))), width=4, icon=icon("vials"), color="aqua"),
                                         infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_calibrationCurveQuadratic_meanConcentration"))), width=4, icon=icon("map-marker"), color="fuchsia"),
                                         infoBox(HTML("Case Sample<br />Mean Peak Area Ratio\\((y_s)\\)"),HTML(paste(uiOutput("display_calibrationCurveQuadratic_meanPeakAreaRatio"))), width=4, icon=icon("chart-bar"), color="orange")
                                       ),
                                       fluidRow(
                                         box(title="Calculations", width = 12, class="calcOverflow",
                                             DT::dataTableOutput('display_calibrationcurveQuadratic_rearrangedData')
                                         ),
                                         box(title="Quadratic Regression", width = 3, class="calcOverflow",
                                             uiOutput("display_calibrationcurveQuadratic_quadraticRegression")
                                         ),
                                         box(title="Standard Error of Regression \\((S_{y/x})\\)", width = 3, class="calcOverflow",
                                             uiOutput("display_calibrationCurveQuadratic_standardErrorOfRegression")
                                         ),
                                         box(title="Variance of \\(y_s\\)", width = 3, class="calcOverflow",
                                             uiOutput("display_calibrationCurveQuadratic_variancePeakAreaRatio")
                                         ),
                                         box(title="Variance of \\(\\overline{y}\\)", width = 3, class="calcOverflow",
                                             uiOutput("display_calibrationCurveQuadratic_varianceMeanOfY")
                                         )
                                       ),
                                       fluidRow(
                                         box(title="Deriving Partial Derivatives", width = 12,
                                             p("The partial derivatives is obtained by differentiating the equation below with respect to \\(b_1, b_2, \\overline{y}, y_0\\)"),
                                             p("\\(\\displaystyle\\hat{x_s} = \\frac{-b_1\\sqrt{b_1^2-4b_2(\\overline{y}-y_s-b_1\\overline{x}-b_2\\overline{x^2})}}{2b_2}\\)"),
                                             p(HTML("&nbsp;")),
                                             box(width = 12, class="calcOverflow",
                                               p("For simplicity let discriminant \\((D)\\) be equal to:"),
                                               uiOutput("display_calibrationCurveQuadratic_discriminant")
                                             ),
                                             box(width = 3, class="calcOverflow",
                                                 uiOutput("display_calibrationCurveQuadratic_partialDerivativeMeanOfY")
                                             ),
                                             box(width = 3, class="calcOverflow",
                                                 uiOutput("display_calibrationCurveQuadratic_partialDerivativeCaseSampleMeanPeakAreaRatio")
                                             ),
                                             box(width = 6, class="calcOverflow",
                                                 uiOutput("display_calibrationCurveQuadratic_partialDerivativeSlope1")
                                             ),
                                             box(width = 12, class="calcOverflow",
                                                 uiOutput("display_calibrationCurveQuadratic_partialDerivativeSlope2")
                                             ),
                                         )
                                       ),
                                       fluidRow(
                                         box(title="Deriving Covariance Matrix", width = 12,
                                             p("The covariance matrix \\(S_{y/x}^2(\\underline{X}^T\\underline{X})^{-1}\\) is derived by taking a transpose of the design matrix and then multiplying it by the design matrix, after which an inverse is taken and multiplied by the variance \\(S_{y/x}^2\\)."),
                                             box(title="Design Matrix", width = 3, class="calcOverflow",
                                                 uiOutput("display_calibrationCurveQuadratic_designMatrix")
                                             ),
                                             box(title="Design Matrix Transposed", width = 9, class="calcOverflow",
                                                 uiOutput("display_calibrationCurveQuadratic_designMatrixTransposed")
                                             ),
                                             box(title="Multiply", width = 9, class="calcOverflow",
                                                 uiOutput("display_calibrationCurveQuadratic_designMatrixMultiply")
                                             ),
                                             box(title="Inverse", width = 9, class="calcOverflow",
                                                 uiOutput("display_calibrationCurveQuadratic_designMatrixMultiplyInverse")
                                             ),
                                             box(title="Covariance Matrix", width = 9, class="calcOverflow",
                                                 uiOutput("display_calibrationCurveQuadratic_covarianceMatrix")
                                             )
                                         )
                                       ),
                                       fluidRow(
                                         box(title="Uncertainty of Calibration \\((u)\\)", width = 12, class="calcOverflow",
                                             uiOutput("display_calibrationCurveQuadratic_uncertaintyOfCalibration")
                                         )
                                       ),
                                       fluidRow(
                                         box(title="Relative Standard Uncertainty \\((u_r)\\)", width = 12, background = "blue", solidHeader = TRUE,
                                             uiOutput("display_calibrationCurveQuadratic_finalAnswer_bottom")
                                         )
                                       )

)