
# # Install and import required libraries
require(shiny)
 require(ggplot2)
 require(tidyverse)
require(scales)
library(lubridate)
#
# # Import model_prediction R which contains methods to call OpenWeather API
# # and make predictions
#source("/home/rstudio/Test it/Final project/raw_model_prediction.R")

# Create a RShiny server
shinyServer(function(input, output){
  # Define a city list
  
  # Define color factor
  color_levels <- colorFactor(c("green", "yellow", "red"), 
                              levels = c("small", "medium", "large"))
  city_weather_bike_df <- test_weather_data_generation()
  
  # Create another data frame called `cities_max_bike` with each row contains city location info and max bike
  # prediction for the city
  
  cities_max_bike <- city_weather_bike_df %>% group_by(CITY_ASCII, LNG, LAT) %>% filter(BIKE_PREDICTION == max(BIKE_PREDICTION))
  
  # Observe drop-down event
  observeEvent(input$city_dropdown, {
    if(input$city_dropdown == 'All') {
      # Then render output plots with an id defined in ui.R
      output$city_bike_map <- renderLeaflet({
        # If All was selected from dropdown, then render a leaflet map with circle markers
        # and popup weather LABEL for all five cities
        leaflet(cities_max_bike) %>% addTiles() %>%
          addCircleMarkers(lng=cities_max_bike$LNG, lat=cities_max_bike$LAT,
                           popup=cities_max_bike$LABEL,
                           radius=~case_when(cities_max_bike$BIKE_PREDICTION_LEVEL=='small' ~ 6,
                                             cities_max_bike$BIKE_PREDICTION_LEVEL=='medium' ~ 10,
                                             cities_max_bike$BIKE_PREDICTION_LEVEL=='large' ~ 12),
                           color=~color_levels(cities_max_bike$BIKE_PREDICTION_LEVEL))
      })
    }
    else {
      # If just one specific city was selected, then render a leaflet map with one marker

        selected_city <- city_weather_bike_df[city_weather_bike_df$CITY_ASCII == input$city_dropdown, ]
        output$city_bike_map <- renderLeaflet({
          leaflet(selected_city) %>% addTiles() %>%
            addCircleMarkers(lng=selected_city$LNG, lat=selected_city$LAT,
                             popup=selected_city$DETAILED_LABEL,
                             radius=~case_when(selected_city$BIKE_PREDICTION_LEVEL=='small' ~ 6,
                                               selected_city$BIKE_PREDICTION_LEVEL=='medium' ~ 10,
                                               selected_city$BIKE_PREDICTION_LEVEL=='large' ~ 12),
                             color=~color_levels(selected_city$BIKE_PREDICTION_LEVEL))
        }
      
      )
      
      
        output$temp_line <- renderPlot({
          # Create a plot for temperature data
          ggplot(selected_city, aes(x=hour(FORECASTDATETIME), y=TEMPERATURE)) +
            geom_line(color='skyblue', size = 1.5) + # Add a line representing temperature trend with a sky blue color
            labs(x="Time (3 hours ahead)", y="Temperature (℃)") + # Set axis labels
            geom_point(color='orange', size = 3) + # Add orange points representing temperature values
            geom_text(aes(label=paste(TEMPERATURE, " ℃")), hjust=-0.2, vjust=0.5, size=5, color='black') + # Add text labels for temperature values, adjust positioning, size, and color
            ggtitle(paste('Temperature Chart of ', input$city_dropdown)) + # Set plot title
            theme_minimal() # Apply a minimal theme for better aesthetics
        })
        
        output$bike_line <- renderPlot({
          # Create a plot for bike demand prediction
          ggplot(selected_city, aes(x=hour(FORECASTDATETIME), y=BIKE_PREDICTION)) +
            geom_line(color='darkgreen', linetype = "dashed", size = 0.6) + # Add a dashed line representing bike demand prediction trend with a dark green color
            labs(x="Time (3 hours ahead)", y="Bike Demand Prediction") + # Set axis labels
            geom_point(color='red', size = 2) + # Add red points representing bike demand prediction values
            geom_text(aes(label=BIKE_PREDICTION), hjust=-0.2, vjust=0.8, size=4, color='black') + # Add text labels for bike demand prediction values, adjust positioning, size, and color
            ggtitle(paste('Bike Demand Prediction Trend of', input$city_dropdown)) + # Set plot title
            theme_minimal() # Apply a minimal theme for better aesthetics
        })
        
        output$bike_date_output <- renderText({
          # Display information about the selected city and its bike demand prediction at the first time point
          paste("Time = ", selected_city[1,]$FORECASTDATETIME, "  ",
                'BikeCountPred = ', selected_city[1,]$BIKE_PREDICTION)
        })
        
        output$humidity_pred_chart <- renderPlot({
          # Create a plot for bike demand prediction vs humidity
          ggplot(selected_city, aes(x=HUMIDITY, y=BIKE_PREDICTION)) +
            labs(x="Humidity", y="Bike Demand Prediction") + # Set axis labels
            geom_point(color='red', size = 1) + # Add blue points representing bike demand prediction values
            geom_smooth(method = 'lm', formula = y ~ poly(x, 4), se=TRUE, color='darkblue', linetype='solid', size=1.2) + # Add a smoothed line representing bike demand prediction vs humidity with a dark red color and dotted line type
            ggtitle(paste('Bike Demand Prediction vs Humidity of', input$city_dropdown)) + # Set plot title
            theme_minimal() + # Apply a minimal theme for better aesthetics
            theme(text = element_text(size = 10)) # Increase overall plot text size
        })   
        
    } 
  })
})
