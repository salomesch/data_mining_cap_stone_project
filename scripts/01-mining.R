
# load libraries ----------------------------------------------------------
library(tidyverse)
library(httr)
library(rvest)
library(jsonlite)


response <-  httr::GET(
  url = "https://api.gdeltproject.org/api/v2/doc/doc?query=%22endometriosis%22&mode=artlist&maxrecords=100&timespan=1week",
  verbose()
)

Sys.sleep(6)
response <- httr::GET(
  url = "https://api.gdeltproject.org/api/v2/doc/doc",
  query = list(
    query = "endometriosis",
    mode = "artlist",
    maxrecords = 250,
    timespan = "3months",
    format = "json"
  )
)

data <- content(response, as = "parsed")

# convert data from json to R list
data <- fromJSON(content(response, "text", encoding = "UTF-8"))

#Convert to a clean data frame
articles_df <- as.data.frame(data$articles)


# Create empty vectors where to store the codes and names:
out_url <- vector(mode = "character", length = length(data$articles))
out_title <- vector(mode = "character", length = length(data$articles))
out_sourcecountry <- vector(mode = "character", length = length(data$sourcecountry))

# Now loop to extract all codes/names from the list:
for (i in 1:length(data$articles)){
  out_url[i] <- data$articles[[i]]$url
  out_title[i] <- data$articles[[i]]$title
  out_sourcecountry[i] <- data$articles[[i]]$sourcecountry
}

# 5. Convert into a tidy tibble --------------------
variables_dataset = tibble(
  url = out_url, 
  title = out_title,
  country = out_sourcecountry
)

# save variable data set
saveRDS(variables_dataset, "data_raw/variable_dataset.rds")
variables_dataset <- readRDS("data_raw/variable_dataset.rds")

# save articles
saveRDS(articles_df, "data_raw/articles_df.rds")


# Check the source countries and languages covering the topic
table(articles_df$sourcecountry)
table(articles_df$language)



# experiment with other modes:  -------------------------------------------


Sys.sleep(6)
response <- GET(
  url = "https://api.gdeltproject.org/api/v2/doc/doc",
  query = list(
    query = "endometriosis",
    mode = "TimelineTone",      # this shows the senitiment over time)
    timespan = "3y",            
    format = "json"
  ),
  timeout(60) 
)

#data <- content(response, as = "parsed")

data <- fromJSON(content(response, as = "text", encoding = "UTF-8"))

# looking at structure
str(data)
names(data)

# Df
timeline_df <- data$timeline$data[[1]]


#save as RDS

saveRDS(timeline_df, "data_raw/timeline_df.rds")

# country spezifisch ------------------------------------------------------

Sys.sleep(6)

response_test <- GET(
  url = "https://api.gdeltproject.org/api/v2/doc/doc",
  query = list(
    query = "endometriosis sourcecountry:Germany",
    mode = "TimelineTone",
    timespan = "3y",
    format = "json"
  ),
  timeout(60)
)

raw_text_test <- content(response_test, as = "text", encoding = "UTF-8")
cat(substr(raw_text_test, 1, 300))

data_test <- fromJSON(raw_text_test)
df <- data_test$timeline$data[[1]]
df$date <- as.Date(substr(df$date, 1, 8), format = "%Y%m%d")
df$country <- "Germany"

head(df)
