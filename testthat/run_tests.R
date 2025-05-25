library(testthat)

# run a single file
testthat::test_file("testthat/test_transitions.R")

# run every file under tests/testthat/
testthat::test_dir("testthat")
