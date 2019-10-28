#' stripeRShiny UI
#'
#' Shiny Module for use with \link{stripeRShiny}
#'
#' @param id Shiny id
#'
#' @return A Shiny Stripe From
#' @export
#' @examples
#'
#' \dontrun{
#' ## server.R
#' library(shiny)
#' library(stripeR)
#' function(input, output, session){
#'
#' callModule(stripeRShiny, "stripe1",
#'            amount=2000,
#'            plan="example",
#'            formAmount=reactive("$20.00"),
#'            formText=reactive("Please pay $20.00"))
#'            }
#'
#' ## ui.R
#' library(shiny)
#' library(stripeR)
#' fluidPage(
#' titlePanel("StripeR Demo"),
#' # A Stripe Form
#' sidebarLayout(
#'   sidebarPanel(
#'     stripeRShinyUI("stripe1")
#'  ),
#'
#' mainPanel(...)))
#'
#' }
stripeRShinyUI <- function(id){

  ns <- shiny::NS(id)

  shiny::tagList(
    shiny::uiOutput(ns("form"))
  )

}

#' stripeRShiny
#'
#' Shiny Module for use with \link{stripeRShinyUI}
#'
#' Call via status <- shiny::callModule(stripeRShiny, "your_id")
#'
#'
#' @param input shiny input
#' @param output shiny output
#' @param session shiny session
#' @param amount Amount to charge, reactive
#' @param plan reactive - If to place the customer on a plan configured in Stripe
#' @param formAmount reactive - Text to display for amount in form
#' @param formText reactive - Custom text for form
#' @param bottom_left What to see in the bottom left of form
#' @param thanks What to see once the form is successfully submitted
#' @param currency The currency the amount is in
#' @param live Whether to charge against the live Stripe account.
#' @param metadata reactive - A named list of other data to send into stripeR
#'
#' @return A reactive status object
#'
#' @export
#' @importFrom shiny p fluidRow renderUI column h4 strong helpText
#' @importFrom shiny numericInput textInput br actionButton tagList observeEvent
#'
#' @examples
#'
#' \dontrun{
#' ## server.R
#' library(shiny)
#' library(stripeR)
#' function(input, output, session){
#'
#' callModule(stripeRShiny, "stripe1",
#'            amount=2000,
#'            plan="example",
#'            formAmount=reactive("$20.00"),
#'            formText=reactive("Please pay $20.00"))
#'            }
#'
#' ## ui.R
#' library(shiny)
#' library(stripeR)
#' fluidPage(
#' titlePanel("StripeR Demo"),
#' # A Stripe Form
#' sidebarLayout(
#'   sidebarPanel(
#'     stripeRShinyUI("stripe1")
#'  ),
#'
#' mainPanel(...)))
#'
#' }
stripeRShiny <- function(input, output, session,
                         amount,
                         plan,
                         formAmount,
                         formText,
                         bottom_left="Powered by StripeR",
                         thanks = shiny::p("Thanks!"),
                         currency="gbp",
                         live = FALSE,
                         metadata=NULL){

  ns <- session$ns

  status <- stripeShinyInit()

  output$form <-  shiny::renderUI({

    if(!status$charged){

      formAmount <- formAmount()
      formText <- formText()

      if(is.null(formAmount)){
        formAmount <- as.character(amount())
      }

      ## once per transaction to prevent duplicates
      status$idempotency <- idempotency()

      row1 <- shiny::fluidRow(
        shiny::column(width = 6,
                      shiny::h4("Amount"),
                      shiny::strong(formAmount)
        ),
        shiny::column(width = 6,
                      shiny::h4(formText),
                      shiny::helpText(formText)
        )
      )

      row2 <- shiny::textInput(ns("email"),"Email", placeholder = "Email for invoice")
      row3 <- shiny::textInput(ns("card_number"), "Credit Card Number", value=4242424242424242)

      row4 <- shiny::fluidRow(
        shiny::column(width = 6,
                      shiny::numericInput(ns("exp_month"),
                                          "Expiry Month",
                                          value = 1,
                                          min=1, max=12,
                                          step=1)
        ),
        shiny::column(width = 6,
                      shiny::numericInput(ns("exp_year"),
                                          "Expiry Year",
                                          value=2016,
                                          min=2016, max=2100,
                                          step=1)
        )
      )

      row5 <- shiny::fluidRow(
        shiny::column(width = 4,
                      shiny::textInput(ns("cvc"),
                                       "CVC",
                                       value=123)
        ),
        shiny::column(width = 6, offset=2,
                      shiny::br(),
                      if(!is.null(status$charge_message)){
                        shiny::helpText(status$charge_message)
                      } else {
                        shiny::helpText(bottom_left)
                      }
        )
      )

      row6 <- shiny::actionButton(ns("charge_card"),
                                  label = "Charge Card",
                                  icon = shiny::icon("cc-stripe"),
                                  width = "100%",
                                  class="btn btn-success")

      shiny::tagList(row1, row2, row3, row4, row5, row6)
    } else {
      thanks
    }

  })

  shiny::observeEvent(input$charge_card, {

    ## from outside module
    amount <- amount()
    plan <- plan()
    currency <- currency

    ## inside module
    email <- input$email
    cn <- as.character(input$card_number)
    exp_month <- gsub(" ","0",sprintf("%2d",input$exp_month))
    exp_year <- as.character(input$exp_year)
    cvc <- as.character(input$cvc)
    idempotency <- status$idempotency

    if(is.null(idempotency)) {
      message("idempotency:", idempotency)
      stop("Idempotency is null")
    }

    stripeR_init(live=live)

    if(!grepl("@",email)){
      warning("Invalid email?")
      status$charge_message <- "Invalid email?"
      return()
    }

    token <- try(create_card_token(number=cn,
                                   exp_month=exp_month,
                                   exp_year=exp_year,
                                   cvc=cvc,
                                   name=email))

    if(is.error(token)){
      warning(error.message(token))
      status$charge_message <- error.message(token)
      return()
    }

    ## A recurring charge to a pre-made payment plan in Stripe settings
    if(!is.null(plan)){
      message("Customer created with plan")
      customer <- try(create_customer(idempotency=idempotency,
                                      source = token$id,
                                      email = email,
                                      plan = plan,
                                      account_balance = status$account_balance,
                                      coupon = status$coupon,
                                      quantity = status$quantity,
                                      trial_end = status$trial_end,
                                      metadata = metadata()))

      updateStatus(customer, status)

      ## TODO: add condition to update customer with new plan


    } else { ## one off payment
      message("One off payment, no plan detected.")

      charge <- try(charge_card(idempotency=idempotency,
                                amount = amount,
                                currency = currency,
                                customer = customer,
                                source = token$id,
                                receipt_email = email,
                                statement_descriptor = status$statement_descriptor))

      updateStatus(charge, status)

    }

  })

  return(status)

}



#' Stripe Shiny status object
#'
#' Use at start of Shiny session
#'
#' @details If a user has paid the $charged = TRUE else FALSE.
#'
#'   e.g. if status <- stripeShinyInit()
#'   if(status$charged) "Thanks for paying"
#'
#' @family shiny
#' @keywords internal
#' @importFrom shiny reactiveValues
stripeShinyInit <- function(){

  shiny::reactiveValues(charged=FALSE,
                        account_balance=NULL,
                        coupon=NULL,
                        plan=NULL,
                        quantity=NULL,
                        trial_end=NULL,
                        statement_descriptor=NULL,
                        charge_message=NULL,
                        idempotency=NULL)
}

#' updateStatus
#'
#' @param attempt stripeR request
#' @param status status object ot update
#'
#' @return Updates the status object with values in attempt
#'
#' @family shiny
#' @keywords internal
#' @importFrom utils str
updateStatus <- function(attempt, status){
  utils::str(attempt)
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
                  attempt$subscriptions$data$plan.amount,
                  paste(names(attempt$metadata),attempt$metadata, sep="=", collapse = ",")
                  ),
            sep=", "
            )

    ## set this to FALSE again outside of this function
    ## to allow another charge
    status$charge_message <- "Success"
    status$id             <- attempt$id
    status$amount         <- attempt$amount
    status$receipt_email  <- attempt$receipt_email
    status$email          <- attempt$email

    ## doesn't support mupltiple subscriptions!
    ## todo: filter to subscription with $subscriptions$data[[X]]$created == now
    status$subscriptionId <- attempt$subscriptions$data[[1]]$id
    status$plan.id        <- attempt$subscriptions$data[[1]]$plan$id
    status$plan.amount    <- attempt$subscriptions$data[[1]]$plan$amount

    ## set last so support data is present in reactiveValues
    status$charged <- TRUE

  }
}
