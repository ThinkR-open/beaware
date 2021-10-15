test_that("fct utils",{

  species <- unique(iris$Species)

  expect_equal(pull_unique(iris, Species), species)

})
