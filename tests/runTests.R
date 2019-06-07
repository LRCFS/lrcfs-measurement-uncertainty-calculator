# Run this command to run all tests
rm(list=ls()); testthat::test_dir('tests')

# Tests are located in the 'tests' directory and are run in alphabetical order
# setup_configureTests.R is run before the tests and can be used to load default values