library(shiny)
library(ggplot2)
library(randomForest)

shinyUI(
  
  #Create a bootstrap fluid layout
  fluidPage(

    #Add a title
    titlePanel('Random Forest with First Two Principal Components'),
  
    #Add a row for the main content
    fluidRow(
      
      # Display the Cluster Plot
      plotOutput('iris.rf.ggplot')
      
    ),
    
  
    #Create another row for User Input
    fluidRow(
      
      mainPanel(
        #Simple integer interval
        sliderInput("ntree", "Specify # of Trees:", 
          min = 1, max = 200, value = 20),
        
        checkboxInput('showCorrectness', label = 'Show Correctness', 
          value = FALSE),
        
        
        p('This tool box aims to demonstrate result by using Random Forest to classifiy spieces based on the training data on "Iris" and 1st two principal components.  The user can switch the number of trees to grow and configure whether or not to display actual result.')
        
      ),
      
      sidebarPanel(
        actionButton("submit", "Submit")
      )
      
    )
    
  )
)
