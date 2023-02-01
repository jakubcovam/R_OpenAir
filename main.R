# ----------------------------------------------
#   OPENAIR DATABASE
# ----------------------------------------------
# A Guide to the Analysis of Air Pollution Data is on:
# https://bookdown.org/david_carslaw/openair/
# ----------------------------------------------

# ----------------------------------------------
# IMPORT LIBRARIES
# ----------------------------------------------
library(openair)
library(openairmaps)
library(tidyverse)
library(worldmet)
# ----------------------------------------------

# ----------------------------------------------
# PLOT SITES ON MAP
# ----------------------------------------------
networkMap(source = "aurn", control = "site_type")
# ----------------------------------------------

# ----------------------------------------------
# ACCESS AIR QUALITY DATA
# ----------------------------------------------
myData = importAURN(
  site = "my1",
  year = 2022,
  data_type = "hourly",
  pollutant = "all",
  meta = TRUE,
  ratified = FALSE,
  to_narrow = TRUE,
  verbose = FALSE,
  progress = TRUE
)

head(myData)
# ----------------------------------------------

# ----------------------------------------------
# SET VARIABLES
# ----------------------------------------------
myData_lat = 51.52
myData_lon = -0.15
# ----------------------------------------------

# ----------------------------------------------
# ACCESS METEOROLOGICAL DATA (IF NEEDED)
# ----------------------------------------------
getMeta(lat = myData_lat, lon = myData_lon, returnMap = TRUE)
station_met <- importNOAA(code = "039690-99999", year = 2022)

# first few lines of data
station_met
# ----------------------------------------------

# ----------------------------------------------
# PLOT DATA - DIRECTIONAL ANALYSIS
# ----------------------------------------------
# Wind rose
windRose(station_met)
windRose(mydata, type='year')
windRose(mydata, type='pm10')

# Pollution rose
pollutionRose(mydata, pollutant = "nox")
pollutionRose(mydata,
              pollutant = "nox",
              type = "so2",
              layout = c(4, 1),
              key.position = "bottom"
)
pollutionRose(mydata, pollutant = "nox", statistic = "prop.mean")
pollutionRose(mydata,
              pollutant = "so2",
              normalise = TRUE,
              seg = 1,
              cols = "heat"
)

# Polar frequencies
polarFreq(mydata)
polarFreq(mydata, type = "year")
polarFreq(mydata, pollutant = "so2", 
          type = "year",
          statistic = "mean", 
          min.bin = 2)
polarFreq(mydata, pollutant = "nox", ws.int = 30, 
          statistic = "weighted.mean",
          offset = 80, trans = FALSE, 
          col = "heat")

# Polar plots
polarPlot(mydata, pollutant = "nox")
polarPlot(mydata, pollutant = "so2", uncertainty = TRUE)

# Polar annulus
polarAnnulus(mydata, 
             pollutant = "pm10", 
             period = "season", 
             main = "Season")
polarAnnulus(mydata, 
             pollutant = "pm10",
             period = "hour", 
             main = "Hour")
# ----------------------------------------------

# ----------------------------------------------
# PLOT DATA - TIME SERIES
# ----------------------------------------------
timePlot(mydata, 
         pollutant = c("nox", "o3"), 
         y.relation = "free")
timePlot(selectByDate(mydata, year = 2003), 
         pollutant = c("nox", "o3"), 
         y.relation = "free")
timePlot(selectByDate(mydata, year = 2003, month = "říj"),
         pollutant = c("nox", "o3", "pm25", "pm10", "ws"),
         y.relation = "free")

# plot monthly means of ozone and no2
timePlot(mydata, pollutant = c("o3", "no2"), avg.time = "month",
         y.relation = "free")

# plot 95th percentile monthly concentrations
timePlot(mydata, pollutant = c("o3", "no2"), avg.time = "month",
         statistic = "percentile", percentile = 95,
         y.relation = "free")

# plot the number of valid records in each 2-week period
timePlot(mydata, pollutant = c("o3", "no2"), avg.time = "2 week",
         statistic = "frequency", y.relation = "free")

# normalizing time series data
timePlot(mydata, 
         pollutant = c("nox", "no2", "co", "so2", "pm10"),
         avg.time = "year", normalise = "1/1/1998", 
         lwd = 4, lty = 1,
         group = TRUE, ylim = c(0, 120))

# import data from 3 sites and plot them
aq = importAURN(site = c("kc1", "my1", "nott"), 
                 year = 2005:2010)
timePlot(aq, pollutant = "nox", 
         type = "site", 
         avg.time = "month")

# in one plot
aq = select(aq, -site)
aq = pivot_wider(aq, id_cols = date, 
                  names_from = code, 
                  values_from = co:air_temp)
timePlot(aq, 
         pollutant = c("nox_KC1", "nox_MY1", "nox_NOTT"),
         avg.time = "month", group = TRUE,
         lty = 1, lwd = c(1, 3, 5),
         ylab = "nox (ug/m3)"
)
# ----------------------------------------------

# ----------------------------------------------
# PLOT DATA - TEMPORAL VARIATIONS
# ----------------------------------------------
timeVariation(filter(mydata, ws > 3,  wd > 100, wd < 270),
              pollutant = "pm10", ylab = "pm10 (ug/m3)")
timeVariation(mydata, 
              pollutant = c("nox", "co", "no2", "o3"), 
              normalise = TRUE)
# ----------------------------------------------

# ----------------------------------------------
# PLOT DATA - HEAT MAPS
# ----------------------------------------------
trendLevel(mydata, pollutant = "nox")
trendLevel(mydata, pollutant = "nox", y = "wd", 
           border = "white", 
           cols = "turbo")
trendLevel(mydata, x = "nox", y = "no2", pollutant = "o3", 
           border = "white",
           n.levels = 30, statistic = "max", 
           limits = c(0, 50))
trendLevel(mydata, pollutant = "no2",
           x = "week",
           border = "white",  statistic = "max",
           breaks = c(0, 50, 100, 500),
           labels = c("low", "medium", "high"),
           cols = c("forestgreen", "yellow", "red"),
           key.position = "top")
# ----------------------------------------------

# ----------------------------------------------
# PLOT DATA - CALENDAR PLOTS
# ----------------------------------------------
calendarPlot(mydata, pollutant = "o3", year = 2003)
calendarPlot(mydata,
             pollutant = "pm10", year = 2003,
             annotate = "value",
             lim = 50,
             cols = "Purples",
             col.lim = c("black", "orange"),
             layout = c(4, 3)
)
calendarPlot(mydata,
             pollutant = "o3", year = 2003,
             annotate = "ws"
)
# ----------------------------------------------

# ----------------------------------------------
# PLOT DATA - TRENDS
# ----------------------------------------------
# Theil-Sen trends
TheilSen(mydata, pollutant = "o3", 
         ylab = "ozone (ppb)", 
         deseason = TRUE,
         date.format = "%Y")
TheilSen(mydata, pollutant = "o3", type = "wd", 
         deseason = TRUE,
         date.format = "%Y",
         ylab = "ozone (ppb)")

# Smooth trends
smoothTrend(mydata, pollutant = "o3", ylab = "concentration (ppb)",
            main = "monthly mean o3")
smoothTrend(mydata, pollutant = "o3", deseason = TRUE, ylab = "concentration (ppb)",
            main = "monthly mean deseasonalised o3")
smoothTrend(mydata, pollutant = "no2", simulate = TRUE, ylab = "concentration (ppb)",
            main = "monthly mean no2 (bootstrap uncertainties)")
smoothTrend(mydata, pollutant = "no2", deseason = TRUE, simulate =TRUE,
            ylab = "concentration (ppb)",
            main = "monthly mean deseasonalised no2 (bootstrap uncertainties)")
smoothTrend(mydata, pollutant = "o3", deseason = TRUE,
            type = "wd")
smoothTrend(mydata, pollutant = c("no2", "pm10", "o3"), 
            type = c("wd", "season"),
            date.breaks = 3, lty = 0)

# Seasonal averages
lh = importAURN(site = "lh", year = 2000:2019)
smoothTrend(lh, pollutant = "o3",
            avg.time = "season",
            type = "season",
            date.breaks = 4)
# ----------------------------------------------

# ----------------------------------------------
# PLOT DATA IN MAP
# ----------------------------------------------
dplyr::glimpse(polar_data)
polarMap(
  polar_data,
  pollutant = "nox",
  latitude = "lat",
  longitude = "lon",
  popup = "site"
)
polarMap(
  polar_data,
  pollutant = "nox",
  latitude = "lat",
  longitude = "lon",
  popup = "site",
  limits = c(0, 500)
)
annulusMap(
  polar_data,
  pollutant = c("nox", "no2"), 
  provider = "CartoDB.Positron",
  latitude = "lat",
  longitude = "lon"
)
polar_data %>%
  openair::cutData("weekend") %>% 
  percentileMap(
    pollutant = "nox",
    control = "weekend",
    latitude = "lat",
    longitude = "lon", 
    provider = "Esri.WorldTopoMap",
    cols = "viridis",
    popup = "site",
    label = "site_type",
    intervals = c(0, 200, 400, 600, 800, 1000)
  )
polar_data %>%
  openair::cutData("weekend") %>%
  buildPopup(
    cols = c("site", "site_type", "date", "nox"),
    names = c(
      "Site" = "site",
      "Site Type" = "site_type",
      "Date Range" = "date",
      "Average nox" = "nox"
    ),
    control = "weekend"
  ) %>%
  pollroseMap(pollutant = "nox",
              popup = "popup",
              breaks = 6,
              control = "weekend")
# ----------------------------------------------
