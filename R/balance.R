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
