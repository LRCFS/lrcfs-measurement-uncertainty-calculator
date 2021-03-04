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
                     box(title=paste0("Welcome to ",APP_NAME_SHORT), width=12,
                         p(paste0("The ",APP_DEV," ",APP_NAME," (",APP_NAME_SHORT,") is an application for calculating measurement uncertainty in accordance with the standards of International Organization for Standardization ISO/IEC 17025.")),
                         p(paste0("This version (v",APP_VER,") of the software computes uncertainty components for Method Precision, Standard Solution, Sample Volume and Calibration Curve with the Calibration Curve assumed to be linear. If data is uploaded for all four components, the Combined Uncertainty is computed using all four components. An uncertainty component can be excluded from the Combined Uncertainty by simply not uploading any data for that component.")),
                         p("Once data is uploaded, a step by step computation and details of all formulas used can be accessed by clicking on the respective uncertainty component tab displayed at the left hand side of the screen. Each uncertainty component has three main tabs; Overview, Method and Step by Step Calculations. Together these give more detailed information about the approach used."),
                         hr(),
                         actionButton("help_start_start", "Help", icon=icon("question"))
                     )
                   ),
                   fluidRow(
                     column(width=6,
                            fluidRow(
                              box(width=12, id="fileUploadBox",
                                  div(
                                    h4("Upload Data Files"),
                                    p(paste0("Data is required to compute each uncertainty component. All data should be saved as a CSV file before uploading to ",APP_NAME_SHORT,". The exact format of data required can be accessed by downloading the Example Data file for each uncertainty component. The example data files can be edited to include lab specific data."))
                                  ),
                                  hr(),
                                  
                                  div(id="homogeneity",
                                      actionButton("help_start_homogeneity", "", icon=icon("question"), class="smallRightHelp"),
                                      h4("Homogeneity"),
                                      a("Download Example Homogeneity CSV", href="exampleData/exampleData-homogeneity.csv"),
                                      uiOutput("display_start_homogeneityFileUpload"),
                                      div("Error with uploaded file...", class="error", id="display_start_error_homogeneityFileUpload"),
                                      actionButton("reset_inputHomogeneityFileUpload", "Remove Homogeneity Data", icon=icon("times")),
                                      div(class="clear")
                                  ),
                                  hr(),
                                  
                                  div(id="calcurve",
                                    actionButton("help_start_calcurve", "", icon=icon("question"), class="smallRightHelp"),
                                    h4("Calibration Curve"),
                                    a("Download Example Calibration Curve CSV", href="exampleData/exampleData-calibrationCurve.csv"),
                                    uiOutput("display_start_calibrationCurveFileUpload"),
                                    div("Error with uploaded file...", class="error", id="display_start_error_calibrationCurveFileUpload"),
                                    a("Download Pooled Standard Error CSV", href="exampleData/exampleData-calibrationCurve-pooledStandardError.csv"),
                                    uiOutput("display_start_externalStandardErrorFileUpload"),
                                    div("Error with uploaded file...", class="error", id="display_start_error_externalStandardErrorFileUpload"),
                                    actionButton("reset_inputCalibrationCurveFileUpload", "Remove Calibration Curve Data", icon=icon("times")),
                                    div(class="clear")
                                  ),
                                  hr(),
                                  
                                  div(id="methodprec",
                                    actionButton("help_start_methodprec", "", icon=icon("question"), class="smallRightHelp"),
                                    h4("Method Precision"),
                                    a("Download Example Method Precision CSV", href="exampleData/exampleData-methodPrecision.csv"),
                                    uiOutput("display_start_methodPrecisionFileUpload"),
                                    div("Error with uploaded file...", class="error", id="display_start_error_methodPrecisionFileUpload"),
                                    actionButton("reset_inputMethodPrecisionFileUpload", "Remove Method Precision Data", icon=icon("times")),
                                    div(class="clear")
                                  ),
                                  hr(),
                                  
                                  div(id="stdsol",
                                    actionButton("help_start_stdsol", "", icon=icon("question"), class="smallRightHelp"),
                                    h4("Standard Solution"),
                                    a("Download Example Standard Solution Structure CSV", href="exampleData/exampleData-standardSolution-structure.csv"),
                                    uiOutput("display_start_standardSolutionStructureFileUpload"),
                                    div("Error with uploaded file...", class="error", id="display_start_error_standardSolutionStructureFileUpload"),
                                    a("Download Example Standard Solution Equipment CSV", href="exampleData/exampleData-standardSolution-equipment.csv"),
                                    uiOutput("display_start_standardSolutionEquipmentFileUpload"),
                                    div("Error with uploaded file...", class="error", id="display_start_error_standardSolutionEquipmentFileUpload"),
                                    actionButton("reset_inputStandardSolutionFileUpload", "Remove all Standard Solution Data", icon=icon("times")),
                                    div(class="clear")
                                  ),
                                  hr(),
                                  
                                  div(id="sampleprep",
                                    actionButton("help_start_sampleprep", "", icon=icon("question"), class="smallRightHelp"),
                                    h4("Sample Preparation"),
                                    a("Download Example Sample Preparation CSV", href="exampleData/exampleData-samplepreparation.csv"),
                                    uiOutput("display_start_samplePreparationFileUpload"),
                                    div("Error with uploaded file...", class="error", id="display_start_error_samplePreparationFileUpload"),
                                    actionButton("reset_inputSamplePreparationFileUpload", "Remove Sample Preparation Data", icon=icon("times")),
                                    div(class="clear")
                                  ),
                                  hr()
                                  
                                  
                              )
                            )
                     ),
                     column(width=6,
                            fluidRow(
                              box(title = "Weighted Least Squares (WLS) Regression", width = 12,
                                  actionButton("help_start_weightedLeastSquare", "", icon=icon("question"), class="smallRightHelpInHeader"),
                                  p("To fit a weighted least squares (WLS) regression, the default weight of \\(W = 1\\) must be changed. A weight of \\(W = 1\\) implies an ordinary linear regression with no weights applied. The following weight options are currently available:"),
                                  p("\\(W = \\frac{1}{x}, \\frac{1}{x^2},\\frac{1}{y}\\), \\(\\frac{1}{y^2}\\) or you can \"specify custom weights\"."),
                                  p("Select a weight option to be applied to the model if a WLS regression is required. Note that a default weight of \\(1\\) results in a simple linear regression with no weighting."),
                                  selectizeInput("inputWeightLeastSquared", "Weight \\((W)\\):",
                                              c("Default \\((1)\\)" = 1,
                                                "Concentraion \\((1/x)\\)" = 2,
                                                "Concentraion Squared \\((1/x^2)\\)" = 3,
                                                "Peak Area \\((1/y)\\)" = 4,
                                                "Peak Area Squared \\((1/y^2)\\)" = 5,
                                                "Specify custom Weights..." = 999)),
                                  uiOutput("display_start_customWlsFileUploadExampleDownloadLink"),
                                  uiOutput("display_start_customWlsFileUpload"),
                                  uiOutput("display_start_customWlsFileUploadErrorDiv"),
                                  uiOutput("display_start_customWlsPooledFileUploadExampleDownloadLink"),
                                  uiOutput("display_start_customWlsPooledFileUpload"),
                                  uiOutput("display_start_customWlsPooledFileUploadErrorDiv"),
                                  uiOutput("display_start_customWlsFileUploadRemoveDataButton")
                              )
                            ),
                            fluidRow(
                              box(title = "Case Sample Data", width = 12,
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
                              ),
                              infoBox(HTML("Case Sample<br />Replicates \\((r_s)\\)"),HTML(paste(uiOutput("display_start_replicates"))), width=6, icon=icon("vials"), color="aqua"),
                              infoBox(HTML("Case Sample<br />Mean Concentration\\((x_s)\\)"),HTML(paste(uiOutput("display_start_meanConcentration"))), width=6, icon=icon("map-marker"), color="fuchsia"),
                              uiOutput("display_start_meanPar"),
                              uiOutput("display_start_customWeight")
                            ),
                            fluidRow(
                              hr()
                            ),
                            fluidRow(
                              box(title = "Coverage Factor \\((k)\\)",width = 12,
                                  actionButton("help_start_confidenceInterval", "", icon=icon("question"), class="smallRightHelpInHeader"),
                                  p("A coverage factor can be manually specified below, or automatically calculated by specifying a Confidence Level"),
                                  p("The specified Confidence Level percentage probability will be used to read the appropriate Coverage Factor from a t-distribution table, whereas a manually specified Coverage Factor will take precedence over the specified Confidence Level"),
                                  column(width=6,
                                         uiOutput("display_start_chooseConfidenceInterval")
                                  ),
                                  column(width=6,
                                         numericInput("inputManualCoverageFactor",
                                                      "Coverage Factor \\((k)\\)",
                                                      value = NULL),
                                  ),
                              ),
                              column(width=6,
                                infoBox("Confidence Level \\(({\\small CI}\\% )\\)",HTML(paste(uiOutput("display_start_confidenceInterval"))), width=12, icon=icon("percentage"), color="yellow")
                              ),
                              column(width=6,
                                infoBox("Coverage Factor \\((k)\\)",HTML(paste(uiOutput("display_start_coverageFactor"))), width=12, icon=icon("table"), color="teal")
                              )
                            ),
                            fluidRow(
                              hr()
                            ),
                            fluidRow(
                              div(id="percentageExpandedUncertaintyStartPage",
                                  valueBox("Results", uiOutput("display_expandedUncertainty_finalAnswer_start"), width = 12, color = "green", icon = icon("equals")),
                                  box(title="Download Report", width = 12,
                                    p("For reporting purposes and report can be downloaded and stored for all the results uploaded."),
                                    downloadButton("actionButton_start_downloadReport", "Download Report", icon=icon("download"))
                                  )
                              )
                            )
                     )
                   )
)
