
<!-- README.md is generated from README.Rmd. Please edit that file -->

# DVLA

<!-- badges: start -->

<!-- badges: end -->

The UK Driver Vehicle License Authority makes information about vehicles
available to the public, after they register for an API key. This
package makes interacting with this API easy.

## Installation

You can install the released version of DVLA from
[Github](https://github.com) with:

``` r
devtools::install_github("daveyr/DVLA")
```

## Examples

To retrieve data for a single vehicle, use `getDVLA`.

``` r
library(DVLA)
api_key <- "Apply-2-the-DVLA-4-a-key"
df1 <- getDVLA(api_key, "X60AMPL")
```

To retrieve data for many vehicles, use `tidyDVLA`. As the name
suggests, `tidyDVLA` is compatible with the pipe work flow common to the
tidyverse, where a data frame is the first argument to any function, and
its sole output.

The result is a data frame containing the input and vehicle data from
the DVLA in additional columns. The data are tidy: one vehicle per row
and one feature per column.

``` r
library(dplyr)
df2 <- tribble(
  ~reg, ~owner,
  "X60AMPL" , "Alice",
  "X21MPLE",  "Bob"
)

df2 <- df2 %>%
  tidyDVLA("reg", api_key)
```
