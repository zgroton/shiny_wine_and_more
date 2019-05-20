#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button in the upper-right corner of RStudio.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

require(shiny)
require(shinythemes)
require(rhandsontable)

# Define UI for Application
ui <- tagList(
  
  #shinythemes::themeSelector(),
  
  navbarPage
  (
    theme = "cerulean",  # <--- To use a particular theme, uncomment 'theme'
    "TWM - Store Inventory",
    
    tabPanel
    (
      "Single-Store Drilldown",
      
      sidebarPanel
      (
        HTML("<u><b><h4>Data Filter Panel</h4></b></u>"),
        selectInput("single_store_desc", "Select Store Description", c('Store #1 - Fairfax, VA','Store #2 - Sterling, VA','Store #3 - Alexandria, VA','Store #4 - Arlington, VA','Store #5 - Wheaton, MD','Store #6 - Owings Mills, MD','Store #7 - Matthews, NC','Store #8 - Charlotte, NC','Store #9 - Raleigh, NC','Store #10 - Apex, NC')),
        br(),
        actionButton("singleSaveBtn", "Save Table Changes")
      ),
      
      mainPanel
      (
        rHandsontableOutput("single_store_table")
      )
      
    ),
    
    tabPanel
    (
      "Multi-Store Comparison",
      
      sidebarPanel
      (
        HTML("<u><b><h4>Data Filter Panel</h4></b></u>"),
        checkboxGroupInput(inputId = "multi_store_desc", label = "Select Store Description(s)", choices = c('Store #1 - Fairfax, VA','Store #2 - Sterling, VA','Store #3 - Alexandria, VA','Store #4 - Arlington, VA','Store #5 - Wheaton, MD','Store #6 - Owings Mills, MD','Store #7 - Matthews, NC','Store #8 - Charlotte, NC','Store #9 - Raleigh, NC','Store #10 - Apex, NC'), selected = c('Store #1 - Fairfax, VA','Store #2 - Sterling, VA')),
        br(),
        selectInput("multiCompareBtn", "Select Comparison Value", c('Approval','CurrentPrice','Strategy'))
      ),
      
      mainPanel
      (
        rHandsontableOutput("multi_store_table")
      )
      
    )
    
  )
  
)
