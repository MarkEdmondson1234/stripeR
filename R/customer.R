#' Create a customer
#'
#' @param idempotency A random string to ensure no repeat charges
#' @param account_balance Integer amount in pence
#' @param coupon A discount on recurring charges
#' @param description Arbitary string
#' @param email customer's email address
#' @param metadata A named list
#' @param plan ID of the plan to subscribe customer to
#' @param quantity Quantity to apply to subscription. Needs plan.
#' @param shipping Optional dictionary
#' @param source A token from \link{get_token}
#' @param tax_percent A positive decimal. Percentage added as tax.
#' @param trial_end Unix timestamp when trial period ends. Needs plan.
#'
#' @details
#'   Setting \code{account_balance} to negative means the customer will have a credit.
#'   A positive amount means it will be added to the next invoice.
#'
#'   \code{description, email, metadata} will be set to empty if you POST an empty value.
#'
#' @return List object
#'
#' @family customers
#' @export
create_customer <- function(idempotency,
                            account_balance=NULL,
                            coupon=NULL,
                            description=NULL,
                            email=NULL,
                            metadata=NULL,
                            plan=NULL,
                            quantity=NULL,
                            shipping=NULL,
                            source=NULL,
                            tax_percent=NULL,
                            trial_end=NULL){

  the_body <-  list(
    account_balance=account_balance,
    coupon=coupon,
    description=description,
    email=email,
    plan=plan,
    quantity=quantity,
    shipping=shipping,
    source=source,
    tax_percent=tax_percent,
    trial_end=trial_end
  )

  if(!is.null(metadata)){
    the_body <- c(the_body, make_meta(metadata))
  }

  req <- do_request("https://api.stripe.com/v1/customers",
                    "POST",
                    the_body = the_body)

  req
}

#' Retrieve a customer
#'
#' @param customerId The ID of the customer
#'
#' @return List object
#'
#' @family customers
#' @export
get_customer <- function(customerId){

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
#' @param metadata A named list
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
#' @family customers
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

  the_body <-  list(
    account_balance=account_balance,
    coupon=coupon,
    default_source=default_source,
    description=description,
    email=email,
    shipping=shipping,
    source=source
  )


  if(!is.null(metadata)){
    the_body <- c(the_body, make_meta(metadata))
  }

  req <- do_request(url,
                    "POST",
                    the_body = the_body)

  req
}

#' Delete a customer
#'
#' @param customerId The ID of the customer
#'
#' @return List object
#'
#' @family customers
#' @export
delete_customer <- function(customerId){

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
#' @param raw_data Default FALSE
#'
#' @return List object
#'
#' @family customers
#' @export
list_customers <- function(created=NULL,
                           ending_before=NULL,
                           limit=10,
                           starting_before=NULL,
                           raw_data=FALSE){

  params <- list(
    created=created,
    ending_before=ending_before,
    limit=limit,
    starting_before=starting_before
  )

  url <- httr::modify_url("https://api.stripe.com/v1/customers",
                          query = params)

  req <- do_request(url,"GET", limit=limit)

  content <- req$data

  req

}


