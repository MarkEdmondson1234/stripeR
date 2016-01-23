#' Charge a credit card
#'
#' @param amount Amount in smallest currency unit
#' @param currency ISO code for currency
#' @param customer ID of existing customer. This or source required.
#' @param source A payment source to be charged
#' @param application_fee Optional charge fee.
#' @param capture Default TRUE
#' @param description Default NULL
#' @param destination Account to charge from
#' @param metadata A named list of metadata
#' @param receipt_email email address to send receipt to
#' @param shipping Shipping info for the charge

#' @param statement_descriptor 22 chars displayed on customer statement
#'
#' @return List object
#'
#' @export
balance <- function(amount,
                    currency,
                    customer,
                    source,
                    application_fee,
                    capture,
                    description,
                    destination,
                    metadata,
                    receipt_email,
                    shipping){

  req <- do_request("https://api.stripe.com/v1/charges",
                    "POST")

  req
}
