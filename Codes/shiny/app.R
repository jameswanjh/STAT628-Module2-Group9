library(shiny)

# Define UI for application that calculates users' body fat
ui <- fluidPage(

    # Application title
    titlePanel(h1("Let's calculate your body fat percentage!", align = "center")),

    # Sidebar for users to input their information
    sidebarLayout(
        
        sidebarPanel(
            
            numericInput(inputId = "density", 
                         label = "Please input your body density:",
                         value = NULL,
                         min = 1.0, max = 1.1,
                         step = 0.001),
            
            numericInput(inputId = "age",
                         label = "Please input your age:",
                         value = NULL,
                         min = 1, max = 122,
                         step = 1),
            
            numericInput(inputId = "weight",
                         label = "Please input your weight:",
                         value = NULL,
                         min = 10, max = 300,
                         step = 1),
            
            numericInput(inputId = "height",
                         label = "Please input your height:",
                         value = NULL,
                         min = 18, max = 90,
                         step = 1)
        ),

        # Show the result
        mainPanel(
            img(src = "panda.png", height = 300, width = 300),
            br(),
            "Your estimated body fat percentage is:",
            #textOutput("text"),
            textOutput("bodyFat"),
        )
    )
)

# Define server logic required to calculate users' body fat
server <- function(input, output) {
    
    #output$text = 
    
    output$bodyFat = renderText({
        input$weight / (10 * input$density)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
