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
    numericInput("inputUseScientificNotationIfMoreThan",
                 HTML("Use Scientific Notation if more than (&plusmn;):"),
                 value = 10000000),
    numericInput("inputUseScientificNotationIfLessThan",
                 HTML("Use Scientific Notation if less than (&plusmn;):"),
                 value = 0.0000001),
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
        colourInput("colour9", "Colour 9", value = colour9),
        colourInput("colour10", "Colour 10", value = colour10),
        colourInput("colour11", "Colour 11", value = colour11),
        colourInput("colour12", "Colour 12", value = colour12),
        # colourInput("colour13", "Colour 13", value = colour13)
    )
  )
)