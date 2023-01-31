# Import libraries
library(openair)
library(tidyverse)
library(worldmet)

# Access air quality data
myData = importAURN(
  site = "my1",
  year = 2000:2022,
  data_type = "hourly",
  pollutant = "all",
  meta = TRUE,
  ratified = FALSE,
  to_narrow = TRUE,
  verbose = FALSE,
  progress = TRUE
)

head(myData)

# Access meteorological data
