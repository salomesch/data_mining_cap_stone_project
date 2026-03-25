# load libraries ----------------------------------------------------------
library(dplyr)
library(lubridate)


# preprocess data for media coverage analysis by country ------------------
# load data
endo_df_preprocessed <- readRDS("data_raw/final_endo_df.rds")

# create readable format of date with  (this step was done with the help of AI)
endo_df_preprocessed <- endo_df_preprocessed |> 
  mutate(date_parsed = ymd_hms(seendate, tz = "UTC"))

# split up date for analysis of years and months and days
endo_df_preprocessed <- endo_df_preprocessed |>
  mutate(
    year  = year(date_parsed),
    month = month(date_parsed, label = TRUE),
    day   = day(date_parsed),
    hour = hour(date_parsed)
  )

# save preprocessed df
saveRDS(endo_df_preprocessed, "data_preprocessed/endo_df_preprocessed.rds")


# preprocess data for sentiment score analysis ---------------------------------------------------------
#load data 
timeline_df_preprocessed <- readRDS("data_raw/timeline_df_4.rds")

# create readable format of date (this step was done with the help of AI)
timeline_df_preprocessed <- timeline_df_preprocessed |> 
  mutate(date = as.Date(substr(date, 1, 8), format = "%Y%m%d"))

timeline_df_preprocessed |> summary()

# split up date for analysis of years and months and days

timeline_df_preprocessed <- timeline_df_preprocessed |>
  mutate(
    year  = year(date),
    month = month(date, label = TRUE),
    day   = day(date)
  )
# save preprocessed df
saveRDS(timeline_df_preprocessed, "data_preprocessed/timeline_df_preprocessed.rds")

