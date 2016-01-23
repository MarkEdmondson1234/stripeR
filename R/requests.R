#' Set global configurations
#'
#' Run this at the start of every stripeR session.
#'
#' @details
#'
#' Set up your Stripe API keys first via:
#'
#' \code{options('stripeR.secret_test') <- SECRET_TEST_KEY}
#' \code{options('stripeR.secret_live') <- SECRET_LIVE_KEY}
#' \code{options('stripeR.public_test') <- PUBLIC_TEST_KEY}
#' \code{options('stripeR.public_live') <- PUBLIC_LIVE_KEY}
#'
#' Then run \code{stripeR_init()} to initialise your Stripe API session.
#'
#' @param live TRUE If the payments should be against your live Stripe account.
#'
#' @export
stripeR_init <- function(live=FALSE){

  httr::reset_config()

  if(!live){
    key <- getOption("stripeR.secret_test")
  } else {
    key <- getOption("stripeR.secret_live")
  }

  httr::set_config(httr::authenticate(user = key,
                                      password = ""))
}



#' Do a request
#'
#' @param url The url of the request
#' @param request_type GET, POST, PUT etc.
#' @param the_body Body to send with the request, if any
#' @param customConfig a list of custom configurations from httr
#'
#' @return the request content or NULL
#'
#' @keywords internal
do_request <- function(url, request_type, the_body = NULL, customConfig = NULL){

  arg_list <- list(url = url,
                   body = the_body,
                   encode = "form"
  )

  if(!is.null(customConfig)){
    stopifnot(inherits(customConfig, "list"))

    arg_list <- c(arg_list, customConfig)

  }

#   if(!is.null(the_body)){
#     message("Body JSON parsed to: ", jsonlite::toJSON(the_body, auto_unbox=T))
#   }

  req <- retryRequest(do.call(request_type,
                              args = arg_list,
                              envir = asNamespace("httr")))

  response <- checkRequest(req)

  response

}

#' Check request content
#'
#' @param req A httr request
#'
#' @return content if it is there, or NULL
#'
#' @keywords internal
checkRequest <- function(req){

  content <- httr::content(req, as = "text", type = "application/json",encoding = "UTF-8")

  if(!is.null(content)){
    content <- jsonlite::fromJSON(content, simplifyVector = TRUE, flatten = TRUE)

    if(exists("error", where = content)){
      error <- content$error
      if(grepl("You did not provide an API key",error$message)){
        stop("You need to set up your Stripe API key via \n
             options('stripeR.secret_test') <- YOUR_TEST_KEY and/or \n
             options('stripeR.secret_live') <- YOUR_LIVE_KEY , \n
             then run stripeR_init() before making any Stripe API requests.")
      }
      stop(error$type, "\n", error$message)
    } else {
      out <- content
    }
  } else {
    message("No content found but was successful. Returning NULL")
    out <- NULL
  }

  out

}



#' ReTry API requests for certain errors using exponential backoff.
#'
#' @param f A function of a http request
#'
#' @keywords internal
retryRequest <- function(f){
  the_request <- try(f)

  if(!the_request$status_code %in% c(200, 201)){
    warning("Request Status Code: ", the_request$status_code)

    if(the_request$status_code %in% c(500, 501, 502, 503, 504)){
      for(i in 1:5){
        warning("Trying again: ", i, " of 5")
        Sys.sleep((2 ^ i) + runif(n = 1, min = 0, max = 1))
        the_request <- try(f)
        if(!is.error(the_request)) break
      }
      warning("All attempts failed.")
    } else {
      warning("No retry attempted")
    }

  }

  the_request
}
