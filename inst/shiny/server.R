library(shiny)
library(stripeR)

function(input, output, session){

  callModule(stripeRShiny, "stripe1",
             amount=2000,
             plan="example",
             formAmount=reactive("$20.00"),
             formText=reactive("Please pay $20.00"))

}
