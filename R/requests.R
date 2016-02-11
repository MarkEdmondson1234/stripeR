#' R6 environment to store authentication credentials
#'
#' Used to keep persistent state.
#' @export
stripeR_auth <- R6::R6Class(
  "stripeR_auth",
  public = list(
    key = NULL
  ),
  lock_objects = F,
  parent_env = emptyenv()
)


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

  if(!live){
    key <- getOption("stripeR.secret_test")
  } else {
    key <- getOption("stripeR.secret_live")
  }

#   httr::set_config(httr::authenticate(user = key,
#                                       password = ""))

  stripeR_auth$set("public","key", key, overwrite = TRUE)
  invisible(return(key))
}



#' Do a request
#'
#' @param url The url of the request
#' @param request_type GET, POST, PUT etc.
#' @param idempotency A random string to ensure no repeat charges
#' @param the_body Body to send with the request, if any
#' @param customConfig a list of custom configurations from httr
#'
#' @return the request content or NULL
#'
#' @keywords internal
do_request <- function(url,
                       request_type,
                       idempotency=NULL,
                       the_body = NULL,
                       customConfig = NULL,
                       limit=NULL){

  key <- stripeR_auth$public_fields$key

  if(!is.null(limit)){
    if(limit > 100){
      new_limit <- 100
      url <- httr::modify_url(url,
                              query = list(limit = new_limit))
    }
  }

  arg_list <- list(url = url,
                   body = the_body,
                   encode = "form",
                   httr::add_headers("Idempotency-Key" = idempotency),
                   httr::authenticate(user = key, password = "")
  )

  if(!is.null(customConfig)){
    stopifnot(inherits(customConfig, "list"))

    arg_list <- c(arg_list, customConfig)

  }

  message("Request: ", url)

  req <- retryRequest(do.call(request_type,
                              args = arg_list,
                              envir = asNamespace("httr"))
                      )

  response <- checkRequest(req)

  ## page through content results if necessary
  if(inherits(response, "response_content") && !is.null(limit)){
    if(response$has_more){

      new_limit <- limit - 100

      if(new_limit > 0){

        message("Paging through results: ", new_limit, " left of ", limit)
        number_of_objects <- length(response$data)
        last_obj <- response$data[[number_of_objects]]

        url <- httr::modify_url(url,
                                query = list(limit = new_limit,
                                             starting_after = last_obj$id))
        new_response <- do_request(url=url,
                                   request_type = request_type,
                                   the_body = NULL,
                                   customConfig = NULL,
                                   limit=new_limit)

        response <- structure(
          list(
            object = new_response$object,
            data = c(response$data, new_response$data),
            has_more = new_response$has_more,
            url = new_response$url
          ),
          class = "response_content"
        )

      }
    }
  }


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
    content <- jsonlite::fromJSON(content, simplifyVector = FALSE, flatten = TRUE)

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
      class(out) <- "response_content"
    }
  } else {
    message("No content found. Returning NULL")
    out <- NULL
  }

  out

}



#' Retry API requests for certain errors using exponential backoff.
#'
#' @param f A function of a http request
#'
#' @keywords internal
retryRequest <- function(f){
  the_request <- try(f)

  if(!the_request[["status_code"]] %in% c(200, 201)){
    warning("Request Status Code: ", the_request$status_code)

    if(the_request[["status_code"]] %in% c(429, 500, 501, 502, 503, 504)){
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

  message("API fetch successful")
  the_request
}
