library(shiny)
library(stripeR)



function(input, output, session){

  status <- reactiveValues(charged=FALSE)

  output$stripeForm <- renderStripeForm(status, "€100.99", "Annual")

  observeCharge(status, input, amount = 10099)

}
