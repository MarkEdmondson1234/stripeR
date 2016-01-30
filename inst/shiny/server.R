library(shiny)
library(stripeR)

function(input, output, session){

  status <- stripeShinyInit()

  output$stripeForm <- renderStripeForm(status,
                                        amount="GBP20.00",
                                        plan="Agency - GBP20.00 per month")

  observeStripeCharge(status,
                      input,
                      amount = 2000,
                      currency = "gbp",
                      plan="agency")

}
