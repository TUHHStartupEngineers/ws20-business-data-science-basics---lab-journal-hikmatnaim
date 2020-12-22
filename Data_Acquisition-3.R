library(RSQLite)
library(dplyr)
library(httr)
library(glue)
library(jsonlite)
library(keyring)
library(rvest)
library(stringr)
library(purrr)
library(owmr)
library(xopen)
library(stringi)
library(tibble)


################################################## Task_1 ##################################################

Sys.setenv(OWM_API_KEY = "e4deaed2c6fcc4cf048ee6427bf44024")
(res <- get_current("London", units = "metric") %>%
    owmr_as_tibble()) %>% names()
res[, 1:6]

# ... by city id
(rio <- search_city_list("Rio de Janeiro")) %>%
  as.list()

get_current(rio$id, units = "metric") %>%
  owmr_as_tibble() %>% .[, 1:6]

# get current weather data for cities around geo point
res <- find_cities_by_geo_point(
  lat = rio$lat,
  lon = rio$lon,
  cnt = 5,
  units = "metric"
) %>% owmr_as_tibble()

idx <- c(names(res[1:6]), "name")
res[, idx]

# get forecast
forecast <- get_forecast("London", units = "metric") %>%
  owmr_as_tibble()

forecast[, 1:6]


################################################## Task_2 ##################################################

url= "https://www.rosebikes.de/fahrräder/e-bike"

#Wrap it into a function ----
  
get_bike_data <- function(url) {
  
  html_bike_category <- read_html(url)
  
  # Get the URLs
  bike_url_tbl  <- html_bike_category %>%
    html_nodes(css = ".catalog-category-bikes__title-text") %>%
    html_text()%>%
    enframe(name = "Number", value = "Bike.Name")
  
  # Get the descriptions
  bike_database_tbl<-bike_url_tbl%>% 
    mutate(price=html_bike_category%>%
             html_nodes(css =".catalog-category-bikes__price-title")%>%
             html_text())
}

bike_tableout<-get_bike_data(url)
bike_tableout
saveRDS(bike_tableout,"Data_Acquisition_Challenge.rds")