#' Charge a credit card
#'
#' @param amount Amount in smallest currency unit
#' @param currency ISO code for currency
#' @param customer ID of existing customer. This or source required.
#' @param source A payment source to be charged
#' @param receipt_email email address to send receipt to
#' @param application_fee Optional charge fee.
#' @param capture Default TRUE
#' @param description Default NULL
#' @param destination Account to charge from
#' @param metadata A named list of metadata
#' @param shipping Shipping info for the charge
#' @param statement_descriptor 22 chars displayed on customer statement
#'
#' @return List object
#'
#' @export
charge_card <- function(amount,
                        currency,
                        customer=NULL,
                        source=NULL,
                        receipt_email=NULL,
                        application_fee=NULL,
                        capture=TRUE,
                        description=NULL,
                        destination=NULL,
                        metadata=NULL,
                        shipping=NULL){

  req <- do_request("https://api.stripe.com/v1/charges",
                    "POST",
                    the_body = list(
                     amount=amount,
                     currency=currency,
                     source=source,
                     receipt_email=receipt_email,
                     application_fee=application_fee,
                     capture=capture,
                     description=description,
                     destination=destination,
                     metadata=metadata,
                     shipping=shipping
                    ))

  req
}

#' Retieve a charge
#'
#' @param chargeId The ID from a previous charge
#'
#' @return List object
#'
#' @export
retrieve_charge <- function(chargeId){

  url <- sprintf("https://api.stripe.com/v1/charges/%s", chargeId)

  req <- do_request(url, "GET")

  req

}

