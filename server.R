library(shiny)
library(leaflet)
library(ggplot2)
library(dplyr)
library(reshape)
shinyServer(function(input, output) {
  data <- read.csv("data.csv", check.names = FALSE)
  
  ## Tab 2. Data
  output$data <- renderTable(
    data[,-c(3,4)]
  )
  
  ## Tab 3. Map
  pal <- colorFactor(
    palette = c("red", "darkgreen", "blue"),
    levels = c("Lecture hall", "Residence hall", "Other")
  )
  
  output$map <- renderLeaflet({
    data %>%
      leaflet() %>%
      addTiles() %>%
      addCircleMarkers(weight = 3,
                       radius = sqrt(data[,input$map.year]/200),
                       color = ~pal(data$`Building Type`),
                       popup = paste("<strong>", data$Location, "</strong>", 
                                     "<br/>", "Bottle Count (", input$map.year, 
                                     "): ", data[,input$map.year], 
                                     sep = "")) %>%
      addLegend(labels = c("Lecture hall", "Residence hall", "Other"),
                col = c("red", "darkgreen", "blue"))
  })
  
  
  ## Tab 4. Time plot
  data$`Building Type` <- factor(data$`Building Type`, 
                                 levels = c("Lecture hall", "Residence hall", "Other"))
  data.plot <- data %>% 
    group_by(`Building Type`) %>% 
    summarize_at(vars(`2016`:`2019`),sum)
  data.plot <- rbind(as.data.frame(data.plot), 
                     cbind(data.frame("Building Type" = "Total", check.names = FALSE), 
                           cbind(summarize_at(data, vars(`2016`:`2019`), sum))))
  data.plot <- melt(data.plot, id.vars = c("Building Type"))
  names(data.plot) <- c("Building Type", "Year", "Bottle Count")
  
  data.plot.final <- reactive({
    data.plot.final <- data.plot
    data.plot.final[!(data.plot$`Building Type` %in% input$plot.type),3] <- 0
    data.plot.final
  })
  
  output$plot <- renderPlot({
    data.plot.final <- data.plot.final()
    ggplot(data.plot.final, 
           aes(x = Year, y = `Bottle Count`, fill = `Building Type`)) + 
      geom_bar(stat = "identity", position = position_dodge()) + 
      theme(text = element_text(size = 20))
  })
})