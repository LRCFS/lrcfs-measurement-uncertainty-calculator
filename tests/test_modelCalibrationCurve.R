#Set context for tests for reporting purposes
context('Testing modelCalibrationCurve.R functions')

#Load in model that test are written against
source("../models/modelApplication.R")
source("../models/modelCalibrationCurve.R")



test_that('getSqDevation', {
  expect_equal(getSqDevation(c(1,2,3,4,5)),      c(4,1,0,1,4))
  expect_equal(getSqDevation(c(0,0,0,0,0)),      c(0,0,0,0,0))
  expect_equal(getSqDevation(c(10,10,10,10,10)), c(0,0,0,0,0))
  expect_equal(getSqDevation(c(-1,-2,-3,-4,-5)), c(4,1,0,1,4))
})

test_that('getPredicetedY', {
  expect_equal(getPredicetedY(c(1,2,3,4,5),c(1,2,3,4,5)),    c(1,2,3,4,5))
  expect_equal(getPredicetedY(c(5,4,3,2,1),c(1,2,3,4,5)),    c(1,2,3,4,5))
  expect_equal(getPredicetedY(c(1,1,1,1,1),c(1,2,3,4,5)),    c(3,3,3,3,3))
  expect_equal(getPredicetedY(c(35,5,45,5,55),c(1,2,3,4,5)), c(3.11321,2.54717,3.30189,2.54717,3.49057))
})


test_that('getSlope', {
  expect_equal(getSlope(c(1,2,3,4,5),c(1,2,3,4,5)),  1)
  expect_equal(getSlope(c(1,2,3,4,5),c(1,1,1,1,1)),  0)
  expect_equal(getSlope(c(1,2,3,4,5),c(0,3,6,9,12)), 3)
})


test_that('getIntercept', {
  expect_equal(getIntercept(c(1,2,3,4,5),c(1,2,3,4,5)),  0)
  expect_equal(getIntercept(c(1,2,3,4,5),c(2,3,4,5,6)),  1)
  expect_equal(getIntercept(c(1,2,3,4,5),c(2,2,2,2,2)),  2)
  expect_equal(getIntercept(c(1,2,3,4,5),c(0,1,2,3,4)),  -1)
})

test_that('getErrorSqDevationY', {
  #expect_equal(getErrorSqDevationY(c(1,2,3,4,5),c(1,2,3,4,5)),  c(0,0,0,0,0))
  #do more tests here
})


test_that('getDegreesOfFreedom', {
  expect_equal(getDegreesOfFreedom(c(1,1,1,1,1)), 3)
  expect_equal(getDegreesOfFreedom(c(1)), -1)
})


test_that('getStandardErrorOfRegerssion', {
  #expect_equal(getStandardErrorOfRegerssion(c(1,2,3,4,5),c(1,2,3,4,5)), 0)
  #do more tests here
})

test_that('getUncertaintyOfCalibration', {
  #expect_equal(getUncertaintyOfCalibration(c(1,2,3,4,5),c(1,2,3,4,5)), 0)
  #do more tests here
})

test_that('getRelativeStandardUncertainty', {
  #expect_equal(getRelativeStandardUncertainty(c(1,2,3,4,5),c(1,2,3,4,5)), 0)
  #do more tests here
})


