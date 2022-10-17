library(shiny)
library(bslib)
library(shinyvalidate)

df = read.csv("df.csv")

# Define UI for application that calculates users' body fat
ui <- fluidPage(
    # UI theme
    theme = bs_theme(version = 4, bootswatch = "minty",
                     base_font = font_google("Space Mono"),
                     code_font = font_google("Space Mono")),
    

    # Application title
    titlePanel(h1("Let's calculate your body fat percentage!", align = "center")),
    br(),

    # Sidebar for users to input their information
    sidebarLayout(
        
        # Prompts for users' input
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
                         textOutput("bodyFat")
                         ),
                
                tabPanel("Details",
                         plotOutput("boxplot"),
                         verbatimTextOutput("summary")
                         )
                
            )
        )
    ),
    
    br(),
    br(),
    br(),
    
    fluidRow(
        column(12, 
               br(),
               p("If you have any question about this body fat calculator, please feel free to contact us by E-mail."),
               "For questions or problems about this web app, please contact: ", strong("jwan23@wisc.edu"), br(),
               "For questions or problems about our data and model, please contact: ", 
               strong("jyu386@wisc.edu "), "| ", strong("kma57@wisc.edu "), "| ", strong("xhao33@wisc.edu")
               ),
        style = "background-color:#eeeee4; height:150px;"
    )
)

# Define server logic required to calculate users' body fat
server <- function(input, output) {
    # Validate users' input
    iv = InputValidator$new()
    iv$add_rule("adiposity", sv_required())
    iv$add_rule("adiposity", sv_numeric())
    iv$add_rule("adiposity", sv_between(13, 60))
    iv$add_rule("chest", sv_required())
    iv$add_rule("chest", sv_numeric())
    iv$add_rule("chest", sv_between(50, 130))
    iv$add_rule("abdomen", sv_required())
    iv$add_rule("abdomen", sv_numeric())
    iv$add_rule("abdomen", sv_between(23, 130))
    iv$add_rule("hip", sv_required())
    iv$add_rule("hip", sv_numeric())
    iv$add_rule("hip", sv_between(50, 130))
    iv$add_rule("wrist", sv_required())
    iv$add_rule("wrist", sv_numeric())
    iv$add_rule("wrist", sv_between(10, 22))
    
    # Click the button to get results
    estimate = eventReactive(input$calculate, {
        iv$enable()
        
        req(iv$is_valid())
        iv$disable()
        
        # Notification for inaccuracy
        if (input$adiposity < 19.1 || input$adiposity > 39.1) {
            showNotification("Your result may be inaccurate because your adiposity is out of the range in the dataset which our model is based on.", type = "warning")
        }
        if (input$chest < 83.4 || input$chest > 128.3) {
            showNotification("Your result may be inaccurate because your chest circumference is out of the range in the dataset which our model is based on.", type = "warning")
        }
        if (input$abdomen < 70.4 || input$abdomen > 126.2) {
            showNotification("Your result may be inaccurate because your abdominal circumference is out of the range in the dataset which our model is based on.", type = "warning")
        }
        if (input$hip < 85.3 || input$hip > 125.6) {
            showNotification("Your result may be inaccurate because your hip circumference is out of the range in the dataset which our model is based on.", type = "warning")
        }
        if (input$wrist < 15.8 || input$wrist > 21.4) {
            showNotification("Your result may be inaccurate because your wrist circumference is out of the range in the dataset which our model is based on.", type = "warning")
        }
            
        # Calculate users' body fat
        result = 0.73329*input$adiposity - 0.29203*input$chest + 0.84434*input$abdomen - 0.29645*input$hip - 1.77567*input$wrist + 13.69886
        
        # Check the result
        if (result < 2 || result > 50) {
            showModal(modalDialog(
                title = "Your estimated body fat percentage is abnormal",
                "A normal (Note: not healthy) human body fat percentage should be between 2 and 50. 
                Please check the data you input, correct any wrong value, and then click the Calculate button again. 
                Thank you!",
                size = "l"
            ))
        } else {
            result
        }
    })
    
    # Display the result
    output$bodyFat = renderText({
        estimate()
    })
    
    output$boxplot = renderPlot({
        # Horizontal box plot
        boxplot(df$BODYFAT, xlab = "Body Fat Percentage", main = "See where you are in the distribution of our dataset", col = "white", horizontal = TRUE, outline = FALSE)
        
        # Point
        stripchart(c(estimate()), pch = 19, col = "#EF9A9A", cex = 2, add = TRUE) 
    })
    
    output$summary = renderText({
        paste("Mean: 18.972             High: 43.314                    Low: 1.423", "\n",
              "Median: 19.210           Upper Quartile: 24.622          Lower Quartile: 12.982", "\n",
              "\n",
              "Your estimated body fat percentage ", estimate(), " is indicated by the pink point in the plot above.",
               sep = "")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
