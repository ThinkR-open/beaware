test_that("Test get cpu mem info", {
  process <- get_mem_cpu()
  expect_is(process, "data.frame")
  expect_true(all(c("pid", "%cpu", "%mem") %in% names(process)))
})
