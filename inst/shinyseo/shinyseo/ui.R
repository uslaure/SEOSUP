try(detach("package:SEO", unload=TRUE))
library(SEO)
library(shiny)
library(DT)
library(dygraphs)
library(shinyjs)
library(rhandsontable)

fluidPage(
  useShinyjs(), # on active shinyjs
  titlePanel("Shiny SEO"),
  tabsetPanel(
    tabPanel("research",
             titlePanel("Recherches")
    ),
    tabPanel("site",
             titlePanel("Sites")
    )
  )
)
