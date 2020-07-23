.onAttach <- function(libname, pkgname) {
  packageStartupMessage("DVLA API package by Richard Davey")
}


#' Returns a data frame of vehicle data from the DVLA about a single vehicle
#'
#' \code{getDVLA}:getDVLA takes a vehicle registration plate number and returns
#' information held by the DVLA about this vehicle. To use this service you
#' must have registered and been granted an API key.
#'
#' @param reg A single character containing one vehicle registration number
#' @param key The API key provided to you by the DVLA
#' @export

getDVLA <- function(key, reg) {
  baseurl <- "https://driver-vehicle-licensing.api.gov.uk/vehicle-enquiry/v1/vehicles"
  response <- httr::POST(baseurl,
                         httr::add_headers(`x-api-key` = key,
                                     `Content-Type` = "application/json",
                                     Accept = "application/json"),
                         body = list(`registrationNumber` = reg),
                         encode = "json")

  as.data.frame(httr::content(response))
}

#' Tidy version of getDVLA for a data frame containing vehicle registrations
#'
#' \code{tidyDVLA}: tidyDVLA extends the functionality of \code{getDVLA} by
#' taking a data frame containing vehicle registration numbers and using
#' parallel processing to retrieve DVLA information for each one. It binds
#' these columns back to the input data frame.
#'
#' @param data A data frame containing a vehicle registration column
#' @param reg_column The quoted column name that contains vehicle registrations
#' @param key The API key provided to you by the DVLA
#'
#' @importFrom foreach %dopar%
#' @export

tidyDVLA <- function(data, reg_column, key) {

  ncore <- parallel::detectCores() - 1
  cl <- parallel::makeCluster(ncore)
  doParallel::registerDoParallel(cl, cores = ncore)

  Func <- function(i) {
    output <- getDVLA(key, i)
    return(output)
  }
  out <- foreach::foreach(i = data[[reg_column]],
                 .packages = c("data.table", "httr", "dplyr"),
                 .export = "getDVLA",
                 .final = function(x) data.table::rbindlist(x, fill = T)
  ) %dopar% Func(i)
  colnames(out) <- c(reg_column, colnames(out)[-1])
  parallel::stopCluster(cl)
   return(
     merge(data, out,by = reg_column)
  )
}
