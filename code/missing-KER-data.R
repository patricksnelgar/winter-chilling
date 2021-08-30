library(here)
library(tidyverse)
library(magrittr)
library(lubridate)

if(!dir.exists(here("workspace"))){
	dir.create(here("workspace"))
}

# Raw data from Kai Lewis, old cr10 format so need to put col headers in manually.
ker_raw <- 
	read_csv(here("input/KER.dat"), 
					col_names = c("ArrID", "StationID", "Year", "DoY", "HHMM", "Air_Temp", "Wet_Bulb", "Wet_Sens", "Rain1", "Grass_min", "ET10", "ET20", "ET30", "ET100", "Rad", "WS", "WD", "Rain2", "RH", "soilm")) %>% 
	filter(ArrID == 20 & Year == 2021) %>% 
	mutate(Date = as.Date(DoY, origin = ymd("2020-12-31")), StopDate = as_datetime(Date + HHMM/2400))


# all hours of data where the temperature has been recorded as NA
ker_missing_met_data <-  
	read_csv(here("input/MetWatch_Export.csv"), 
			 na = c('-',NA)) %>%
	rename(StationID = 1, StartDate = 2,
		   StopDate = 3, TemperatureMean = 4, 
		   RelativeHumidityMean = 5, RainTotal = 6,
		   RadiationMean = 7, WindSpeedMean = 8) %>%
	mutate(StopDate = dmy_hm(StopDate),
		   StartDate = dmy_hm(StartDate),
		   Month = month(StopDate),
		   Year = year(StopDate), 
		   DayOfYear = yday(StopDate)) %>% 
	filter(Year == 2021 & StationID == "KER" & is.na(TemperatureMean))


# now find the matching rows in the raw data
matched_data <- 
	ker_raw %>% 
	filter(StopDate >= first(ker_missing_met_data$StopDate)) %>%  
	mutate(StartDate = StopDate - 3600) %>% 
	select(StationID, StartDate, StopDate, Air_Temp, RH, Rain1, Rad, WS)


# one record not found?
ker_missing_met_data %>% 
	filter(!(StopDate %in% matched_data$StopDate))
# yeah missing in raw data file too

write_csv(matched_data, here("workspace/KER-missing-data.csv"))
