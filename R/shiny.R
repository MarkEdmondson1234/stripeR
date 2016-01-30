#' Render Shiny payment form
#'
#' @param amount Amount to charge
#'
#' @return A StripeR form to output with \link{stripeFormOutput}
#'
#' @import shiny
#' @family shiny
#'
#' @export
renderStripeForm <- function(amount){
  renderUI({

    row1 <- fluidRow(
      column(width = 6,
             h4(paste("Amount ",amount))
      ),
      column(width = 6,
             helpText("")
      )
    )

    row2 <- textInput("email","Email",placeholder = "Email for invoice")
    row3 <- textInput("card_number", "Credit Card Number", value=4242424242424242)

    row4 <- fluidRow(
      column(width = 6,
             numericInput("exp_month", "Expiry Month", value = 1, min=1, max=12, step=1)
      ),
      column(width = 6,
             numericInput("exp_year", "Expiry Year", value=2016, min=2016, max=2100, step=1)
      )
    )

    row5 <- fluidRow(
      column(width = 4,
             textInput("cvc","CVC", value=123)
      ),
      column(width = 6, offset=2,
             br(),
             helpText("Powered by Stripe")
      )
    )

    row6 <- actionButton(inputId = "charge_card",
                         label = "Charge Card",
                         icon = icon("credit-card"),
                         width = "100%",
                         class="btn btn-success")

    out <- tagList(row1, row2, row3, row4, row5, row6)
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
