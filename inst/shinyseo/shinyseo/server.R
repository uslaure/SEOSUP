try(detach("package:SEO", unload=TRUE))
library(SEO)
library(shiny)
library(DT)
library(dygraphs)
library(ggplot2)


shinyServer(function(input, output, session) {
  randomVals <- eventReactive(input$go, {
    runif(input$n)
  })
  output$plot <- renderPlot({
    hist(randomVals())
  })
  output$value <- renderText({ input$texte})
  output$table <- DT::renderDataTable(DT::datatable({
    data <- mpg
    if (input$man != "All") {
      data <- data[data$manufacturer == input$man,]
    }
    if (input$cyl != "All") {
      data <- data[data$cyl == input$cyl,]
    }
    if (input$trans != "All") {
      data <- data[data$trans == input$trans,]
    }
    data
  }))

})

