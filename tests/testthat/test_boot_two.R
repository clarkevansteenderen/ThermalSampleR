library(ThermalSampleR)
coreid = ThermalSampleR::coreid_data

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
