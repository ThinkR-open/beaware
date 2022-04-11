
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/ThinkR-open/beaware/workflows/R-CMD-check/badge.svg)](https://github.com/ThinkR-open/beaware/actions)
<!-- badges: end -->

# beaware

This application was developed to monitor the use of your server
resources by R and Rstudio. It fills a gap in Rstudio Server.

**Code to work with:**

-   linux server
-   to be server administrator (to be able to read user’s pid)

## Installation

You can install {beaware} from github with:

``` r
remotes::install_github("thinkr-open/beaware")
```

## How to use the package ?

To launch the application:

``` r
beaware::launching_app()
```

This instruction allows to launch application in background.

# Sponsor

The development of this package has been sponsored by:

<a href = "https://https://www.santepubliquefrance.fr//"><img src = "inst/langfr-260px-Sante-publique-France-logo.svg.png"></img></a>

# Code of Conduct

Please note that the {beaware} project is released with a Contributor
Code of Conduct. By contributing to this project, you agree to abide by
its terms.
