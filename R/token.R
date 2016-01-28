#' Create a card token
#'
#' @description Store this token instead of card details
#'
#' @param number The card number
#' @param exp_month Expiry month (two digits)
#' @param exp_year Expiry year (two or four digits)
#' @param cvc Card security code
#' @param name Cardholder's full name
#'
#' @details
#'   Not implemented: address
#'
#' @family tokens
#' @export
create_card_token <- function(number,
                         exp_month,
                         exp_year,
                         cvc,
                         name=NULL){

  url <- "https://api.stripe.com/v1/tokens"

  req <- do_request(url,
                    "POST",
                    the_body = list(
                      "card[number]"=number,
                      "card[exp_month]"=exp_month,
                      "card[exp_year]"=exp_year,
                      "card[cvc]"=cvc,
                      "card[name]"=name
                    ))

  req

}

#' Create a bank account token
#'
#' @description Store this token instead of bank details
#'
#' @param account_number The bank account number
#' @param country Country of the bank
#' @param currency Currency of the bank
#' @param routing_number Or sort code for bank.
#' @param name Bank account holder's full name
#' @param account_holder_type "individual" or "company"
#'
#' @details
#'   \code{routing_number} is not required if
#'   \code{account_number} is an IBAN
#'
#' @family tokens
#' @export
create_bank_token <- function(account_number,
                              country,
                              currency,
                              routing_number=NULL,
                              name=NULL,
                              account_holder_type=NULL){

  url <- "https://api.stripe.com/v1/tokens"

  req <-
    do_request(url,
                    "POST",
                    the_body = list(
                      "bank_account[account_number]"=account_number,
                      "bank_account[country]"=country,
                      "bank_account[currency]"=currency,
                      "bank_account[routing_number]"=routing_number,
                      "bank_account[name]"=name,
                      "bank_account[account_holder_type]"=account_holder_type
                    ))

  req

}

#' Retrieve a token
#'
#' A token as created by \link{create_card_token}
#'
#' @param token The ID of the token
#'
#' @return Token object
#' @family tokens
#' @export
get_token <- function(token){

  url <- sprintf("https://api.stripe.com/v1/tokens/%s", token)

  req <- do_request(url, "GET")

  req
}

