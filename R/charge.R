#' Charge a credit card
#'
#' @param amount Amount in smallest currency unit
#' @param currency ISO code for currency
#' @param customer ID of existing customer. This or source required.
#' @param source A payment source to be charged
#' @param receipt_email email address to send receipt to
#' @param application_fee Optional charge fee.
#' @param capture TRUE to charge now, FALSE charge with \link{capture_charge}
#' @param description Default NULL
#' @param metadata A named list
#' @param shipping Shipping info for the charge
#' @param statement_descriptor 22 chars displayed on customer statement
#'
#' @return List object
#'
#' @details
#'   \code{source} and \code{customer}:
#' If you pass a customer ID, the source must be the ID of
#'   a source belonging to the customer.
#'
#' If you do not pass a customer ID,
#'   the source you provide must be a token from \link{create_token}
#'
#' @family charges
#' @export
charge_card <- function(amount,
                        currency,
                        customer=NULL,
                        source=NULL,
                        receipt_email=NULL,
                        application_fee=NULL,
                        capture=TRUE,
                        description=NULL,
                        metadata=NULL,
                        shipping=NULL,
                        statement_descriptor=NULL){

  capture <- ifelse(capture, "true", "false")

  the_body <-  list(
    amount=amount,
    currency=currency,
    source=source,
    receipt_email=receipt_email,
    application_fee=application_fee,
    capture=capture,
    description=description,
    shipping=shipping,
    statement_descriptor=statement_descriptor
  )

  if(!is.null(metadata)){
    the_body <- c(the_body, make_meta(metadata))
  }

  req <- do_request("https://api.stripe.com/v1/charges",
                    "POST",
                    the_body = the_body)

  req
}

#' Retieve a charge
#'
#' @param chargeId The ID from a previous charge
#'
#' @return List object
#'
#' @family charges
#' @export
get_charge <- function(chargeId){

  url <- sprintf("https://api.stripe.com/v1/charges/%s", chargeId)

  req <- do_request(url, "GET")

  req

}

#' Update a charge
#'
#' @param chargeId Id of charge
#' @param fraud_details Possible fraud information
#' @inheritParams charge_card
#'
#' @return List object
#'
#' @family charges
#' @export
update_charge <- function(chargeId,
                          description=NULL,
                          fraud_details=NULL,
                          metadata=NULL,
                          receipt_email=NULL,
                          shipping=NULL){

  url <- sprintf("https://api.stripe.com/v1/charges/%s", chargeId)

  the_body <-  list(
    fraud_details=fraud_details,
    receipt_email=receipt_email,
    description=description,
    shipping=shipping
  )

  if(!is.null(metadata)){
    the_body <- c(the_body, make_meta(metadata))
  }

  req <- do_request(url,
                    "POST",
                    the_body = the_body)

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
#' @family charges
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
#' @family charges
#' @export
list_charges <- function(created=NULL,
                         customer=NULL,
                         ending_before=NULL,
                         limit=NULL,
                         source=NULL,
                         starting_before=NULL){

  params = list(
    created=created,
    customer=customer,
    ending_before=ending_before,
    limit=limit,
    source=source,
    starting_before=starting_before
  )

  url <- httr::modify_url("https://api.stripe.com/v1/charges/",
                          query = params)

  req <- do_request(url,"GET",limit=limit)

  req

}
