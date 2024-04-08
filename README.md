# Applied_Data_Science_with_R_Capstone_project

****************************************************************************************
The `ui.R` file defines the user interface layout for the bike-sharing demand prediction app, featuring an interactive leaflet map and detailed plots for selected cities. In `server.R`, the Shiny server logic dynamically updates the displayed information based on user input, fetching weather data and making predictions using a regression model. `raw_model-prediction.R` contains functions to fetch weather forecast data from the OpenWeatherMap API, load a regression model, and predict bike demand, forming the core functionality of the application.
****************************************************************************************

**ui.R**

**Description:**

**Code Overview:**

- **Required Libraries:** Load Shiny and Leaflet.

- **UI Setup:** Define the UI layout with a title panel and a sidebar layout.

- **Sidebar Layout:** 
  - **Main Panel:** Display the leaflet map.
  - **Sidebar Panel:** Show detailed plots for the selected city.

**Usage:**

1. Run **ui.R** to launch the app.
2. Select a city to view weather forecasts and visualizations.

**Dependencies:**

- R Shiny

***************************************************************************************************


**server.R**

**Description:**

**Code Overview:**

- **Required Libraries:** Load Shiny, ggplot2, tidyverse, scales, and lubridate.

- **Server Setup:** Define the server function for the R Shiny app.

- **Data Processing:**
  - Define a color factor for bike prediction levels.
  - Generate weather and bike data for cities.

- **Event Handling:**
  - Observe the dropdown selection event.
  - Render Leaflet maps and plots based on city selection.

- **Plot Rendering:**
  - Render temperature trend plot.
  - Render bike demand prediction plot.
  - Render bike demand prediction vs humidity plot.

**Usage:**

1. Run **server.R** to start the server.
2. Select a city from the dropdown to view weather and bike demand visualizations.

**Dependencies:**

- Shiny
- ggplot2
- tidyverse
- scales
- lubridate


*********************************************************************************************************************

**raw_model-prediction.R**

**Description:**

**Code Overview:**

- **Required Libraries:** Load tidyverse, httr, and readr.

- **Functions:**
  - **get_weather_forecaset_by_cities:** Fetch weather forecast data for specified cities from the OpenWeatherMap API. Extracts weather-related predictor variables.
  - **load_saved_model:** Load a saved regression model from a CSV file.
  - **predict_bike_demand:** Predict bike-sharing demand using the loaded regression model and weather-related predictor variables.
  - **calculate_bike_prediction_level:** Define bike-sharing demand levels for visualization.
  - **generate_city_weather_bike_data:** Generate a dataframe containing weather forecasting and bike prediction data for selected cities.

**Usage:**

1. Run **raw_model-prediction.R** to load functions.
2. Use the functions to fetch weather data, load regression models, predict bike demand, and generate city weather and bike data.

**Dependencies:**

- tidyverse
- httr
- readr





- Leaflet
