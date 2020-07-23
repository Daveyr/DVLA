
<!-- README.md is generated from README.Rmd. Please edit that file -->

# DVLA

<!-- badges: start -->

<!-- badges: end -->

The UK Driver Vehicle License Authority makes information about vehicles
available to the public, after they register for an API key. This
package makes interacting with this API easy.

## Prerequisites

In addition to this package, you must apply for and be granted an API
key from the UK Driver Vehicle Licensing Authority. You can do so
[here](https://developer-portal.driver-vehicle-licensing.api.gov.uk/apis/vehicle-enquiry-service/Register-For-VES-API.html).

## Installation

You can install the released version of DVLA from
[Github](https://github.com/Daveyr/DVLA) with:

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

## Misc

To understand more about how the API works, refer to the [Vehicle
Enquiry Service API
documentation](https://developer-portal.driver-vehicle-licensing.api.gov.uk/apis/vehicle-enquiry-service/vehicle-enquiry-service-description.html#vehicle-enquiry-service-api).

To summarise, the package works as follows:

  - Issue an HTTP POST request using the `httr` library with the
    following
      - A header containing `x-api-key` and the key value
      - A body containing `registrationNumber` and the vehicle
        registration string
  - Receive a response in json format
  - Convert the json response into a data frame
