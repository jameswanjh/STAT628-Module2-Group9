library(shiny)
library(bslib)

# Define UI for application that calculates users' body fat
ui <- fluidPage(
    theme = bs_theme(version = 4, bootswatch = "minty",
                     base_font = font_google("Space Mono"),
                     code_font = font_google("Space Mono")),
    

    # Application title
    titlePanel(h1("Let's calculate your body fat percentage!", align = "center")),
    br(),
    
    #img(src = "panda.png", height = 300, width = 300),
    #img(src = "cat.png", height = 300, width = 300),

    # Sidebar for users to input their information
    sidebarLayout(
        
        sidebarPanel(
            "Please help us learn more about you...",
            br(),
            br(),
            
            numericInput(inputId = "adiposity",
                         label = "Adiposity (bmi):",
                         value = NULL,
                         min = 13, max = 60,
                         step = 0.1),
            
            numericInput(inputId = "chest", 
                         label = "Chest circumference (cm):",
                         value = NULL,
                         min = 50, max = 130,
                         step = 1),
            
            numericInput(inputId = "abdomen",
                         label = "Abdominal circumference (cm):",
                         value = NULL,
                         min = 23, max = 130,
                         step = 1),
            
            numericInput(inputId = "hip",
                         label = "Hip circumference (cm):",
                         value = NULL,
                         min = 50, max = 130,
                         step = 1),
            
            numericInput(inputId = "wrist",
                         label = "Wrist circumference (cm):",
                         value = NULL,
                         min = 10, max = 22,
                         step = 1),
            
            div(actionButton("calculate", label = "Calculate", 
                             style="color: #fff; background-color: #76b5c5; border-color: #abdbe3;"), 
                align = "center")
                
        ),

        # Show the result
        mainPanel(
            tabsetPanel(
                type = "pills",
                
                tabPanel("Result",
                         br(),
                         "Your estimated body fat percentage is:",
                         textOutput("bodyFat")),
                
                tabPanel("Details")
                
            )
        )
    )
)

# Define server logic required to calculate users' body fat
server <- function(input, output) {
    output$bodyFat = renderText({
        input$calculate
        req(input$calculate)
        isolate(0.73329*input$adiposity - 0.29203*input$chest + 0.84434*input$abdomen - 0.29645*input$hip - 1.77567*input$wrist + 13.69886)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
