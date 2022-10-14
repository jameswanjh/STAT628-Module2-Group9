library(shiny)

# Define UI for application that calculates users' body fat
ui <- fluidPage(

    # Application title
    titlePanel(h1("Let's calculate your body fat percentage!", align = "center")),
    br(),
    
    #img(src = "panda.png", height = 300, width = 300),
    #img(src = "cat.png", height = 300, width = 300),

    # Sidebar for users to input their information
    sidebarLayout(
        
        sidebarPanel(
            
            numericInput(inputId = "age", 
                         label = "Please input your age:",
                         value = NULL,
                         min = 1, max = 122,
                         step = 1),
            
            numericInput(inputId = "adiposity",
                         label = "Please input your adiposity:",
                         value = NULL,
                         min = 10, max = 40,
                         step = 0.1),
            
            numericInput(inputId = "abdomen",
                         label = "Please input your abdomen:",
                         value = NULL,
                         min = 70, max = 130,
                         step = 0.1),
            
            numericInput(inputId = "wrist",
                         label = "Please input your wrist:",
                         value = NULL,
                         min = 10, max = 25,
                         step = 0.1),
            
            div(actionButton("calculate", label = "Calculate", 
                             style="color: #fff; background-color: #337ab7; border-color: #2e6da4;"), 
                align = "center")
                
        ),

        # Show the result
        mainPanel(
            tabsetPanel(
                
                tabPanel("Result",
                         br(),
                         #br(),
                         "Your estimated body fat percentage is:",
                         textOutput("bodyFat")),
                
                tabPanel("Graph")
                
            )
        )
    )
)

# Define server logic required to calculate users' body fat
server <- function(input, output) {
    observeEvent(input$calculate, {
        output$bodyFat = renderText({
            input$age / (10 * input$abdomen)
        })
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
