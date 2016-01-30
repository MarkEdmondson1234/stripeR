library(shiny)
library(stripeR)

fluidPage(

  # Application title
  titlePanel("StripeR Demo"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      stripeFormOutput("stripeForm")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)
