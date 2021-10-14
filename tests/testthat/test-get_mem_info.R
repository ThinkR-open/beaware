test_that("Test for get info", {
 meminfo <- get_mem_info()
 expect_is(meminfo, "data.frame")
 expect_true(all(c("usedmemory", "memtotal", "time") %in% names(meminfo)))
})
