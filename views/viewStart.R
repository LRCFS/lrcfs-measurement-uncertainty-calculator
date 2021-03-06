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

tabStart = tabItem(tabName = "start",
                   fluidRow(
                     column(width=12,
                            box(title=paste0("Welcome to ",APP_NAME_SHORT), width=12,
                                p(paste0("The ",APP_DEV," ",APP_NAME," (",APP_NAME_SHORT,") is an application for calculating measurement uncertainty in accordance with the standards of International Organization for Standardization ISO/IEC 17025.")),
                                p(paste0("This version (v",APP_VER,") of the software computes uncertainty components for Homogeneity, Method Precision, Calibration Standard, Sample Volume and Calibration Curve with the Calibration Curve assumed to be linear. If data is uploaded for all components, the Combined Uncertainty is computed using all components. An uncertainty component can be excluded from the Combined Uncertainty by simply not uploading any data for that component.")),
                                p("Once data is uploaded, a step by step computation and details of all formulas used can be accessed by clicking on the respective uncertainty component tab displayed at the left hand side of the screen. Each uncertainty component has three main tabs; Overview, Method and Step by Step Calculations. Together these give more detailed information about the approach used."),
                                p("Additionally a Homogeneity Test details calculation for testing whether there is a statistically significant difference between group means of samples using a one-way analysis of variance (ANOVA)."),
                                actionButton("help_start_start", "Help", icon=icon("question"))
                            )
                     )
                   ),
                   fluidRow(id="fileUploadBox",
                            column(width=12,
                                   tabBox(width=12,
                                          tabPanel(title="Getting Started",
                                                   h4("Upload Your Data"),
                                                   p("Each uncertainty component is calculated using the data supplied in the above tabs; Homogeneity, Calibartion Curve etc."),
                                                   p("Select each tab at the top of this box to specify your data for each component. As a minimum, you are required to upload data for at least ONE component, but any and all combinations of these components can be used."),
                                                   h4("Getting Your Result"),
                                                   p("Once you have uploaded your data, a tab will appear in the left hand menu so you can review the calculations for that specific component and the individual relative standard uncertainty."),
                                                   p("To calculate an overall uncertainty, even for one compoent, you must also specify the Case Sample Replicates, Mean Concentration and Coverage Factor; either as a Confidence Level or an explicity defined Coverage Factor."),
                                                   p("Your result will then be diaplyed at the bottom of this page and updated automatically as additional uncertainty components are added or additional data is modified.")
                                          ),
                                          tabPanel(title="Homogeneity",
                                                   fluidRow(
                                                     column(width=6,
                                                            div(id="homogeneity",
                                                                h4("Upload Homogeneity Data"),
                                                                a("Download Example Homogeneity CSV", href="exampleData/exampleData-homogeneity.csv", target="_blank", class="exampleDownloadLink"),
                                                                uiOutput("display_start_homogeneityFileUpload"),
                                                                div("Error with uploaded file...", class="error", id="display_start_error_homogeneityFileUpload"),
                                                                actionButton("reset_inputHomogeneityFileUpload", "Remove Homogeneity Data", icon=icon("times"))
                                                            )
                                                     ),
                                                     column(width=6,
                                                            h4("About Homogeneity"),
                                                            p("The Homogeneity data specified here can be used for both Measurement Uncertainty and a Homogeneity Test. Both calculations are capable of handling data without an identical number of replicates per group.")
                                                     )
                                                   )
                                          ),
                                          tabPanel(title="Calibration Curve",
                                                   fluidRow(
                                                     tabBox(width= 12,
                                                       tabPanel(title="Linear Fit",
                                                         fluidRow(
                                                           column(width=6,
                                                                  h4("Upload Calibration Curve Data"),
                                                                  a("Download Example Calibration Curve CSV", href="exampleData/exampleData-calibrationCurve.csv", target="_blank", class="exampleDownloadLink"),
                                                                  uiOutput("display_start_calibrationCurveFileUpload"),
                                                                  div("Error with uploaded file...", class="error", id="display_start_error_calibrationCurveFileUpload"),
                                                                  a("Download Pooled Standard Error CSV", href="exampleData/exampleData-calibrationCurve-pooledStandardError.csv", target="_blank", class="exampleDownloadLink"),
                                                                  uiOutput("display_start_externalStandardErrorFileUpload"),
                                                                  div("Error with uploaded file...", class="error", id="display_start_error_externalStandardErrorFileUpload"),
                                                                  actionButton("reset_inputCalibrationCurveFileUpload", "Remove Calibration Curve Data", icon=icon("times")),
                                                                  div(class="clear"),
                                                                  hr()
                                                           ),
                                                           column(width=6,
                                                                  h4("About Calibartion Curve"),
                                                                  p("Calibration curve data is data on concentration levels and peak area (ratios) used to generate the calibration for estimating the level of concentration in a given new sample."),
                                                                  p(HTML("<br />")),
                                                                  h4("About Pooled Standard Error"),
                                                                  p("In place of the standard error of regression, standard error from previous calibration curve data can be pooled together with current calibration data to obtain a more reliable estimate. This is recommended if calibration curve data uploaded above have only one replicate or is based on single point calibration system.")
                                                           )
                                                         ),
                                                         fluidRow(
                                                           column(width=6,
                                                                  h4("Weighted Least Squares (WLS) Regression"),
                                                                  p("To fit a weighted least squares (WLS) regression, the default weight of \\(W = 1\\) must be changed. A weight of \\(W = 1\\) implies an ordinary linear regression with no weights applied. The following weight options are currently available:"),
                                                                  p("\\(W = \\frac{1}{x}, \\frac{1}{x^2},\\frac{1}{y}\\), \\(\\frac{1}{y^2}\\) or you can \"specify custom weights\"."),
                                                                  p("Select a weight option to be applied to the model if a WLS regression is required. Note that a default weight of \\(1\\) results in a simple linear regression with no weighting."),
                                                                  selectizeInput("inputWeightLeastSquared", "Weight \\((W)\\):",
                                                                                 c("Default (1)" = 1,
                                                                                   "Concentraion (1/x)" = 2,
                                                                                   "Concentraion Squared (1/x\U00B2)" = 3,
                                                                                   "Peak Area (1/y)" = 4,
                                                                                   "Peak Area Squared (1/y\U00B2)" = 5,
                                                                                   "Specify custom Weights..." = 999)),
                                                                  uiOutput("display_start_customWlsFileUploadExampleDownloadLink"),
                                                                  uiOutput("display_start_customWlsFileUpload"),
                                                                  uiOutput("display_start_customWlsFileUploadErrorDiv"),
                                                                  uiOutput("display_start_customWlsPooledFileUploadExampleDownloadLink"),
                                                                  uiOutput("display_start_customWlsPooledFileUpload"),
                                                                  uiOutput("display_start_customWlsPooledFileUploadErrorDiv"),
                                                                  uiOutput("display_start_customWlsFileUploadRemoveDataButton"),
                                                                  div(class="clear")
                                                           ),
                                                           column(width=6,
                                                                  h4("About Weighted Least Square (WLS) Regression"),
                                                                  img(src="images/wls-help.png", width="100%", class="wlsHelpImage", title="Example plot showing the presence of heteroscedasticity"),
                                                                  p(HTML("WLS is recommend if the standard deviation of data correlates with the magnitude of the concentration being estimated, such that plot of residuals shows a non-constant error (termed heteroscedasticity).")),
                                                                  p(HTML("Figure from <a href='https://pdfs.semanticscholar.org/5814/151283d2b44412edfb8ae5a9d3e53616fa32.pdf' target='_blank'>Regression and Calibration (2001)</a> shows an example of where the standard deviation of data is proportional to the magnitude concentration (a) such that the plot of residuals have high variability for high predicted values. For more information on choosing the appropriate weight see the paper by <a href='https://pubs.acs.org/doi/pdf/10.1021/ac5018265'>Huidong Gu et al (2014)</a>.")),
                                                                  p(HTML("Alternatively, if 'Specify custom Weights' is chosen, a file containing specific weights can be specified for both Calibartion Curve and Pooled Standard Error.")),
                                                                  
                                                           )
                                                         )
                                                       ),
                                                       tabPanel(title="Quadratic Fit",
                                                                fluidRow(
                                                                  column(width=6,
                                                                         h4("Upload Quadratic Calibration Curve Data"),
                                                                         a("Download Example Quadratic Calibration Curve CSV", href="exampleData/exampleData-calibrationCurve-quadratic.csv", target="_blank", class="exampleDownloadLink"),
                                                                         uiOutput("display_start_calibrationCurveQuadraticFileUpload"),
                                                                         div("Error with uploaded file...", class="error", id="display_start_error_calibrationCurveQuadraticFileUpload"),
                                                                         actionButton("reset_inputCalibrationCurveQuadraticFileUpload", "Remove Calibration Curve Data", icon=icon("times")),
                                                                         div(class="clear"),
                                                                         hr()
                                                                  ),
                                                                  column(width=6,
                                                                         h4("About Calibartion Curve"),
                                                                         p("Calibration curve data is data on concentration levels and peak area (ratios) used to generate the calibration for estimating the level of concentration in a given new sample."),
                                                                         p(HTML("<br />")),
                                                                         h4("About Pooled Standard Error"),
                                                                         p("In place of the standard error of regression, standard error from previous calibration curve data can be pooled together with current calibration data to obtain a more reliable estimate. This is recommended if calibration curve data uploaded above have only one replicate or is based on single point calibration system.")
                                                                  )
                                                                )
                                                                
                                                       )
                                                     )
                                                   )
                                          ),
                                          tabPanel(title="Method Precision",
                                                   fluidRow(
                                                     column(width=6,
                                                            h4("Upload Method Precision Data"),
                                                            a("Download Example Method Precision CSV", href="exampleData/exampleData-methodPrecision.csv", target="_blank", class="exampleDownloadLink"),
                                                            uiOutput("display_start_methodPrecisionFileUpload"),
                                                            div("Error with uploaded file...", class="error", id="display_start_error_methodPrecisionFileUpload"),
                                                            actionButton("reset_inputMethodPrecisionFileUpload", "Remove Method Precision Data", icon=icon("times"))
                                                     ),
                                                     column(width=6,
                                                            h4("About Method Precision"),
                                                            p("Method precision quantifies the closeness of agreement between measured values obtained through replicate measurements on the same or similar objects under specified conditions. The replicate measurements could be carried out over different concentration range of Low, Medium and High."),
                                                     )
                                                   )
                                          ),
                                          tabPanel(title="Calibration Standard",
                                                   fluidRow(
                                                     column(width=6,
                                                            h4("Upload Calibration Standard Data"),
                                                            a("Download Example Calibration Standard Structure CSV", href="exampleData/exampleData-calibrationStandard-structure.csv", target="_blank", class="exampleDownloadLink"),
                                                            uiOutput("display_start_standardSolutionStructureFileUpload"),
                                                            div("Error with uploaded file...", class="error", id="display_start_error_standardSolutionStructureFileUpload"),
                                                            a("Download Example Calibration Standard Equipment CSV", href="exampleData/exampleData-calibrationStandard-equipment.csv", target="_blank", class="exampleDownloadLink"),
                                                            uiOutput("display_start_standardSolutionEquipmentFileUpload"),
                                                            div("Error with uploaded file...", class="error", id="display_start_error_standardSolutionEquipmentFileUpload"),
                                                            actionButton("reset_inputStandardSolutionFileUpload", "Remove all Calibration Standard Data", icon=icon("times")),
                                                     ),
                                                     column(width=6,
                                                            h4("About Calibration Standard"),
                                                            p("Two data files are required for the calibration standard; Structure and Equipment data. Equipment data requires information on all pipettes and flasks used in each solution preparation including information on manufacturer's tolerance and coverage factor, volume and number of times used for pipetting."),
                                                            p("Structure data requires information on reference compound, its purity, tolerance and coverage factor and the structure of how the reference compound was diluted to form other solutions in generating the calibration curve.")
                                                     )
                                                   )
                                          ),
                                          tabPanel(title="Sample Preparation",
                                                   fluidRow(
                                                     column(width=6,
                                                            h4("Upload Sample Preparation Data"),
                                                            a("Download Example Sample Preparation CSV", href="exampleData/exampleData-samplePreparation.csv", target="_blank", class="exampleDownloadLink"),
                                                            uiOutput("display_start_samplePreparationFileUpload"),
                                                            div("Error with uploaded file...", class="error", id="display_start_error_samplePreparationFileUpload"),
                                                            actionButton("reset_inputSamplePreparationFileUpload", "Remove Sample Preparation Data", icon=icon("times")),
                                                     ),
                                                     column(width=6,
                                                            h4("About Sample Preparation"),
                                                            p("Uncertainty of sample preparation combines uncertainty sources from the use of different equipment in preparing the sample, such as weighing balance, pipette and volumetric flask.")
                                                     )
                                                   )
                                          )
                                   )
                            )
                   ),
                   
                   fluidRow(
                     column(width=6,
                            box(title = "Case Sample Data", width = 12, id="caseSampleDataStart",
                                actionButton("help_start_caseSampleData", "", icon=icon("question"), class="smallRightHelpInHeader"),
                                p("Specify below the number of replicates and mean concentration for the case sample."),
                                numericInput("inputCaseSampleReplicates",
                                             "Replicates \\((r_s)\\)",
                                             value = NULL),
                                numericInput("inputCaseSampleMeanConcentration",
                                             "Mean Concentration\\((x_s)\\)",
                                             value = NULL),
                                uiOutput("display_start_caseSampleMeanPeakAreaRatio"),
                                uiOutput("display_start_caseSampleCustomWeight")
                            )
                     ),
                     column(width=6,
                            box(title = "Coverage Factor \\((k)\\)",width = 12,
                                actionButton("help_start_confidenceInterval", "", icon=icon("question"), class="smallRightHelpInHeader"),
                                p("A coverage factor can be automatically calculated by specifying a Confidence Level below, or overridden by a manually specified Coverage Factor."),
                                p("The specified Confidence Level percentage probability will be used to read the appropriate Coverage Factor from a t-distribution table, whereas a manually specified Coverage Factor will take precedence over the specified Confidence Level and be used explicity for the Expanded Uncertainty calculation."),
                                column(width=6,
                                       uiOutput("display_start_chooseConfidenceInterval")
                                ),
                                column(width=6,
                                       numericInput("inputManualCoverageFactor",
                                                    "Manual Specified Coverage Factor \\((k)\\)",
                                                    value = NULL),
                                )
                            )
                     )
                   ),
                   fluidRow(
                     column(width=6,
                            infoBox(HTML("Case Sample<br />Replicates \\((r_s)\\)"),HTML(paste(uiOutput("display_start_replicates"))), width=6, icon=icon("vials"), color="aqua"),
                            infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_start_meanConcentration"))), width=6, icon=icon("map-marker"), color="fuchsia"),
                            uiOutput("display_start_meanPar"),
                            uiOutput("display_start_customWeight")
                     ),
                     column(width=6,
                            infoBox("Confidence Level \\(({\\small CL}\\% )\\)",HTML(paste(uiOutput("display_start_confidenceInterval"))), width=6, icon=icon("percentage"), color="yellow"),
                            infoBox("Coverage Factor \\((k)\\)",HTML(paste(uiOutput("display_start_coverageFactor"))), width=6, icon=icon("table"), color="teal")
                     )
                   ),
                   fluidRow(
                     column(width=12,
                            div(id="percentageExpandedUncertaintyStartPage",
                                fluidRow(
                                  valueBox("Results", uiOutput("display_expandedUncertainty_finalAnswer_start"), width = 12, color = "green", icon = icon("equals"))
                                ),
                                fluidRow(
                                  box(title="Download Report", width = 12,
                                      p("For reporting purposes and report can be downloaded and stored for all the results uploaded."),
                                      downloadButton("actionButton_start_downloadReport", "Download Report", icon=icon("download"))
                                  )
                                )
                            )
                     )
                   )
)
