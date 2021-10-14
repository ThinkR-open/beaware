test_that("my_function works properly", {
  process <- get_all_info()
  expect_is(process, "data.frame")
  expect_true(all(c("pid", "r_version", "%cpu", "%mem", "username") %in% names(process)))
})
