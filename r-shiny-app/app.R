library(shiny)
library(ggplot2)
library(shinythemes)

annual <- read.csv('all-nba-predictions.csv')
cumulative <- read.csv('all-nba-cumulative.csv')

ui <- fluidPage(theme = shinytheme('paper'),
                
                titlePanel("Determining the 2010s NBA All-Decade team with machine learning"),
                
  
                tabsetPanel(
                  tabPanel("Introduction", fluid = TRUE,
                           
                           mainPanel(
                             h1('Methods'),
                             p("To determine the All-Decade team, we created 4 machine learning models. We trained the models on historical data going back to 1979
                               (introduction of the 3-point line). Then, we predicted All-NBA probability for each player season between the 2009-2010 and 2018-19 seasons.
                               By summing the All-NBA scores, we created an All-Decade team. The player with the highest cumulative score
                               went into the highest available slot in his position.", style = "font-size:16px"),
                             br(),
                             p("This dashboard helps visualize All-NBA probability for players each year over time. Not all players played the whole decade.
                               Furthermore, some played the tail end of their prime in the decade, while others just started their prime at the end of the decade.
                               In the visualization tab, you can compare any pair of players. Search any two players, and a graph will automatically
                               pop up comparing their All-NBA probability each year Along with this, a table will pop up showing the average
                               All-NBA probability each year and each model's predictions.", style = "font-size:16px"),
                             h1("Links"),
                             a(href="https://dribbleanalytics.blog/2019/12/all-decade-teams",
                               div("Click here to see the original blog post which includes a more detailed discussion of methods and results.", style = 'font-size:16px')),
                             br(),
                             a(href="https://github.com/dribbleanalytics/all-decade-teams/",
                               div("Click here to see the GitHub repository for the project which contains all code, data, and results.", style = 'font-size:16px'))
                             
                             )
                           ),
                  tabPanel("Visualization", fluid = TRUE,
                           sidebarLayout(
                             sidebarPanel(p("To compare All-NBA probabilities throughout the decade for any two players, select any two players from the dropdown menus below.
                                 The graphs and tables with automatically update", style = 'font-size:16px'),
                                          br(),
                                          
                                          selectInput(inputId = "player1",
                                                      label = "Select player 1 (blue line):",
                                                      choices = unique(annual$player)),
                                          
                                          selectInput(inputId = "player2",
                                                      label = "Select player 2 (red line):",
                                                      choices = unique(annual$player)),
                                          
                                          sliderInput(inputId = "season_lim",
                                                      label = "Select season range:",
                                                      min = 2009, max = 2018, value = c(2009, 2018)),
                                          
                                          selectInput(inputId = "season_sum",
                                                      label = "Select yearly data or cumulative data",
                                                      choices = c("Yearly", "Cumulative"))
                             ),
                             mainPanel(plotOutput(outputId = "line_plot"),
                                       tableOutput('table1'),
                                       tableOutput('table2')   
                             )
                             )
                           )
                  )
                )



server <- function(input, output) {
  
  output$line_plot <- renderPlot({
    
    if (input$season_sum == "Yearly") {
      data <- annual
      y_break = seq(0, 1, by = .2)
      y_lim = 1
    } else {
      data <- cumulative
      y_break = seq(0, 10, by = 2)
      y_lim = 10
    }
    
    print(input$player1)
    player1_data <- data[which(data$player == input$player1),]
    player2_data <- data[which(data$player == input$player2),]
    
    p = ggplot() + 
      geom_line(data = player1_data, aes(x = season_start, y = avg), color = "blue", size = 2) +
      geom_line(data = player2_data, aes(x = season_start, y = avg), color = "red", size = 2) +
      xlab('Season') +
      ylab('All-NBA probability') +
      scale_x_continuous(breaks = seq(input$season_lim[1], input$season_lim[2], by= 1), limits=c(input$season_lim[1],input$season_lim[2])) +
      scale_y_continuous(breaks = y_break, limits=c(0,y_lim)) +
      theme_light()
    
    p
    
    
  })
  
  output$table1 <- renderTable({
    
    if (input$season_sum == "Yearly") {
      data <- annual
    } else {
      data <- cumulative
    }
    
    player1_data <- data[which(data$player == input$player1 & data$season_start >= input$season_lim[1] & data$season_start <= input$season_lim[2]),]
    
  })
  
  output$table2 <- renderTable({
    
    if (input$season_sum == "Yearly") {
      data <- annual
    } else {
      data <- cumulative
    }
    
    player2_data <- data[which(data$player == input$player2 & data$season_start >= input$season_lim[1] & data$season_start <= input$season_lim[2]),]
  })
  
}

shinyApp(ui = ui, server = server)
