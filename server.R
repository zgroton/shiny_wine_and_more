#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

require(readr) #Version 1.3.1
require(tidyr) #Version 0.8.3
require(dplyr) #Version 0.8.1
require(shiny) #Version 1.3.2
require(rhandsontable) # 0.3.7

###### BEGINNING OF SETUP SUBROUTINE ######

# Define global data and methods to enable session data editing
#values <- list() 
#setSingle <- function(x) values[["single"]] <<- x 
#setMulti <- function(x) values[["multi"]] <<- x 

# Import Raw Data
item <- read_csv("Item.csv")
sales <- read_csv("Sales.csv")
store <- read_csv("Store.csv")
itemstore <- read_csv("ItemStore.csv")

# Build master datasets
df_item_store_sales <- sales %>% 
  left_join(item, by=c('ItemNumber')) %>% 
  left_join(store, by=c('StoreNumber')) %>% 
  left_join(itemstore, by=c('ItemNumber', 'StoreNumber')) %>% 
  mutate(City_State = paste0(City,'-',State), CategoryCountry = paste0(CountryState," : ", CategoryName))

df_item_store <- itemstore %>%
  left_join(item, by=c('ItemNumber')) %>% 
  left_join(store, by=c('StoreNumber')) %>% 
  mutate(City_State = paste0(City,'-',State), CategoryCountry = paste0(CountryState," : ", CategoryName)) %>%
  mutate(Store_Desc = paste0('Store #',StoreNumber,' - ',City,', ',State))

###### END OF SETUP SUBROUTINE ######

# Define server logic
server <-  function(input, output) 
{
  
  ###### BEGINNING OF PRIAMRY SERVER LOGIC ######
  
  rv <- reactiveValues()
  rv$single_item_store <- df_item_store
  rv$multi_item_store <- df_item_store
  
  observeEvent(
    input$singleSaveBtn, # update dataframe file each time the button is pressed
    if (!is.null(input$single_store_table)){
      rv$single_item_store <- hot_to_r(input$single_store_table)
    } 
  )
  
  # Filter 'J1-GW/BB CONFIG' based on selections
  output$single_store_table <- renderRHandsontable({
    
    input_x <- rv$single_item_store
    
    result <- filter(input_x, Store_Desc == input$single_store_desc) %>%
      select(Store_Desc,ItemName,CategoryName,CountryState,Approval,CurrentPrice,Strategy) %>%
      arrange(ItemName)
    
    rhandsontable(result, rowHeaders = NULL, readOnly = TRUE, width = 1000, height=600) %>%
      hot_col(col = "Approval", type = "dropdown", readOnly = FALSE, source = c('Approved', 'Not Approved'), strict = TRUE)
    
  })
  
  # Filter 'multi_store_table' based on selections
  output$multi_store_table <- renderRHandsontable({
    
    input_x <- rv$multi_item_store
    
    compare_col <- input$multiCompareBtn
    spread_fill <- if (compare_col=='Approval') {'Not Approved'} else {NA}
    
    result <- select(input_x,ItemName,Store_Desc,Approval,CurrentPrice,Strategy) %>% 
      filter(Store_Desc %in% input$multi_store_desc) %>% 
      select(ItemName,Store_Desc,compare_col) %>% 
      spread(Store_Desc,compare_col, fill = spread_fill) %>%
      arrange(ItemName)
    
    #print(result)
    
    rhandsontable(result, rowHeaders = NULL, readOnly = TRUE, width = 1000, height=600)
    
  })
  
  ###### END OF PRIAMRY SERVER LOGIC ######
  
}
