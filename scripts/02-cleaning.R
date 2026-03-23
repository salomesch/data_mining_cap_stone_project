# load libraries ----------------------------------------------------------
library(dplyr)
library(lubridate)

# preprocess data ---------------------------------------------------------

#load data 
timeline_df_preprocessed <- readRDS("data_raw/timeline_df_4.rds")

# create readable format of date (this step was done with the help of AI)
timeline_df_preprocessed$date <- as.Date(substr(timeline_df_preprocessed$date, 1, 8), 
                                      format = "%Y%m%d")

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
