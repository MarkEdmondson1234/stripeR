% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/customer.R
\name{update_customer}
\alias{update_customer}
\title{Update a customer}
\usage{
update_customer(customerId, account_balance = NULL, coupon = NULL,
  default_source = NULL, description = NULL, email = NULL,
  metadata = NULL, shipping = NULL, source = NULL)
}
\arguments{
\item{customerId}{The ID of the customer}

\item{account_balance}{Integer amount in pence}

\item{coupon}{A discount on recurring charges}

\item{default_source}{ID of source to make customer new default}

\item{description}{Arbitary string}

\item{email}{customer's email address}

\item{metadata}{A named list
# @param plan ID of the plan to subscribe customer to
# @param quantity Quantity you'd like to apply to subscription. Needs plan.}

\item{shipping}{Optional dictionary}

\item{source}{A token from \link{get_token}
# @param tax_percent A positive decimal. Percentage added as tax.
# @param trail_end Unix timestamp when trial period ends. Needs plan.}
}
\value{
List object
}
\description{
Update a customer
}
\details{
Setting \code{account_balance} to negative means the customer will have a credit.
  A positive amount means it will be added to the next invoice.

  \code{description, email, metadata} will be set to empty if you POST an empty value.
}
\seealso{
Other customers: \code{\link{create_customer}},
  \code{\link{delete_customer}},
  \code{\link{get_customer}}, \code{\link{list_customers}}
}
\concept{customers}
