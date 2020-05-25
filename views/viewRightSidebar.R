mouCalcRightSidebar = rightSidebar(
  background = "dark",
  rightSidebarTabContent(
    id = 1,
    active = TRUE,
    title = "Display Settings",
    icon = "folder",
    p("Configure options for display and reports below."),
    hr(),
    numericInput("inputNumberOfDecimalPlaces",
                 "Number of Decimal Places:",
                 value = 6),
    hr(),
    numericInput("inputUseScientificNotationIfLessThan",
                 "Use Scientific Notation if less than:",
                 value = 0.001),
    numericInput("intputNumberOfScientificNotationDigits",
                 "Number of digits in Scientific Notation:",
                 value = 2),
    hr(),
    prettySwitch(
      inputId = "useColours",
      label = "Colour Important Numbers",
      fill = TRUE, 
      status = "primary",
      value = TRUE
    ),
    div(id="colourPickers",
        colourInput("colour1", "Colour 1", value = colour1),
        colourInput("colour2", "Colour 2", value = colour2),
        colourInput("colour3", "Colour 3", value = colour3),
        colourInput("colour4", "Colour 4", value = colour4),
        colourInput("colour5", "Colour 5", value = colour5),
        colourInput("colour6", "Colour 6", value = colour6),
        colourInput("colour7", "Colour 7", value = colour7),
        colourInput("colour8", "Colour 8", value = colour8),
        colourInput("colour9", "Colour 9", value = colour9)
    )
  )
  # rightSidebarTabContent(
  #   id = 2,
  #   title = "Case Sample Information",
  #   p("Specify below the number of replicates and mean concentration for the sample that the calibration data was tested against."),
  #   numericInput("inputCaseSampleReplicates",
  #                "Replicates \\((r_s)\\)",
  #                value = 2),
  #   numericInput("aaa",
  #                "Mean Concentration\\((x_s)\\)",
  #                value = 2),
  #   hr(),
  #   h3("Confidence Interval"),
  #   p("The confidence interval you specify below does something..."),
  #   
  #   
  #   selectInput("bbb", "Confidence Interval\\((c_i)\\):",
  #               c("99.73%" = "99.73%",
  #                 "99%" = "99%",
  #                 "95.45%" = "95.45%",
  #                 "95%" = "95%",
  #                 "90%" = "90%",
  #                 "68.27%" = "68.27%"))
  # )
)