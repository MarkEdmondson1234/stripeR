library(shiny)
library(stripeR)

function(input, output, session){

  output$stripeForm <- renderStripeForm(100.99)

}
