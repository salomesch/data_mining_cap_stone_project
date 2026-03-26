# load libraries ----------------------------------------------------------
library(tidyverse)
library(httr)
library(rvest)
library(jsonlite)

# get 250 articles about endometriosis from the past 3 months
Sys.sleep(6)
response <- httr::GET(
  url = "https://api.gdeltproject.org/api/v2/doc/doc",
  query = list(
    query = "endometriosis",
    mode = "artlist",
    maxrecords = 250,
    timespan = "1week",
    format = "json"
  ),
  timeout(60)
)


# convert data from json to R list
data <- fromJSON(content(response, "text", encoding = "UTF-8"))

#Convert to a clean data frame
articles_df <- as.data.frame(data$articles)

# save articles
saveRDS(articles_df, "data_raw/articles_df.rds")


# Check the source countries and languages covering the topic
table(articles_df$sourcecountry)
table(articles_df$language)



# Write a loop to get all articles from the past 3 months: ----------------

# Define dates
date_sequence <- seq(as.Date("2025-12-25"), as.Date("2026-03-24"), by="day")
all_articles <- list()

for(i in 1:length(date_sequence)){
  current_day <- format(date_sequence[i], "%Y%m%d")
  print(paste("Fetching data for:", current_day))
  
  # tryCatch prevents the code from stopping if there is a timeout error
  result <- tryCatch({
    GET(
      url = "https://api.gdeltproject.org/api/v2/doc/doc",
      query = list(
        query = "endometriosis",
        mode = "artlist",
        maxrecords = 250,
        startdatetime = paste0(current_day, "000000"),
        enddatetime = paste0(current_day, "235959"),
        format = "json"
      ),
      # These two lines fix the timeout, section written with help of AI
      timeout(60),                      # guards the download phase
      config(connecttimeout = 60)       # guards the connection phase
    )
  }, error = function(e) {
    message(paste("Timeout on", current_day, "- skipping."))
    return(NULL)
  })
  
  # Process only if result is valid
  if (!is.null(result) && status_code(result) == 200) {
    raw_content <- content(result, as = "text", encoding = "UTF-8")
    if (!grepl("Please limit requests", raw_content)) {
      data <- fromJSON(raw_content)
      if (!is.null(data$articles)) {
        all_articles[[i]] <- as.data.frame(data$articles)
      }
    }
  }
  
  # Stay under the rate limit
  Sys.sleep(6)
}

# Combine all days into one table
final_endo_df_2 <- bind_rows(all_articles)
final_endo_df_2
# save variable data set
saveRDS(final_endo_df_2, "data_raw/final_endo_df_2.rds")




# get sentiment score from the past 4 years:  -------------------------------------------


Sys.sleep(6)
response_timeline <- GET(
  url = "https://api.gdeltproject.org/api/v2/doc/doc",
  query = list(
    query = "endometriosis",
    mode = "TimelineTone",      # this shows the sentiment over time)
    timespan = "4y",            
    format = "json"
  ),
  timeout(60) 
)

data_timeline <- fromJSON(content(response_timeline, as = "text", encoding = "UTF-8"))

# looking at structure
str(data_timeline)
names(data_timeline)

# create df
timeline_df <- data_timeline$timeline$data[[1]]


#save as RDS

saveRDS(timeline_df, "data_raw/timeline_df_4.rds")


# country specify ------------------------------------------------------
# i.e. look at countries with top 3 media coverage

Sys.sleep(6)
response_country <- GET(
  url = "https://api.gdeltproject.org/api/v2/doc/doc",
  query = list(
    query = "endometriosis sourcecountry:United Kingdom",
    mode = "TimelineTone",
    timespan = "4y",
    format = "json"
  ),
  timeout(60)
)

raw_country <- fromJSON(content(response_country, as = "text", encoding = "UTF-8"))

df <- response_country$timeline$data[[1]]
df$date <- as.Date(substr(df$date, 1, 8), format = "%Y%m%d")
df$country <- "Germany"

head(df)
