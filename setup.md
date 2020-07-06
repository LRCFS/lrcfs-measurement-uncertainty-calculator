#
#############################################
# Running the MUCalc from source with RStudio
#############################################
#
# MUCalc uses packrat (https://rstudio.github.io/packrat/) to manage dependancies of the various packages it uses.
#
# This ensures that the versions of the packages you use for this project work correctly and won't interfeare with
# other versions of the same packages you might be using on other projects.
#

##########################################
# Running MUCalc source for the first time
##########################################

# To get started, open this file in RStudio and run the following command, ensuring that your working directory is set to the folder in which this file is stored.
getwd()


# If your working directory is not set correctly, use the following command to set your working directory - replacing the example path between the quotes.
setwd("c:/example/directory/application")


# Once your working directly is correctly set, install the "packrat" package with the following command.
install.packages("packrat")


# Once installed you will be able to run the following packrat command to "resotre" the correct versions of packages required.
# This command is checking the .\packrat\packrat.lock file and is loading all the saved version of these packages from .\packrat\src\
packrat::restore()


# MUCalc uses a package called "shiny" (https://shiny.rstudio.com/) for rendering the website you see when you start the application.
# RStudio has built in support for Shiny and because we've just installed it (if you haven't used Shiny before) you must restart your RStudio instance and open the app.R file.
Close R Studio and open app.R

# Now that we've installed all the required dependancies, and loaded the app.R in RStudio, you will see an option to "Run App" at the top right of the app.R source code.








## IGNORE ##
#install.packages(c("shiny","shinyjs","shinydashboard","shinydashboardPlus","ggplot2","reshape2","scales","dplyr","plotly","DT","DiagrammeR","stringr","data.tree","rintrojs","textutils","tinytex","rmarkdown","knitr","webshot","shinyWidgets","colourpicker"))
#webshot::install_phantomjs() - on linux make sure you've got bzip2 installed for this to work
#tinytex::install_tinytex()