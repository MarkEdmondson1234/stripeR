#' Create a customer
#'
#' @param account_balance Integer amount in pence
#' @param coupon A discount on recurring charges
#' @param description Arbitary string
#' @param email customer's email address
#' @param metadata Set of key/value pairs
#' @param plan ID of the plan to subscribe customer to
#' @param quantity Quantity to apply to subscription. Needs plan.
#' @param shipping Optional dictionary
#' @param source A token, or dict with credit card details
#' @param tax_percent A positive decimal. Percentage added as tax.
#' @param trail_end Unix timestamp when trial period ends. Needs plan.
#'
#' @details
#'   Setting \code{account_balance} to negative means the customer will have a credit.
#'   A positive amount means it will be added to the next invoice.
#'
#'   \code{description, email, metadata} will be set to empty if you POST an empty value.
#'
#' @return List object
#'
#' @export
create_customer <- function(account_balance=NULL,
                            coupon=NULL,
                            description=NULL,
                            email=NULL,
                            metadata=NULL,
                            plan=NULL,
                            quantity=NULL,
                            shipping=NULL,
                            source=NULL,
                            tax_percent=NULL,
                            trail_end=NULL){

  req <- do_request("https://api.stripe.com/v1/customers",
                    "POST",
                    the_body = list(
                      account_balance=account_balance,
                      coupon=coupon,
                      description=description,
                      email=email,
                      metadata=metadata,
                      plan=plan,
                      quantity=quantity,
                      shipping=shipping,
                      source=source,
                      tax_percent=tax_percent,
                      trail_end=trail_end
                    ))

  req
}

#' Retrieve a customer
#'
#' @param customerId The ID of the customer
#'
#' @return List object
#'
#' @export
retrieve_customer <- function(customerId){

  url <- sprintf("https://api.stripe.com/v1/customers/%s", customerId)

  req <- do_request(url, "GET")

  req

}

#' Update a customer
#'
#' @param customerId The ID of the customer
#' @param account_balance Integer amount in pence
#' @param coupon A discount on recurring charges
#' @param default_source ID of source to make customer new default
#' @param description Arbitary string
#' @param email customer's email address
#' @param metadata Set of key/value pairs
#' @param plan ID of the plan to subscribe customer to
#' @param quantity Quantity you'd like to apply to subscription. Needs plan.
#' @param shipping Optional dictionary
#' @param source A token, or dict with credit card details
#' @param tax_percent A positive decimal. Percentage added as tax.
#' @param trail_end Unix timestamp when trial period ends. Needs plan.
#'
#' @details
#'   Setting \code{account_balance} to negative means the customer will have a credit.
#'   A positive amount means it will be added to the next invoice.
#'
#'   \code{description, email, metadata} will be set to empty if you POST an empty value.
#'
#' @return List object
#'
#' @export
update_customer <- function(customerId,
                            account_balance=NULL,
                            coupon=NULL,
                            default_source=NULL,
                            description=NULL,
                            email=NULL,
                            metadata=NULL,
                            shipping=NULL,
                            source=NULL){

  url <- sprintf("https://api.stripe.com/v1/customers/%s", customerId)

  req <- do_request(url,
                    "POST",
                    the_body = list(
                      account_balance=account_balance,
                      coupon=coupon,
                      default_source=default_source,
                      description=description,
                      email=email,
                      metadata=metadata,
                      shipping=shipping,
                      source=source
                    ))

  req
}

#' Delete a customer
#'
#' @param customerId The ID of the customer
#'
#' @return List object
#'
#' @export
retrieve_customer <- function(customerId){

  url <- sprintf("https://api.stripe.com/v1/customers/%s", customerId)

  req <- do_request(url, "DELETE")

  req

}

#' List all customers
#'
#' @param created filter on created
#' @param ending_before filter for pagination
#' @param limit Between 1 and 100
#' @param starting_after filter for pagination
#'
#' @return List object
#'
#' @export
list_customers <- function(created=NULL,
                           ending_before=NULL,
                           limit=NULL,
                           starting_before=NULL){

  params <- list(
    created=created,
    ending_before=ending_before,
    limit=limit,
    starting_before=starting_before
  )

  url <- httr::modify_url("https://api.stripe.com/v1/customers",
                          query = params)

  req <- do_request(url,"GET")

  req

}


