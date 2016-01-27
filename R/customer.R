#' Create a customer
#'
#' @param account_balance Integer amount in pence
#' @param coupon A discount on recurring charges
#' @param description Arbitary string
#' @param email customer's email address
#' @param metadata Set of key/value pairs
#' @param plan ID of the plan to subscribe customer to
#' @param quantity Quantity you'd like to apply to subscription. Needs plan.
#' @param shipping Optional dictionary
#' @param source A token, or dict with credit card details
#' @param tax_percent A positive decimal. % to be added as tax.
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
