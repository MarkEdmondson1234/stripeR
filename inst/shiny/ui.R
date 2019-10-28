library(shiny)
library(stripeR)

fluidPage(

  titlePanel("StripeR Demo"),

  # A Stripe Form
  sidebarLayout(
    sidebarPanel(
      stripeRShinyUI("stripe1")
    ),

    mainPanel(

    )
  )
)
