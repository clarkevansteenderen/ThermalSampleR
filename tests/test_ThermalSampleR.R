library(testthat)
library(ggplot2)
library(sn)

# run test_file("test_ThermalSampleR.R") to test everything in this R file

# 60 rows of data

coreid = read.csv("tests/coreid_data.csv")

source("R/boot_one.R")
source("R/boot_two.R")
source("R/plot_one_group.R")
source("R/plot_two_groups.R")
source("R/equiv_tost.R")

############################################################################################
# BOOT_ONE and PLOT_ONE_GROUP TESTS
############################################################################################

########################################
# Test for general errors: boot_one
########################################

bt_one = boot_one(data=coreid, groups_col=col,
                  groups_which="Catorhintha schaffneri_APM",
                  n_max=49, iter=15, response=response)

test_that("No error is thrown in boot_one function", {

  # Call the function and check for errors
  expect_no_error(boot_one(data=coreid, groups_col=col,
                        groups_which="Catorhintha schaffneri_APM",
                        n_max=49, iter=15, response=response))
})

##################################################
# Test: user puts in the incorrect groups_col
##################################################

test_that("Error is thrown in boot_one function", {

  # Call the function and check for errors
  expect_error(boot_one(data=coreid, groups_col="Catorhintha schaffneri_APM",
                           groups_which="Catorhintha schaffneri_APM",
                           n_max=49, iter=15, response=response))
})

########################################
# check that the col column consists of names
########################################

test_that("Incorrect columns in data", {

 expect_type(coreid$col, "character")
})

########################################
# check that the response column contains integers
########################################

test_that("Incorrect columns in data", {

  expect_type(coreid$response, "integer")
})

########################################
# Test for the class of bt_one output
########################################
test_that("boot_one output is the list class", {

  expect_type(bt_one, "list")
  expect_type(bt_one$mean_low_ci[1], "double")
  expect_equal(ncol(bt_one), 14)
})

########################################
# Test for NA values in bt_one
########################################

bt_one_buggy = bt_one
bt_one_buggy$mean_low_ci[1] = NA

test_that("No NA values in the dataframe", {
    expect_false(any(is.na(bt_one)), info = "The dataframe contains NA values.")
})

test_that("NA values present in the dataframe", {
  expect_true(any(is.na(bt_one_buggy)), info = "The dataframe does not contain NA values.")
})

#############################
# test bt_one plotting
#############################

plot_bt_one = plot_one_group(
  # Variable containing the output from running `boot_one` function
  x = bt_one,
  # Minimum sample size to plot
  n_min = 3,
  # Actual size of your existing dataset
  n_max = 15,
  # Colour for your experimental data
  colour_exp = "forestgreen",
  # Colour for the extrapolated predictions
  colour_extrap = "orange",
  # Position of the legend
  legend.position = "right",
  # Change the degree of shading on the graph
  alpha_val = 0.25)

########################################
# Test for the class of plot_one_group
########################################
test_that("plot_one_group output is the ggplot class", {

  expect_true(inherits(plot_bt_one, "ggplot"))
})

##############################################
# Test for the correctness of user input file
##############################################

test_that("Error: incorrect input data", {

  # Call the function and check for errors
  expect_error(plot_one_group(
    # Variable containing the output from running `boot_one` function
    x = bt_oneee, # incorrect name here -> should throw an error
    # Minimum sample size to plot
    n_min = 3,
    # Actual size of your existing dataset
    n_max = 15,
    # Colour for your experimental data
    colour_exp = "forestgreen",
    # Colour for the extrapolated predictions
    colour_extrap = "orange",
    # Position of the legend
    legend.position = "right",
    # Change the degree of shading on the graph
    alpha_val = 0.25))
})

############################################################################################
# BOOT_TWO and PLOT_TWO_GROUPS TESTS
############################################################################################

########################################
# Test for general errors: boot_two
########################################

bt_two <- boot_two(
  # Which dataframe does the data come from?
  data = coreid,
  # Provide the column name containing the taxon ID
  groups_col = col,
  # Provide the name of the column containing the response variable (e.g CTmin data)
  response = response,
  # Provide the name of the first taxon to be compared
  group1 = "Catorhintha schaffneri_APM",
  # Provide the name of the second taxon to be compared
  group2 = "Catorhintha schaffneri_NPM",
  # Maximum sample sample to extrapolate to
  n_max = 49,
  # How many bootstrap resamples should be drawn?
  iter = 15)


test_that("No error is thrown in boot_two function", {

  # Call the function and check for errors
  expect_no_error(boot_two(data=coreid, groups_col=col,
                           group1="Catorhintha schaffneri_APM",
                           group2="Catorhintha schaffneri_NPM",
                           n_max=49, iter=15, response=response))
})

########################################
# Test for the class of bt_two output
########################################
test_that("boot_two output is the list class", {

  expect_type(bt_two, "list")
  expect_type(bt_two$mean_low_ci[1], "double")
  expect_equal(ncol(bt_two), 11)
})

########################################
# Test for NA values in bt_two
########################################

bt_two_buggy = bt_two
bt_two_buggy$mean_low_ci[1] = NA

test_that("No NA values in the dataframe", {
  expect_false(any(is.na(bt_two)), info = "The dataframe contains NA values.")
})

test_that("NA values present in the dataframe", {
  expect_true(any(is.na(bt_two_buggy)), info = "The dataframe does not contain NA values.")
})

#############################
# test bt_two plotting
#############################

plot_bt_two = plot_two_groups(
  # Variable containing the output from running `boot_two` function
  x = bt_two,
  # Minimum sample size to plot
  n_min = 3,
  # Actual size of your existing dataset
  n_max = 30,
  # Colour for your experimental data
  colour_exp = "blue",
  # Colour for the extrapolated predictions
  colour_extrap = "red",
  # Position of the legend
  legend.position = "right",
  # Change the degree of shading on the graph
  alpha_val = 0.25)

########################################
# Test for the class of plot_one_group
########################################
test_that("plot_two_groups output is the ggplot class", {

  expect_true(inherits(plot_bt_two, "ggplot"))
})

############################################################################################
# EQUIV_TOST TESTS
############################################################################################

tte = equiv_tost(
  # Which dataframe does the data come from?
  data = coreid,
  # Provide the column name containing the taxon ID
  groups_col = col,
  # Provide the name of the taxon to be tested
  groups_which = "Catorhintha schaffneri_APM",
  # Provide the name of the column containing the response variable (e.g CTmin data)
  response = response,
  # Define the skewness parameters
  skews = c(1,10),
  # Define the equivalence of subsets to full population CT estimate (unit = degree Celcius)
  equiv_margin = 1,
  # Size of the population to sample (will test subsamples of size pop_n - x against pop_n for equivalence). Defaults to population size = 30
  pop_n = 30
)

########################################
# Test for the class of tte
########################################
test_that("tte output is the ggplot class", {

  expect_true(inherits(tte, "ggplot"))
})


test_that("No error is thrown in equiv_tost function", {

  # Call the function and check for errors
  expect_no_error(equiv_tost(
    # Which dataframe does the data come from?
    data = coreid,
    # Provide the column name containing the taxon ID
    groups_col = col,
    # Provide the name of the taxon to be tested
    groups_which = "Catorhintha schaffneri_APM",
    # Provide the name of the column containing the response variable (e.g CTmin data)
    response = response,
    # Define the skewness parameters
    skews = c(1,10),
    # Define the equivalence of subsets to full population CT estimate (unit = degree Celcius)
    equiv_margin = 1,
    # Size of the population to sample (will test subsamples of size pop_n - x against pop_n for equivalence). Defaults to population size = 30
    pop_n = 30
  ))
})

