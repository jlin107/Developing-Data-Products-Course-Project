library(shiny)
library(leaflet)
shinyUI(fluidPage(
  titlePanel("Usage of Water Bottle Filling Stations on the Johns Hopkins University 
             Homewood Campus From 2016 to 2019"),
  tabsetPanel(
    ## Tab 1: About this site
    tabPanel("About this site",
             ## Background
             tags$h3("Background"),
             "Abel Wolman, one of Johns Hopkins' first three engineering graduates, 
             pioneered the practice of chlorination of public water supplies and 
             revolutionized water sanitization across the globe. Today, Johns 
             Hopkins is committed to sustainable water systems, and people across
             the university are changing their behaviors and making purchasing 
             decisions to reduce our water usage. Beginning in 2013, the Office of
             Sustainability developed a comprehensive replacement and retrofit plan 
             for all water fountains on the Homewood campus. Over 100 water fountains 
             in nearly every building on Homewood either received gooseneck bottle 
             fillers or were replaced with a water bottle filling station to make 
             it easy to refill a water bottle anywhere on campus. This Shiny app
             examines the usage of the water bottle filling stations on the Homewood
             campus from 2016 to 2019. For more information, visit the",
             a(href = "https://sustainability.jhu.edu/initiatives/water-initiative/", 
               "Office of Sustainability"),
             "website.",
             
             ## Dataset
             h3("Dataset"),
             "Each water bottle filling station has a counter that counts the number
             of plastic water bottles saved by using the station. Every February 
             from 2016 to 2019, we audited each filling station on Homewood campus
             and recorded the bottle count. However, bottle counts sometimes could 
             not be recorded for various reasons. For this project, only filling 
             stations with recorded measurements at all 4 time points were included.",
             
             ## Site navigation
             h3("Site navigation"),
             "To navigate the Shiny app, select a tab at the top. The tabs include:",
             br(),
             tags$li(strong("About this site."), 
                     "Background information and instructions on how to navigate
                     the site."),
             tags$li(strong("Data."),
                     "A data spreadsheet showing the bottle count for each filling
                     station at each year."),
             tags$li(strong("Map."),
                     "A map showing the water bottle filling stations on Homewood
                     campus."),
             tags$li(strong("Time plot."),
                     "A time plot showing the bottle counts from 2016 to 2019."),
             
             ## Author
             h3("Author"),
             "John Lin",
             
             # Contact
             h3("Contact"),
             "jlin107@jh.edu"
    ),
    
    ## Tab 2: Data
    tabPanel("Data",
             tableOutput("data")),
    
    ## Tab 3: Map
    tabPanel("Map",
             wellPanel(selectInput(
                 inputId = "map.year",
                 label = "Year",
                 choices = c("2016", "2017", "2018", "2019"),
                 selected = "2019"
             )),
             leafletOutput("map")
    ),
    
    ## Tab 4: Time plot
    tabPanel("Time plot",
             wellPanel(
               checkboxGroupInput(
                 inputId = "plot.type",
                 label = "Building type", 
                 choices = c("Lecture hall", "Residence hall", "Other", "Total"),
                 selected = c("Lecture hall", "Residence hall", "Other", "Total"),
                 inline = TRUE
               )
             ),
             plotOutput("plot"))
  )
))