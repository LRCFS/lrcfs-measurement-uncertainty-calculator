# Measurement Uncertainty Calculator

[![DOI](https://zenodo.org/badge/187221339.svg)](https://zenodo.org/badge/latestdoi/187221339)

The Leverhulme Research Centre for Forensic Science Measurement Uncertainty Calculator (MUCalc) is an application for calculating measurement uncertainty in accordance with the standards of International Organization for Standardization ISO/IEC 17025.

The software computes uncertainty components for Method Precision, Standard Solution, Sample Volume and Calibration Curve with the Calibration Curve assumed to be linear. If data is uploaded for all four components, the Combined Uncertainty is computed using all four components. An uncertainty component can be excluded from the Combined Uncertainty by simply not uploading any data for that component.

Once data is uploaded, a step by step computation and details of all formulas used can be accessed for reviewed.

# Using the LRCFS MUCalc
You can access a publicly available version of this application at: https://uod.ac.uk/lrcfsmucalc

# Running the MUCalc from source with RStudio
MUCalc uses renv (https://rstudio.github.io/renv/articles/renv.html) to manage dependencies of the various packages it uses.
This ensures that the versions of the packages you use for this project work correctly and won't interfere with
other versions of the same packages you might be using on other projects.

## Running MUCalc source for the first time
To get started, open `lrcfs-measurement-uncertainty-calculator.Rproj` in RStudio.

The renv package management software should automatically install. If not, run:
> install.packages("renv")

Once installed you will be able to run the following renv command to "restore" the correct versions of packages required.
This command is checking the `.\renv.lock` file for specific version of the packages to install.
> renv::restore()

MUCalc uses a package called "shiny" (https://shiny.rstudio.com/) for rendering the website you see when you start the application.
RStudio has built in support for Shiny and because we've just installed it (if you haven't used Shiny before) you must restart your RStudio instance and open the app.R file.

> Close R Studio then open 'lrcfs-measurement-uncertainty-calculator.Rproj'

Now that we've installed all the required dependencies, select the `app.R` in RStudio, you will see an option to "Run App" at the top right of the app.R source code. 

You may need to install Rtools to run all dependencies.

# Measurement Uncertainty Calculator - Copyright (C) 2019
## Leverhulme Research Centre for Forensic Science
## Roy Mudie, Joyce Klu, Niamh Nic Daeid
#### Website: https://github.com/LRCFS/lrcfs-measurement-uncertainty-calculator/
#### Contact: lrc@dundee.ac.uk

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

