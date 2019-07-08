#Set context for tests for reporting purposes
context('Testing modelStandardSolution.R functions')

#Load in model that tests are written against
source("../dal/loadStandardSolutionCSV.R")
source("../models/modelApplication.R")
source("../models/modelStandardSolution.R")

# testData = standardSolutionReadCSV("../data/standardSolution/standardSolutionSampleData-compoundAndSolutions.csv", "../data/standardSolution/standardSolutionSampleData-measurementInformation.csv");

test_that('getStandardUncertainty_solution', {
  expect_equal(getStandardUncertainty_solution(33000,2),16500)
  expect_equal(getStandardUncertainty_solution(33000,0),19052.559)
  expect_equal(getStandardUncertainty_solution(33000,NA),19052.559)
  expect_equal(getStandardUncertainty_solution(33000),19052.559)
  expect_equal(getStandardUncertainty_solution(33000,),19052.559)
  expect_equal(getStandardUncertainty_solution(33000,""),19052.559)
})

test_that('getRelativeStandardUncertainty_solution', {
  expect_equal(getRelativeStandardUncertainty_solution(16500, 1000000),0.0165)
})

# test_that('getRsu_solution', {
#   print("testing 1232")
#   expect_equal(getTest(testData),1)
# })





