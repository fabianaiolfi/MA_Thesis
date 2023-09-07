ui <- fluidPage(
  titlePanel("Interactive Map"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("year",
                  "Year:",
                  min = 2000,
                  max = 2021,
                  value = 2000)
    ),
    mainPanel(
      uiOutput("mapPlot")
    )
  )
)

server <- function(input, output) {
  
  output$mapPlot <- renderUI({
    # Generate the file name based on the selected year
    file_name <- paste0("map_", input$year, ".png")  # Assuming that the images are in the www folder
    
    # Create an image tag for the selected year
    tags$img(src = file_name, width = "100%", height = "100%")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
