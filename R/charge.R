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

#' Update a charge
#'
#' @param chargeId
#' @param fraud_details Possible fraud information
#' @inheritParams charge_card
#'
#' @return List object
#'
#' @export
update_charge <- function(chargeId,
                          description=NULL,
                          fraud_details=NULL,
                          metadata=NULL,
                          receipt_email=NULL,
                          shipping=NULL){

  url <- sprintf("https://api.stripe.com/v1/charges/%s", chargeId)

  req <- do_request(url,
                    "POST",
                    the_body = list(
                      fraud_details=fraud_details,
                      receipt_email=receipt_email,
                      description=description,
                      metadata=metadata,
                      shipping=shipping
                    ))

  req



}

#' Capture a charge
#'
#' @param chargeId A charge from a previous uncaptured charge
#' @param amount Amount in smallest currency unit
#' @param application_fee Optional charge fee.
#' @param receipt_email email address to send receipt to
#' @param statement_descriptor 22 chars displayed on customer statement
#'
#' @return A charge object
#'
#' @export
capture_charge <- function(chargeId,
                           amount=NULL,
                           application_fee=NULL,
                           receipt_email=NULL,
                           statement_descriptor=NULL){

  url <- sprintf("https://api.stripe.com/v1/charges/%s", chargeId)

  req <- do_request(url,
                    "POST",
                    the_body = list(
                      amount=amount,
                      application_fee=application_fee,
                      receipt_email=receipt_email,
                      statement_descriptor=statement_descriptor
                    ))

  req

}

#' List all charges
#'
#' @param created A filter based on when charges were created
#' @param customer A filter based on customer
#' @param ending_before A cursor used for pagination
#' @param limit between 1 and 100 objects
#' @param source A filter based on the source of the charge
#' @param starting_after A cursor used for pagination
#'
#'
#' @return A charge object
#'
#' @export
list_charges <- function(created=NULL,
                         customer=NULL,
                         ending_before=NULL,
                         limit=NULL,
                         source=NULL,
                         starting_before=NULL){

  url <- sprintf("https://api.stripe.com/v1/charges/")

  ## do these go in the body? may be parameters
  req <- do_request(url,
                    "GET",
                    the_body = list(
                      created=created,
                      customer=customer,
                      ending_before=ending_before,
                      limit=limit,
                      source=source,
                      starting_before=starting_before
                    ))

  req

}
