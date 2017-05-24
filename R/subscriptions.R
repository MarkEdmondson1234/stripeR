
## https://stripe.com/docs/api/curl#subscriptions

#' Create a subscription for a customer
#'
#' @param customerId The ID of the customer
#' @param plan ID of the plan to subscribe customer to
#' @param coupon A discount on recurring charges
#' @param source A token from \link{get_token}
#' @param quantity Default is 1
#' @param metadata A named list
#' @param tax_percent Postive decimal
#' @param trial_end Unix timestamp or 'now'
#'
#' @details
#'   Not implemented: application_fee_percent
#'
#' @return List object
#'
#' @family subscriptions
#' @export
create_subscription <- function(customerId,
                                plan,
                                coupon=NULL,
                                source=NULL,
                                quantity=NULL,
                                metadata=NULL,
                                tax_percent=NULL,
                                trial_end=NULL
                                ){

  url <- sprintf("https://api.stripe.com/v1/customers/%s/subscriptions", customerId)

  the_body <- list(plan=plan,
                   coupon=coupon,
                   source=source,
                   quantity=quantity,
                   metadata=metadata,
                   tax_percent=tax_percent,
                   trial_end=trial_end)

  if(!is.null(metadata)){
    the_body <- c(the_body, make_meta(metadata))
  }

  req <- do_request(url,
                    request_type="POST",
                    the_body = the_body)

  req

}

#' Retrieve a subscription
#'
#' @param customerId The ID of the customer
#' @param subscriptionId The ID of the subscription
#'
#' @return List object
#'
#' @family subscriptions
#' @export
get_subscription <- function(customerId, subscriptionId){

  url <- sprintf("https://api.stripe.com/v1/customers/%s/subscriptions/%s",
                 customerId,
                 subscriptionId)

  req <- do_request(url, "GET")

  req

}



#' Update a subscription for a customer
#'
#' @param subscriptionId The ID of the subscription
#' @param customerId The ID of the customer
#' @param plan ID of the plan to subscribe customer to
#' @param prorate Whether to prorate switching plans during billing cycle
#' @param proration_date Timestamp of proration effective. Default current time
#' @param coupon A discount on recurring charges
#' @param source A token from \link{get_token}
#' @param quantity Default is 1
#' @param metadata A named list
#' @param tax_percent Postive decimal
#' @param trial_end Unix timestamp or 'now'
#'
#' @details
#'   Not implemented: application_fee_percent
#'
#' @return List object
#'
#' @family subscriptions
#' @export
update_subscription <- function(subscriptionId,
                                customerId,
                                plan=NULL,
                                prorate=TRUE,
                                proration_date=NULL,
                                coupon=NULL,
                                source=NULL,
                                quantity=NULL,
                                metadata=NULL,
                                tax_percent=NULL,
                                trial_end=NULL
){

  prorate <- ifelse(prorate, "true", "false")

  url <- sprintf("https://api.stripe.com/v1/customers/%s/subscriptions/%s",
                 customerId,
                 subscriptionId)

  the_body <- list(plan=plan,
                   prorate=prorate,
                   proration_date=proration_date,
                   coupon=coupon,
                   source=source,
                   quantity=quantity,
                   metadata=metadata,
                   tax_percent=tax_percent,
                   trial_end=trial_end)

  if(!is.null(metadata)){
    the_body <- c(the_body, make_meta(metadata))
  }

  req <- do_request(url,
                    request_type="POST",
                    the_body = the_body)

  req

}


#' Cancel a subscription
#'
#' @param customerId The ID of the customer
#' @param subscriptionId The ID of the subscription
#' @param at_period_end Default FALSE. Delay cancellation to end of billing period.
#'
#' @return List object
#'
#' @family subscriptions
#' @export
cancel_subscription <- function(customerId, subscriptionId, at_period_end=FALSE){

  at_period_end <- ifelse(at_period_end, "true", "false")

  url <- sprintf("https://api.stripe.com/v1/customers/%s/subscriptions/%s",
                 customerId,
                 subscriptionId)

  req <- do_request(url, "DELETE")

  req

}

#' List a customer's subscriptions
#'
#' @param customerId The ID of the customer
#' @param ending_before filter for pagination
#' @param limit Between 1 and 100
#' @param starting_before filter for pagination
#'
#' @return List object
#'
#' @family subscriptions
#' @export
list_subscriptions <- function(customerId,
                               ending_before=NULL,
                               limit=10,
                               starting_before=NULL){

  params <- list(
    ending_before=ending_before,
    limit=limit,
    starting_before=starting_before
  )


  url <- sprintf("https://api.stripe.com/v1/customers/%s/subscriptions", customerId)

  url <- httr::modify_url(url,
                          query = params)

  req <- do_request(url, "GET")

  req

}


