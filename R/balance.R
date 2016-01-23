#' Get the balance of your Stripe account
#'
#' @return List object
#'
#' @export
balance <- function(){

  req <- do_request("https://api.stripe.com/v1/balance",
                    "GET")

  req
}

#' Get the balance transaction
#'
#' @param transactionId The ID of the balance transaction
#'
#' Balance transaction ID found on any API object that affects
#'   balance e.g. a charge or transfer
#'
#' @return List object
#'
#' @export
balance_transaction <- function(transactionId){

  url <- sprintf("https://api.stripe.com/v1/balance/history/%s",
                 transactionId)

  req <- do_request(url,
                    "GET")

  req
}

#' Get the balance history of your Stripe account
#'
#' @return List object
#'
#' @export
balance_history <- function(){
  ## arguments to add:
  # available_on
  # created
  # currency
  # ending_before
  # limit
  # source
  # transfer
  # type
  req <- do_request("https://api.stripe.com/v1/balance/history",
                    "GET")

  req
}
