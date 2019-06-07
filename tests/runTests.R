# Run this command to run all tests (uses testthat package)
rm(list=ls()); testthat::test_dir('tests')

# Tests are located in the 'tests' directory and are automatically loaded and run in alphabetical order by testthat
# setup_configureTests.R is automatically run before the tests and can be used to load default values