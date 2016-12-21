try(detach("package:SEO", unload=TRUE))
library(SEO)
library(shiny)
library(DT)
library(dygraphs)
library(shinyjs)
library(rhandsontable)
library(ggplot2)

fluidPage(
  useShinyjs(), # on active shinyjs
  titlePanel("Shiny SEO"),
  tabsetPanel(
    tabPanel("Configuration",
             textInput("texte", "Votre recherche", "Data Summary"),
             verbatimTextOutput("value"),
             dateRangeInput(inputId = "plagedate", label = " Votre recherche sur la durée: ", language = "fr"),
             actionButton("go", "Go"),
             numericInput("n", "Plot de votre recherche web", 10),
             plotOutput("plot"),
             tableOutput(outputId = "table1"),
             column(4,
                    selectInput("man",
                                "Manufacturer:",
                                c("All",
                                  unique(as.character(mpg$manufacturer))))
             ),
             column(4,
                    selectInput("trans",
                                "Transmission:",
                                c("All",
                                  unique(as.character(mpg$trans))))
             ),
             column(4,
                    selectInput("cyl",
                                "Cylinders:",
                                c("All",
                                  unique(as.character(mpg$cyl))))
             )
    ),
    fluidRow(
      DT::dataTableOutput("table")
    ),
    tabPanel("site",
             titlePanel("Sites")
    )
  )
)
