#' Stripe Shiny status object
#'
#' Use at start of Shiny session
#'
#' @import shiny
#' @family shiny
#'
#' @export
stripeShinyInit <- function(){
  reactiveValues(charged=FALSE,
                 account_balance=NULL,
                 coupon=NULL,
                 plan=NULL,
                 quantity=NULL,
                 trial_end=NULL,
                 statement_descriptor=NULL,
                 charge_message=NULL)
}

#' Render Shiny payment form
#'
#' @param status A reactive list with element \code{charged}
#' @param amount String with amount to charge e.g. "€4.40"
#' @param plan Optional payment plan to show
#' @param bottom_left Text shown at bottom left
#' @param thanks The thank you UI upon payment
#'
#' @return A StripeR form to output with \link{stripeFormOutput} The form has
#'   these inputs: input$email input$card_number input$exp_month input$exp_year
#'   input$cvc
#'
#'   Action button: input$charge_card
#'
#' @import shiny
#' @family shiny
#'
#' @export
renderStripeForm <- function(status,
                             amount,
                             plan="",
                             bottom_left="Powered by Stripe",
                             thanks = p(amount, " paid successful.  Thanks!")){


    renderUI({
      if(!status$charged){
        row1 <- fluidRow(
          column(width = 6,
                 h4("Amount"),
                 strong(amount)
          ),
          column(width = 6,
                 h4(ifelse(plan!="","Plan","")),
                 helpText(plan)
          )
        )

        row2 <- shiny::textInput("email","Email", placeholder = "Email for invoice")
        row3 <- shiny::textInput("card_number", "Credit Card Number", value=4242424242424242)

        row4 <- fluidRow(
          column(width = 6,
                 shiny::numericInput("exp_month",
                                     "Expiry Month",
                                     value = 1,
                                     min=1, max=12,
                                     step=1)
          ),
          column(width = 6,
                 shiny::numericInput("exp_year",
                                     "Expiry Year",
                                     value=2016,
                                     min=2016, max=2100,
                                     step=1)
          )
        )

        row5 <- fluidRow(
          column(width = 4,
                 textInput("cvc",
                           "CVC",
                           value=123)
          ),
          column(width = 6, offset=2,
                 br(),
                 if(!is.null(status$charge_message)){
                   helpText(status$charge_message)
                 } else {
                   helpText(bottom_left)
                 }
          )
        )

        row6 <- actionButton(inputId = "charge_card",
                             label = "Charge Card",
                             icon = icon("credit-card"),
                             width = "100%",
                             class="btn btn-success")

        tagList(row1, row2, row3, row4, row5, row6)
      } else {
        thanks
      }
    })


}

#' stripeForm Shiny Output
#'
#' @param outputId What \link{renderStripeForm} outputs to.
#'
#' @return The Stripe Form in Shiny UI.
#'
#' @family shiny
#' @importFrom shiny uiOutput
#'
#' @export
stripeFormOutput <- function(outputId){
  uiOutput(outputId)
}

#' Charge Observer
#'
#' Needs to be present to do the charge with stripeForm
#'
#' @param status A reactive list with element \code{charged}
#' @param input Shiny input object
#' @param amount The amount to charge
#' @param currency Currency of amount
#' @param plan Optional payment plan to subscribe to
#' @param live Whether to charge your live Stripe account
#'
#' @family shiny
#' @import shiny
#'
#' @export
observeStripeCharge <- function(status,
                                input,
                                amount,
                                currency="gbp",
                                plan=NULL,
                                live=FALSE){

  observeEvent(input$charge_card, {

    email <- input$email
    cn <- as.character(input$card_number)
    exp_month <- gsub(" ","0",sprintf("%2d",input$exp_month))
    exp_year <- as.character(input$exp_year)
    cvc <- as.character(input$cvc)
    amount <- amount
    currency <- currency
    plan <- plan

    stripeR_init(live=live)

    if(!grepl("@",email)){
      warning("Invalid email?")
      status$charge_message <- "Invalid email?"
      return()
    }

    token <- create_card_token(number=cn,
                               exp_month=exp_month,
                               exp_year=exp_year,
                               cvc=cvc,
                               name=email)

    ## A recurring charge to a pre-made payment plan in Stripe settings
    if(!is.null(plan)){
      customer <- try(create_customer(source = token$id,
                                      email = email,
                                      plan = plan,
                                      account_balance = status$account_balance,
                                      coupon = status$coupon,
                                      quantity = status$quantity,
                                      trial_end = status$trial_end))

      updateStatus(customer, status)


    } else { ## one off payment
      customer <- try(create_customer(email = email,
                                      account_balance = status$account_balance))

      ## Can still make a charge if error, just won't have customer object
      if(is.error(customer)){
        warning(error.message(customer))
        status$charge_message <- error.message(customer)
      }

      charge <- try(charge_card(amount = amount,
                                currency = currency,
                                customer = customer,
                                source = token$id,
                                receipt_email = email,
                                statement_descriptor = status$statement_descriptor))

      updateStatus(charge, status)

    }

  })
}


updateStatus <- function(attempt, status){
  if(is.error(attempt)){
    warning(error.message(attempt))
    status$charge_message <- error.message(attempt)
  } else { ## payment successful
    message(Sys.time(),
            " Payment Successful: ",
            paste(attempt$object,
                  attempt$id,
                  attempt$amount,
                  attempt$receipt_email,
                  attempt$email,
                  attempt$subscriptions$data$plan.id,
                  attempt$subscriptions$data$plan.amount
                  ),
            sep=", "
            )

    status$charged <- TRUE
    status$charge_message <- "Success"
  }
}
