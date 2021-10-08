test_that("Test get_process_info", {
  process <- get_process_rsession()
  expect_is(process, "data.frame")
  expect_true(all(c("pid", "username") %in% names(process)))
})
